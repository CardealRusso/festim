import festim, random

var app = init(Fenster, "white noise with fenster", 800, 600)

while app.loop:
  for x in 0 ..< app.width:
    for y in 0 ..< app.height:
      app[x, y] = rand(int32.high)

app.destroy