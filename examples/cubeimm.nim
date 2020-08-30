import nim_cv, unicode, opengl, opengl/glu

var posx : float
var posy : float
var posz : float = -7

proc glinit() =
  loadExtensions()
  glDisable(GL_CULL_FACE)
  glEnable(GL_DEPTH_TEST)

proc resize(w: uint, h: uint) =
  glViewport(0, 0, w.GLsizei, h.GLsizei)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  gluPerspective(45.0, w.float / h.float, 0.1, 100.0)

proc update() =
  if cvPressed cvkLeftArrow: posx -= 0.1
  if cvPressed cvkRightArrow: posx += 0.1
  if cvPressed cvkDownArrow: posy -= 0.1
  if cvPressed cvkUpArrow: posy += 0.1

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  glTranslatef(posx, posy, posz)
  glRotatef(360.0 * cvMouseY().int.toFloat / cvHeight().int.toFloat, 1, 0, 0)
  glRotatef(360.0 * cvMouseX().int.toFloat / cvWidth().int.toFloat, 0, 1, 0)

  glBegin(GL_TRIANGLES)

  # Top face (y = 1.0f)
  glColor3f(0.0, 1.0, 0.0)     # Green
  glVertex3f( 1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)

  # Bottom face (y = -1.0f)
  glColor3f(1.0, 0.5, 0.0)     # Orange
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Front face  (z = 1.0f)
  glColor3f(1.0, 0.0, 0.0)     # Red
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)
  glVertex3f( 1.0, -1.0, 1.0)
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)

  # Back face (z = -1.0f)
  glColor3f(1.0, 1.0, 0.0)     # Yellow
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f( 1.0,  1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)

  # Left face (x = -1.0f)
  glColor3f(0.0, 0.0, 1.0)     # Blue
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Right face (x = 1.0f)
  glColor3f(1.0, 0.0, 1.0)    # Magenta
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0,  1.0,  1.0)
  glVertex3f(1.0, -1.0,  1.0)
  glVertex3f(1.0, -1.0, -1.0)
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0, -1.0,  1.0)

  glEnd()


proc event(e: ptr ev) : int {.cdecl.} =
  result = 1
  case e.evType:
    of cvqName: result = cast[int]("cube".cstring)
    of cvqXPos: result = 50
    of cvqYPos: result = 50
    of cvqWidth: result = 640
    of cvqHeight: result = 480
    of cveGlInit: glinit()
    of cveResize: resize(e.evWidth, e.evHeight)
    of cveUpdate: update()
    else:
      result = 0

discard cvRun event
