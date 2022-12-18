@GOTO :BEGIN
:: csrun.bat 01-show-image.cs

:BEGIN
@SETLOCAL enabledelayedexpansion

@SET "PATH=%CD%;%PATH%"
@PUSHD "%~dp0"
@CD /d %CD%
@SET "PATH=%CD%;%PATH%"

@CALL powershell.exe -ExecutionPolicy UnRestricted -File csrun.ps1 %*

:END
@POPD
@EXIT /B %ERRORLEVEL%
