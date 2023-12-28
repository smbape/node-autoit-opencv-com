cmake_minimum_required(VERSION 3.19)

# Sources: https://github.com/opencv/ci-gha-workflow/blob/main/.github/workflows/OCV-WinPack-4.x-W10.yaml

# Name of the project (will be the name of the plugin)
project(opencv)

set(DEFAULT_BUILD_TYPE "Release")

if(NOT DEFINED CMAKE_BUILD_TYPE)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build.")
endif()

# Set the possible values of build type for cmake-gui
set(CMAKE_CONFIGURATION_TYPES "Debug;Release;MinSizeRel;RelWithDebInfo" CACHE STRING "Configs" FORCE)
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${CMAKE_CONFIGURATION_TYPES}")

include(../autoit-opencv-com/FindPatch.cmake)

set(OpenCV_VERSION 4.9.0 CACHE STRING "Choose the OpenCV version.")
set_property(CACHE OpenCV_VERSION PROPERTY STRINGS "4.9.0" "4.8.1" "4.8.0" "4.7.0" "4.6.0" "4.5.5" "4.5.4" "4.5.3" "4.5.2" "4.5.1" "4.5.0")

string(REPLACE "." ";" OpenCV_VERSION_LIST ${OpenCV_VERSION})
list(GET OpenCV_VERSION_LIST 0 OpenCV_VERSION_MAJOR)
list(GET OpenCV_VERSION_LIST 1 OpenCV_VERSION_MINOR)
list(GET OpenCV_VERSION_LIST 2 OpenCV_VERSION_PATCH)

set(OpenCV_DLLVERSION "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
set(OpenCV_DEBUG_POSTFIX d)

# Tell cmake we will need opencv.
include(FetchContent)
FetchContent_Populate(opencv
  GIT_REPOSITORY    https://github.com/opencv/opencv.git
  GIT_TAG           ${OpenCV_VERSION}

  # PATCH_COMMAND is run once for each BUILD_TYPE
  # however, source download is only done once when it is a git repository
  # use a custom patch command to perform patch only once
  PATCH_COMMAND "${CMAKE_COMMAND}"
                  "-DSOURCE_DIR=<SOURCE_DIR>"
                  "-DGIT_EXECUTABLE=${GIT_EXECUTABLE}"
                  "-DPATCH_FILE=${CMAKE_CURRENT_SOURCE_DIR}/../autoit-opencv-com/patches/001-opencv-src.patch"
                  -P "${CMAKE_CURRENT_SOURCE_DIR}/../autoit-opencv-com/cmake/git_patch_once.cmake"
  SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv"
  BINARY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/build"
)

# Tell cmake that we will need opencv_contrib.
include(FetchContent)
FetchContent_Populate(opencv_contrib
  GIT_REPOSITORY https://github.com/opencv/opencv_contrib.git
  GIT_TAG        d6102ef65f9ccdb37bba0ea9b8254951eb89dc39
  SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/opencv_contrib"
  BINARY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/build"
)

set(opencv_BINARY_DIR "${CMAKE_CURRENT_SOURCE_DIR}/build")
file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/opencv" OPENCV_INSTALL_DATA_DIR_RELATIVE)

set(EXTRA_CMAKE_OPTIONS
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  # "-DOPENCV_EXTRA_MODULES_PATH=${opencv_contrib_SOURCE_DIR}/modules"

  "-DOPENCV_DOWNLOAD_PATH=${CMAKE_CURRENT_SOURCE_DIR}/download"
  -DOPENCV_PYTHON_INSTALL_PATH=python
  "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_SOURCE_DIR}/install"
  -DINSTALL_PDB=ON
  -DINSTALL_PDB_COMPONENT_EXCLUDE_FROM_ALL=OFF
  "-DOPENCV_INSTALL_DATA_DIR_RELATIVE=${OPENCV_INSTALL_DATA_DIR_RELATIVE}"
  -DINSTALL_CREATE_DISTRIB=ON
  -DOPENCV_GENERATE_SETUPVARS=ON

  # -DVIDEOIO_PLUGIN_LIST=all
  -DBUILD_opencv_world=ON
  -DBUILD_opencv_python2=OFF
  -DBUILD_opencv_python3=OFF
  -DBUILD_opencv_java=OFF
  -DBUILD_opencv_apps=OFF
  # -DBUILD_opencv_freetype=OFF
  -DBUILD_SHARED_LIBS=ON
  -DBUILD_TESTS=OFF
  -DBUILD_PERF_TESTS=OFF
  -DBUILD_DOCS=OFF
  -DBUILD_EXAMPLES=OFF
  # -DWITH_EIGEN=ON
  # -DBUILD_OPENEXR=ON
  -DBUILD_opencv_java_bindings_generator=OFF
  -DBUILD_opencv_js_bindings_generator=OFF
  -DBUILD_opencv_objc_bindings_generator=OFF
  -DBUILD_opencv_python_bindings_generator=ON
)

add_custom_command(
  OUTPUT "${opencv_BINARY_DIR}/CMakeCache.txt"
  COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" ${EXTRA_CMAKE_OPTIONS} "${opencv_SOURCE_DIR}"
  WORKING_DIRECTORY "${opencv_BINARY_DIR}"
  DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt"
  COMMENT "Cmake OpenCV"
)
add_custom_target(configure_opencv ALL DEPENDS "${opencv_BINARY_DIR}/CMakeCache.txt")

add_custom_command(
  OUTPUT "${opencv_BINARY_DIR}/bin/Debug/opencv_world${OpenCV_DLLVERSION}${OpenCV_DEBUG_POSTFIX}.dll"
  COMMAND "${CMAKE_COMMAND}" --build . --config debug --target install
  WORKING_DIRECTORY "${opencv_BINARY_DIR}"
  DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt"
  COMMENT "Compile OpenCV debug"
)
add_custom_target(compile_opencv_debug ALL DEPENDS
  "${opencv_BINARY_DIR}/bin/Debug/opencv_world${OpenCV_DLLVERSION}${OpenCV_DEBUG_POSTFIX}.dll"
  configure_opencv
)

add_custom_command(
  OUTPUT "${opencv_BINARY_DIR}/bin/Release/opencv_world${OpenCV_DLLVERSION}.dll"
  COMMAND "${CMAKE_COMMAND}" --build . --config release --target install
  WORKING_DIRECTORY "${opencv_BINARY_DIR}"
  DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt"
  COMMENT "Compile OpenCV release"
)
add_custom_target(compile_opencv_release ALL DEPENDS
  "${opencv_BINARY_DIR}/bin/Release/opencv_world${OpenCV_DLLVERSION}.dll"
  compile_opencv_debug
)
