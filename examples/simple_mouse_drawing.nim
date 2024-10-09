import fenstim, random

var
  app = init(Fenster, "Draw on mouse click. Change color with W key", 800, 600)
  currentColor = 0xFF0000.uint32

while app.loop and app.keys[27] == 0:

  if app.keys[ord('W')] == 1:
    currentColor = rand(uint32)

  let (mouseX, mouseY, mouseDown) = app.mouse

  if app.mouse[2] == 1:
    let x = clamp(app.mouse[0], 0, app.width)
    let y = clamp(app.mouse[1], 0, app.height)
    app[x, y] = currentColor
