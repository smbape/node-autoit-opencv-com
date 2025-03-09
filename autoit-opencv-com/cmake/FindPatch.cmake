find_package(Git)

# https://github.com/scivision/cmake-patch-file/blob/main/cmake/PatchFile.cmake
if(WIN32)
    # prioritize Git Patch on Windows as other Patches may be very old and incompatible.
    if(Git_FOUND)
        cmake_path(SET GIT_DIR NORMALIZE "${GIT_EXECUTABLE}/../../..")
    endif()
endif()

find_program(PATCH_EXECUTABLE
    NAMES patch
    HINTS ${GIT_DIR}
    PATH_SUFFIXES usr/bin
    DOC "Patch executable"
    REQUIRED
)
