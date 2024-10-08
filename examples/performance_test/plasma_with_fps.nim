import fenstim, math

var 
  app = init(Fenster, "Plasma with FPS", 800, 600, 999)
  t = 0.0
  lastFpsUpdate = app.time

while app.loop and app.keys[27] == 0:
  if app.time - lastFpsUpdate >= 1000:
    echo "FPS: ", app.fps.int
    lastFpsUpdate = app.time
  
  t += 0.1
  for i in 0..<app.width:
    for j in 0..<app.height:
      let plasma = sin(i.float * 0.04 + t) + sin(j.float * 0.03) + sin((i.float + j.float) * 0.02 + t)
      let color = uint32((plasma + 3) * 85)
      app[i, j] = color shl 16 or (color shl 1) shl 8 or color shl 2
