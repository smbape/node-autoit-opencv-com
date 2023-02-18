execute_process(
    COMMAND "${CMAKE_COMMAND}" -E tar x "${ARCHIVE}"
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
)

execute_process(
    COMMAND distrib.7z.exe "-o${OUTPUT}" -y
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
)

execute_process(
    COMMAND "${CMAKE_COMMAND}" -E rm distrib.7z.exe
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
)