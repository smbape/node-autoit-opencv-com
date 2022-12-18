cmake_minimum_required(VERSION 3.19)

# Name of the project (will be the name of the plugin)
project(autoit_opencv_com)

set(DEFAULT_BUILD_TYPE "Release")

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_compile_options(/MP)

# https://github.com/scivision/cmake-patch-file/blob/main/cmake/PatchFile.cmake
if(WIN32)
  # prioritize Git Patch on Windows as other Patches may be very old and incompatible.
  find_package(Git)
  if(Git_FOUND)
    get_filename_component(GIT_DIR ${GIT_EXECUTABLE} DIRECTORY)
    get_filename_component(GIT_DIR ${GIT_DIR} DIRECTORY)
  endif()
endif()

find_program(PATCH
  NAMES patch
  HINTS ${GIT_DIR}
  PATH_SUFFIXES usr/bin
)

if(NOT PATCH)
  message(FATAL_ERROR "Did not find GNU Patch")
endif()

# Tell cmake that we will need opencv.
get_filename_component(OPENCV_DOWNLOAD_DIR "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
set(OPENCV_VERSION 4.6.0)
set(OPENCV_DOWNLOAD_NAME  opencv-${OPENCV_VERSION}-vc14_vc15.exe)
set(OPENCV_URL            https://github.com/opencv/opencv/releases/download/${OPENCV_VERSION}/${OPENCV_DOWNLOAD_NAME})
set(OPENCV_URL_HASH       SHA256=3fb046e14dc5b50719a86ea0395b5b1e3299e2343111ebd2e31828aa31d6d477)

include(FetchContent)
FetchContent_Declare(opencv
  URL                 ${OPENCV_URL}
  URL_HASH            ${OPENCV_URL_HASH}
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR        "${OPENCV_DOWNLOAD_DIR}"
  SOURCE_DIR          "${OPENCV_DOWNLOAD_DIR}"
  PATCH_COMMAND       "<DOWNLOAD_DIR>/${OPENCV_DOWNLOAD_NAME}" "-o<DOWNLOAD_DIR>/opencv-${OPENCV_VERSION}-vc14_vc15" -y
)

include(FetchContent)
FetchContent_Declare(opencv-patch
  URL                 ${OPENCV_URL}
  URL_HASH            ${OPENCV_URL_HASH}
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR        "${OPENCV_DOWNLOAD_DIR}"
  SOURCE_DIR          "${OPENCV_DOWNLOAD_DIR}"
  PATCH_COMMAND       "${PATCH}" -p 1 -d "<DOWNLOAD_DIR>/opencv-${OPENCV_VERSION}-vc14_vc15/opencv/sources/"
                        -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-opencv-src.patch"
)

FetchContent_Populate(opencv)
FetchContent_Populate(opencv-patch)

get_filename_component(OpenCV_DIR "${opencv_SOURCE_DIR}/opencv-${OPENCV_VERSION}-vc14_vc15/opencv/build" REALPATH)
set(opencv_SOURCE_DIR "${opencv_SOURCE_DIR}/opencv-${OPENCV_VERSION}-vc14_vc15/opencv/sources")

get_filename_component(OpenCV_BINARY_DIR "${OpenCV_DIR}/x64/vc15/bin" REALPATH)
file(TO_NATIVE_PATH "${OpenCV_BINARY_DIR}" OpenCV_BINARY_DIR)

get_filename_component(OPENCV_SAMPLES_DATA_PATH "../samples/data" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_SAMPLES_DATA_PATH}" OPENCV_SAMPLES_DATA_PATH)

find_package(OpenCV REQUIRED)

# generate source files
if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/opencv_build_x64/modules/python_bindings_generator/pyopencv_generated_include.h")
  file(MAKE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/opencv_build_x64")
  execute_process(
    COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
      -DBUILD_opencv_world=ON -DBUILD_opencv_python3=ON
      "${opencv_SOURCE_DIR}"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/opencv_build_x64"
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()

execute_process(
  COMMAND node --unhandled-rejections=strict --trace-uncaught --trace-warnings src/gen.js --skip=vs
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/.."
  COMMAND_ECHO STDERR
  COMMAND_ERROR_IS_FATAL ANY
)

file(GLOB_RECURSE project_source_resources "src/*.rc" "src/*.rgs")
file(GLOB_RECURSE project_source_headers "src/*.h*")
file(GLOB_RECURSE project_sources_files "src/*.c" "src/*.cpp" "src/*.def")

file(GLOB_RECURSE project_generated_resources "generated/*.rc" "generated/*.rgs")
file(GLOB_RECURSE project_generated_headers "generated/*.h*")
file(GLOB_RECURSE project_generated_files "generated/*.cpp" "generated/*_i.c")

source_group("Source Resources" FILES ${project_source_resources})
source_group("Source Headers" FILES ${project_source_headers})
source_group("Source Files" FILES ${project_sources_files})

source_group("Generated Resources" FILES ${project_generated_resources})
source_group("Generated Headers" FILES ${project_generated_headers})
source_group("Generated Files" FILES ${project_generated_files})

set(SRC_FILES
  ${project_source_resources}
  ${project_source_headers}
  ${project_sources_files}

  ${project_generated_resources}
  ${project_generated_headers}
  ${project_generated_files}
)

# Build a shared library named as the project
add_library(${PROJECT_NAME} SHARED ${SRC_FILES})
target_precompile_headers(${PROJECT_NAME} PRIVATE
  "$<$<COMPILE_LANGUAGE:CXX>:${CMAKE_CURRENT_SOURCE_DIR}/generated/autoit_bridge_generated_pch.h>"
)

target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})

set(OpenCV_DLLVERSION "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
set(DEBUG_POSTFIX d)

set_target_properties(${PROJECT_NAME} PROPERTIES
  OUTPUT_NAME "${PROJECT_NAME}${OpenCV_DLLVERSION}"
  DEBUG_POSTFIX "${DEBUG_POSTFIX}"
  COMPILE_PDB_NAME "${PROJECT_NAME}${OpenCV_DLLVERSION}"
  COMPILE_PDB_NAME_DEBUG "${PROJECT_NAME}${OpenCV_DLLVERSION}${DEBUG_POSTFIX}"
  VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BINARY_DIR};%PATH%"
)

target_include_directories(${PROJECT_NAME} PUBLIC "src")
target_include_directories(${PROJECT_NAME} PUBLIC "generated")

# /Zc:__cplusplus is required to make __cplusplus accurate
# /Zc:__cplusplus is available starting with Visual Studio 2017 version 15.7
# (according to https://docs.microsoft.com/en-us/cpp/build/reference/zc-cplusplus)
# That version is equivalent to _MSC_VER==1914
# (according to https://docs.microsoft.com/en-us/cpp/preprocessor/predefined-macros?view=vs-2019)
# CMake's ${MSVC_VERSION} is equivalent to _MSC_VER
# (according to https://cmake.org/cmake/help/latest/variable/MSVC_VERSION.html#variable:MSVC_VERSION)
if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1914))
  target_compile_options(${PROJECT_NAME} PRIVATE "/Zc:__cplusplus")
  target_compile_options(${PROJECT_NAME} PRIVATE "/bigobj")
