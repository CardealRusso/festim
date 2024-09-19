import os

const fensterHeader = currentSourcePath().parentDir() / "fenster/fenster.h"

when defined(linux): {.passl: "-lX11".}
elif defined(windows): {.passl: "-lgdi32".}
elif defined(macosx): {.passl: "-framework Cocoa".}

{.passC: "-Ivendor".}

type
  FensterStruct = object
    title*: cstring
    width*: cint
    height*: cint
    buf*: ptr UncheckedArray[uint32]
    keys*: array[256, cint]
    modkey*: cint
    x*: cint
    y*: cint
    mouse*: cint
  
  Fenster* = object
    raw: ptr FensterStruct
    targetFps: int
    lastFrameTime: int64

  Draw* = object
    fenster: ptr Fenster

  Point* = tuple[x, y: int]

{.push importc, header: fensterHeader.}
proc fenster_open(fenster: ptr FensterStruct): cint
proc fenster_loop(fenster: ptr FensterStruct): cint
proc fenster_close(fenster: ptr FensterStruct)
proc fenster_sleep(ms: cint)
proc fenster_time(): int64
{.pop.}

proc `=destroy`(self: Fenster) =
  fenster_close(self.raw)
  dealloc(self.raw.buf)
  dealloc(self.raw)

proc init*(_: type Fenster, title: string, width: int, height: int, fps: int = 60): Fenster =
  result = Fenster()
  
  result.raw = cast[ptr FensterStruct](alloc0(sizeof(FensterStruct)))
  result.raw.title = cstring(title)
  result.raw.width = cint(width)
  result.raw.height = cint(height)
  result.raw.buf =
    cast[ptr UncheckedArray[uint32]](alloc(width * height * sizeof(uint32)))
  
  result.targetFps = fps
  result.lastFrameTime = fenster_time()
  
  discard fenster_open(result.raw)

proc loop*(self: var Fenster): bool =
  let frameTime = 1000 div self.targetFps
  let currentTime = fenster_time()
  let elapsedTime = currentTime - self.lastFrameTime
  
  if elapsedTime < frameTime:
    fenster_sleep((frameTime - elapsedTime).cint)
  
  self.lastFrameTime = fenster_time()
  result = fenster_loop(self.raw) == 0

proc sleep*(ms: int) = fenster_sleep(ms.cint)
proc time*(): int64 = fenster_time()

proc `[]`*(self: Fenster, x, y: int): uint32 =
  self.raw.buf[y * self.raw.width + x]

proc `[]=`*(self: Fenster, x, y: int, color: SomeInteger) =
  self.raw.buf[y * self.raw.width + x] = color.uint32

proc width*(self: Fenster): int = self.raw.width.int
proc height*(self: Fenster): int = self.raw.height.int
proc keys*(self: Fenster): array[256, cint] = self.raw.keys
proc mouse*(self: Fenster): tuple[x, y, click: int] = (self.raw.x.int, self.raw.y.int, self.raw.mouse.int)
proc modkey*(self: Fenster): int = self.raw.modkey.int

proc targetFps*(self: Fenster): int = self.targetFps
proc `targetFps=`*(self: var Fenster, fps: int) = self.targetFps = fps

proc line*(self: Draw, startPos, endPos: tuple[x, y: int], color: SomeInteger, thickness: int = 1): seq[Point] =
  var points: seq[Point] = @[]
  let 
    (x1, y1) = startPos
    (x2, y2) = endPos
    dx = abs(x2 - x1)
    dy = abs(y2 - y1)
    sx = if x1 < x2: 1 else: -1
    sy = if y1 < y2: 1 else: -1
  var 
    (x, y) = (x1, y1)
    err = dx - dy

  while true:
    for tx in -thickness div 2 .. thickness div 2:
      for ty in -thickness div 2 .. thickness div 2:
        let 
          px = x + tx
          py = y + ty
        if px in 0..<self.fenster.raw.width and py in 0..<self.fenster.raw.height:
          self.fenster.raw.buf[py * self.fenster.raw.width + px] = color.uint32
          points.add((px, py))

    if x == x2 and y == y2: break

    let e2 = 2 * err
    if e2 > -dy:
      err -= dy
      x += sx
    if e2 < dx:
      err += dx
      y += sy

  points

proc paint*(self: Draw, points: seq[Point], color: SomeInteger) =
  for point in points:
    let (x, y) = point
    if x >= 0 and x < self.fenster.raw.width and y >= 0 and y < self.fenster.raw.height:
      self.fenster.raw.buf[y * self.fenster.raw.width + x] = color.uint32

proc draw*(self: var Fenster): Draw =
  Draw(fenster: addr self)