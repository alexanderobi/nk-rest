{-# LANGUAGE OverloadedStrings #-}

module NK.Controllers.User (
    getUsersRoute
  , getUserByIdRoute
  , postUserRoute
) where

import           Control.Monad.IO.Class
import           Control.Monad.Trans.Reader
import           NK.DBConnection            (getConnection)
import           NK.Model.User              (createUser, getUserById, getUsers)
import           NK.Controllers.Response    (Except(..))
import           Web.Scotty.Trans           (ScottyT, ActionT, get, json, jsonData, param, post, liftAndCatchIO, raise)

getUserByIdAction :: MonadIO m => ActionT Except m ()
getUserByIdAction = do
  idx <- param "id"
  result <- liftAndCatchIO $ getConnection >>= runReaderT (getUserById idx)
  case result of
    Just res -> json res
    Nothing -> raise (NotFound 832)

getUsersAction :: MonadIO m => ActionT Except m ()
getUsersAction = do
  result <- liftAndCatchIO $ getConnection >>= runReaderT getUsers
  json result

postUserAction :: MonadIO m => ActionT Except m ()
postUserAction = do
  user <- jsonData
  result <- liftAndCatchIO $ getConnection >>= runReaderT (createUser user)
  json result

getUserByIdRoute :: MonadIO m => ScottyT Except m ()
getUserByIdRoute = get "/users/:id/" getUserByIdAction

getUsersRoute :: MonadIO m => ScottyT Except m ()
getUsersRoute = get "/users/" getUsersAction

postUserRoute :: MonadIO m => ScottyT Except m ()
postUserRoute = post "/users/" postUserAction
