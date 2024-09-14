import festim

var app = init(Fenster, "red square. exit on esc key", 800, 600)

# check keys codes here https://theasciicode.com.ar/
# pressed key returns 1

while app.loop() and app.keys[27] == 0:
  for x in 350 .. 450:
    for y in 250 .. 350:
      app[x, y] = uint32(0xFF0000)
