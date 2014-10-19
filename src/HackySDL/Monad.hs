{-# Language TemplateHaskell #-}
-- The hackiest of monads

module HackySDL.Monad where

import Graphics.UI.SDL.Video
import Graphics.UI.SDL.Timer
import Graphics.UI.SDL.Basic
import Graphics.UI.SDL.Event
import Graphics.UI.SDL.Enum
import Graphics.UI.SDL.Types
import Graphics.UI.SDL.Mixer
import qualified Graphics.UI.SDL.Image as I

import Foreign.Ptr
import Foreign.C.String
import Foreign.C.Types
import Foreign.Storable

import Data.Maybe

import Control.Lens
import Control.Monad
import Control.Monad.Trans.State
import Control.Monad.IO.Class

import System.Exit

data SDLState = SDLState 
  { _window :: Window
  , _windowSurf :: Ptr Surface
  }

-- Lenses by hand, because template Haskell and C libraries don't play nicely together
window :: Lens' SDLState Window
window = lens _window (\s b -> s { _window = b})

windowSurf :: Lens' SDLState (Ptr Surface)
windowSurf = lens _windowSurf (\s b -> s { _windowSurf = b})

data WindowSize = WindowSize CInt CInt CInt CInt

type SDL a = StateT SDLState IO a

runSDL :: Maybe String -> WindowSize -> SDL a -> IO a
runSDL s (WindowSize tl tr h w) sdl = do
  Graphics.UI.SDL.Basic.init initFlagVideo
  I.init [I.initPng]
  mixOpenAudio 44100 audioS16Sys 2 2048
  window <- withCString (fromMaybe "SDL Program" s) $ \s ->
    createWindow s tl tr h w 0
  surf <- getWindowSurface window
  evalStateT sdl (SDLState window surf)

redraw :: SDL ()
redraw = void (use window >>= (liftIO . updateWindowSurface))

exitSDL :: SDL a
exitSDL = do
  uses window destroyWindow
  liftIO mixQuit
  liftIO I.quit
  liftIO quit 
  liftIO exitSuccess

loadImageFromPath :: String -> SDL (Ptr Surface)
loadImageFromPath path = do
  img <- liftIO $ withCString path (I.imgLoad)
  surf <- use windowSurf
  surfForm <- liftIO $ peek surf >>= return . surfaceFormat
  img' <- liftIO $ convertSurface img surfForm 0
  liftIO $ freeSurface img
  return img'

playSongForever :: String -> SDL ()
playSongForever path = do
  music <- liftIO $ withCString path mixLoadMUS
  liftIO $ mixPlayMusic music (-1)
  return ()
