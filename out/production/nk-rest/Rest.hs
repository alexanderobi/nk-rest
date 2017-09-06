module Rest (
  scottyMain
) where

import Data.Monoid
import Web.Scotty (scotty, json, param, get, middleware)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import NK.Controllers.User (getUserByIdRoute, getUsersRoute)

scottyMain :: IO ()
scottyMain = scotty 3333 $ do
  middleware logStdoutDev
  getUserByIdRoute
  getUsersRoute