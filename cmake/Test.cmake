if(ENABLE_TEST)
    enable_testing()
    find_program(BASH_EXECUTABLE NAMES bash REQUIRED)
    add_test(
        NAME bash_test
        COMMAND ${BASH_EXECUTABLE} ${TOP}/test.sh
    )

    # find_package(PythonInterp REQUIRED)
    # add_test(
    # NAME python_test
    # COMMAND ${PYTHON_EXECUTABLE} ${TOP}/test.py --executable
    # )
endif()