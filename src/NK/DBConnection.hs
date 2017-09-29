module NK.DBConnection (
  getConnection
) where

import           Control.Monad.Trans.Reader
import           Data.Monoid
import           Database.HDBC.PostgreSQL
import           System.Environment

type EnvValue = String

type EnvKey = String

type DefaultValue = String

getDBEnv :: EnvKey -> EnvValue -> DefaultValue -> IO String
getDBEnv k v d = do
  env <- lookupEnv v
  case env of
    Nothing -> return (k <> d)
    Just a  -> return (k <> a)

buildConnectString :: IO String
buildConnectString = do
  host <- getDBEnv "host=" "nk_host" "localhost"
  user <- getDBEnv " user=" "nk_user" "nkrest"
  pass <- getDBEnv " password=" "nk_password" "password"
  dbname <- getDBEnv " dbname=" "nk_dbname" "nkrest"
  return (host <> user <> pass <> dbname)

connection' :: ReaderT String IO Connection
connection' = ReaderT connectPostgreSQL

getConnection :: IO Connection
getConnection = buildConnectString >>= runReaderT connection'
