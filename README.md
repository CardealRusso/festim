# Fenstim
Fenstim is a Nim wrapper for [Fenster](https://github.com/zserge/fenster), the most minimal cross-platform GUI library. It provides a simple and efficient way to create graphical applications in Nim.

# Implementation status
- [x] Minimal 24-bit RGB framebuffer.
- [x] Application lifecycle and system events are all handled automatically.
- [x] Simple polling API without a need for callbacks or multithreading (like Arduino/Processing).
- [x] Cross-platform keyboard events (keycodes).
- [x] Cross-platform mouse events (X/Y + mouse click).
- [x] Cross-platform timers to have a stable FPS rate. (builtin)
- [ ] Cross-platform audio playback (WinMM, CoreAudio, ALSA). [#1](https://github.com/CardealRusso/fenstim/issues/1)

# Credits
Project done in collaboration with @ElegantBeef and @morturo at https://forum.nim-lang.org/t/12504

# Examples
Basic usage
```nim
import fenstim

var app = init(Fenster, "My Window", 800, 600, 60)

if app.loop:
  echo "Window target FPS: ", app.targetFps, ", Resolution: ", app.width, "x", app.height

while app.loop:
  # Set pixel color
  app[400, 300] = 16711680  # Decimal red
  app[410, 300] = (0, 255, 0)  # (r, g, b) green
  app[420, 300] = 0x0000FF # Hexadecimal blue

  # Get pixel color
  let color = app[420, 300] # Decimal

  # Check key press
  if app.keys[ord('A')] == 1:
    echo "A key is pressed"

  # Get mouse position and click state
  let (mouseX, mouseY, mouseClick) = app.mouse

  # Adjust FPS
  app.targetFps = 30
```

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

# API usage
### Initialization
```nim
proc init*(_: type Fenster, title: string, width: int, height: int, fps: int = 60): Fenster
```  
Creates a new Fenster window with the specified title, dimensions, and target FPS.

### Main Loop
```nim
proc loop*(self: var Fenster): bool
```
Handles events and updates the display. Returns false when the window should close.

### Pixel Manipulation
```nim
proc `[]`*(self: Fenster, x, y: int): uint32
proc `[]=`*(self: Fenster, x, y: int, color: SomeInteger)
proc `[]=`*(self: Fenster, x, y: int, color: tuple[r, g, b: uint8])
```
Get or set pixel color at (x, y). Color can be specified as a 32-bit integer or as an (r, g, b) tuple.

### Window Properties
```nim
proc width*(self: Fenster): int
proc height*(self: Fenster): int
proc targetFps*(self: Fenster): int
proc `targetFps=`*(self: var Fenster, fps: int)
```

### Input Handling
```nim
proc keys*(self: Fenster): array[256, cint]
proc mouse*(self: Fenster): tuple[x, y, click: int]
proc modkey*(self: Fenster): int
```
keys = Array of key states. Index corresponds to ASCII value (0-255), but arrows are 17..20.  
mouse = Get mouse position (x, y) and click state.  
modkey = 4 bits mask, ctrl=1, shift=2, alt=4, meta=8

### Low-complexity art gallery
```nim
  t += 0.1
  for i in 0..<app.width:
    for j in 0..<app.height:
      let plasma = sin(i.float * 0.04 + t) + sin(j.float * 0.03) + sin((i.float + j.float) * 0.02 + t)
      let color = uint32((plasma + 3) * 85)
      app[i, j] = color shl 16 or (color shl 1) shl 8 or color shl 2
```
![lca1](examples/gifs/lca1.gif)

```nim
  t += 1
  for i in 0..<app.width:
    for j in 0..<app.height:
      app[i, j] = (i xor j xor t) * 65793
```
![lca1](examples/gifs/lca2.gif)

```nim
  t += 1
  for i in 0..<app.width:
    for j in 0..<app.height:
      app[i, j] = (i * j * t)
```
![lca1](examples/gifs/lca3.gif)