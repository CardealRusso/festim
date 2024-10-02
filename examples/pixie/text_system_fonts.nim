import fenstim, pixie, os, random

randomize()

var 
  app = init(Fenster, "Pixie Text Example on Fenstim with system font", 200, 200)

let 
  fonts = app.getFonts
  image = newImage(200, 200)
  randomFont = fonts[rand(fonts.len - 1)]
  text = "Used font: " & lastPathPart(randomFont)

#image.fill(rgba(255, 255, 255, 255))

var font = readFont(randomFont)
font.size = 16
font.paint.color = color(1, 0, 0)

image.fillText(font.typeset(text, vec2(180, 180)), translate(vec2(10, 10)))

for y in 0 ..< image.height:
  for x in 0 ..< image.width:
    let rgbx = image.unsafe[x, y]
    app[x, y] = (rgbx.r, rgbx.g, rgbx.b)

while app.loop and app.keys[27] == 0:
  discard