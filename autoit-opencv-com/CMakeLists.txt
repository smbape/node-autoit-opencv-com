cmake_minimum_required(VERSION 3.16)

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

# Tell cmake we will need opencv. These command will pull in opencv.
include(ExternalProject)
ExternalProject_Add(opencv
  URL               https://github.com/opencv/opencv/releases/download/4.5.5/opencv-4.5.5-vc14_vc15.exe
  URL_HASH          SHA256=cac31973cd1c59bfe9dc926acbde815553d23662ea355e0414b5e50d8f8aa5a8
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR      ${CMAKE_CURRENT_SOURCE_DIR}/..
  CONFIGURE_COMMAND ""
  BUILD_COMMAND     ""
  INSTALL_COMMAND   ""
)

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../opencv-4.5.5-vc14_vc15/opencv/sources/SECURITY.md")
  execute_process(COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/../opencv-4.5.5-vc14_vc15.exe -o${CMAKE_CURRENT_SOURCE_DIR}/../opencv-4.5.5-vc14_vc15 -y)
endif()

# Library directories
set(OpenCV_DIR "")
file(GLOB __OpenCV_ROOT_DIR "../opencv-4.*")
foreach(f ${__OpenCV_ROOT_DIR})
  get_filename_component(__f "${f}/opencv/build" REALPATH)
  if(EXISTS "${__f}")
    set(OpenCV_DIR "${__f}")
    break()
  endif()
endforeach()
unset(__f)

find_package(OpenCV REQUIRED)

get_filename_component(OpenCV_BINARY_DIR "${OpenCV_DIR}/x64/vc15/bin" REALPATH)
file(TO_NATIVE_PATH "${OpenCV_BINARY_DIR}" OpenCV_BINARY_DIR)

file(GLOB_RECURSE project_source_resources "./src/*.rc" "./src/*.rgs")
file(GLOB_RECURSE project_source_headers "./src/*.h*")
file(GLOB_RECURSE project_sources_files "./src/*.c" "./src/*.cpp" "./src/*.def")

file(GLOB_RECURSE project_generated_resources "./generated/*.rc" "./generated/*.rgs")
file(GLOB_RECURSE project_generated_headers "./generated/*.h*")
file(GLOB_RECURSE project_generated_files "./generated/*.cpp" "./generated/*_i.c")

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
  "$<$<COMPILE_LANGUAGE:CXX>:${CMAKE_CURRENT_SOURCE_DIR}/src/autoit_bridge.h>"
  "$<$<COMPILE_LANGUAGE:CXX>:${CMAKE_CURRENT_SOURCE_DIR}/src/wgc/pch.h>"
)
set_source_files_properties(./src/autoit_bridge.cpp PROPERTIES COMPILE_FLAGS "/MP1")

target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})

set(OpenCV_DLLVERSION "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
set(OpenCV_DEBUG_POSTFIX d)

set_target_properties(${PROJECT_NAME} PROPERTIES
  OUTPUT_NAME "${PROJECT_NAME}${OpenCV_DLLVERSION}"
  DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
  COMPILE_PDB_NAME "${PROJECT_NAME}${OpenCV_DLLVERSION}"
  COMPILE_PDB_NAME_DEBUG "${PROJECT_NAME}${OpenCV_DLLVERSION}${OpenCV_DEBUG_POSTFIX}"
  VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BINARY_DIR};%PATH%"
)

target_include_directories(${PROJECT_NAME} PUBLIC "src")
target_include_directories(${PROJECT_NAME} PUBLIC "generated")
target_include_directories(${PROJECT_NAME} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.dir/${CMAKE_CFG_INTDIR}")

# /Zc:__cplusplus is required to make __cplusplus accurate
# /Zc:__cplusplus is available starting with Visual Studio 2017 version 15.7
# (according to https://docs.microsoft.com/en-us/cpp/build/reference/zc-cplusplus)
# That version is equivalent to _MSC_VER==1914
# (according to https://docs.microsoft.com/en-us/cpp/preprocessor/predefined-macros?view=vs-2019)
# CMake's ${MSVC_VERSION} is equivalent to _MSC_VER
# (according to https://cmake.org/cmake/help/latest/variable/MSVC_VERSION.html#variable:MSVC_VERSION)
if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1914))
  target_compile_options(${PROJECT_NAME} PUBLIC "/Zc:__cplusplus")
endif()

# ===============
# cpp_test target
# ===============
file(GLOB test_files "./test/*.h*" "./test/*.cpp")

add_executable (cpp_test ${test_files})

get_filename_component(OPENCV_SAMPLES_DATA_PATH "../samples/data" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_SAMPLES_DATA_PATH}" OPENCV_SAMPLES_DATA_PATH)

target_precompile_headers(cpp_test PRIVATE
  "$<$<COMPILE_LANGUAGE:CXX>:${CMAKE_CURRENT_SOURCE_DIR}/test/test.h>"
)
set_source_files_properties(./test/test.cpp PROPERTIES COMPILE_FLAGS "/MP1")

target_link_libraries(cpp_test PRIVATE ${PROJECT_NAME} "windowsapp.lib" "dwmapi.lib")
set_property(TARGET cpp_test PROPERTY VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BINARY_DIR};%PATH%\nOPENCV_SAMPLES_DATA_PATH=${OPENCV_SAMPLES_DATA_PATH}")
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT cpp_test)

# /Zc:__cplusplus is required to make __cplusplus accurate
# /Zc:__cplusplus is available starting with Visual Studio 2017 version 15.7
# (according to https://docs.microsoft.com/en-us/cpp/build/reference/zc-cplusplus)
# That version is equivalent to _MSC_VER==1914
# (according to https://docs.microsoft.com/en-us/cpp/preprocessor/predefined-macros?view=vs-2019)
# CMake's ${MSVC_VERSION} is equivalent to _MSC_VER
# (according to https://cmake.org/cmake/help/latest/variable/MSVC_VERSION.html#variable:MSVC_VERSION)
if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1914))
  target_compile_options(cpp_test PUBLIC "/Zc:__cplusplus")
endif()
