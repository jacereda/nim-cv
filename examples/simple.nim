import cv

proc update() =
  discard

proc handler(e: ptr ev) : int {.cdecl.} =
  case evType(e):
    of cveUpdate:
      update()
      return 1
    else:
      return 0

discard cvRun(handler)
