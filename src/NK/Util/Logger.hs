module NK.Util.Logger (
      appLogger
    , appLoggerName
) where

import           System.Log.Formatter
import           System.Log.Logger
import           System.Log.Handler     (setFormatter)
import           System.Log.Handler.Simple
import           System.IO

type AppLogger = String

appLoggerName :: AppLogger
appLoggerName = "NK-Rest"

appLogger :: IO ()
appLogger = do
    h <- streamHandler stdout DEBUG >>= \lh -> return $ setFormatter lh (simpleLogFormatter "{ time : $time, App: $loggername, priority: $prio, message: $msg }")
    updateGlobalLogger appLoggerName (addHandler h)