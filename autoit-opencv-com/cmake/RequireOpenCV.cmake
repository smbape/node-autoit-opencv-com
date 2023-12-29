include(cmake/FindPatch.cmake)

set(BUILD_opencv OFF CACHE BOOL "Build opencv from sources.")

set(OpenCV_URL_HASH_490 fefddff0623fbd5a6fa0cecb9bccd4b822478354e6c587ebb6e40ab09dacba51)
set(OpenCV_URL_HASH_481 037dd1c5c172237b0a00ee822684e5ac453028e1933111a2c547b62061f8b7e4)
set(OpenCV_URL_HASH_480 1c8b1b78a51c46852eb5569d762bd11d0097a45c3db1f03eb41aba6f727b8942)
set(OpenCV_URL_HASH_470 7fab7be68a4ab7f1b70759b0e58d4c4ffc2b8aee72642df6f2dfcc6c161b2465)
set(OpenCV_URL_HASH_460 3fb046e14dc5b50719a86ea0395b5b1e3299e2343111ebd2e31828aa31d6d477)
set(OpenCV_URL_HASH_455 cac31973cd1c59bfe9dc926acbde815553d23662ea355e0414b5e50d8f8aa5a8)
set(OpenCV_URL_HASH_454 d49f6a8ef304de4f5617baf8d9ece51b53a76b3cf5ce26377e4ed7632f0ac467)
set(OpenCV_URL_HASH_453 88eb53fcb81c40f093b18c3eaa818e33d1463d96b47c9713468a68c2c3fccaf0)
set(OpenCV_URL_HASH_452 106b588a82b3045a44305ba426c281887416745d4ce8f3983156d9f82e89ff75)
set(OpenCV_URL_HASH_451 32132dd0bf38c62f73a2f20a0b19785282364f35e19c403f0767aa0266ed410d)
set(OpenCV_URL_HASH_450 65c6b872cfcb1f55f8bedee8b64dc9c4c549035a566ac5ace622a4627c03bcf9)

set(OpenCV_VERSION 4.9.0 CACHE STRING "Choose the OpenCV version.")
set_property(CACHE OpenCV_VERSION PROPERTY STRINGS "4.9.0" "4.8.1" "4.8.0" "4.7.0" "4.6.0" "4.5.5" "4.5.4" "4.5.3" "4.5.2" "4.5.1" "4.5.0")
string(REPLACE "." "" OpenCV_DLLVERSION ${OpenCV_VERSION})

if (OpenCV_DLLVERSION GREATER_EQUAL 470)
  set(OpenCV_DOWNLOAD_NAME opencv-${OpenCV_VERSION}-windows.exe)
else()
  set(OpenCV_DOWNLOAD_NAME opencv-${OpenCV_VERSION}-vc14_vc15.exe)
endif()

string(REGEX REPLACE "\\.[a-zA-Z]+\$" "" OpenCV_OUTPUT_DIR "${OpenCV_DOWNLOAD_NAME}")

if(BUILD_opencv AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../opencv")
  set(OpenCV_BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../opencv/__build__")
  file(MAKE_DIRECTORY "${OpenCV_BUILD_DIR}")

  # configure OpenCV
  execute_process(
    COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" -DOpenCV_VERSION=${OpenCV_VERSION} ..
    WORKING_DIRECTORY "${OpenCV_BUILD_DIR}"
    COMMAND_ECHO STDERR
  )

  # compile OpenCV
  execute_process(
    COMMAND "${CMAKE_COMMAND}" --build . --target ALL_BUILD
    WORKING_DIRECTORY "${OpenCV_BUILD_DIR}"
    COMMAND_ECHO STDERR
  )

  get_filename_component(OpenCV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../opencv/install" REALPATH)
endif()

# Tell cmake that we will need opencv.
get_filename_component(OPENCV_DOWNLOAD_DIR "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
set(OpenCV_URL            https://github.com/opencv/opencv/releases/download/${OpenCV_VERSION}/${OpenCV_DOWNLOAD_NAME})
set(OpenCV_URL_HASH       SHA256=${OpenCV_URL_HASH_${OpenCV_DLLVERSION}})

include(FetchContent)
FetchContent_Declare(opencv
  URL                 ${OpenCV_URL}
  URL_HASH            ${OpenCV_URL_HASH}
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR        "${OPENCV_DOWNLOAD_DIR}"
  SOURCE_DIR          "${OPENCV_DOWNLOAD_DIR}"
  PATCH_COMMAND       "<DOWNLOAD_DIR>/${OpenCV_DOWNLOAD_NAME}" "-o<DOWNLOAD_DIR>/${OpenCV_OUTPUT_DIR}" -y
)

include(FetchContent)
FetchContent_Declare(opencv-patch
  URL                 ${OpenCV_URL}
  URL_HASH            ${OpenCV_URL_HASH}
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR        "${OPENCV_DOWNLOAD_DIR}"
  SOURCE_DIR          "${OPENCV_DOWNLOAD_DIR}"
  PATCH_COMMAND       "${PATCH}" -p 1 -d "<DOWNLOAD_DIR>/${OpenCV_OUTPUT_DIR}/opencv/sources/"
                        -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-opencv-src.patch"
)

FetchContent_Populate(opencv)
FetchContent_Populate(opencv-patch)

get_filename_component(OpenCV_DIR "${opencv_SOURCE_DIR}/${OpenCV_OUTPUT_DIR}/opencv/build" ABSOLUTE)
find_package(OpenCV REQUIRED)

get_filename_component(OpenCV_BIN_PATH "${OpenCV_LIB_PATH}/../bin" ABSOLUTE)

get_filename_component(OpenCV_VC_PATH "${OpenCV_LIB_PATH}" DIRECTORY)
file(RELATIVE_PATH OpenCV_VC_PATH "${OpenCV_DIR}" "${OpenCV_VC_PATH}")

file(TO_NATIVE_PATH "${OpenCV_VC_PATH}" OpenCV_VC_PATH_ESC)
string(REPLACE "\\" "\\\\" OpenCV_VC_PATH_ESC "${OpenCV_VC_PATH_ESC}")
string(REPLACE "\\" "\\\\" OpenCV_VC_PATH_ESC_ESC "${OpenCV_VC_PATH_ESC}")

set(opencv_SOURCE_DIR "${opencv_SOURCE_DIR}/${OpenCV_OUTPUT_DIR}/opencv/sources")
file(TO_NATIVE_PATH "${OpenCV_BIN_PATH}" OpenCV_BIN_NATIVE_PATH)

string(REPLACE "." ";" OpenCV_VERSION_LIST ${OpenCV_VERSION})
list(GET OpenCV_VERSION_LIST 0 OpenCV_VERSION_MAJOR)
list(GET OpenCV_VERSION_LIST 1 OpenCV_VERSION_MINOR)
list(GET OpenCV_VERSION_LIST 2 OpenCV_VERSION_PATCH)

set(OpenCV_DLLVERSION "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
set(OpenCV_DEBUG_POSTFIX d)

if(DEFINED CMAKE_DEBUG_POSTFIX)
  set(OpenCV_DEBUG_POSTFIX "${CMAKE_DEBUG_POSTFIX}")
endif()

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  set(OpenCV_BUILD_DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}")
else()
  set(OpenCV_BUILD_DEBUG_POSTFIX "")
endif()
