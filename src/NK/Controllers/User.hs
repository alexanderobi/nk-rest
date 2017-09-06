{-# LANGUAGE OverloadedStrings #-}

module NK.Controllers.User (
    getUsersRoute
  , getUserByIdRoute
  , postUserRoute
) where

import Web.Scotty (json, param, get, jsonData, liftAndCatchIO, post, ActionM, ScottyM)
import NK.Model.User (getUserById, getUsers, createUser, User)
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

postUserAction :: ActionM ()
postUserAction = do
  user <- jsonData
  result <- liftAndCatchIO (createUser user =<< getConnection)
  if result > 0 then json True else json False

getUserByIdRoute :: ScottyM ()
getUserByIdRoute = get "/users/:id" getUserByIdAction

getUsersRoute :: ScottyM ()
getUsersRoute = get "/users" getUsersAction

postUserRoute :: ScottyM ()
postUserRoute = post "/users" postUserAction