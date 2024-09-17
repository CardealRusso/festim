import fenstim, random

var app = init(Fenster, "White noise with fenstim", 800, 600)

while app.loop and app.keys[27] == 0:
  for x in 0 ..< app.width:
    for y in 0 ..< app.height:
      #app[x, y] = rand(0xFFFFFF) or 0xFF000000
      app[x, y] = rand(int32.high)

app.close