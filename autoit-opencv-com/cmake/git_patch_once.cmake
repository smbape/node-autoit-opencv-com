find_package(Git)

execute_process(
    COMMAND "${GIT_EXECUTABLE}" apply --check -R "${PATCH_FILE}"
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    RESULT_VARIABLE ret
    ERROR_QUIET
)

if(NOT ${ret} EQUAL "0")
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" apply --check "${PATCH_FILE}"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        COMMAND_ERROR_IS_FATAL ANY
    )

    execute_process(
        COMMAND "${GIT_EXECUTABLE}" apply "${PATCH_FILE}"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        COMMAND_ERROR_IS_FATAL ANY
    )
endif()
