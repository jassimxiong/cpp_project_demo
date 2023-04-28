[settings]
os=Linux
os_build=Linux
os_target=Linux
arch=armv7
arch_build=x86_64
arch_target=armv7
compiler=gcc
compiler.version=8.3
compiler.libcxx=libstdc++11
build_type=Release

[conf]
tools.cmake.cmaketoolchain:user_toolchain=["/home/jassim/workspace/owner/cpp_project_template/cmake/ToolChain.cmake"]

[env]
CHOST="arm-linux-gnueabihf"
