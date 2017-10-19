module NK.DBConnection (
  getConnection
) where

import           Data.Maybe
import           Data.Monoid
import           Database.HDBC.PostgreSQL
import           System.Environment

host :: IO String
host =  ("host="<>) . fromMaybe "localhost" <$> lookupEnv "nk_host"

user :: IO String
user = (" user="<>) . fromMaybe "nkrest" <$> lookupEnv "nk_user"

password :: IO String
password = (" password="<>) . fromMaybe "password" <$> lookupEnv "nk_password"

dbname:: IO String
dbname =  (" dbname=" <> ) . fromMaybe "nkrest" <$> lookupEnv "nk_dbname"

buildConnectString :: IO String
buildConnectString = fmap concat (sequenceA [host, user, password, dbname])

getConnection :: IO Connection
getConnection = buildConnectString >>= \s -> connectPostgreSQL s
