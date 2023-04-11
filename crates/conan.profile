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
tools.cmake.cmaketoolchain:user_toolchain=["/home/jassim/workspace/tupu/code/ipc/cross-build/rv1109/toolchain.cmake"]

[env]
CHOST="arm-linux-gnueabihf"
