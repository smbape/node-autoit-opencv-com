#requires -version 5.0

[CmdletBinding()]
param (
    [string] $Image = $null,
    [string] $BuildType = $Env:BUILD_TYPE,
    [string] $OpenCVWorldDll = $null,
    [string] $OpenCVComDll = $null,
    [switch] $Register,
    [switch] $Unregister
)
# "pwsh.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0
trap { throw $Error[0] }

Import-Module "$PSScriptRoot\opencv_utils.psm1"

$BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "RelWithDebInfo" }

$OpenCVWorldDll = if ([string]::IsNullOrEmpty($OpenCVWorldDll)) { _OpenCV_FindDLL "opencv_world4*" "opencv-4.*\opencv" -BuildType $BuildType } else { $OpenCVWorldDll }
$OpenCVComDll = if ([string]::IsNullOrEmpty($OpenCVComDll)) { _OpenCV_FindDLL "autoit_opencv_com4*" -BuildType $BuildType } else { $OpenCVComDll }
$Image = if ([string]::IsNullOrEmpty($Image)) { _OpenCV_FindFile "samples\data\lena.jpg" } else { $Image }

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
