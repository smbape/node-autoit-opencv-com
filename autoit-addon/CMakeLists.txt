cmake_minimum_required(VERSION 3.19)

# Name of the project (will be the name of the plugin)
project(autoit_addon)

set(DEFAULT_BUILD_TYPE "Release")

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
    set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
    # Set the possible values of build type for cmake-gui
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

file(CREATE_LINK "${CMAKE_CURRENT_SOURCE_DIR}/../autoit-opencv-com/cmake" "${CMAKE_CURRENT_SOURCE_DIR}/cmake" SYMBOLIC)
file(CREATE_LINK "${CMAKE_CURRENT_SOURCE_DIR}/../autoit-opencv-com/patches" "${CMAKE_CURRENT_SOURCE_DIR}/patches" SYMBOLIC)
include(cmake/RequireOpenCV.cmake)
include(cmake/vcpkg_regex_replace_string.cmake)

vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/addon.au3" "autoit_addon[0-9]+" "autoit_addon${OpenCV_DLLVERSION}")

set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/bin" CACHE PATH "Output directory for applications")
set(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/lib" CACHE PATH "Output directory for libraries")

if(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused-function")
endif()

# Source headers
file(GLOB project_hdrs addon.h)
source_group("Include" FILES ${project_hdrs})

# Source files
file(GLOB project_srcs addon.cpp)
source_group("Src" FILES ${project_srcs})

# Build a shared library named as the project
add_library(${PROJECT_NAME} SHARED ${project_srcs} ${project_hdrs})
target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS})
target_compile_definitions(${PROJECT_NAME} PRIVATE ADDON_MODULE_NAME=${PROJECT_NAME} ADDON_API_EXPORTS)

set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "${PROJECT_NAME}${OpenCV_DLLVERSION}"
    DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
    COMPILE_PDB_NAME "${PROJECT_NAME}${OpenCV_DLLVERSION}"
    COMPILE_PDB_NAME_DEBUG "${PROJECT_NAME}${OpenCV_DLLVERSION}${OpenCV_DEBUG_POSTFIX}"
    ARCHIVE_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_PATH}"
    COMPILE_PDB_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_PATH}"
    LIBRARY_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_PATH}"
    RUNTIME_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}"
)

# Always generate debug files
if(MSVC AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    target_link_options(${PROJECT_NAME} PRIVATE "/DEBUG")
endif()

get_filename_component(OPENCV_SAMPLES_DATA_PATH_HINT "../samples/data" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_SAMPLES_DATA_PATH_HINT}" OPENCV_SAMPLES_DATA_PATH_HINT)

# Buil an application that uses the addon
add_executable(test_addon test_addon.cc)
target_link_libraries(test_addon PRIVATE ${PROJECT_NAME} ${OpenCV_LIBS})
set_target_properties(test_addon PROPERTIES
    OUTPUT_NAME "test_addon${OpenCV_DLLVERSION}"
    DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
    COMPILE_PDB_NAME "test_addon${OpenCV_DLLVERSION}"
    COMPILE_PDB_NAME_DEBUG "test_addon${OpenCV_DLLVERSION}${OpenCV_DEBUG_POSTFIX}"
    ARCHIVE_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_PATH}"
    COMPILE_PDB_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_PATH}"
    LIBRARY_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_PATH}"
    RUNTIME_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}"

    VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BIN_NATIVE_PATH};%PATH%\nOPENCV_SAMPLES_DATA_PATH_HINT=${OPENCV_SAMPLES_DATA_PATH_HINT}"
)
set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY VS_STARTUP_PROJECT test_addon)

# Always generate debug files
if(MSVC AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set_target_properties(test_addon PROPERTIES LINK_FLAGS "/DEBUG")
endif()
