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

$BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "RelWithDebInfo" }

$OpenCVWorldDll = if ([string]::IsNullOrEmpty($OpenCVWorldDll)) { _OpenCV_FindDLL -Path "opencv_world4*" -Filter "opencv-4.*\opencv" -BuildType $BuildType } else { $OpenCVWorldDll }
$OpenCVComDll = if ([string]::IsNullOrEmpty($OpenCVComDll)) { _OpenCV_FindDLL -Path "autoit_opencv_com4*" -BuildType $BuildType } else { $OpenCVComDll }

function Example() {
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $VideoCapture = [OpenCvComInterop]::ObjCreate("cv.VideoCapture")
    $cap = $VideoCapture.create($Camera)
    if (!$cap.isOpened()) {
        Write-Error "!>Error: cannot open the camera $Camera."
        return
    }

    $frame = [OpenCvComInterop]::ObjCreate("cv.Mat")

    while ($true) {
        if ($cap.read($frame)) {
            # Flip the image horizontally to give the mirror impression
            $oldframe = $frame
            $frame = $cv.flip($frame, 1)
            $cv.imshow("capture camera", $frame)

            # Memory leak without this
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($oldframe) | Out-Null
        } else {
            Write-Error "!>Error: cannot read the camera $Camera."
        }

        $key = $cv.waitKey(30)
        if (($key -eq 27) -or ($key -eq [byte][char]'q') -or ($key -eq [byte][char]'Q')) {
            break
        }
    }

    # Mimic what is done in c#
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($frame) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($cap) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($VideoCapture) | Out-Null
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
