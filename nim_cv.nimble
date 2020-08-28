# Package

version       = "0.1.0"
author        = "Jorge Acereda"
description   = "Canvas event handling library for GL/Vulkan"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["nim_cv"]



# Dependencies

requires "nim >= 1.3.5"


task simple, "Runs the simple example":
  exec "nim c -r example/simple"

task test, "Runs the test example":
  exec "nim c -r example/test"
