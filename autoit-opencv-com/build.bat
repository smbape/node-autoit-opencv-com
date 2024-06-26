@ECHO OFF
SETLOCAL enabledelayedexpansion

PUSHD "%~dp0"
CD /d %CD%
SET "PATH=%CD%;%PATH%"
SET "SCRIPTPATH=%CD%"

SET skip_build=0
SET skip_config=0
SET TARGET=ALL_BUILD
SET has_generator=0
SET is_dry_run=0
SET CMAKE_GENERATOR=

SET nparms=20

:GET_OPTS
IF %nparms%==0 GOTO :MAIN

SET "_param=%~1"
IF ["%_param%"] == [""] GOTO :NEXT_OPT

IF ["%_param:~0,2%"] == ["-D"] (
    echo %_param% | find "=" 1>NUL 2>NUL
    if errorlevel 1 SET _param=%_param%=%~2
    if errorlevel 1 SET /a nparms -=1
    if errorlevel 1 SHIFT
    SET EXTRA_CMAKE_OPTIONS=%EXTRA_CMAKE_OPTIONS% "!_param!"
    GOTO :NEXT_OPT
)

IF [%1] == [-d] SET CMAKE_BUILD_TYPE=Debug
IF [%1] == [--dry-run] SET is_dry_run=1
IF [%1] == [--skip-build]  SET skip_build=1
IF [%1] == [--skip-config] SET skip_config=1
IF [%1] == [--target] (
    SET TARGET=%2
    GOTO :NEXT_OPT
)
IF [%1] == [-G] (
    IF [%2-%TARGET%] == [Ninja-ALL_BUILD] SET TARGET=all
    SET CMAKE_GENERATOR=-G %2
    SET has_generator=1
    GOTO :NEXT_OPT
)
IF ["%_param:~0,2%"] == ["-G"] (
    IF ["%_param%-%TARGET%"] == ["Ninja-ALL_BUILD"] SET TARGET=all
    SET CMAKE_GENERATOR="%_param%"
    SET has_generator=1
    GOTO :NEXT_OPT
)
IF [%1] == [-A] (
    SET CMAKE_GENERATOR_PLATFORM=-A %2
    GOTO :NEXT_OPT
)
:NEXT_OPT
SET /a nparms -=1
SHIFT
GOTO GET_OPTS

:MAIN
IF ["%CMAKE_GENERATOR%-%TARGET%"] == ["-G Ninja-ALL_BUILD"] SET TARGET=all
IF NOT DEFINED CMAKE_BUILD_TYPE SET CMAKE_BUILD_TYPE=Release
SET BUILD_FOLDER=%CD%\build_x64
SET EXTRA_CMAKE_OPTIONS=%EXTRA_CMAKE_OPTIONS% "-DCMAKE_BUILD_TYPE:STRING=%CMAKE_BUILD_TYPE%" "-DCMAKE_INSTALL_PREFIX:PATH=install"

IF DEFINED VSCMD_VER GOTO Set_Generator

::Find Visual Studio
FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,^) -property installationVersion -latest`) DO SET VS_VERSION=%%F
FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,^) -property catalog_productLineVersion -latest`) DO SET VS_PRODUCT_VERSION=%%F
FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [16.0^,^) -property installationPath -latest`) DO (
    IF NOT [%has_generator%] == [1] (
        SET CMAKE_GENERATOR=-G "Visual Studio %VS_VERSION:~0,2% %VS_PRODUCT_VERSION%"
        SET CMAKE_GENERATOR_PLATFORM=-A x64
    )
    SET has_generator=1
    CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /B %ERRORLEVEL%
)

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [15.0^,16.0^) -property installationPath -latest`) DO (
    IF NOT [%has_generator%] == [1] (
        SET CMAKE_GENERATOR=-G "Visual Studio %VS_VERSION:~0,2% %VS_PRODUCT_VERSION%""
        SET CMAKE_GENERATOR_PLATFORM=Win64"
    )
    SET has_generator=1
    CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /B %ERRORLEVEL%
)

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,15.0^) -property installationPath -latest`) DO (
    IF NOT [%has_generator%] == [1] (
        SET CMAKE_GENERATOR=-G "Visual Studio %VS_VERSION:~0,2% %VS_PRODUCT_VERSION%""
        SET CMAKE_GENERATOR_PLATFORM=Win64"
    )
    SET has_generator=1
    CALL "%%F\VC\vcvarsall.bat" x64
    GOTO MAKE
    EXIT /B %ERRORLEVEL%
)

ECHO Unable to find a visual studio version
SET ERROR=1
GOTO END

:Set_Generator
IF NOT DEFINED CMAKE_GENERATOR SET CMAKE_GENERATOR_PLATFORM=-A %VSCMD_ARG_TGT_ARCH%
IF NOT DEFINED CMAKE_GENERATOR SET CMAKE_GENERATOR=-G "Visual Studio %VSCMD_VER:~0,2%"

:MAKE
::Find CMake
SET "PATH=%DevEnvDir%\CommonExtensions\Microsoft\CMake\CMake\bin;%PATH%"
FOR %%X IN (cmake.exe) DO (set CMAKE="%%~$PATH:X")
IF NOT DEFINED CMAKE (
    IF EXIST "%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe"
    IF EXIST "%PROGRAMFILES_DIR%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR%\CMake\bin\cmake.exe"
    IF EXIST "%PROGRAMW6432%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMW6432%\CMake\bin\cmake.exe"
)

::Find Ninja
SET "PATH=%DevEnvDir%\CommonExtensions\Microsoft\CMake\Ninja;%PATH%"
FOR %%X IN (ninja.exe) DO (set "NINJA=%%~$PATH:X")
IF ["%CMAKE_GENERATOR:"=%"] == ["-G Ninja"] SET EXTRA_CMAKE_OPTIONS=%EXTRA_CMAKE_OPTIONS% "-DCMAKE_MAKE_PROGRAM=%NINJA%"

SET ERROR=0
SET TRY_RUN=
IF [%is_dry_run%] == [1] SET "TRY_RUN=@ECHO "
IF [%is_dry_run%] == [1] SET "CMAKE=@ECHO %CMAKE%"

:MAKE_CONFIG
IF NOT EXIST %BUILD_FOLDER% mkdir %BUILD_FOLDER%
REM IF EXIST "%BUILD_FOLDER%\CMakeCache.txt" del "%BUILD_FOLDER%\CMakeCache.txt"

IF [%skip_config%] == [1] GOTO BUILD
%CMAKE% %CMAKE_GENERATOR% %CMAKE_GENERATOR_PLATFORM% %EXTRA_CMAKE_OPTIONS% -S "%SCRIPTPATH%" -B "%BUILD_FOLDER%"
SET ERROR=%ERRORLEVEL%
IF [%ERROR%] == [0] GOTO BUILD
GOTO END

:BUILD
IF [%skip_build%] == [1] GOTO END
%CMAKE% --build "%BUILD_FOLDER%" --config %CMAKE_BUILD_TYPE% --target %TARGET%
SET ERROR=%ERRORLEVEL%

:END
POPD
EXIT /B %ERROR%
