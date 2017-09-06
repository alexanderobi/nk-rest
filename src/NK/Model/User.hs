{-# LANGUAGE DeriveGeneric #-}

module NK.Model.User (
    getUserById
  , getUsers
  , User
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL
import GHC.Generics
import Data.Aeson
import NK.Util.JsonUtil

data User = User {
    id         :: String
  , name       :: String
  , slug       :: String
  , email      :: String
  , phone      :: String
  , image_url  :: String
  , language   :: String
  , last_login :: String
  , location   :: String
  , created_at :: String
  , updated_at :: String
  , published  :: Bool
} deriving (Generic, Show)

instance ToJSON User where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON User where

getUsers :: Connection -> IO [User]
getUsers c = do
  select <- prepare c "select * from users limit 10"
  execute select []
  result <- fetchAllRowsMap' select
  toJsonUtil result

getUserById :: String -> Connection -> IO User
getUserById i c = do
  select <- prepare c "select * from users where id = ?"
  execute select [toSql i]
  result <- fetchRowMap select
  toJsonUtil' result