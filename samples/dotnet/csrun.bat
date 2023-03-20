@GOTO :BEGIN
:: csrun.bat 01-show-image.cs

:BEGIN
@SETLOCAL enabledelayedexpansion

@SET CWD=%CD%
@SET "PATH=%CD%;%PATH%"

@PUSHD "%~dp0"
@CD /d %CD%

@SET SCRIPTDIR=%CD%
@SET "PATH=%SCRIPTDIR%;%PATH%"

@POPD
@CD /d %CD%

@CALL powershell.exe -ExecutionPolicy UnRestricted -File "%SCRIPTDIR%\csrun.ps1" %*

:END
@POPD
@EXIT /B %ERRORLEVEL%
