@ECHO off
SETLOCAL enabledelayedexpansion

SET BUILD_FOLDER=build_x64

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
