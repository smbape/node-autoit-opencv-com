#requires -version 5.0

[CmdletBinding()]
param (
    [string] $Video = $null,
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
$Video = if ([string]::IsNullOrEmpty($Video)) { _OpenCV_FindFile "samples\data\vtest.avi" } else { $Video }

function Example() {
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $cap = [OpenCvComInterop]::ObjCreate("cv.VideoCapture").create($Video)
    if (!$cap.isOpened()) {
        Write-Error "!>Error: cannot open the video file $Video."
        return
    }

    $frame = [OpenCvComInterop]::ObjCreate("cv.Mat")

    while ($true) {
        if (-not $cap.read($frame)) {
            Write-Error "!>Error: cannot read the video or end of the video."
            break
        }

        $cv.imshow("capture video file", $frame)
        $key = $cv.waitKey(30)
        if (($key -eq 27) -or ($key -eq [byte][char]'q') -or ($key -eq [byte][char]'Q')) {
            break
        }
    }
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
