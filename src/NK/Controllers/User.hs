{-# LANGUAGE OverloadedStrings #-}

module NK.Controllers.User (
    getUsersRoute
  , getUserByIdRoute
  , postUserRoute
) where

import           NK.DBConnection (getConnection)
import           NK.Model.User   (createUser, getUserById, getUsers)
import           Web.Scotty      (ActionM, ScottyM, get, json, jsonData,
                                  liftAndCatchIO, param, post)

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
