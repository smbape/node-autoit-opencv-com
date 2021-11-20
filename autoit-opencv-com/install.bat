@GOTO :BEGIN
:: install.bat /i
:: install.bat /i:user
:: install.bat /u
:: install.bat /u:user
:: install.bat /u /i
:: install.bat /u:user /i:user

:BEGIN
@SETLOCAL enabledelayedexpansion

@SET _batchFile=%~fs0

:: double up any quotes
@SET _batchFile=""%_batchFile:"=%""

@SET "PATH=%CD%;%PATH%"
@PUSHD "%~dp0"
@CD /d %CD%
@SET "PATH=%CD%;%PATH%"

@SET install=0
@SET uninstall=0
@SET install_user=0
@SET uninstall_user=0
@SET DEBUG_PREFIX=

@SET nparms=20
:LOOP
@IF %nparms%==0 GOTO :MAIN
@IF [%1] == [/i] @SET install=1
@IF [%1] == [/u] @SET uninstall=1
@IF [%1] == [/i:user] @SET install_user=1
@IF [%1] == [/u:user] @SET uninstall_user=1
@IF [%1] == [/d] @SET DEBUG_PREFIX=d
@SET /a nparms -=1
@SHIFT
@GOTO LOOP

:MAIN
@SET DLLDIRNAME=
@SET DLLNAME=autoit_opencv_com454%DEBUG_PREFIX%.dll

@IF EXIST "%CD%\build_x64\Release\%DLLNAME%" SET "DLLDIRNAME=%CD%\build_x64\Release\"
@IF EXIST "%CD%\build_x64\Debug\%DLLNAME%" SET "DLLDIRNAME=%CD%\build_x64\Debug\"

:UNINSTALL
@IF [%uninstall%] == [1] (
    fltmc >nul 2>&1 || (
        @IF [%install%] == [1] CALL :ELEVATE /u /i
        @IF NOT [%install%] == [1] CALL :ELEVATE /u
        GOTO UNINSTALL_USER
        GOTO END
    )

    @ECHO regsvr32 /u /n /i %DLLDIRNAME%%DLLNAME%
    regsvr32 /u /n /i %DLLDIRNAME%%DLLNAME%
)
@IF NOT [%ERRORLEVEL%] == [0] GOTO END

:INSTALL
@IF [%install%] == [1] (
    fltmc >nul 2>&1 || (
        CALL :ELEVATE /i
        GOTO UNINSTALL_USER
        GOTO END
    )

    @ECHO regsvr32 /n /i %DLLDIRNAME%%DLLNAME%
    regsvr32 /n /i %DLLDIRNAME%%DLLNAME%
)
@IF NOT [%ERRORLEVEL%] == [0] GOTO END

:UNINSTALL_USER
@IF [%uninstall_user%] == [1] (
    @ECHO regsvr32 /u /n /i:user %DLLDIRNAME%%DLLNAME%
    regsvr32 /u /n /i:user %DLLDIRNAME%%DLLNAME%
)
@IF NOT [%ERRORLEVEL%] == [0] GOTO END

:INSTALL_USER
@IF [%install_user%] == [1] (
    @ECHO regsvr32 /n /i:user %DLLDIRNAME%%DLLNAME%
    regsvr32 /n /i:user %DLLDIRNAME%%DLLNAME%
)
@IF NOT [%ERRORLEVEL%] == [0] GOTO END

@GOTO END

:ELEVATE
::Create and run a temporary VBScript to elevate this batch file
@SET _Args=%*
@SET _Args=%_Args:"=""%
@Echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\~ElevateMe.vbs"
@ECHO UAC.ShellExecute "cmd", "/c ""%_batchFile% %_Args%""", "", "runas", 1 >> "%temp%\~ElevateMe.vbs"
@CALL "%temp%\~ElevateMe.vbs"
@DEL /f /q "%temp%\~ElevateMe.vbs"

:END
@POPD
@EXIT /B %ERRORLEVEL%
