
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv7)
set(TARGET_HOST "arm-linux-gnueabihf")
set(SDKTARGETSYSROOT "/home/jassim/workspace/tupu/toolchain/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf")
set(SDK_PATH ${SDKTARGETSYSROOT}/bin)
set(CMAKE_C_COMPILER "${SDK_PATH}/${TARGET_HOST}-gcc" CACHE FILEPATH "C compiler path")
set(CMAKE_CXX_COMPILER "${SDK_PATH}/${TARGET_HOST}-g++" CACHE FILEPATH "C++ compiler path")
set(CMAKE_C_FLAGS "-march=armv7ve -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -pipe -feliminate-unused-debug-types")
set(CMAKE_CXX_FLAGS "-march=armv7ve -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -pipe -feliminate-unused-debug-types")
set(CMAKE_CXX_FLAGS_RELEASE "-Wall -g -")
set(CMAKE_CXX_FLAGS_RELEASE "-Wall -O3 -s")
set(LDFLAGS "-Wl,--hash-style=gnu -Wl,--as-needed")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)