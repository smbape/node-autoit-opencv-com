@ECHO OFF
SETLOCAL enabledelayedexpansion

PUSHD "%~dp0"
CD /d %CD%
SET "PATH=%CD%;%PATH%"
SET "CWD=%CD%"

SET skip_python=0
SET skip_node=0
SET skip_build=0
SET TARGET=ALL_BUILD

SET nparms=20
:LOOP
IF %nparms%==0 GOTO :MAIN
IF [%1] == [nopy] SET skip_python=1
IF [%1] == [nojs] SET skip_node=1
IF [%1] == [-g] SET skip_build=1
SET /a nparms -=1
SHIFT
GOTO LOOP

:MAIN

SET BUILD_FOLDER=build_x64

IF NOT DEFINED CMAKE_BUILD_TYPE SET CMAKE_BUILD_TYPE=Release
SET GENERAL_CMAKE_CONFIG_FLAGS=%GENERAL_CMAKE_CONFIG_FLAGS% -DCMAKE_BUILD_TYPE:STRING="%CMAKE_BUILD_TYPE%" -DCMAKE_INSTALL_PREFIX:STRING=install

::Find CMake
SET CMAKE="cmake.exe"
IF EXIST "%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe"
IF EXIST "%PROGRAMFILES_DIR%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR%\CMake\bin\cmake.exe"
IF EXIST "%PROGRAMW6432%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMW6432%\CMake\bin\cmake.exe"

::Find Visual Studio
FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,^) -property installationVersion -latest`) DO SET VS_VERSION=%%F

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [16.0^,^) -property installationPath -latest`) DO (
    SET CMAKE_CONF="Visual Studio %VS_VERSION:~0,2%" -A x64
    CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [15.0^,16.0^) -property installationPath -latest`) DO (
    SET CMAKE_CONF="Visual Studio %VS_VERSION:~0,2% Win64"
    CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,15.0^) -property installationPath -latest`) DO (
    SET CMAKE_CONF="Visual Studio %VS_VERSION:~0,2% Win64"
    CALL "%%F\VC\vcvarsall.bat" x64
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

ECHO Unable to find a visual studio version
SET ERROR=1
GOTO END

:MAKE
SET ERROR=0

:DOWNLOAD_OPENCV
SET TARGET=opencv
CALL :MAKE_CONFIG
SET ERROR=%ERRORLEVEL%
SET TARGET=ALL_BUILD
CD /d %CWD%
IF "%ERROR%" == "0" GOTO GEN_PYTHON
GOTO END

:GEN_PYTHON
IF [%skip_python%] == [1] GOTO GEN_SOURCES
IF EXIST opencv_build_x64\modules\python_bindings_generator\pyopencv_generated_include.h GOTO GEN_SOURCES

IF NOT EXIST opencv_build_x64 mkdir opencv_build_x64
PUSHD opencv_build_x64

SET PYTHON_CONFIG_FLAGS=%PYTHON_CONFIG_FLAGS% -DCMAKE_BUILD_TYPE:STRING="%CMAKE_BUILD_TYPE%"
SET PYTHON_CONFIG_FLAGS=%PYTHON_CONFIG_FLAGS% -DBUILD_opencv_world=ON -DBUILD_opencv_python3=ON

%CMAKE% -G %CMAKE_CONF% %PYTHON_CONFIG_FLAGS% ..\..\opencv-4.5.5-vc14_vc15\opencv\sources\
SET ERROR=%ERRORLEVEL%
POPD
IF "%ERROR%" == "0" GOTO GEN_SOURCES
GOTO END

:GEN_SOURCES
IF [%skip_node%] == [1] GOTO MAKE_CONFIG
node --unhandled-rejections=strict --trace-uncaught --trace-warnings ..\src\gen.js --skip=vs
SET ERROR=%ERRORLEVEL%
IF "%ERROR%" == "0" GOTO MAKE_CONFIG
GOTO END

:MAKE_CONFIG
IF [%skip_config%] == [1] GOTO BUILD

IF NOT EXIST %BUILD_FOLDER% mkdir %BUILD_FOLDER%
cd %BUILD_FOLDER%
rem IF EXIST "CMakeCache.txt" del CMakeCache.txt

%CMAKE% -G %CMAKE_CONF% %GENERAL_CMAKE_CONFIG_FLAGS% ..\
SET ERROR=%ERRORLEVEL%
IF "%ERROR%" == "0" GOTO BUILD
GOTO END

:BUILD
IF [%skip_build%] == [1] GOTO END
%CMAKE% --build . --config %CMAKE_BUILD_TYPE% --target %TARGET%
SET ERROR=%ERRORLEVEL%

:END
POPD
EXIT /B %ERROR%