endif()

IF ((WIN32) AND CMAKE_GENERATOR STREQUAL Ninja)
  target_compile_options(${PROJECT_NAME} PRIVATE "/Zc:__cplusplus")
  target_compile_options(${PROJECT_NAME} PRIVATE "/bigobj")
  target_compile_definitions(${PROJECT_NAME} PRIVATE WIN32)
  target_compile_definitions(${PROJECT_NAME} PRIVATE _WINDOWS)
  target_compile_definitions(${PROJECT_NAME} PRIVATE _WINDLL)
ENDIF()

get_filename_component(VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/.." REALPATH)
file(TO_NATIVE_PATH "${VS_DEBUGGER_WORKING_DIRECTORY}" VS_DEBUGGER_WORKING_DIRECTORY)

set_target_properties(${PROJECT_NAME} PROPERTIES
  VS_DEBUGGER_COMMAND           "pwsh.exe"
  VS_DEBUGGER_COMMAND_ARGUMENTS "-ExecutionPolicy UnRestricted -File .\\samples\\samples.ps1"
  VS_DEBUGGER_WORKING_DIRECTORY "${VS_DEBUGGER_WORKING_DIRECTORY}"
  VS_DEBUGGER_ENVIRONMENT       "PATH=${OpenCV_BINARY_DIR};%PATH%\nOPENCV_SAMPLES_DATA_PATH=${OPENCV_SAMPLES_DATA_PATH}\nBUILD_TYPE=Debug"
)

# ===============
# cpp_test target
# ===============
file(GLOB test_files "test/*.h*" "test/*.cpp")

add_executable(cpp_test ${test_files})

target_precompile_headers(cpp_test PRIVATE
  "$<$<COMPILE_LANGUAGE:CXX>:${CMAKE_CURRENT_SOURCE_DIR}/test/test.h>"
)
set_source_files_properties(test/test.cpp PROPERTIES COMPILE_FLAGS "/MP1")

target_link_libraries(cpp_test PRIVATE ${PROJECT_NAME} "windowsapp.lib" "dwmapi.lib")
set_property(TARGET cpp_test PROPERTY VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BINARY_DIR};%PATH%\nOPENCV_SAMPLES_DATA_PATH=${OPENCV_SAMPLES_DATA_PATH}")
set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY VS_STARTUP_PROJECT cpp_test)

