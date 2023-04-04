function(config_conan
  X_CONANFILE_PATH
  X_OS
  X_OS_BUILD
  X_ARCH
  X_ARCH_BUILD
  X_COMPLILER
  X_COMPLILER_VERSION
  X_COMPLILER_LIBCXX
  X_BUILD_TYPE
)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/Conan.cmake")
    file(COPY ${TOP}/cmake/modules/Conan.cmake DESTINATION ${CMAKE_BINARY_DIR})

    # file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/v0.16.1/conan.cmake"
    # "${CMAKE_BINARY_DIR}/conan.cmake"
    # TLS_VERIFY ON
    # )
  endif()

  include(${CMAKE_BINARY_DIR}/Conan.cmake)
  conan_add_remote(NAME cci-beta
    URL https://center.conan.io)
  conan_cmake_run(
    CONANFILE ${X_CONANFILE_PATH}
    BASIC_SETUP CMAKE_TARGETS
    BUILD missing

    # PROFILE ${conan_profile_path}
    SETTINGS
    os=${X_OS}
    os_build=${X_OS_BUILD}
    arch=${X_ARCH}
    arch_build=${X_ARCH_BUILD}
    compiler=${X_COMPLILER}
    compiler.version=${X_COMPLILER_VERSION}
    compiler.libcxx=${X_COMPLILER_LIBCXX}
    build_type=${X_BUILD_TYPE}
  )
  conan_basic_setup()
endfunction(config_conan)