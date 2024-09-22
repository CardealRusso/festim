# [Fenster](https://github.com/zserge/fenster)
The most minimal cross-platform GUI library.

Requires only Xlibs (libX11, libcxb, libXau, libXdmcp) on Linux. No additional requirements for Windows (gdi32) or MAC (Cocoa)

# Credits
Project done in collaboration with @ElegantBeef and @morturo at https://forum.nim-lang.org/t/12504

# Implementation status
- [x] Minimal 24-bit RGB framebuffer.
- [x] Application lifecycle and system events are all handled automatically.
- [x] Simple polling API without a need for callbacks or multithreading (like Arduino/Processing).
- [x] Cross-platform keyboard events (keycodes).
- [x] Cross-platform mouse events (X/Y + mouse click).
- [x] Cross-platform timers to have a stable FPS rate. (builtin)
- [ ] Cross-platform audio playback (WinMM, CoreAudio, ALSA). [#1](https://github.com/CardealRusso/fenstim/issues/1)

# Examples
Opens a 60fps 800x600 window, draws a red square and exits when pressing the Escape key:

```nim
# examples/red_square.nim
import fenstim

var app = init(Fenster, "Red square with fenstim", 800, 600, 60)

while app.loop and app.keys[27] == 0:
  for x in 350 .. 450:
    for y in 250 .. 350:
      app[x, y] = 0xFF0000
```

Audio example (Currently linux only)
```nim
# examples/audio.nim
import fenstim, fenstim_audio

var 
  app = init(Fenster, "Audio Example", 320, 240, 60)
  app_audio = init(FensterAudio)
  t, u = 0

proc generateAudio(n: int): seq[float32] =
  result = newSeq[float32](n)
  for i in 0..<n:
    u.inc
    let x = (u * 80 div 441).int
    result[i] = float32(((((x shr 10) and 42) * x) and 0xff)) / 256.0

while app.loop and app.keys[27] == 0:
  t.inc

  let n = app_audio.available
  if n > 0:
    let audio = generateAudio(n)
    app_audio.write(audio)

  for i in 0..<app.width:
    for j in 0..<app.height:
      app[i, j] = (i * j * t)

```
