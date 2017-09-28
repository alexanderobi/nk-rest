{-# LANGUAGE OverloadedStrings #-}

module NK.Controllers.User (
    getUsersRoute
  , getUserByIdRoute
  , postUserRoute
) where

import           Control.Monad.Trans.Reader
import           NK.DBConnection            (getConnection)
import           NK.Model.User              (createUser, getUserById, getUsers)
import           Web.Scotty                 (ActionM, ScottyM, get, json,
                                             jsonData, liftAndCatchIO, param,
                                             post)

getUserByIdAction :: ActionM ()
getUserByIdAction = do
  idx <- param "id"
  result <- liftAndCatchIO (getConnection >>= runReaderT (getUserById idx))
  json result

getUsersAction :: ActionM ()
getUsersAction = do
  result <- liftAndCatchIO (getConnection >>= runReaderT getUsers)
  json result

postUserAction :: ActionM ()
postUserAction = do
  user <- jsonData
  result <- liftAndCatchIO (getConnection >>= runReaderT (createUser user))
  json result

getUserByIdRoute :: ScottyM ()
getUserByIdRoute = get "/users/:id" getUserByIdAction

getUsersRoute :: ScottyM ()
getUsersRoute = get "/users" getUsersAction

postUserRoute :: ScottyM ()
postUserRoute = post "/users" postUserAction
