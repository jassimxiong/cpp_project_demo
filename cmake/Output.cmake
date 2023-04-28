# 生成固件包原始文件
include(GNUInstallDirs)

set(CMAKE_INSTALL_PREFIX ${TOP}/output)

configure_file(${TOP}/chores/in/daemon.in ${PROJECT_BINARY_DIR}/${DAEMON} @ONLY)
configure_file(${TOP}/chores/in/startup.in ${PROJECT_BINARY_DIR}/${STARTUP_SHELL_NAME} @ONLY)
configure_file(${TOP}/chores/in/manifest.json.in ${PROJECT_BINARY_DIR}/manifest.json @ONLY)
configure_file(${TOP}/chores/in/install.sh.in ${PROJECT_BINARY_DIR}/install.sh @ONLY)

install(PROGRAMS "${PROJECT_BINARY_DIR}/${APP_NAME}" DESTINATION ${PKG_NAME}/bin)
install(PROGRAMS "${PROJECT_BINARY_DIR}/${DAEMON}" DESTINATION ${PKG_NAME}/bin)
install(PROGRAMS "${PROJECT_BINARY_DIR}/${STARTUP_SHELL_NAME}" DESTINATION ${PKG_NAME})
install(PROGRAMS "${PROJECT_BINARY_DIR}/install.sh" DESTINATION ${PKG_NAME})
install(PROGRAMS "${TOP}/chores/libxxx.so" DESTINATION ${PKG_NAME}/lib)
install(FILES "${PROJECT_BINARY_DIR}/manifest.json" DESTINATION ${PKG_NAME})
install(FILES "${TOP}/chores/app.conf" DESTINATION ${PKG_NAME}/config)
install(FILES "${TOP}/chores/logo.png" DESTINATION ${PKG_NAME}/res)
