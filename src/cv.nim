
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
  ev* {.byref.} = object
    `type`*: uint
    p*: array[2, uint]


proc run*(handler: proc (e: ev): int {.cdecl}): int {.importc: "cvRun".}
proc canvasWidth*(): cuint {.importc: "cvWidth".}
proc canvasHeight*(): cuint {.importc: "cvHeight".}
proc mouseX*(): cint {.importc: "cvMouseX".}
proc mouseY*(): cint {.importc: "cvMouseY".}
proc keyPressed*(k: cvkey): bool {.importc: "cvPressed".}
proc keyReleased*(k: cvkey): bool {.importc: "cvReleased".}
proc cursorSet*(rgba: array[32*32*4, uint8], hotx: cint, hoty: cint) {.importc: "cvSetCursor".}
proc cursorHide*() {.importc: "cvHideCursor".}
proc cursorDefault*() {.importc: "cvDefaultCursor".}
proc keyboardShow*() {.importc: "cvShowKeyboard".}
proc keyboardHide*() {.importc: "cvHideKeyboard".}
proc canvasFullscreen*() {.importc: "cvFullscreen".}
proc canvasWindowed*() {.importc: "cvWindowed".}
proc quit*() {.importc: "cvQuit".}
proc eventType*(e: ev): cveventtype {.importc: "evType".}
proc eventName*(e: ev): cstring {.importc: "evName".}
proc eventWidth*(e: ev): cuint {.importc: "evWidth".}
proc eventHeight*(e: ev): cuint {.importc: "evHeight".}
proc eventWhich*(e: ev): cvkey {.importc: "evWhich".}
proc eventUnicode*(e: ev): cvunicode {.importc: "evUnicode".}
proc eventArg0*(e: ev): int {.importc: "evArg0".}
proc eventArg1*(e: ev): int {.importc: "evArg1".}
proc eventX*(e: ev): cint {.importc: "evX".}
proc eventY*(e: ev): cint {.importc: "evY".}
proc eventArgC*(e: ev): cint {.importc: "evArgC".}
proc eventArgV*(e: ev): cstringArray {.importc: "evArgV".}
proc eventMethod*(e: ev): cstring {.importc: "evMethod".}
proc eventInject*(e: cveventtype; a1: int; a2: int): int {.importc: "cvInject".}
proc keyName*(k: cvkey): cstring {.importc: "keyName".}
