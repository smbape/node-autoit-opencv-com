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
trap { throw $Error[0] }

Import-Module "$PSScriptRoot\opencv_utils.psm1" -ArgumentList $BuildType

$ExeFile = "$($File.Substring(0, $File.Length - 3)).exe"

$Env:Path = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\bin\Roslyn;' + $Env:Path
$Env:Path = 'C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\bin\Roslyn;' + $Env:Path

$OpenCvComInterop = _OpenCV_FindFile -Path "dotnet\OpenCvComInterop.cs" -SearchPaths @(
    "."
    "autoit-opencv-com"
)

$OpenCVInteropServices = _OpenCV_FindFile -Path "dotnet\OpenCV.InteropServices.dll" -SearchPaths @(
    "."
    "autoit-opencv-com"
    "autoit-opencv-com\generated"
)

csc.exe @(
    "/link:$OpenCVInteropServices"
    "/out:$ExeFile"
    "$OpenCvComInterop"
    "$File"
)

if ($lastexitcode -eq 0) {
    & "$ExeFile" --build-type `"$BuildType`" @argv
}

exit $lastexitcode
