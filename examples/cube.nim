import nim_cv, opengl, glm

var posx : float32
var posy : float32
var posz : float32 = -7

var program : GLuint
var uMVP : GLint
var mesh: tuple[vbo, vao, ebo: GLuint, len: GLint]
var proj : Mat4[float32]

type
  logMsg = object
    buf : array[1024, char]
    sz : GLint

proc echoMsg(msg: logMsg) =
    var r = ""
    for i in 0..<msg.sz: r &= msg.buf[i]
    echo r


proc statusShader(shader: GLuint) =
  var status: GLint
  glGetShaderiv(shader, GL_COMPILE_STATUS, status.addr);
  if status != GL_TRUE.ord:
    var msg: logMsg
    glGetShaderInfoLog(shader, msg.buf.sizeof.GLsizei, msg.sz.addr, msg.buf[0].addr);
    echoMsg msg


proc statusProgram(prg: GLuint) =
  var status: GLint
  glGetProgramiv(prg, GL_LINK_STATUS, status.addr);
  if status != GL_TRUE.ord:
    var msg : logMsg
    glGetProgramInfoLog(prg, msg.buf.sizeof.GLsizei, msg.sz.addr, msg.buf[0].addr);
    echoMsg msg


proc glinit() =
  loadExtensions()

  glEnable(GL_CULL_FACE)
  glEnable(GL_DEPTH_TEST)


  var vertex = glCreateShader(GL_VERTEX_SHADER)
  var vsrc = allocCstringArray(["""
#version 300 es
precision highp float;
in vec3 aPos;
in vec4 aCol;
out vec4 color;
uniform mat4 uMVP;
void main() {
  gl_Position = uMVP * vec4(aPos, 1.0);
  color = aCol;
}
  """])
  glShaderSource(vertex, 1, vsrc, nil)
  deallocCstringArray(vsrc)
  glCompileShader(vertex)
  statusShader(vertex)

  var fragment = glCreateShader(GL_FRAGMENT_SHADER)
  var fsrc = allocCstringArray(["""
#version 300 es
precision highp float;
in vec4 color;
out vec4 FragColor;
void main() {
  FragColor = color;
}
  """])
  glShaderSource(fragment, 1, fsrc, nil)
  deallocCstringArray(fsrc)
  glCompileShader(fragment)
  statusShader(fragment)

  program = glCreateProgram()
  glAttachShader(program, vertex)
  glAttachShader(program, fragment)
  glLinkProgram(program)
  statusProgram(program)

  uMVP   = glGetUniformLocation(program, "uMVP")

  glGenVertexArrays(1, mesh.vao.addr)
  glBindVertexArray(mesh.vao)

  glGenBuffers(1, mesh.vbo.addr)
  glBindBuffer(GL_ARRAY_BUFFER, mesh.vbo)

  glGenBuffers(1, mesh.ebo.addr)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mesh.ebo)

  type Vertex = tuple[
    x: GLfloat,
    y: GLfloat,
    z: GLfloat,
    r: GLfloat,
    g: GLfloat,
    b: GLfloat,
    a: GLfloat,
    ]
  var vert : array[8, Vertex];
  for i in 0..<8:
    vert[i].x = if (i and 1) != 0: 1.0f else: -1.0f
    vert[i].y = if (i and 2) != 0: 1.0f else: -1.0f
    vert[i].z = if (i and 4) != 0: 1.0f else: -1.0f
    vert[i].r = if (i and 1) != 0: 1.0f else: 0.0f
    vert[i].g = if (i and 2) != 0: 1.0f else: 0.0f
    vert[i].b = if (i and 4) != 0: 1.0f else: 0.0f
    vert[i].a = 1.0f
  glBufferData(GL_ARRAY_BUFFER, vert.sizeof.GLint, vert[0].addr, GL_STATIC_DRAW)

  var ind = [
    4'u32, 5'u32, 7'u32, 7'u32, 6'u32, 4'u32, # front
    1'u32, 0'u32, 2'u32, 2'u32, 3'u32, 1'u32, # back
    0'u32, 4'u32, 6'u32, 6'u32, 2'u32, 0'u32, # left
    5'u32, 1'u32, 3'u32, 3'u32, 7'u32, 5'u32, # right
    6'u32, 7'u32, 3'u32, 3'u32, 2'u32, 6'u32, # top
    0'u32, 1'u32, 5'u32, 5'u32, 4'u32, 0'u32, # bottom
  ]
  mesh.len = ind.len.GLint
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, ind.sizeof.GLint, ind[0].addr, GL_STATIC_DRAW)

  let aPos = glGetAttribLocation(program, "aPos")
  glEnableVertexAttribArray(aPos.GLuint)
  glVertexAttribPointer(aPos.GLuint, 3, cGL_FLOAT, false, Vertex.sizeof.GLsizei, cast[pointer](Vertex.offsetOf(x)))

  let aCol = glGetAttribLocation(program, "aCol")
  glEnableVertexAttribArray(aCol.GLuint)
  glVertexAttribPointer(aCol.GLuint, 4, cGL_FLOAT, false, Vertex.sizeof.GLsizei, cast[pointer](Vertex.offsetOf(r)))


proc resize(w: uint, h: uint) =
  glViewport(0, 0, w.GLsizei, h.GLsizei)
  proj = perspective(45.0f, w.float / h.float, 0.1f, 100000.0f)

proc update() =
  if cvPressed cvkLeftArrow: posx -= 0.1f
  if cvPressed cvkRightArrow: posx += 0.1f
  if cvPressed cvkDownArrow: posy -= 0.1f
  if cvPressed cvkUpArrow: posy += 0.1f
  if cvPressed cvkX: posz -= 0.1f
  if cvPressed cvkZ: posz += 0.1f

  let model = mat4f()
  .translate(posx, posy, posz)
  .rotate(2.0 * PI * cvMouseY().int.toFloat / cvHeight().int.toFloat, 1, 0, 0)
  .rotate(2.0 * PI * cvMouseX().int.toFloat / cvWidth().int.toFloat, 0, 1, 0)
  let view =  mat4f()
  var mvp = proj * view * model

  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glUseProgram(program)
  glUniformMatrix4fv(uMVP, 1, false, mvp.caddr)
  glBindVertexArray(mesh.vao)
  glDrawElements(GL_TRIANGLES, mesh.len, GL_UNSIGNED_INT, nil)

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
