module Graphics.UI.SDL.Mixer where

#include <SDL.h>
#include <SDL_mixer.h>

import Foreign
import Foreign.C.Types
import Foreign.C.String
import Prelude hiding (init)
import Graphics.UI.SDL.Types hiding (AudioFormat)

import Data.Word

foreign import ccall unsafe "Mix_OpenAudio"
  mixOpenAudio :: CInt -> AudioFormat -> CInt -> CInt -> IO CInt

foreign import ccall unsafe "Mix_Quit"
  mixQuit :: IO ()

foreign import ccall unsafe "Mix_LoadMUS"
  mixLoadMUS :: CString -> IO Music

foreign import ccall unsafe "Mix_PlayMusic"
  mixPlayMusic :: Music -> CInt -> IO CInt

foreign import ccall unsafe "SDL_GetError"
  mixGetError :: IO CString

type Music = Ptr ()

newtype AudioFormat = AudioFormat { unwrapAudio :: #{type Uint16} }
#{enum AudioFormat, AudioFormat
     , audioU8 = AUDIO_U8
     , audioS8 = AUDIO_S8
     , audioU16LSB = AUDIO_U16LSB
     , audioS16LSB = AUDIO_S16LSB
     , audioU16MSB = AUDIO_U16MSB
     , audioS16MSB = AUDIO_S16MSB
     , audioU16 = AUDIO_U16
     , audioS16 = AUDIO_S16
     , audioU16Sys = AUDIO_U16SYS
     , audioS16Sys = AUDIO_S16SYS
     }
