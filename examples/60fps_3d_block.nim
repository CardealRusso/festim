#code generated by claude 3.5 sonnet
import fenstim
import math
import sequtils

type
  Point3D = tuple[x, y, z: float]
  Point2D = tuple[x, y: int]

proc rotate(p: Point3D, angleX, angleY: float): Point3D =
  let
    cosX = cos(angleX)
    sinX = sin(angleX)
    cosY = cos(angleY)
    sinY = sin(angleY)
  var temp = p
  # Rotation around Y
  temp.x = p.x * cosY - p.z * sinY
  temp.z = p.x * sinY + p.z * cosY
  # Rotation around X
  result.y = temp.y * cosX - temp.z * sinX
  result.z = temp.y * sinX + temp.z * cosX
  result.x = temp.x

proc project(p: Point3D, center_x, center_y: int): Point2D =
  let factor = 300.0 / (300.0 - p.z)
  result.x = int(p.x * factor) + center_x
  result.y = int(p.y * factor) + center_y

proc drawLine(app: Fenster, x0, y0, x1, y1: int, color: uint32) =
  var
    x = x0
    y = y0
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    sx = if x0 < x1: 1 else: -1
    sy = if y0 < y1: 1 else: -1
    err = dx - dy

  while true:
    if x >= 0 and x < 800 and y >= 0 and y < 600:
      app[x, y] = color

    if x == x1 and y == y1: break

    let e2 = 2 * err
    if e2 > -dy:
      err -= dy
      x += sx
    if e2 < dx:
      err += dx
      y += sy

proc drawFace(app: Fenster, pts: seq[Point2D], color: uint32) =
  for i in 0 ..< pts.len:
    let
      p1 = pts[i]
      p2 = pts[(i + 1) mod pts.len]
    drawLine(app, p1.x, p1.y, p2.x, p2.y, color)

proc drawBlock3D(app: Fenster, center_x, center_y: int, size: int, angleX, angleY: float) =
  let
    frontColor = 0xFF0000'u32  # Red
    topColor = 0xC00000'u32    # Dark red
    sideColor = 0xDC0000'u32   # Medium red
    half = float(size div 2)

  let vertices = @[
    (-half, -half, -half),
    (half, -half, -half),
    (half, half, -half),
    (-half, half, -half),
    (-half, -half, half),
    (half, -half, half),
    (half, half, half),
    (-half, half, half)
  ]

  let projectedVertices = vertices.mapIt(project(rotate(it, angleX, angleY), center_x, center_y))

  # Draw all faces
  let faces = @[
    (@[0, 1, 2, 3], frontColor),  # Front
    (@[4, 5, 6, 7], topColor),    # Back
    (@[0, 4, 7, 3], sideColor),   # Left
    (@[1, 5, 6, 2], sideColor),   # Right
    (@[3, 2, 6, 7], topColor),    # Top
    (@[0, 1, 5, 4], topColor)     # Base
  ]

  for (faceIndices, color) in faces:
    drawFace(app, faceIndices.mapIt(projectedVertices[it]), color)

proc main() =
  var app = init(Fenster, "Rotating 3D Block", 800, 600)
  var
    angleX: float = 0.0
    angleY: float = 0.0

  let frameTime = 1000 div 60
  var now = app.time()

  while app.loop and app.keys[27] == 0:
    for x in 0..799:
      for y in 0..599:
        app[x, y] = 0

    drawBlock3D(app, 400, 300, 200, angleX, angleY)
    
    angleX += 0.02
    angleY += 0.03
    if angleX > 2 * PI: angleX -= 2 * PI
    if angleY > 2 * PI: angleY -= 2 * PI

    let timeElapsed = app.time() - now
    if timeElapsed < frameTime:
      app.sleep(frameTime - timeElapsed)
    now = app.time()

  app.close()


when isMainModule:
  main()
