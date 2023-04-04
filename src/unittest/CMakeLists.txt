project(test_${APP_NAME})

file(GLOB_RECURSE TEST_SRCS
    ${TOP}/src/unittest/*.cpp
)
add_executable(${PROJECT_NAME} ${TEST_SRCS})
set_target_properties(
    ${PROJECT_NAME}
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}
)

target_link_libraries(
    ${PROJECT_NAME}
    PUBLIC
    THIS::${APP_NAME}_static
    CONAN_PKG::catch2
)