# /Zc:__cplusplus is required to make __cplusplus accurate
# /Zc:__cplusplus is available starting with Visual Studio 2017 version 15.7
# (according to https://docs.microsoft.com/en-us/cpp/build/reference/zc-cplusplus)
# That version is equivalent to _MSC_VER==1914
# (according to https://docs.microsoft.com/en-us/cpp/preprocessor/predefined-macros?view=vs-2019)
# CMake's ${MSVC_VERSION} is equivalent to _MSC_VER
# (according to https://cmake.org/cmake/help/latest/variable/MSVC_VERSION.html#variable:MSVC_VERSION)
if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1914))
  target_compile_options(cpp_test PRIVATE "/Zc:__cplusplus")
endif()

IF ((WIN32) AND CMAKE_GENERATOR STREQUAL Ninja)
  target_compile_definitions(cpp_test PRIVATE WIN32)
  target_compile_definitions(cpp_test PRIVATE _WINDOWS)
ENDIF()

if (CMAKE_GENERATOR MATCHES "Visual Studio")
# ===============
# C# Interop target
# ===============
include(CSharpUtilities)
enable_language(CSharp)

file(GLOB cs_files "dotnet/*.cs")
add_library(interop_opencv SHARED ${cs_files})

set_target_properties(interop_opencv PROPERTIES
  OUTPUT_NAME "interop.opencv-${OpenCV_VERSION_MAJOR}"
  DEBUG_POSTFIX "${DEBUG_POSTFIX}"
  VS_DOTNET_REFERENCES "Microsoft.CSharp;System"
)

foreach( BUILD_TYPE ${CMAKE_CONFIGURATION_TYPES} )
  string( TOUPPER ${BUILD_TYPE} BUILD_TYPE_UPPER )
  set_target_properties(interop_opencv PROPERTIES RUNTIME_OUTPUT_DIRECTORY_${BUILD_TYPE_UPPER} "${CMAKE_BINARY_DIR}/${BUILD_TYPE}/dotnet")
endforeach()

# ===============
# cs_test target
# ===============
include(CSharpUtilities)
enable_language(CSharp)

file(GLOB test_files "test/*.cs" "dotnet/*.cs")
add_executable(cs_test ${test_files})

get_filename_component(OPENCV_SAMPLES_DATA_PATH "../samples/data" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_SAMPLES_DATA_PATH}" OPENCV_SAMPLES_DATA_PATH)

set_target_properties(cs_test PROPERTIES
  VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BINARY_DIR};%PATH%\nOPENCV_SAMPLES_DATA_PATH=${OPENCV_SAMPLES_DATA_PATH}"
  VS_DOTNET_REFERENCES "Microsoft.CSharp;System"
)

endif()
