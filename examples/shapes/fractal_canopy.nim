import fenstim, math

proc drawTree(app: var Fenster, x, y, len, angle: float, depth: int) =
  if depth <= 0: return
  
  let endX = x + len * cos(angle)
  let endY = y - len * sin(angle)
  
  discard app.draw.line((x.int, y.int), (endX.int, endY.int), 0xFFFFFF,1)
  
  let newLen = len * 0.7
  let newDepth = depth - 1
  
  drawTree(app, endX, endY, newLen, angle + PI/6, newDepth)
  drawTree(app, endX, endY, newLen, angle - PI/6, newDepth)

var app = init(Fenster, "Fractal Tree", 800, 600, 24)

drawTree(app, x = app.width.float / 2, y = app.height.float, len = 100, angle = PI/2, depth = 10)

while app.loop and app.keys[27] == 0: discard