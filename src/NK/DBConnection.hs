module NK.Db where

import Database.HDBC
import Database.HDBC.PostgreSQL
import System.Environment
import Data.Maybe
import Data.Monoid

type ConnectionString = String

host :: IO String
host = lookupEnv "nk_host" >>= \h -> fmap ("host=" <> ) fromMaybe h "localhost"

user :: IO String
user = lookupEnv "nk_user" >>= \u -> fmap ("user=" <> ) fromMaybe u "nkrest"

password :: IO String
password = lookupEnv "nk_password" >>= \p -> fmap ("password=" <> ) fromMaybe p "password"

dbname:: IO String
dbname = lookupEnv "nk_dbname" >>= \p -> fmap ("dbname=" <> ) fromMaybe p "nkrest"

buildConnectString :: IO String
buildConnectString = fmap (foldl \a b -> a <> b) sequenceA [host, user, password, dbname]

getConnection :: IO Connection
getConnection = buildConnectString >>= \s -> connectPostgreSQL s