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

Import-Module "$PSScriptRoot\opencv_utils.psm1" -ArgumentList $BuildType

$BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "RelWithDebInfo" }

$OpenCVWorldDll = if ([string]::IsNullOrEmpty($OpenCVWorldDll)) { _OpenCV_FindDLL -Path "opencv_world4*" -Filter "opencv-4.*\opencv" -BuildType $BuildType } else { $OpenCVWorldDll }
$OpenCVComDll = if ([string]::IsNullOrEmpty($OpenCVComDll)) { _OpenCV_FindDLL -Path "autoit_opencv_com4*" -BuildType $BuildType } else { $OpenCVComDll }
$Image = if ([string]::IsNullOrEmpty($Image)) { _OpenCV_FindFile -Path "samples\data\pic1.png" } else { $Image }

function Example() {
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $img = $cv.imread($Image)
    $img_grey = $cv.cvtColor($img, $cv.COLOR_BGR2GRAY_)
    $cv.threshold($img_grey, 100, 255, $cv.THRESH_BINARY_) | Out-Null
    $thresh = $cv.extended[1]
    $contours = $cv.findContours($thresh, $cv.RETR_TREE_, $cv.CHAIN_APPROX_SIMPLE_)

    Write-Output "Found $($contours.Count) contours"

    $cv.drawContours($img, $contours, -1, @(0, 0, 255), 2) | Out-Null
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
