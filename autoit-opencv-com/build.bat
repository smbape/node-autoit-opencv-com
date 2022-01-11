@ECHO OFF
SETLOCAL enabledelayedexpansion

PUSHD "%~dp0"
CD /d %CD%
SET "PATH=%CD%;%PATH%"

SET skip_python=0
SET skip_node=0
SET skip_build=0

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

SET ARCH=x64
SET OS_MODE= Win64
SET BUILD_FOLDER=build_x64
SET BUILD_ARCH=-A x64

IF NOT DEFINED CMAKE_BUILD_TYPE SET CMAKE_BUILD_TYPE=Release
SET GENERAL_CMAKE_CONFIG_FLAGS=%GENERAL_CMAKE_CONFIG_FLAGS% -DCMAKE_BUILD_TYPE:STRING="%CMAKE_BUILD_TYPE%" -DCMAKE_INSTALL_PREFIX:STRING=install

::Find CMake
SET CMAKE="cmake.exe"
IF EXIST "%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe"
IF EXIST "%PROGRAMFILES_DIR%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR%\CMake\bin\cmake.exe"
IF EXIST "%PROGRAMW6432%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMW6432%\CMake\bin\cmake.exe"

::Find Visual Studio
for /f "usebackq tokens=*" %%F in (`vswhere.exe -version [16.0^,17.0^) -property installationPath`) DO (
    SET CMAKE_CONF="Visual Studio 16" %BUILD_ARCH%
    CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [15.0^,16.0^) -property installationPath`) DO (
    SET CMAKE_CONF="Visual Studio 15%OS_MODE%"
    CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [14.0^,15.0^) -property installationPath`) DO (
    SET CMAKE_CONF="Visual Studio 14%OS_MODE%"
    rem SET MSVC_DIR=%%F
    CALL "!MSVC_DIR!VC\vcvarsall.bat" %ARCH%
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [12.0^,13.0^) -property installationPath`) DO (
    SET CMAKE_CONF="Visual Studio 12%OS_MODE%"
    rem SET MSVC_DIR=%%F
    CALL "!MSVC_DIR!VC\vcvarsall.bat" %ARCH%
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [11.0^,12.0^) -property installationPath`) DO (
    SET CMAKE_CONF="Visual Studio 11%OS_MODE%"
    SET MSVC_DIR=%%F
    CALL "!MSVC_DIR!VC\vcvarsall.bat" %ARCH%
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,11.0^) -property installationPath`) DO (
    SET CMAKE_CONF="Visual Studio 10%OS_MODE%"
    SET MSVC_DIR=%%F
    rem ECHO CALL "!MSVC_DIR!VC\vcvarsall.bat" %ARCH%
    CALL "!MSVC_DIR!VC\vcvarsall.bat" %ARCH%
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

ECHO Unable to find a visual studio version
SET ERROR=1
GOTO END

:MAKE
SET ERROR=0

:GEN_PYTHON
IF [%skip_python%] == [1] GOTO GEN_SOURCES
IF EXIST opencv_build_x64\modules\python_bindings_generator\pyopencv_generated_include.h GOTO GEN_SOURCES

IF NOT EXIST opencv_build_x64 mkdir opencv_build_x64
PUSHD opencv_build_x64

SET PYTHON_CONFIG_FLAGS=%PYTHON_CONFIG_FLAGS% -DCMAKE_BUILD_TYPE:STRING="%CMAKE_BUILD_TYPE%"
SET PYTHON_CONFIG_FLAGS=%PYTHON_CONFIG_FLAGS% -DBUILD_opencv_world:BOOL=ON -DBUILD_opencv_python3:BOOL=ON

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
IF NOT EXIST %BUILD_FOLDER% mkdir %BUILD_FOLDER%
cd %BUILD_FOLDER%

IF [%skip_config%] == [1] GOTO RUN_CMAKE

IF EXIST "CMakeache.txt" del CMakeCache.txt

:RUN_CMAKE
%CMAKE% -G %CMAKE_CONF% %GENERAL_CMAKE_CONFIG_FLAGS% ..\
SET ERROR=%ERRORLEVEL%
IF "%ERROR%" == "0" GOTO BUILD
GOTO END

:BUILD
IF [%skip_build%] == [1] GOTO END
%CMAKE% --build . --config %CMAKE_BUILD_TYPE% --target ALL_BUILD
SET ERROR=%ERRORLEVEL%

:END
POPD
EXIT /B %ERROR%
