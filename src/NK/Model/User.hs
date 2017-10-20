{-# LANGUAGE DeriveGeneric #-}

module NK.Model.User (
    getUserById
  , getUsers
  , createUser
  , User
) where

import           Control.Monad.IO.Class
import           Control.Monad.Trans.Reader
import           Data.Aeson
import           Database.HDBC
import           Database.HDBC.PostgreSQL   (Connection)
import           GHC.Generics
import           NK.Util.JsonUtil

data User = User {
    id         :: Maybe String
  , name       :: String
  , slug       :: Maybe String
  , email      :: String
  , phone      :: Maybe String
  , image_url  :: Maybe String
  , language   :: Maybe String
  , last_login :: Maybe String
  , location   :: Maybe String
  , created_at :: Maybe String
  , updated_at :: String
  , published  :: Maybe Bool
} deriving (Generic, Show)

instance ToJSON User where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON User where

prepare' :: String -> ReaderT Connection IO Statement
prepare' s =  do
  c <- ask
  liftIO $ prepare c s

getUsers :: ReaderT Connection IO [User]
getUsers = do
  c <- ask
  select <- liftIO $ prepare c "select * from users limit 10"
  _ <- liftIO $ execute select []
  result <- liftIO $ fetchAllRowsMap' select
  liftIO $ toJsonUtil result

getUserById :: String -> ReaderT Connection IO (Maybe User)
getUserById i = do
  c <- ask
  select <- liftIO $ prepare c "select * from users where id = ?"
  _ <- liftIO $ execute select [toSql i]
  result <- liftIO $ fetchRowMap select
  return (toJsonUtil' result)

getUserByEmail :: String -> ReaderT Connection IO (Maybe User)
getUserByEmail i = do
  c <- ask
  select <- liftIO $ runReaderT (prepare' "select * from users where email = ?") c
  _ <- liftIO $ execute select [toSql i]
  result <- liftIO $ fetchRowMap select
  return (toJsonUtil' result)

getValues :: User -> [SqlValue]
getValues u = [toSql $ name u, toSql $ slug u, toSql $ email u, toSql $ phone u, toSql $ image_url u, toSql $ language u, toSql $ location u]

createUser :: User -> ReaderT Connection IO (Maybe User)
createUser u = do
  c <- ask
  insert <- liftIO $ prepare c "insert into users (name, slug, email, phone, image_url, language, location) values (?,?,?,?,?,?,?)"
  _ <- liftIO $ execute insert $ getValues u
  liftIO $ runReaderT (getUserByEmail (email u)) c
