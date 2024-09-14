import festim

var app = init(Fenster, "color progression", 800, 600)
var x, y, color = 0

proc nextColor(): uint32 =
  result = uint32(color)
  color += 1

while app.loop():
  app[x, y] = nextColor()

  x += 1
  if x >= app.width:
    x = 0
    y += 1
    if y >= app.height:
      y = 0