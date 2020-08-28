# Package

version       = "0.1.0"
author        = "Jorge Acereda"
description   = "Canvas event handling library for GL/Vulkan"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
skipDirs      = @["examples", "tests"]



# Dependencies

requires "nim >= 1.3.5"


task simple, "Runs the simple example":
  exec "nim c -r examples/simple"

task test, "Runs the test example":
  exec "nim c -r examples/test"
