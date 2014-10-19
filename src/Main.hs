import Graphics.UI.SDL.Video
import Graphics.UI.SDL.Timer
import Graphics.UI.SDL.Basic
import Graphics.UI.SDL.Event
import Graphics.UI.SDL.Types
import Graphics.UI.SDL.Mixer
import Foreign.Ptr
import Foreign.C.String
import Foreign.Storable
import Foreign.Marshal.Alloc
import Control.Monad
import Control.Monad.IO.Class

import Control.Lens

import HackySDL.Events
import HackySDL.Monad

import qualified Graphics.UI.SDL.Image as I

main :: IO ()
main = runSDL (Just "USB - The quest to move files") (WindowSize 10 10 640 480) setup

setup :: SDL a
setup = do
  use windowSurf >>= (liftIO . \s ->  fillRect s nullPtr 0xffffffff)
  img <- loadImageFromPath "test.png"
  surf <- use windowSurf
  liftIO $
    alloca $ \clipRect ->
    alloca $ \drawRect -> do
      poke clipRect (Rect 100 100 100 100)
      poke drawRect (Rect 10 10 50 50) -- Do these last two values get used?
      blitSurface img clipRect surf drawRect

  playSongForever "discord.ogg"
  forever alone -- sometimes you make it too easy

alone :: SDL ()
alone = do
    getEvents >>= mapM_ handleEvent
    redraw
    liftIO $ delay 16

handleEvent :: Event -> SDL ()
handleEvent (KeyboardEvent _ _ _ 1 r (Keysym _ 0x1b _)) = do
  exitSDL
handleEvent (KeyboardEvent _ _ _ s r k) = do
  use windowSurf >>= (liftIO . \s -> (fillRect s nullPtr 0xffabcdef))
  return ()
handleEvent _ = return ()
