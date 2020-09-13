
{.passC: "-DCV_NO_MAIN -DCV_EXPLICIT_ENTRY".}

when defined(vulkan):
  {.passC: "-DCV_NO_CONTEXT".}

when defined(windows):
  {.passL: "-lgdi32 -lopengl32 -luser32 -ldwmapi".}
  {.compile: "glcv/src/win.c".}
elif defined(macosx):
  {.passC: "-fobjc-arc".}
  {.passL: "-fobjc-arc -framework OpenGL -framework AppKit".}
  {.compile: "glcv/src/cocoaarc.m".}
elif defined(wayland):
  {.passL: gorge("pkg-config wayland-client xkbcommon wayland-egl egl gl --cflags --libs").}
  {.compile: "glcv/src/wl.c".}
else:
  {.passL: "-lX11 -lGL -lXcursor -lXrender".}
  {.compile: "glcv/src/xlib.c".}

type
  cveventtype* = enum
    cveNone, cvqName, cvqLogger, cvqXPos, cvqYPos, cvqWidth, cvqHeight,
    cveInit, cveTerm, cveGLInit, cveGLTerm, cveDown, cveUp, cveUnicode,
    cveMotion, cveClose, cveInvoke, cveResize, cveUpdate, cveShowKeyboard,
    cveHideKeyboard, cveSetCursor, cveDefaultCursor, cveFullscreen,
    cveWindowed, cveQuit, cveMax,
    cveInvalid=0x10000
  cvkey* = enum
    cvkNone, cvkMouseWheelUp, cvkMouseWheelDown, cvkMouseLeft, cvkMouseRight,
    cvkMouseMiddle, cvkA, cvkB, cvkC, cvkD, cvkE, cvkF, cvkG, cvkH, cvkI, cvkJ,
    cvkK, cvkL, cvkM, cvkN, cvkO, cvkP, cvkQ, cvkR, cvkS, cvkT, cvkU, cvkV,
    cvkW, cvkX, cvkY, cvkZ, cvk0, cvk1, cvk2, cvk3, cvk4, cvk5, cvk6, cvk7,
    cvk8, cvk9, cvkEqual, cvkMinus, cvkRightBracket, cvkLeftBracket, cvkQuote,
    cvkSemicolon, cvkBackslash, cvkComma, cvkSlash, cvkPeriod, cvkGrave,
    cvkKeypadDecimal, cvkKeypadMultiply, cvkKeypadPlus, cvkKeypadClear,
    cvkKeypadDivide, cvkKeypadEnter, cvkKeypadMinus, cvkKeypadEquals,
    cvkKeypad0, cvkKeypad1, cvkKeypad2, cvkKeypad3, cvkKeypad4, cvkKeypad5,
    cvkKeypad6, cvkKeypad7, cvkKeypad8, cvkKeypad9, cvkReturn, cvkTab,
    cvkSpace, cvkDelete, cvkEscape, cvkCommand, cvkShift, cvkCapsLock,
    cvkOption, cvkControl, cvkRightShift, cvkRightOption, cvkRightCntrol,
    cvkFunction, cvkVolumeUp, cvkVolumeDown, cvkMute, cvkF1, cvkF2, cvkF3,
    cvkF4, cvkF5, cvkF6, cvkF7, cvkF8, cvkF9, cvkF10, cvkF11, cvkF12, cvkF13,
    cvkF14, cvkF15, cvkF16, cvkF17, cvkF18, cvkF19, cvkF20, cvkHelp, cvkHome,
    cvkPageUp, cvkForwardDelete, cvkEnd, cvkPageDown, cvkLeftArrow,
    cvkRightArrow, cvkDownArrow, cvkUpArrow, cvkScroll, cvkNumLock, cvkClear,
    cvkSysReq, cvkPause, cvkCamera, cvkCenter, cvkAt, cvkSym, cvkMax,
    cvkInvalid=0x10000
  cvunicode* = cuint
  ev* {.bycopy.} = object
    `type`*: uint
    p*: array[2, uint]


proc cvRun*(handler: proc (e: ptr ev): int {.cdecl}): int {.importc.}
proc cvWidth*(): cuint {.importc.}
proc cvHeight*(): cuint {.importc.}
proc cvMouseX*(): cint {.importc.}
proc cvMouseY*(): cint {.importc.}
proc cvPressed*(k: cvkey): bool {.importc.}
proc cvReleased*(k: cvkey): bool {.importc.}
proc cvSetCursor*(rgba: array[32*32*4, uint8], hotx: cint, hoty: cint) {.importc.}
proc cvHideCursor*() {.importc.}
proc cvDefaultCursor*() {.importc.}
proc cvShowKeyboard*() {.importc.}
proc cvHideKeyboard*() {.importc.}
proc cvFullscreen*() {.importc.}
proc cvWindowed*() {.importc.}
proc cvQuit*() {.importc.}
proc evType*(e: ptr ev): cveventtype {.importc.}
proc evName*(e: ptr ev): cstring {.importc.}
proc evWidth*(e: ptr ev): cuint {.importc.}
proc evHeight*(e: ptr ev): cuint {.importc.}
proc evWhich*(e: ptr ev): cvkey {.importc.}
proc evUnicode*(e: ptr ev): cvunicode {.importc.}
proc evArg0*(e: ptr ev): int {.importc.}
proc evArg1*(e: ptr ev): int {.importc.}
proc evX*(e: ptr ev): cint {.importc.}
proc evY*(e: ptr ev): cint {.importc.}
proc evArgC*(e: ptr ev): cint {.importc.}
proc evArgV*(e: ptr ev): cstringArray {.importc.}
proc evMethod*(e: ptr ev): cstring {.importc.}
proc cvInject*(e: cveventtype; a1: int; a2: int): int {.importc.}
proc keyName*(k: cvkey): cstring {.importc.}
