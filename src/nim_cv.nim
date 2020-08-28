{.compile: "glcv/src/win.c".}
{.passC: "-DCV_NO_MAIN -DCV_EXPLICIT_ENTRY".}
{.passL: "-lgdi32 -lopengl32 -luser32".}
type
  cveventtype* = enum
    CVE_NONE, CVQ_NAME, CVQ_LOGGER, CVQ_XPOS, CVQ_YPOS, CVQ_WIDTH, CVQ_HEIGHT,
    CVE_INIT, CVE_TERM, CVE_GLINIT, CVE_GLTERM, CVE_DOWN, CVE_UP, CVE_UNICODE,
    CVE_MOTION, CVE_CLOSE, CVE_INVOKE, CVE_RESIZE, CVE_UPDATE, CVE_SHOWKEYBOARD,
    CVE_HIDEKEYBOARD, CVE_SETCURSOR, CVE_DEFAULTCURSOR, CVE_FULLSCREEN,
    CVE_WINDOWED, CVE_QUIT, CVE_MAX
  cvkey* = enum
    CVK_NONE, CVK_MOUSEWHEELUP, CVK_MOUSEWHEELDOWN, CVK_MOUSELEFT, CVK_MOUSERIGHT,
    CVK_MOUSEMIDDLE, CVK_A, CVK_B, CVK_C, CVK_D, CVK_E, CVK_F, CVK_G, CVK_H, CVK_I, CVK_J,
    CVK_K, CVK_L, CVK_M, CVK_N, CVK_O, CVK_P, CVK_Q, CVK_R, CVK_S, CVK_T, CVK_U, CVK_V,
    CVK_W, CVK_X, CVK_Y, CVK_Z, CVK_0, CVK_1, CVK_2, CVK_3, CVK_4, CVK_5, CVK_6, CVK_7,
    CVK_8, CVK_9, CVK_EQUAL, CVK_MINUS, CVK_RIGHTBRACKET, CVK_LEFTBRACKET, CVK_QUOTE,
    CVK_SEMICOLON, CVK_BACKSLASH, CVK_COMMA, CVK_SLASH, CVK_PERIOD, CVK_GRAVE,
    CVK_KEYPADDECIMAL, CVK_KEYPADMULTIPLY, CVK_KEYPADPLUS, CVK_KEYPADCLEAR,
    CVK_KEYPADDIVIDE, CVK_KEYPADENTER, CVK_KEYPADMINUS, CVK_KEYPADEQUALS,
    CVK_KEYPAD0, CVK_KEYPAD1, CVK_KEYPAD2, CVK_KEYPAD3, CVK_KEYPAD4, CVK_KEYPAD5,
    CVK_KEYPAD6, CVK_KEYPAD7, CVK_KEYPAD8, CVK_KEYPAD9, CVK_RETURN, CVK_TAB,
    CVK_SPACE, CVK_DELETE, CVK_ESCAPE, CVK_COMMAND, CVK_SHIFT, CVK_CAPSLOCK,
    CVK_OPTION, CVK_CONTROL, CVK_RIGHTSHIFT, CVK_RIGHTOPTION, CVK_RIGHTCONTROL,
    CVK_FUNCTION, CVK_VOLUMEUP, CVK_VOLUMEDOWN, CVK_MUTE, CVK_F1, CVK_F2, CVK_F3,
    CVK_F4, CVK_F5, CVK_F6, CVK_F7, CVK_F8, CVK_F9, CVK_F10, CVK_F11, CVK_F12, CVK_F13,
    CVK_F14, CVK_F15, CVK_F16, CVK_F17, CVK_F18, CVK_F19, CVK_F20, CVK_HELP, CVK_HOME,
    CVK_PAGEUP, CVK_FORWARDDELETE, CVK_END, CVK_PAGEDOWN, CVK_LEFTARROW,
    CVK_RIGHTARROW, CVK_DOWNARROW, CVK_UPARROW, CVK_SCROLL, CVK_NUMLOCK, CVK_CLEAR,
    CVK_SYSREQ, CVK_PAUSE, CVK_CAMERA, CVK_CENTER, CVK_AT, CVK_SYM, CVK_MAX
  ev* {.bycopy.} = object
    `type`*: uint
    p*: array[2, uint]


proc cvRun*(handler: proc (e: ptr ev): int): int {.importc.}

proc cvWidth*(): cuint {.importc.}
proc cvHeight*(): cuint {.importc.}
proc cvMouseX*(): cint {.importc.}
proc cvMouseY*(): cint {.importc.}
proc cvPressed*(k: cvkey): cint {.importc.}
proc cvReleased*(k: cvkey): cint {.importc.}
proc cvSetCursor*(rgba: ptr uint8; hotx: cint; hoty: cint) {.importc.}
proc cvHideCursor*() {.importc.}
proc cvDefaultCursor*() {.importc.}
proc cvShowKeyboard*() {.importc.}
proc cvHideKeyboard*() {.importc.}
proc cvFullscreen*() {.importc.}
proc cvWindowed*() {.importc.}
proc cvQuit*() {.importc.}
proc evType*(e: ptr ev): cint {.importc.}
proc evName*(e: ptr ev): cstring {.importc.}
proc evWidth*(e: ptr ev): cint {.importc.}
proc evHeight*(e: ptr ev): cint {.importc.}
proc evWhich*(e: ptr ev): cvkey {.importc.}
proc evUnicode*(e: ptr ev): uint32 {.importc.}
proc evArg0*(e: ptr ev): int {.importc.}
proc evArg1*(e: ptr ev): int {.importc.}
proc evX*(e: ptr ev): cint {.importc.}
proc evY*(e: ptr ev): cint {.importc.}
proc evArgC*(e: ptr ev): cint {.importc.}
proc evArgV*(e: ptr ev): cstringArray {.importc.}
proc evMethod*(e: ptr ev): cstring {.importc.}
proc cvInject*(e: cveventtype; a1: int; a2: int): int {.importc.}
proc keyName*(k: cvkey): cstring {.importc.}
