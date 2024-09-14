import festim
import random

var app = init(Fenster, "white noise with fenster", 800, 600)
while app.loop():
  for i in 0 ..< app.width:
    for j in 0 ..< app.height:
      app[i, j] = uint32(rand(int32.high))