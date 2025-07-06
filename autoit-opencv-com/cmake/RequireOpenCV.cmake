include(cmake/FindPatch.cmake)

set(BUILD_opencv OFF CACHE BOOL "Build opencv from sources.")

set(OpenCV_URL_HASH_4120 b753b14d880b9bc8d89d6acd3b665c040baec0211078435432fcae117db707af)

set(OpenCV_VERSION 4.12.0 CACHE STRING "Choose the OpenCV version.")
set_property(CACHE OpenCV_VERSION PROPERTY STRINGS "4.12.0")
string(REPLACE "." "" OpenCV_DLLVERSION ${OpenCV_VERSION})

set(OpenCV_DOWNLOAD_NAME opencv-${OpenCV_VERSION}-windows.exe)

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
FetchContent_Populate(opencv
    URL                 ${OpenCV_URL}
    URL_HASH            ${OpenCV_URL_HASH}
    DOWNLOAD_NO_EXTRACT TRUE
    DOWNLOAD_DIR        "${OPENCV_DOWNLOAD_DIR}"
    SOURCE_DIR          "${OPENCV_DOWNLOAD_DIR}"
    PATCH_COMMAND       "<DOWNLOAD_DIR>/${OpenCV_DOWNLOAD_NAME}" "-o<DOWNLOAD_DIR>/${OpenCV_OUTPUT_DIR}" -y
)

include(FetchContent)
FetchContent_Populate(opencv-patch
    URL                 ${OpenCV_URL}
    URL_HASH            ${OpenCV_URL_HASH}
    DOWNLOAD_NO_EXTRACT TRUE
    DOWNLOAD_DIR        "${OPENCV_DOWNLOAD_DIR}"
    SOURCE_DIR          "${OPENCV_DOWNLOAD_DIR}"
    PATCH_COMMAND       "${PATCH_EXECUTABLE}" -p1 -d "<DOWNLOAD_DIR>/${OpenCV_OUTPUT_DIR}/opencv/sources/"
                                                -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-opencv-src.patch"
)

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
