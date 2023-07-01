cmake_minimum_required(VERSION 3.19)

# Name of the project (will be the name of the plugin)
project(autoit_opencv_com)

set(DEFAULT_BUILD_TYPE "Release")

if(NOT DEFINED CMAKE_BUILD_TYPE)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build.")
endif()

# Set the possible values of build type for cmake-gui
set(CMAKE_CONFIGURATION_TYPES "Debug;Release;MinSizeRel;RelWithDebInfo" CACHE STRING "Configs" FORCE)
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${CMAKE_CONFIGURATION_TYPES}")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(WIN32 AND MSVC)
  add_compile_options(/MP)
endif()

include(cmake/RequireOpenCV.cmake)
include(cmake/vcpkg_regex_replace_string.cmake)

# update version in files
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/src/cvLib.rc" "(opencv_world|autoit_opencv_com|opencv_videoio_ffmpeg)[0-9]+" "\\1${OpenCV_DLLVERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../scripts/build.js" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+" "opencv-${OpenCV_VERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../src/gen.js" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+" "opencv-${OpenCV_VERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "/opencv/releases/download/[0-9]+\\.[0-9]+\\.[0-9]+/" "/opencv/releases/download/${OpenCV_VERSION}/")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "\\\\\\\\x64\\\\\\\\vc[^\\\\]+\\\\\\\\bin" "\\\\\\\\${OpenCV_VC_PATH_ESC_ESC}\\\\\\\\bin")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../autoit-addon/CMakeLists.txt" "OpenCV_VERSION [0-9]+\\.[0-9]+\\.[0-9]+" "OpenCV_VERSION ${OpenCV_VERSION}")

file(GLOB_RECURSE files_to_change
  "install.bat"
  "udf/*.au3"
  "dotnet/*.cs"
  "test/*.cpp"
  "test/*.cs"
  "../README.md"
  "../samples/*.au3"
  "../samples/*.cs"
  "../samples/*.ps1"
  "../samples/*.psm1"
)

