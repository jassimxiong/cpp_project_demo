add_executable(
    ${APP_NAME}
    ${TOP}/src/main/main.cpp
)

target_link_libraries(
    ${APP_NAME}
    PUBLIC
    THIS::${APP_NAME}_static
)
set_target_properties(
    ${APP_NAME}
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY
    ${CMAKE_BINARY_DIR}
)