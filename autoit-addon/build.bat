@echo off
SETLOCAL enabledelayedexpansion

SET ARCH=x64
SET OS_MODE= Win64
SET BUILD_FOLDER=build_x64
SET BUILD_ARCH=-A x64

IF NOT DEFINED CMAKE_BUILD_TYPE SET CMAKE_BUILD_TYPE=Release
SET GENERAL_CMAKE_CONFIG_FLAGS=%GENERAL_CMAKE_CONFIG_FLAGS% -DCMAKE_BUILD_TYPE:STRING="%CMAKE_BUILD_TYPE%" -DCMAKE_INSTALL_PREFIX:STRING=install

PUSHD "%~dp0"
CD /d %CD%
SET "PATH=%CD%;%PATH%"

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
EXIT /B 1

:MAKE
IF NOT EXIST %BUILD_FOLDER% mkdir %BUILD_FOLDER%
cd %BUILD_FOLDER%

IF EXIST "CMakeCache.txt" del CMakeCache.txt

:RUN_CMAKE
%CMAKE% -G %CMAKE_CONF% %GENERAL_CMAKE_CONFIG_FLAGS% ..\
SET ERROR=%ERRORLEVEL%
IF "%1%"=="-g" (
    EXIT /B %ERROR%
)
IF "%ERROR%" == "0" GOTO BUILD
EXIT /B %ERROR%

:BUILD
%CMAKE% --build . --config %CMAKE_BUILD_TYPE% --target ALL_BUILD
SET ERROR=%ERRORLEVEL%
IF "%ERROR%" == "0" GOTO END
EXIT /B %ERROR%

:END
POPD
