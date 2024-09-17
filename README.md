# [Fenster](https://github.com/zserge/fenster)
The most minimal cross-platform GUI library.

Requires only Xlibs (libX11, libcxb, libXau, libXdmcp) on Linux. No additional requirements for Windows (gdi32) or MAC (Cocoa)

# Credits
Project done in collaboration with @ElegantBeef and @morturo at https://forum.nim-lang.org/t/12504

# Examples
Opens a 800x600 window, draws a red square and exits when pressing the Escape key:

```nim
-- red_square_exit_on_esc_key.nim.lua
import festim

var app = init(Fenster, "red square. exit on esc key", 800, 600)

while app.loop() and app.keys[27] == 0:
  for x in 350 .. 450:
    for y in 250 .. 350:
      app[x, y] = 0xFF0000
```
