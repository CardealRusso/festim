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
  
  Fenster* = ref object
    raw: ptr FensterStruct
    targetFps: int
    lastFrameTime: int64

{.push importc, header: fensterHeader.}
proc fenster_open(fenster: ptr FensterStruct): cint
proc fenster_loop(fenster: ptr FensterStruct): cint
proc fenster_close(fenster: ptr FensterStruct)
proc fenster_sleep(ms: cint)
proc fenster_time(): int64
{.pop.}

#must replace this with =destroy
proc close*(self: Fenster) =
  if not self.raw.isNil:
    fenster_close(self.raw)
    if not self.raw.buf.isNil:
      dealloc(self.raw.buf)
    dealloc(self.raw)
    self.raw = nil

proc init*(_: type Fenster, title: string, width, height: int, fps: int = 60): Fenster =
  new(result, close)
  result.raw = cast[ptr FensterStruct](alloc0(sizeof(FensterStruct)))
  result.targetFps = fps
  result.lastFrameTime = fenster_time()
  result.raw.title = title.cstring
  result.raw.width = width.cint
  result.raw.height = height.cint
  result.raw.buf = cast[ptr UncheckedArray[uint32]](alloc(width * height * sizeof(uint32)))
  discard fenster_open(result.raw)

proc loop*(self: Fenster): bool =
  let frameTime = 1000 div self.targetFps
  let timeElapsed = fenster_time() - self.lastFrameTime
  if timeElapsed < frameTime:
    fenster_sleep((frameTime - timeElapsed).cint)
  self.lastFrameTime = fenster_time()
  fenster_loop(self.raw) == 0

proc sleep*(ms: int) = fenster_sleep(ms.cint)
proc time*(): int64 = fenster_time()

proc `[]`*(self: Fenster, x, y: int): uint32 =
  self.raw.buf[y * self.raw.width + x]

proc `[]=`*(self: Fenster, x, y: int, color: SomeInteger) =
  self.raw.buf[y * self.raw.width + x] = color.uint32

proc width*(self: Fenster): int = self.raw.width.int
proc height*(self: Fenster): int = self.raw.height.int
proc keys*(self: Fenster): array[256, cint] = self.raw.keys
proc mousex*(self: Fenster): int = self.raw.x.int
proc mousey*(self: Fenster): int = self.raw.y.int
proc mousedown*(self: Fenster): int = self.raw.mouse.int
proc targetFps*(self: Fenster): int = self.targetFps
proc `targetFps=`*(self: Fenster, fps: int) = self.targetFps = fps