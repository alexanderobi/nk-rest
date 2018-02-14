module Rest (
  scottyMain
) where

import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           Network.Wai.Middleware.Cors
import           NK.Controllers.User                  (getUserByIdRoute, getUsersRoute,
                                                       postUserRoute)
import           NK.Controllers.Response              (handleEx)
import           Web.Scotty.Trans                     (middleware, scottyT, defaultHandler)

scottyMain :: IO ()
scottyMain = scottyT 3333 id $ do
  middleware logStdoutDev
  middleware simpleCors
  defaultHandler handleEx
  getUserByIdRoute
  getUsersRoute
  postUserRoute