foreach(item ${files_to_change})
  vcpkg_regex_replace_string("${item}" "(https://docs\\.opencv\\.org/|https://github\\.com/opencv/opencv/blob/|opencv-)[0-9]+\\.[0-9]+\\.[0-9]+/" "\\1${OpenCV_VERSION}/")
  vcpkg_regex_replace_string("${item}" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+-(vc14_vc15|windows)\\.(exe|zip)" "${OpenCV_DOWNLOAD_NAME}")
  vcpkg_regex_replace_string("${item}" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+-(vc14_vc15|windows)" "${OpenCV_OUTPUT_DIR}")
  vcpkg_regex_replace_string("${item}" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+" "opencv-${OpenCV_VERSION}")
  vcpkg_regex_replace_string("${item}" "(opencv_world|autoit_opencv_com|opencv_videoio_ffmpeg)[0-9]+" "\\1${OpenCV_DLLVERSION}")
  vcpkg_regex_replace_string("${item}" "\\\\x64\\\\vc[^\\\\]+\\\\bin" "\\\\${OpenCV_VC_PATH_ESC}\\\\bin")
endforeach()

set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/bin" CACHE PATH "Output directory for applications")
set(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/lib" CACHE PATH "Output directory for libraries")

get_filename_component(OPENCV_SAMPLES_DATA_PATH "${opencv_SOURCE_DIR}/samples/data" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_SAMPLES_DATA_PATH}" OPENCV_SAMPLES_DATA_PATH)

# generate python headers
if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/opencv-${OpenCV_VERSION}-build_x64/modules/python_bindings_generator/headers.txt")
  file(MAKE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/opencv-${OpenCV_VERSION}-build_x64")
  execute_process(
    COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" -DBUILD_opencv_world=ON -DBUILD_opencv_python_bindings_generator=ON "${opencv_SOURCE_DIR}"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/opencv-${OpenCV_VERSION}-build_x64"
    COMMAND_ECHO STDERR
  )
endif()

# generate source files
execute_process(
  COMMAND node --unhandled-rejections=strict --trace-uncaught --trace-warnings src/gen.js
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

list(APPEND project_generated_resources "$<$<CONFIG:Debug>:${EXECUTABLE_OUTPUT_PATH}/Debug/autoit_opencv_com${OpenCV_DLLVERSION}d.sxs.manifest>")
list(APPEND project_generated_resources "$<$<NOT:$<CONFIG:Debug>>:${EXECUTABLE_OUTPUT_PATH}/Release/autoit_opencv_com${OpenCV_DLLVERSION}.sxs.manifest>")

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
target_compile_definitions(${PROJECT_NAME}
  PRIVATE ISOLATION_AWARE_ENABLED
  PRIVATE _WIN32_FUSION=0x0100
)

target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS})

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
  set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/DEBUG")
endif()

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
  VS_DEBUGGER_ENVIRONMENT       "PATH=${OpenCV_BIN_NATIVE_PATH};%PATH%\nOPENCV_SAMPLES_DATA_PATH=${OPENCV_SAMPLES_DATA_PATH}\nBUILD_TYPE=Debug"
)

# ===============
# cpp_test target
# ===============
file(GLOB test_files "test/*.h*" "test/*.cpp")

add_executable(cpp_test ${test_files})

target_precompile_headers(cpp_test PRIVATE
  "$<$<COMPILE_LANGUAGE:CXX>:${CMAKE_CURRENT_SOURCE_DIR}/test/test.h>"
)

target_link_libraries(cpp_test PRIVATE ${PROJECT_NAME} "windowsapp.lib" "dwmapi.lib" ${OpenCV_LIBS})
set_target_properties(cpp_test PROPERTIES
  VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BIN_NATIVE_PATH};%PATH%\nOPENCV_SAMPLES_DATA_PATH=${OPENCV_SAMPLES_DATA_PATH}"
  RUNTIME_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}"
)
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

# Always generate debug files
if(MSVC AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  set_target_properties(cpp_test PROPERTIES LINK_FLAGS "/DEBUG")
endif()

if (CMAKE_GENERATOR MATCHES "Visual Studio")
# ===============
# C# Interop target
# ===============
include(CSharpUtilities)
enable_language(CSharp)

file(GLOB_RECURSE cs_files "dotnet/*.cs")
add_library(interop_opencv SHARED ${cs_files})

set_target_properties(interop_opencv PROPERTIES
  OUTPUT_NAME "interop.opencv-${OpenCV_VERSION_MAJOR}"
  DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
  VS_DOTNET_REFERENCES "CustomMarshalers;Microsoft.CSharp;System"
)

foreach( BUILD_TYPE ${CMAKE_CONFIGURATION_TYPES} )
  string( TOUPPER ${BUILD_TYPE} BUILD_TYPE_UPPER )
  set_target_properties(interop_opencv PROPERTIES RUNTIME_OUTPUT_DIRECTORY_${BUILD_TYPE_UPPER} "${EXECUTABLE_OUTPUT_PATH}/${BUILD_TYPE}/dotnet")
endforeach()

# Always generate debug files
if(MSVC AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  target_compile_options(interop_opencv PRIVATE "-debug:pdbonly")
endif()

# ===============
# C# Assembly target
# ===============
set(ASSEMBLY_DLL "${CMAKE_CURRENT_SOURCE_DIR}/generated/dotnet/OpenCV.InteropServices.dll")
file(TO_NATIVE_PATH "${ASSEMBLY_DLL}" ASSEMBLY_DLL_NATIVE_PATH)
file(TO_NATIVE_PATH "generated/cvLib.tlb" TYPELIB)
add_custom_command(OUTPUT "${ASSEMBLY_DLL}"
  COMMAND           tlbimp.exe
                    "/out:${ASSEMBLY_DLL_NATIVE_PATH}"
                    /VariantBoolFieldToBool
                    /strictref
                    # /noclassmembers
                    /machine:X64
                    "${TYPELIB}"
  # COMMAND           cmake -E touch "${ASSEMBLY_DLL}"
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  DEPENDS           "${TYPELIB}"
  VERBATIM
)
add_custom_target(cs_assembly DEPENDS "${ASSEMBLY_DLL}")

# ===============
# cs_test target
# ===============
include(CSharpUtilities)
enable_language(CSharp)

file(GLOB test_files "test/*.cs" "dotnet/*.cs")
add_executable(cs_test ${test_files})

get_filename_component(OPENCV_SAMPLES_DATA_PATH_HINT "../samples/data" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_SAMPLES_DATA_PATH_HINT}" OPENCV_SAMPLES_DATA_PATH_HINT)

set_target_properties(cs_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}"
  DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
  VS_GLOBAL_EnableUnmanagedDebugging "true"
  VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BIN_NATIVE_PATH};%PATH%\nOPENCV_SAMPLES_DATA_PATH_HINT=${OPENCV_SAMPLES_DATA_PATH_HINT}"
  VS_DOTNET_REFERENCES "Microsoft.CSharp;System;System.Core"
  VS_DOTNET_REFERENCE_OpenCV "${ASSEMBLY_DLL}"
  VS_DOTNET_REFERENCEPROP_OpenCV_TAG_EmbedInteropTypes "True"
)

add_dependencies(cs_test cs_assembly)

# Always generate debug files
if(MSVC AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  target_compile_options(cs_test PRIVATE "-debug:pdbonly")
endif()

endif()
