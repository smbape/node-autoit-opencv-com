@GOTO :BEGIN
:: install.bat /i:user
:: install.bat /u:user
:: install.bat /u:user /i:user
:: install.bat /i
:: install.bat /u
:: install.bat /u /i

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
@SET INT_DIR=Release

@SET nparms=20
:LOOP
@IF %nparms%==0 GOTO :mainmenu
@IF [%1] == [/i] @SET install=1
@IF [%1] == [/u] @SET uninstall=1
@IF [%1] == [/i:user] @SET install_user=1
@IF [%1] == [/u:user] @SET uninstall_user=1
@IF [%1] == [/d] @SET DEBUG_PREFIX=d
@IF [%1] == [/d] @SET INT_DIR=Debug
@SET /a nparms -=1
@SHIFT
@GOTO LOOP

:mainmenu
@SET DLLDIRNAME=
@SET DLLNAME=autoit_opencv_com470%DEBUG_PREFIX%.dll

@IF EXIST "%CD%\build_x64\%INT_DIR%\%DLLNAME%" @SET "DLLDIRNAME=%CD%\build_x64\%INT_DIR%\"
@IF EXIST "%CD%\..\opencv-4.7.0-windows\opencv\build\x64\vc15\bin" @SET "PATH=%CD%\..\opencv-4.7.0-windows\opencv\build\x64\vc15\bin;%PATH%"

@SET DLLNAME=%DLLDIRNAME%%DLLNAME%

@IF NOT [%install%%uninstall%%install_user%%uninstall_user%] == [0000] GOTO MAIN

@CLS
@TITLE AutoIt OpenCV COM
@ECHO. AutoIt OpenCV COM
@ECHO.
@ECHO. VERSION: 2.2.2
@ECHO. DLLNAME: %DLLNAME%
@ECHO.
@ECHO.
@ECHO. Choose your option...
@ECHO.
@ECHO. (1) Install for the current user
@ECHO. (2) Uninstall for the current user
@ECHO. (3) Reinstall for the current user
@ECHO. (4) Install for the all users
@ECHO. (5) Uninstall for the all users
@ECHO. (6) Reinstall for the all users
@ECHO. (0) Close the Program

@SET /p userinp=    ^   Make your selection: 
@SET userinp=%userinp:~0,1%
@IF /i "%userinp%"=="1" GOTO install_user
@IF /i "%userinp%"=="2" GOTO uninstall_user
@IF /i "%userinp%"=="3" GOTO reinstall_user
@IF /i "%userinp%"=="4" GOTO install
@IF /i "%userinp%"=="5" GOTO uninstall
@IF /i "%userinp%"=="6" GOTO reinstall
@IF /i "%userinp%"=="0" GOTO END
@GOTO mainmenu

:install_user
@SET install=0
@SET uninstall=0
@SET install_user=1
@SET uninstall_user=0
@GOTO mainmenu

:uninstall_user
@SET install=0
@SET uninstall=0
@SET install_user=0
@SET uninstall_user=1
@GOTO mainmenu

:reinstall_user
@SET install=0
@SET uninstall=0
@SET install_user=1
@SET uninstall_user=1
@GOTO mainmenu

:install
@SET install=1
@SET uninstall=0
@SET install_user=0
@SET uninstall_user=0
@GOTO mainmenu

:uninstall
@SET install=0
@SET uninstall=1
@SET install_user=0
@SET uninstall_user=0
@GOTO mainmenu

:reinstall
@SET install=1
@SET uninstall=1
@SET install_user=0
@SET uninstall_user=0
@GOTO mainmenu

:MAIN

:UNINSTALL
@IF [%uninstall%] == [1] (
    fltmc >nul 2>&1 || (
        @IF [%install%] == [1] CALL :ELEVATE /u /i
        @IF NOT [%install%] == [1] CALL :ELEVATE /u
        GOTO UNINSTALL_USER
        GOTO END
    )

    @ECHO regsvr32 /u /n /i %DLLNAME%
    regsvr32 /u /n /i %DLLNAME%
)
@IF NOT [%ERRORLEVEL%] == [0] GOTO END

:INSTALL
@IF [%install%] == [1] (
    fltmc >nul 2>&1 || (
        CALL :ELEVATE /i
        GOTO UNINSTALL_USER
        GOTO END
    )

    @ECHO regsvr32 /n /i %DLLNAME%
    regsvr32 /n /i %DLLNAME%
)
@IF NOT [%ERRORLEVEL%] == [0] GOTO END

:UNINSTALL_USER
@IF [%uninstall_user%] == [1] (
    @ECHO regsvr32 /u /n /i:user %DLLNAME%
    regsvr32 /u /n /i:user %DLLNAME%
)
@IF NOT [%ERRORLEVEL%] == [0] GOTO END

:INSTALL_USER
@IF [%install_user%] == [1] (
    @ECHO regsvr32 /n /i:user %DLLNAME%
    regsvr32 /n /i:user %DLLNAME%
)
@IF NOT [%ERRORLEVEL%] == [0] GOTO END

@GOTO END

:ELEVATE
::Create and run a temporary VBScript to elevate this batch file
@SET _Args=%*
@SET _Args=%_Args:"=""%
@Echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\~ElevateMe.vbs"
@ECHO UAC.ShellExecute "cmd", "/c ""@SET ""PATH=%PATH%"" && %_batchFile% %_Args%""", "", "runas", 1 >> "%temp%\~ElevateMe.vbs"
@CALL "%temp%\~ElevateMe.vbs"
@DEL /f /q "%temp%\~ElevateMe.vbs"
@GOTO :EOF

:END
@POPD
@EXIT /B %ERRORLEVEL%
