import fenstim, random

proc randomColor(): int =
  return rand(0x000000..0xFFFFFF)

var app = init(Fenster, "Random Color Square with line shape", 800, 600, 30)

let
  startX = 300
  startY = 250
  squareSize = 200
  squareColor = 0xFFFFFF
  squareThickness = 5

var
  top = app.draw.line(startX, startY, startX + squareSize, startY, squareColor, squareThickness)
  right = app.draw.line(startX + squareSize, startY, startX + squareSize, startY + squareSize, squareColor, squareThickness)
  base = app.draw.line(startX + squareSize, startY + squareSize, startX, startY + squareSize, squareColor, squareThickness)
  left = app.draw.line(startX, startY + squareSize, startX, startY, squareColor, squareThickness)

while app.loop and app.keys[27] == 0:
  app.draw.paint(top, randomColor())
  app.draw.paint(right, randomColor())
  app.draw.paint(base, randomColor())
  app.draw.paint(left, randomColor())