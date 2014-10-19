module HackySDL.Events where

import Graphics.UI.SDL.Video
import Graphics.UI.SDL.Timer
import Graphics.UI.SDL.Basic
import Graphics.UI.SDL.Event
import Graphics.UI.SDL.Types

import Foreign.Marshal.Alloc
import Foreign.Storable

import Control.Applicative
import Control.Monad.IO.Class

import HackySDL.Monad



getEvents :: SDL [Event]
getEvents = liftIO $ alloca getEvents'
  where getEvents' ev = do
          res <- pollEvent ev
          case res of
            0 -> return []
            _ -> (:) <$> peek ev <*> getEvents' ev


