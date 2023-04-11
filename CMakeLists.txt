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

config_conan(
  "${TOP}/crates/conanfile.txt" # conan包
  "${TOP}/crates/conan.profile" # conan配置
)
add_subdirectory(src)