import festim, random

var
  app = init(Fenster, "Draw on mouse click. Change color with W key", 800, 600)
  currentColor = 0xFF0000

while app.loop and app.keys[27] == 0:
  if app.keys[ord('W')] == 1:
    currentColor = rand(int32.high)

  if app.mouse == 1:
    let x = clamp(app.mousex, 0, app.width)
    let y = clamp(app.mousey, 0, app.height)
    app[x, y] = currentColor

app.close