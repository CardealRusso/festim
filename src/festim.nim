import strutils

proc currentSourceDir(): string {.compileTime.} =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

const fensterHeader = currentSourceDir() & "/fenster/fenster.h"

when defined(linux):
  {.passl: "-lX11".}
elif defined(windows):
  {.passl: "-lgdi32".}
elif defined(macosx):
  {.passl: "-framework Cocoa".}

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

proc open(
  fenster: ptr FensterStruct
): cint {.importc: "fenster_open", header: fensterHeader.}

proc loop(
  fenster: ptr FensterStruct
): cint {.importc: "fenster_loop", header: fensterHeader.}

proc close(
  fenster: ptr FensterStruct
) {.importc: "fenster_close", header: fensterHeader.}

proc sleep(ms: cint) {.importc: "fenster_sleep", header: fensterHeader.}

proc time*(): int64 {.importc: "fenster_time", header: fensterHeader.}

proc `=destroy`(self: Fenster) =
  close(self.raw)
  dealloc(self.raw.buf)
  dealloc(self.raw)

proc init*(_: type Fenster, title: string, width: int, height: int): Fenster =
  result = Fenster()
  
  result.raw = cast[ptr FensterStruct](alloc0(sizeof(FensterStruct)))
  result.raw.title = cstring(title)
  result.raw.width = cint(width)
  result.raw.height = cint(height)
  result.raw.buf =
    cast[ptr UncheckedArray[uint32]](alloc(width * height * sizeof(uint32)))
  
  discard open(result.raw)

proc loop*(self: var Fenster): bool =
  result = loop(self.raw) == 0

proc sleep*(ms: int) =
  sleep(cint(ms))

proc `[]`*(self: Fenster, x, y: int): uint32 =
  result = self.raw.buf[y * self.raw.width + x]

proc `[]=`*(self: Fenster, x, y: int, color: auto) =
  self.raw.buf[y * self.raw.width + x] = uint32(color)

proc width*(self: Fenster): int =
  result = int(self.raw.width)

proc height*(self: Fenster): int =
  result = int(self.raw.height)

proc keys*(self: Fenster): array[256, cint] =
  result = self.raw.keys