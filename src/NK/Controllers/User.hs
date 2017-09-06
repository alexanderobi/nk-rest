{-# LANGUAGE OverloadedStrings #-}

module NK.Controllers.User (
    getUsersRoute
  , getUserByIdRoute
) where

import Web.Scotty (json, param, get, liftAndCatchIO, ActionM, ScottyM)
import NK.Model.User (getUserById, getUsers, User)
import NK.DBConnection (getConnection)

getUserByIdAction :: ActionM ()
getUserByIdAction = do
  idx <- param "id"
  result <- liftAndCatchIO (getUserById idx =<< getConnection)
  json result

getUsersAction :: ActionM ()
getUsersAction = do
  result <- liftAndCatchIO (getUsers =<< getConnection)
  json result

getUserByIdRoute :: ScottyM ()
getUserByIdRoute = get "/users/:id" getUserByIdAction

getUsersRoute :: ScottyM ()
getUsersRoute = get "/users" getUsersAction