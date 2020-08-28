import nim_cv
import unicode

proc init() =
  echo "init"

proc term() =
  echo "term"

proc glinit() =
  echo "glinit"

proc down(k: cvkey) =
  echo "down ", keyName(k)

var cur : array[0..32*32*4-1, uint8]

proc up(k: cvkey): int =
  echo "up ", keyName(k)
  result = 1
  case k:
    of cvkEscape: cvQuit()
    of cvkH: cvHideCursor()
    of cvkD: cvDefaultCursor()
    of cvkC: cvSetCursor(cur, 0, 0)
    of cvkF: cvFullScreen()
    of cvkW: cvWindowed()
    else:
      result = 0

proc unicode(c: Rune) =
  echo "unicode ", c

proc motion(x: int, y: int) =
  echo "motion ", x, " ", y

proc close() =
  echo "close"
  cvQuit()

proc resize(w: uint, h: uint) =
  echo "resize ", w, " ", h

proc update() =
  if cvPressed(cvkA):
    echo "A pressed"
  if cvReleased(cvkA):
    echo "A released"

proc event(e: ptr ev) : int {.cdecl.} =
  result = 1
  let t = evType(e)
  if t != cveUpdate:
    echo "got event ", evName(e), " ", evArg0(e), " ", evArg1(e)
  case t:
    of cvqName: result = cast[int]("test")
    of cvqXPos: result = 50
    of cvqYPos: result = 50
    of cvqWidth: result = 640
    of cvqHeight: result = 480
    of cveInit: init()
    of cveTerm: term()
    of cveGlInit: glinit()
    of cveDown: down(evWhich(e))
    of cveUp: result = up(evWhich(e))
    of cveUnicode: unicode(cast[Rune](evUnicode(e)))
    of cveMotion: motion(evX(e), evY(e))
    of cveClose: close()
    of cveResize: resize(evWidth(e), evHeight(e))
    of cveUpdate: update()
    else:
      result = 0

discard cvRun event
