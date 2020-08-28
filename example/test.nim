import nim_cv, unicode

proc init() =
  echo "init"

proc term() =
  echo "term"

proc glinit() =
  echo "glinit"

proc down(k: cvkey) =
  echo "down ", k.keyName

var cur : array[0..32*32*4-1, uint8]

proc up(k: cvkey): int =
  echo "up ", k.keyName
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
  if cvkA.cvPressed:
    echo "A pressed"
  if cvkA.cvReleased:
    echo "A released"

proc event(e: ptr ev) : int {.cdecl.} =
  result = 1
  let t = e.evType
  if t != cveUpdate:
    echo "got event ", e.evName, " ", e.evArg0, " ", e.evArg1
  case t:
    of cvqName: result = cast[int]("test")
    of cvqXPos: result = 50
    of cvqYPos: result = 50
    of cvqWidth: result = 640
    of cvqHeight: result = 480
    of cveInit: init()
    of cveTerm: term()
    of cveGlInit: glinit()
    of cveDown: down(e.evWhich)
    of cveUp: result = up(e.evWhich)
    of cveUnicode: unicode(cast[Rune](e.evUnicode))
    of cveMotion: motion(e.evX, e.evY)
    of cveClose: close()
    of cveResize: resize(e.evWidth, e.evHeight)
    of cveUpdate: update()
    else:
      result = 0

discard cvRun event
