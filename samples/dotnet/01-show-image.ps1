#requires -version 5.0

[CmdletBinding()]
param (
    [Parameter(Position=0)][string] $Image = $null,
    [string] $BuildType = $Env:BUILD_TYPE,
    [string] $OpenCVWorldDll = $null,
    [string] $OpenCVComDll = $null,
    [switch] $Register,
    [switch] $Unregister
)
# "powershell.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"
# "pwsh.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0
trap { throw $Error[0] }

Import-Module "$PSScriptRoot\opencv_utils.psm1" -ArgumentList $BuildType

$BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "RelWithDebInfo" }

$OpenCVWorldDll = if ([string]::IsNullOrEmpty($OpenCVWorldDll)) { _OpenCV_FindDLL -Path "opencv_world4*" -Filter "opencv-4.*\opencv" -BuildType $BuildType } else { $OpenCVWorldDll }
$OpenCVComDll = if ([string]::IsNullOrEmpty($OpenCVComDll)) { _OpenCV_FindDLL -Path "autoit_opencv_com4*" -BuildType $BuildType } else { $OpenCVComDll }
$Image = if ([string]::IsNullOrEmpty($Image)) { _OpenCV_FindFile -Path "samples\data\lena.jpg" } else { $Image }

function Example() {
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $img = $cv.imread($Image)
    $cv.imshow("Image", $img)
    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

[OpenCvComInterop]::DllOpen($OpenCVWorldDll, $OpenCVComDll)

if ($Register) {
    [OpenCvComInterop]::Register()
}

Example

if ($Unregister) {
    [OpenCvComInterop]::Unregister()
}

[OpenCvComInterop]::DllClose()
