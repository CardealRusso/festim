import fenstim, pixie

let image = newImage(200, 200)
image.fill(rgba(255, 255, 255, 255))

var font = readFont("Roboto-Regular_1.ttf")
font.size = 20
font.paint.color = color(1, 0, 0)

let text = "Typesetting is the arrangement and composition of text in graphic design and publishing in both digital and traditional medias."

image.fillText(font.typeset(text, vec2(180, 180)), translate(vec2(10, 10)))

var app = init(Fenster, "Pixie Text Example on Fenstim", 200, 200)

for y in 0 ..< image.height:
  for x in 0 ..< image.width:
    let rgbx = image.unsafe[x, y]
    let color = rgbx.color()
    app[x, y] = (uint32(color.r * 255) shl 16) or (uint32(color.g * 255) shl 8) or (uint32(color.b * 255))

while app.loop and app.keys[27] == 0:
  discard