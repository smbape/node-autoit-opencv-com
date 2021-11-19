cmake_minimum_required(VERSION 3.6)

# Name of the project (will be the name of the plugin)
project(autoit_opencv_com)

set(DEFAULT_BUILD_TYPE "Release")

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

add_compile_options(/MP)
set_source_files_properties(./src/autoit_bridge.cpp PROPERTIES COMPILE_FLAGS "/MP1")

file(GLOB project_source_resources "./src/*.rc" "./src/*.rgs")
file(GLOB project_source_headers "./src/*.h*")
file(GLOB project_sources_files "./src/*.c" "./src/*.cpp" "./src/*.def")

file(GLOB project_generated_resources "./generated/*.rc" "./generated/*.rgs")
file(GLOB project_generated_headers "./generated/*.h*")
file(GLOB project_generated_files "./generated/*.cpp" "./generated/*_i.c")

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

target_include_directories(${PROJECT_NAME} PUBLIC "src")
target_include_directories(${PROJECT_NAME} PUBLIC "generated")
target_include_directories(${PROJECT_NAME} PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.dir/${CMAKE_CFG_INTDIR}")

get_filename_component(OpenCV_BINARY_DIR "${OpenCV_DIR}/x64/vc15/bin" REALPATH)
file(TO_NATIVE_PATH "${OpenCV_BINARY_DIR}" OpenCV_BINARY_DIR)

set_property(TARGET ${PROJECT_NAME} PROPERTY VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BINARY_DIR};%PATH%")

file(GLOB test_files "./test/*.h*" "./test/*.cpp")

add_executable (cpp_test ${test_files})
target_link_libraries (cpp_test ${PROJECT_NAME})
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT cpp_test)

get_filename_component(OPENCV_SAMPLES_DATA_PATH "../samples/data" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_SAMPLES_DATA_PATH}" OPENCV_SAMPLES_DATA_PATH)

set_property(TARGET cpp_test PROPERTY VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BINARY_DIR};%PATH%\nOPENCV_SAMPLES_DATA_PATH=${OPENCV_SAMPLES_DATA_PATH}")
