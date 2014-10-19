USBGame
=======

USB - The quest to copy files

I've realised that most of the time other people need to use my computer, 
it's to copy something to, or from, a USB. This tends to be a painful experience for them, 
since my computer is not the most intuitive to use.

I intend to resolve this issue by turning this process into an 8-bit style adventure game. 
Be careful though, if you die too many times it might just format your USB.

It's written using Haskell and SDL2 (SDL was chosen because running on DirectFB was a requirement).
Unfortunately since the Haskell bindings to SDL2 are mediocre, I've had to ad-hoc some bindings of my own.

Unfortunately for you (the person reading this), you won't be able to run this, since it's very
much written for one specific machine (and yet I need to support both X and DirectFB... XD) and none of
the assets for the game are on github.
