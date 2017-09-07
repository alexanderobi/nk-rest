module Rest (
  scottyMain
) where

import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           NK.Controllers.User                  (getUserByIdRoute,
                                                       getUsersRoute,
                                                       postUserRoute)
import           Web.Scotty                           (middleware, scotty)

scottyMain :: IO ()
scottyMain = scotty 3333 $ do
  middleware logStdoutDev
  getUserByIdRoute
  getUsersRoute
  postUserRoute
