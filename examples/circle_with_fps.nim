import festim, times, random

var 
  app = init(Fenster, "random color circle, exit on esc key, fps counter", 800, 600)
  frameCount = 0
  lastTime = epochTime()
  radius = 100
  centerX = int(app.width / 2)
  centerY = int(app.height / 2)

while app.loop() and app.keys[27] == 0:
  let randomColor = uint32(rand(0xFFFFFF)) or 0xFF000000'u32
  
  for x in centerX - radius .. centerX + radius:
    for y in centerY - radius .. centerY + radius:
      let dx = x - centerX
      let dy = y - centerY
      if dx * dx + dy * dy <= radius * radius:
        app[x, y] = randomColor

  frameCount += 1
  let currentTime = epochTime()
  if currentTime - lastTime >= 1.0:
    echo "FPS: ", frameCount
    frameCount = 0
    lastTime = currentTime
