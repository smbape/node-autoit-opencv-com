find_package(Git)

# https://github.com/scivision/cmake-patch-file/blob/main/cmake/PatchFile.cmake
if(WIN32)
  # prioritize Git Patch on Windows as other Patches may be very old and incompatible.
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
