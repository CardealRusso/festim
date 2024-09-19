import fenstim, random

proc randomColor(): int = rand(0x000000..0xFFFFFF)

var app = init(Fenster, "Random Color Square", 800, 600, 30)

var sides = [
  app.draw.line((300, 250), (500, 250), 0xFFFFFF, 5),
  app.draw.line((500, 250), (500, 450), 0xFFFFFF, 5),
  app.draw.line((500, 450), (300, 450), 0xFFFFFF, 5),
  app.draw.line((300, 450), (300, 250), 0xFFFFFF, 5)
]

while app.loop and app.keys[27] == 0:
  for side in sides:
    app.draw.paint(side, randomColor())