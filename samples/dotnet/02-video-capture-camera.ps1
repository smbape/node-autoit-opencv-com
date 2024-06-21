#requires -version 5.0

[CmdletBinding()]
param (
    [Parameter(Position=0)][int] $Camera = 0,
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

function Example() {
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $cap = $cv.VideoCapture($Camera)
    if (!$cap.isOpened()) {
        Write-Error "!>Error: cannot open the camera $Camera."
        return
    }

    $CAP_FPS = 60
    $CAP_SPF = 1000 / $CAP_FPS

    $cap.set($cv.enums.CAP_PROP_FRAME_WIDTH, 1280) | Out-Null
    $cap.set($cv.enums.CAP_PROP_FRAME_HEIGHT, 720) | Out-Null
    $cap.set($cv.enums.CAP_PROP_FPS, $CAP_FPS) | Out-Null

    $frame = [OpenCvComInterop]::ObjCreate("cv.Mat")

    while ($true) {
        $start = $cv.getTickCount()
        if ($cap.read($frame)) {
            # Flip the image horizontally to give the mirror impression
            $oldframe = $frame
            $frame = $cv.flip($frame, 1)

            # Memory leak without this
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($oldframe) | Out-Null
        } else {
            Write-Error "!>Error: cannot read the camera $Camera."
        }
        $fps = $cv.getTickFrequency() / ($cv.getTickCount() - $start)

        $cv.putText($frame, "FPS : $([Math]::Round($fps))", @(10, 30), $cv.enums.FONT_HERSHEY_PLAIN, 2, @(255, 0, 255), 3) | Out-Null
        $cv.imshow("capture camera", $frame)

        $key = $cv.waitKey($CAP_SPF)
        if (($key -eq 27) -or ($key -eq [byte][char]'q') -or ($key -eq [byte][char]'Q')) {
            break
        }
    }

    # Mimic what is done in c#
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($frame) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($cap) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($cv) | Out-Null
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
