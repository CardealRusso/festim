import fenstim, pixie, os, random

randomize()

let searchPatterns = when defined(linux):
  [
    expandTilde("~/.local/share/fonts/**/*.ttf"),
    expandTilde("~/.fonts/**/*.ttf"),
    # \/ bad and resource heavy, but it covers almost all possibilities
    "/usr/*/fonts/**/*.ttf",
    "/usr/*/*/fonts/**/*.ttf",
    "/usr/*/*/*/fonts/**/*.ttf",
    "/usr/*/*/*/*/fonts/**/*.ttf"
  ]
elif defined(macos):
  [
    expandTilde("~/Library/Fonts/**/*.ttf"),
    "/Library/Fonts/**/*.ttf",
    "/System/Library/Fonts/**/*.ttf",
    "/Network/Library/Fonts/**/*.ttf"
  ]
elif defined(windows):
  [
    getEnv("SYSTEMROOT") & "/Fonts/*.ttf",
    getEnv("LOCALAPPDATA") & "/Microsoft/Windows/Fonts/*.ttf"
  ]

var fonts: seq[string] = @[]

for pattern in searchPatterns:
  for entry in walkPattern(pattern):
    fonts.add(entry)

let image = newImage(200, 200)
#image.fill(rgba(255, 255, 255, 255))

let randomFont = fonts[rand(fonts.len - 1)]
var font = readFont(randomFont)
font.size = 16
font.paint.color = color(1, 0, 0)

let text = "Used font: " & lastPathPart(randomFont)

image.fillText(font.typeset(text, vec2(180, 180)), translate(vec2(10, 10)))

var app = init(Fenster, "Pixie Text Example on Fenstim with system font", 200, 200)

for y in 0 ..< image.height:
  for x in 0 ..< image.width:
    let rgbx = image.unsafe[x, y]
    app[x, y] = (rgbx.r, rgbx.g, rgbx.b)

while app.loop and app.keys[27] == 0:
  discard
