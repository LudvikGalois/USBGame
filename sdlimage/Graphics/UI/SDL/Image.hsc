module Graphics.UI.SDL.Image where

#include <SDL.h>
#include <SDL_image.h>

import Foreign
import Foreign.C.String
import Prelude hiding (init)
import Graphics.UI.SDL.Types

-- I just copied half of this from someone else. It said public domain so #yolo
-- it also didn't work, so I had to fix quite a bit

version :: (Int, Int, Int)
version = ( #{const SDL_IMAGE_MAJOR_VERSION}
          , #{const SDL_IMAGE_MINOR_VERSION}
          , #{const SDL_IMAGE_PATCHLEVEL}
          )
newtype ImageFlag = ImageFlag { unwrapFlag :: #{type int} }

#{enum ImageFlag, ImageFlag
     , initJpg = IMG_INIT_JPG
     , initPng = IMG_INIT_PNG
     , initTif = IMG_INIT_TIF
     , initWebp = IMG_INIT_WEBP
     }

data ImageType = BMP | CUR | GIF | ICO | JPG | LBM | PCX | PNG | PNM | TGA | TIF | XCF | XPM | XV
    deriving (Show, Eq)

combineImageFlag :: [ImageFlag] -> ImageFlag
combineImageFlag = ImageFlag . foldr ((.|.) . unwrapFlag) 0

foreign import ccall unsafe "IMG_Init"
  init' :: #{type int} -> IO ()

init :: [ImageFlag] -> IO ()
init flags = init' $ unwrapFlag $ combineImageFlag flags

foreign import ccall unsafe "IMG_Quit"
  quit :: IO ()

foreign import ccall unsafe "IMG_Load"
  imgLoad :: CString -> IO (Ptr Surface)
