#requires -version 5.0

[CmdletBinding()]
param (
    [Parameter(Mandatory, Position=0)][string] $File,
    [string] $BuildType = $Env:BUILD_TYPE,
    [Parameter(ValueFromRemainingArguments=$true)][string[]] $argv
)
# "powershell.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"
# "pwsh.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0
trap { Write-Host $Error.ScriptStackTrace -Foreground "DarkGray"; throw $Error[0] }

Import-Module "$PSScriptRoot\opencv_utils.psm1" -ArgumentList $BuildType


$Env:Path = 'C:\Program Files\Microsoft Visual Studio\18\Enterprise\MSBuild\Current\bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn;' + $Env:Path

$OpenCvComInterop = _OpenCV_FindFile -Path "dotnet\OpenCvComInterop.cs" -SearchPaths @(
    "."
    "autoit-opencv-com"
)

$OpenCVInteropServices = _OpenCV_FindFile -Path "dotnet\OpenCV.InteropServices.dll" -SearchPaths @(
    "."
    "autoit-opencv-com"
    "autoit-opencv-com\generated"
)

$Parameters = New-Object System.Collections.Generic.List[string]

$Parameters.Add("/link:$OpenCVInteropServices")

if ($BuildType -eq "Debug") {
    $ExeFile = "$($File.Substring(0, $File.Length - 3))d.exe"
    $Parameters.Add("/debug:full")
    $Parameters.Add("/define:TRACE;DEBUG")
} else {
    $ExeFile = "$($File.Substring(0, $File.Length - 3)).exe"
}

$Parameters.Add("/out:$ExeFile")

$Parameters.Add($OpenCvComInterop)
$Parameters.Add($File)

csc.exe $Parameters.ToArray()

if ($lastexitcode -eq 0) {
    # PowerShell does not load commands from the current location by default (see 'Get-Help about_Command_Precedence').
    $ExeFile = [System.IO.Path]::GetFullPath($ExeFile)
    & "$ExeFile" --build-type `"$BuildType`" @argv
}

exit $lastexitcode
