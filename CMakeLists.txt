cmake_minimum_required(VERSION 3.10)
project(
  "demo"
  LANGUAGES C CXX
)

set(TOP ${CMAKE_CURRENT_SOURCE_DIR})

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "请别在源码目录编译, 污染工程")
endif()

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
endif()

include(${TOP}/cmake/modules/Colors.cmake)
define_colors()
include(${TOP}/cmake/Option.cmake)
include(${TOP}/cmake/modules/GitHash.cmake)
include(${TOP}/cmake/modules/PackageManager.cmake)
include(${TOP}/cmake/modules/StaticCheck.cmake)
include(${TOP}/cmake/ConfigProject.cmake)
include(${TOP}/cmake/Output.cmake)
include(${TOP}/cmake/Debug.cmake)
include(${TOP}/cmake/Test.cmake)

set(CONAN_CMAKE_TOOLCHAIN_FILE ${TOP}/cmake/ToolChain.cmake)
string(REGEX MATCH "^[0-9]+\\.[0-9]+" COMPILER_VERSION ${CMAKE_CXX_COMPILER_VERSION})
config_conan(
  "${TOP}/crates/conanfile.txt" # conan包
  "Linux" # os
  ${CMAKE_SYSTEM_NAME} # os_build
  ${CMAKE_SYSTEM_PROCESSOR} # arch
  ${CMAKE_HOST_SYSTEM_PROCESSOR} # arch_build
  "gcc" # compiler
  ${COMPILER_VERSION} # compiler.version
  "libstdc++11" # compiler.libcxx
  ${CMAKE_BUILD_TYPE} # build_type
)
add_subdirectory(src)