module Rest (
  scottyMain
) where

import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           NK.Controllers.User                  (getUserByIdRoute, getUsersRoute,
                                                       postUserRoute)
import           NK.Controllers.Response              (handleEx)
import           Web.Scotty.Trans                     (middleware, scottyT, defaultHandler)

scottyMain :: IO ()
scottyMain = scottyT 3333 id $ do
  middleware logStdoutDev
  defaultHandler handleEx
  getUserByIdRoute
  getUsersRoute
  postUserRoute
