@ECHO OFF
SETLOCAL enabledelayedexpansion

PUSHD "%~dp0"
CD /d %CD%
SET "PATH=%CD%;%PATH%"
SET "CWD=%CD%"

SET skip_python=0
SET skip_node=0
SET skip_build=0
SET build_target=ALL_BUILD
SET has_generator=0
SET CMAKE_GENERATOR=

SET nparms=20

:GET_OPTS
IF %nparms% == 0 GOTO :MAIN
IF [%1] == [nopy] SET skip_python=1
IF [%1] == [nojs] SET skip_node=1
IF [%1] == [-g] SET skip_build=1
IF [%1] == [--target] (
    SET build_target=%2
    SHIFT
    IF %nparms% == 0 GOTO :MAIN
)
IF [%1] == [-G] (
    IF [%2-%build_target%] == [Ninja-ALL_BUILD] SET build_target=all
    SET CMAKE_GENERATOR=%2
    SET has_generator=1
    SET /a nparms -=1
    SHIFT
    IF %nparms% == 0 GOTO :MAIN
)
IF [%1] == [-A] (
    SET CMAKE_GENERATOR=%CMAKE_GENERATOR% -A %2
    SET /a nparms -=1
    SHIFT
    IF %nparms% == 0 GOTO :MAIN
)
SET /a nparms -=1
SHIFT
GOTO GET_OPTS

:MAIN
SET BUILD_FOLDER=build_x64

IF NOT DEFINED CMAKE_BUILD_TYPE SET CMAKE_BUILD_TYPE=Release
SET EXTRA_CMAKE_OPTIONS=%EXTRA_CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE="%CMAKE_BUILD_TYPE%" -DCMAKE_INSTALL_PREFIX=install

::Find CMake
SET CMAKE="cmake.exe"
IF EXIST "%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe"
IF EXIST "%PROGRAMFILES_DIR%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR%\CMake\bin\cmake.exe"
IF EXIST "%PROGRAMW6432%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMW6432%\CMake\bin\cmake.exe"

::Find Visual Studio
FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,^) -property installationVersion -latest`) DO SET VS_VERSION=%%F

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [16.0^,^) -property installationPath -latest`) DO (
    IF NOT [%has_generator%] == [1] SET CMAKE_GENERATOR="Visual Studio %VS_VERSION:~0,2%" -A x64
    SET has_generator=1
    CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /B %ERRORLEVEL%
)

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [15.0^,16.0^) -property installationPath -latest`) DO (
    IF NOT [%has_generator%] == [1] SET CMAKE_GENERATOR="Visual Studio %VS_VERSION:~0,2% Win64"
    SET has_generator=1
    CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /B %ERRORLEVEL%
)

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,15.0^) -property installationPath -latest`) DO (
    IF NOT [%has_generator%] == [1] SET CMAKE_GENERATOR="Visual Studio %VS_VERSION:~0,2% Win64"
    SET has_generator=1
    CALL "%%F\VC\vcvarsall.bat" x64
    GOTO MAKE
    EXIT /B %ERRORLEVEL%
)

IF [%has_generator%] == [1] GOTO MAKE
ECHO Unable to find a visual studio version
SET ERROR=1
GOTO END

:MAKE
SET ERROR=0

rem IF EXIST "%BUILD_FOLDER%\CMakeCache.txt" DEL "%BUILD_FOLDER%\CMakeCache.txt"

:DOWNLOAD_OPENCV
SET TARGET=opencv
CALL :MAKE_CONFIG
SET ERROR=%ERRORLEVEL%

SET TARGET=%build_target%
CD /d %CWD%
IF [%ERROR%] == [0] GOTO GEN_PYTHON
GOTO END

:GEN_PYTHON
IF [%skip_python%] == [1] GOTO GEN_SOURCES
IF EXIST opencv_build_x64\modules\python_bindings_generator\pyopencv_generated_include.h GOTO GEN_SOURCES

IF NOT EXIST opencv_build_x64 MKDIR opencv_build_x64
PUSHD opencv_build_x64
IF EXIST CMakeCache.txt DEL CMakeCache.txt

SET PYTHON_CONFIG_FLAGS=%PYTHON_CONFIG_FLAGS% "-DCMAKE_BUILD_TYPE:STRING=%CMAKE_BUILD_TYPE%"
SET PYTHON_CONFIG_FLAGS=%PYTHON_CONFIG_FLAGS% -DBUILD_opencv_world=ON -DBUILD_opencv_python3=ON

%CMAKE% -G %CMAKE_GENERATOR% %PYTHON_CONFIG_FLAGS% ..\..\opencv-4.6.0-vc14_vc15\opencv\sources\
SET ERROR=%ERRORLEVEL%
POPD
IF [%ERROR%] == [0] GOTO GEN_SOURCES
GOTO END

:GEN_SOURCES
IF [%skip_node%] == [1] GOTO MAKE_CONFIG
node --unhandled-rejections=strict --trace-uncaught --trace-warnings ..\src\gen.js --skip=vs
SET ERROR=%ERRORLEVEL%
IF [%ERROR%] == [0] GOTO MAKE_CONFIG
GOTO END

:MAKE_CONFIG
IF [%skip_config%] == [1] GOTO BUILD

IF NOT EXIST %BUILD_FOLDER% MKDIR %BUILD_FOLDER%
cd %BUILD_FOLDER%

%CMAKE% -G %CMAKE_GENERATOR% %EXTRA_CMAKE_OPTIONS% ..\
SET ERROR=%ERRORLEVEL%
IF [%ERROR%] == [0] GOTO BUILD
GOTO END

:BUILD
IF [%skip_build%] == [1] GOTO END
%CMAKE% --build . --config %CMAKE_BUILD_TYPE% --target %TARGET%
SET ERROR=%ERRORLEVEL%

:END
POPD
EXIT /B %ERROR%
