import cv, unicode

proc init() =
  echo "init"

proc term() =
  echo "term"

proc glinit() =
  echo "glinit"

proc down(k: cvkey) =
  echo "down ", k.keyName

var cur : array[32*32*4, uint8]

proc up(k: cvkey): int =
  echo "up ", k.keyName
  result = 1
  case k:
    of cvkEscape: cv.quit()
    of cvkH: cursorHide()
    of cvkD: cursorDefault()
    of cvkC: cursorSet(cur, 0, 0)
    of cvkF: canvasFullscreen()
    of cvkW: canvasWindowed()
    else:
      result = 0

proc unicode(c: Rune) =
  echo "unicode ", c

proc motion(x: int, y: int) =
  echo "motion ", x, " ", y

proc close() =
  echo "close"
  cv.quit()

proc resize(w: uint, h: uint) =
  echo "resize ", w, " ", h

proc update() =
  if cvkA.keyPressed:
    echo "A pressed"
  if cvkA.keyReleased:
    echo "A released"

proc event(e: ev) : int {.cdecl.} =
  result = 1
  let t = e.eventType
  if t != cveUpdate:
    echo "got event ", e.eventName, " ", e.eventArg0, " ", e.eventArg1
  case t:
    of cvqName: result = cast[int]("test".cstring)
    of cvqXPos: result = 50
    of cvqYPos: result = 50
    of cvqWidth: result = 640
    of cvqHeight: result = 480
    of cveInit: init()
    of cveTerm: term()
    of cveGlInit: glinit()
    of cveDown: down(e.eventWhich)
    of cveUp: result = up(e.eventWhich)
    of cveUnicode: unicode(e.eventUnicode.Rune)
    of cveMotion: motion(e.eventX, e.eventY)
    of cveClose: close()
    of cveResize: resize(e.eventWidth, e.eventHeight)
    of cveUpdate: update()
    else:
      result = 0

discard run event
