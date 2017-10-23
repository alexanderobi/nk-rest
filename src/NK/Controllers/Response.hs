{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module NK.Controllers.Response (
      Except (Forbidden, NotFound, StringEx)
    , handleEx
) where

import           Control.Monad.IO.Class
import           Data.String                (fromString)
import           Web.Scotty.Trans           (ActionT, ScottyError, stringError, showError, status, html, json)
import           Network.HTTP.Types
import           Data.Aeson                 (ToJSON, FromJSON, toEncoding, genericToEncoding, defaultOptions)
import           GHC.Generics
import           System.Log.Logger
import           NK.Util.Logger (appLogger, appLoggerName)

data Except = Forbidden | NotFound Int | StringEx String deriving (Show, Eq)

instance ScottyError Except where
    stringError = StringEx
    showError = fromString . show

data Errors = Errors {
    msg :: String
    , errorCode :: Int
    , field :: String
} deriving (Generic, Show)

instance ToJSON Errors where
    toEncoding = genericToEncoding defaultOptions
  
instance FromJSON Errors where

data ErrorResponse = ErrorResponse {
    code :: Int
    , message :: String
    , errors :: Maybe [Errors]
} deriving (Generic, Show)

instance ToJSON ErrorResponse where
    toEncoding = genericToEncoding defaultOptions
    
instance FromJSON ErrorResponse where

fourOfour :: Int -> ErrorResponse
fourOfour i = ErrorResponse {
    code = i
    , message = "The item does not exist"
    , errors = Nothing
}

pageNotFound :: ErrorResponse
pageNotFound = ErrorResponse {
    code = 404
    , message = "Page Not Found!"
    , errors = Nothing
}

handleEx :: MonadIO m => Except -> ActionT Except m ()
handleEx Forbidden = do
    status status403
    html "<h1>Forbidden!!!</h1>"
handleEx (NotFound i) = do
    status status404
    json (fourOfour i)
handleEx (StringEx s) = do
    liftIO appLogger
    liftIO $ warningM appLoggerName $ show s
    status status404
    json pageNotFound