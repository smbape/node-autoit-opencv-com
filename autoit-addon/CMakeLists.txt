cmake_minimum_required(VERSION 3.5)

# Name of the project (will be the name of the plugin)
project(autoit_addon)

set(DEFAULT_BUILD_TYPE "Release")

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

add_definitions(-DAUTOIT_MODULE_NAME=${PROJECT_NAME})
add_definitions(-DAUTOITAPI_EXPORTS)

if(CMAKE_COMPILER_IS_GNUCXX)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused-function")
endif()

# Source headers
file(GLOB project_hdrs "./*.h*")
source_group("Include" FILES ${project_hdrs})

# Source files
file(GLOB project_srcs "./*.cpp")
source_group("Src" FILES ${project_srcs})

# Build a shared library named as the project
add_library(${PROJECT_NAME} SHARED ${project_srcs} ${project_hdrs})

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

target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})

set(OpenCV_DLLVERSION "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
set(OpenCV_DEBUG_POSTFIX d)

set_target_properties(${PROJECT_NAME} PROPERTIES
  OUTPUT_NAME "${PROJECT_NAME}${OpenCV_DLLVERSION}"
  DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
  COMPILE_PDB_NAME "${PROJECT_NAME}${OpenCV_DLLVERSION}"
  COMPILE_PDB_NAME_DEBUG "${PROJECT_NAME}${OpenCV_DLLVERSION}${OpenCV_DEBUG_POSTFIX}"
)

get_filename_component(OpenCV_BINARY_DIR "${OpenCV_DIR}/x64/vc15/bin" REALPATH)
file(TO_NATIVE_PATH "${OpenCV_BINARY_DIR}" OpenCV_BINARY_DIR)

set_property(TARGET ${PROJECT_NAME} PROPERTY VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BINARY_DIR};%PATH%")
