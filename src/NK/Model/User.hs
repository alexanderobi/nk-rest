{-# LANGUAGE DeriveGeneric #-}

module NK.Model.User (
    getUserById
  , getUsers
  , createUser
  , User
) where

import           Control.Monad.Trans.Reader
import           Data.Aeson
import           Database.HDBC
import           Database.HDBC.PostgreSQL   (Connection)
import           GHC.Generics
import           NK.Util.JsonUtil

data User = User {
    id        :: Maybe String
  , name      :: String
  , slug      :: Maybe String
  , email     :: String
  , phone     :: Maybe String
  , image_url :: Maybe String
  , language  :: Maybe String
  , lastLogin :: Maybe String
  , location  :: Maybe String
  , createdAt :: Maybe String
  , updatedAt :: Maybe String
  , published :: Maybe Bool
} deriving (Generic, Show)

instance ToJSON User where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON User where

type UserReaderT a = ReaderT Connection IO a

getUsers :: UserReaderT [User]
getUsers = ReaderT getUsers'

getUserById :: String -> UserReaderT User
getUserById = ReaderT . getUserById'

createUser :: User -> UserReaderT User
createUser = ReaderT . createUser'

prepare' :: String -> ReaderT Connection IO Statement
prepare' s =  ReaderT $ flip prepare s

getUsers' :: Connection -> IO [User]
getUsers' c = do
  select <- runReaderT (prepare' "select * from users limit 10") c
  _ <- execute select []
  result <- fetchAllRowsMap' select
  toJsonUtil result

getUserById' :: String -> Connection -> IO User
getUserById' i c = do
  select <- runReaderT (prepare' "select * from users where id = ?") c
  _ <- execute select [toSql i]
  result <- fetchRowMap select
  toJsonUtil' result

getUserByEmail :: String -> Connection -> IO User
getUserByEmail i c = do
  select <- runReaderT (prepare' "select * from users where email = ?") c
  _ <- execute select [toSql i]
  result <- fetchRowMap select
  toJsonUtil' result

getValues :: User -> [SqlValue]
getValues u = [toSql $ name u, toSql $ slug u, toSql $ email u, toSql $ phone u, toSql $ image_url u, toSql $ language u, toSql $ location u]

createUser' :: User -> Connection -> IO User
createUser' u c = do
  insert <- runReaderT (prepare' "insert into users (name, slug, email, phone, image_url, language, location) values (?,?,?,?,?,?,?)") c
  _ <- execute insert $ getValues u
  getUserByEmail (email u) c
