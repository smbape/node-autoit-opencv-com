@ECHO OFF
SETLOCAL enabledelayedexpansion

PUSHD "%~dp0"
CD /d %CD%
SET "PATH=%CD%;%PATH%"
SET "CWD=%CD%"

SET skip_build=0
SET TARGET=ALL_BUILD
SET has_generator=0
SET CMAKE_GENERATOR=

SET nparms=20

:GET_OPTS
IF %nparms% == 0 GOTO :MAIN
IF [%1] == [-g] SET skip_build=1
IF [%1] == [--target] (
    SET TARGET=%2
    SHIFT
    IF %nparms% == 0 GOTO :MAIN
)
IF [%1] == [-G] (
    IF [%2-%TARGET%] == [Ninja-ALL_BUILD] SET TARGET=all
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
