module NK.Controllers.Users where

import Web.Scotty

getUserByIdAction :: Users -> ActionM ()
getUserByIdAction