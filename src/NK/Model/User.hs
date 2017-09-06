{-# LANGUAGE DeriveGeneric #-}

module NK.Model.Users (
    getAllUsers
  , getUsers
) where

import Control.Exception
import Database.HDBC
import Database.HDBC.PostgreSQL
import GHC.Generics
import Data.Aeson
import NK.Util.JsonUtil

data Users = Users {
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

instance ToJSON Users where
  toEncoding = genericToEncoding defaultOptions

instance FromJSON Users where

getAllUsers :: Connection -> IO ()
getAllUsers c = do
  select <- prepare c "select * from users limit 10"
  execute select []
  result <- fetchAllRows select
  putStr . show $ result


getUsers :: Connection -> IO [Users]
getUsers c = do
  select <- prepare c "select * from users limit 10"
  execute select []
  result <- fetchAllRowsMap' select
  toJsonUtil result

getUserById :: Connection -> String -> IO Users
getUserById c i = do
  select <- prepare c "select * from users where id = ?"
  execute select [toSql i]
  result <- fetchRowMap select
  toJsonUtil' result