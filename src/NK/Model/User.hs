{-# LANGUAGE DeriveGeneric #-}

module NK.Model.User (
    getUserById
  , getUsers
  , createUser
  , User
) where

import           Data.Aeson
import           Database.HDBC
import           Database.HDBC.PostgreSQL
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
  , updated_at :: Maybe String
  , published  :: Maybe Bool
} deriving (Generic, Show)

instance ToJSON User where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON User where

getUsers :: Connection -> IO [User]
getUsers c = do
  select <- prepare c "select * from users limit 10"
  _ <- execute select []
  result <- fetchAllRowsMap' select
  toJsonUtil result

getUserById :: String -> Connection -> IO User
getUserById i c = do
  select <- prepare c "select * from users where id = ?"
  _ <- execute select [toSql i]
  result <- fetchRowMap select
  toJsonUtil' result

getValues :: User -> [SqlValue]
getValues u = [toSql $ name u, toSql $ slug u, toSql $ email u, toSql $ phone u, toSql $ image_url u, toSql $ language u, toSql $ location u]

createUser :: User -> Connection -> IO Integer
createUser u c = do
  insert <- prepare c "insert into users (name, slug, email, phone, image_url, language, location) values (?,?,?,?,?,?,?)"
  execute insert $ getValues u
