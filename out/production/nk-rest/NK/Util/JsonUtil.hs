{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}

module NK.Util.JsonUtil (
    toJsonUtil
  , toJsonUtil'
) where

import           Data.Aeson
import           Data.Convertible
import qualified Data.Map.Lazy      as Map
import qualified Data.Text          as T
import qualified Data.Text.Encoding as T
import           Database.HDBC

nothingError :: IOError
nothingError = userError "Id NotFound"

toJsonUtil :: FromJSON a => [Map.Map String SqlValue] -> IO [a]
toJsonUtil s = do
  let result = fromJSON . toJSON $ s
  case result of
    Error e -> error $ "NK.Util.JsonUtil: Could not parse into JSON: " ++ e ++ "\nSqlValue: " ++ show s
    Success x -> return x

toJsonUtil' :: FromJSON a => Maybe(Map.Map String SqlValue) -> IO a
toJsonUtil' (Just a) = case fromJSON . toJSON $ a of
  Error e -> error $ "NK.Util.JsonUtil: Could not parse into JSON: " ++ e ++ "\nSqlValue: " ++ show a
  Success x -> return x
toJsonUtil' _ = ioError nothingError

instance ToJSON SqlValue where
    toJSON (SqlByteString x) = String . T.decodeUtf8 $ x
    toJSON (SqlInt32 x) = Number $ fromIntegral x
    toJSON (SqlInteger x) = Number $ fromIntegral  x
    toJSON (SqlRational x) = Number $ realToFrac x
    toJSON (SqlDouble x) = Number $ realToFrac x
    toJSON (SqlBool x) = Bool x
    toJSON (SqlLocalTime x) = String . T.pack . show $ x
    toJSON (SqlZonedTime x) = String . T.pack . show $ x
    toJSON SqlNull = Null
    toJSON x = error $ "Please implement ToJSON instance for SqlValue: " ++ show x

instance Convertible SqlValue Value where
    safeConvert (SqlString x) = return . String . T.pack $ x
    safeConvert (SqlByteString x) = return . String . T.decodeUtf8 $ x
    safeConvert (SqlWord32 x) = return . Number . fromIntegral $ x
    safeConvert (SqlWord64 x) = return . Number . fromIntegral $ x
    safeConvert (SqlInt32 x) = return . Number . fromIntegral $ x
    safeConvert (SqlInt64 x) = return . Number . fromIntegral $ x
    safeConvert (SqlInteger x) = return . Number . fromIntegral $ x
    safeConvert (SqlChar x) = return . String . T.pack $ [x]
    safeConvert (SqlBool x) = return . Bool $ x
    safeConvert (SqlDouble x) = return . Number . realToFrac $ x
    safeConvert (SqlRational x) = return . Number . realToFrac $ x
    safeConvert SqlNull = return Null
    safeConvert x = error $ "Please implement Convertible SqlValue Value for " ++ show x
