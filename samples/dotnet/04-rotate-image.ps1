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

$BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "Release" }

$OpenCVWorldDll = if ([string]::IsNullOrEmpty($OpenCVWorldDll)) { _OpenCV_FindDLL -Path "opencv_world4100*" -BuildType $BuildType } else { $OpenCVWorldDll }
$OpenCVComDll = if ([string]::IsNullOrEmpty($OpenCVComDll)) { _OpenCV_FindDLL -Path "autoit_opencv_com4100*" -BuildType $BuildType } else { $OpenCVComDll }
$Image = if ([string]::IsNullOrEmpty($Image)) { _OpenCV_FindFile -Path "samples\data\lena.jpg" -SearchPaths @("opencv-4.10.0-*\opencv\sources") } else { $Image }

function Example() {
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $img = $cv.imread($Image)
    $angle = 20
    $scale = 1

    $size = @($img.width, $img.height)
    $center = @(($img.width / 2), ($img.height / 2))
    $M = $cv.getRotationMatrix2D($center, -$angle, $scale)
    $rotated = $cv.warpAffine($img, $M, $size)

    $cv.imshow("Rotation", $rotated)
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
