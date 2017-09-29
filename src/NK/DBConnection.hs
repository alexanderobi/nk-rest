module NK.DBConnection (
  getConnection
) where

import           Control.Monad.IO.Class
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

withConnection :: ReaderT String IO Connection
withConnection = do
  s <- ask
  liftIO $ connectPostgreSQL s

getConnection :: IO Connection
getConnection = buildConnectString >>= runReaderT withConnection
