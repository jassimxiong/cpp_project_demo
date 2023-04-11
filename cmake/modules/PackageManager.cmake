function(config_conan
  conanfile_path
  conan_profile_path
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
    CONANFILE ${conanfile_path}
    BASIC_SETUP CMAKE_TARGETS
    BUILD missing
    PROFILE ${conan_profile_path}
  )
  conan_basic_setup()
endfunction(config_conan)