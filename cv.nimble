# Package

version       = "0.1.0"
author        = "Jorge Acereda"
description   = "Canvas event handling library for GL/Vulkan"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
installDirs   = @["glcv"]
skipDirs      = @["examples", "tests"]



# Dependencies

requires "nim >= 1.2.6"
requires "opengl >= 1.2.6"
requires "glm"


task simple, "Runs the simple example":
  exec "nim c -r examples/simple"

task test, "Runs the test example":
  exec "nim c -r examples/test"

task cube, "Runs the cube example":
  exec "nim c -r examples/cube"

task cubeimm, "Runs the cubeimm example":
  exec "nim c -r examples/cubeimm"
