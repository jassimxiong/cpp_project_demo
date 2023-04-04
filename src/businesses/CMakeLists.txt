project(${APP_NAME}_static)
file(GLOB_RECURSE OBJ_SRCS
    ${TOP}/src/businesses/*.cpp
)
file(GLOB_RECURSE OBJ_HDRS
    ${TOP}/src/businesses/*.h
)
add_library(${PROJECT_NAME} STATIC "")
add_library(THIS::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_sources(
    ${PROJECT_NAME}
    PRIVATE
    ${OBJ_SRCS}
    PUBLIC
    ${OBJ_HDRS}
)
target_compile_definitions(
    ${PROJECT_NAME}
    PUBLIC
    ${Definitions}
)
find_package(Threads REQUIRED)
target_link_libraries(
    ${PROJECT_NAME}
    Threads::Threads
    CONAN_PKG::spdlog
)