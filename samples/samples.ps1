#requires -version 5.0

[CmdletBinding()]
param (
    [string] $BuildType = $Env:BUILD_TYPE
)
# "powershell.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"
# "pwsh.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0
trap { throw $Error[0] }

function _OpenCV_ObjCreate($sClassname) {
    $namespaces = "", "OpenCV.", "OpenCV.cv."
    foreach ($namespace in $namespaces)
    {
        try {
            New-Object -ComObject "$namespace$sClassname"
            return
        } catch {
            # Ignore error
        }
    }
}

function Example1() {
    $cv = _OpenCV_ObjCreate("cv")
    $img = $cv.imread($cv.samples.findFile("lena.jpg"))
    $cv.imshow("image", $img)
    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

function Example2() {
    $cv = _OpenCV_ObjCreate("cv")
    $threshold = 180
    $dCurrentArea = 1000

    $src = $cv.imread($cv.samples.findFile("pic1.png"))
    $src_gray = $cv.cvtColor($src, $cv.enums.COLOR_BGR2GRAY)
    $src_gray = $cv.GaussianBlur($src_gray, @(5, 5), 0)
    $cv.threshold($src_gray, $threshold, 255, $cv.enums.THRESH_BINARY, $src_gray) | Out-Null

    $good_contours = _OpenCV_ObjCreate("VectorOfMat")
    $contours = $cv.findContours($src_gray, $cv.enums.RETR_TREE, $cv.enums.CHAIN_APPROX_SIMPLE) # $cv.enums.RETR_LIST, $cv.enums.RETR_EXTERNAL, $cv.enums.RETR_TREE

    foreach ($contour in $contours) {
        $dArea = $cv.contourArea($contour)
        if ($dArea -ge $dCurrentArea) {
            $good_contours.push_back($contour)
        }
    }

    $src_displayed = $src.Clone()

    foreach ($contour in $good_contours) {
        $cv.drawContours($src_displayed, @($contour), -1, @(0, 255, 0), 3) | Out-Null

        # Draw circle in center of Concave
        $moments = $cv.moments($contour)
        $cx1 = $moments.m10 / $moments.m00
        $cy1 = $moments.m01 / $moments.m00

        $cv.circle($src_displayed, @($cx1, $cy1), 15, @(0, 255, 0), -1) | Out-Null
    }

    $cv.imshow("image", $src_displayed)
    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

function Example3() {
    $cv = _OpenCV_ObjCreate("cv")

    $cap = (_OpenCV_ObjCreate("VideoCapture")).create($cv.samples.findFile("vtest.avi"))
    if (-not $cap.isOpened()) {
        Write-Error '!>Error: cannot open the video file.'
        return
    }

    $frame = _OpenCV_ObjCreate("Mat")

    while ($true) {
        if (-not $cap.read($frame)) {
            Write-Error '!>Error: cannot read the video or end of the video.'
            break
        }

        $cv.imshow("capture video file", $frame)

        $key = $cv.waitKey(30)
        if ($key -eq [int][char]'Q' -or $key -eq [int][char]'q' -or $key -eq 27) {
            break
        }
    }

    $cv.destroyAllWindows()
}

function Example4() {
    $cv = _OpenCV_ObjCreate("cv")
    $img = $cv.imread($cv.samples.findFile("lena.jpg"))

    $blurred = $Null
    $cv.GaussianBlur($img, @(5, 5), 0, [ref] $blurred) | Out-Null
    $cv.imshow("image", $blurred)
    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

Add-Type -TypeDefinition @"
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Principal;

public static class AutoItOpenCV
{
    [DllImport("kernel32.dll")]
    private static extern IntPtr LoadLibrary(string dllToLoad);

    [DllImport("kernel32.dll")]
    private static extern bool FreeLibrary(IntPtr hModule);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    private static extern IntPtr GetProcAddress(IntPtr hModule, string name);

    private delegate bool DllActivateManifest_api([In, MarshalAs(UnmanagedType.LPWStr)] string manifest);
    private delegate bool DllDeactivateActCtx_api();

    private static IntPtr hOpenCvWorld = IntPtr.Zero;
    private static IntPtr hOpenCvFfmpeg = IntPtr.Zero;
    private static IntPtr hOpenCvCom = IntPtr.Zero;

    private static DllActivateManifest_api DllActivateManifest_t;
    private static DllDeactivateActCtx_api DllDeactivateActCtx_t;

    public static void DllOpen(string openCvWorldDll, string openCvComDll)
    {
        hOpenCvWorld = LoadLibrary(openCvWorldDll);
        if (hOpenCvWorld == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to load opencv library " + openCvWorldDll);
        }

        var parts = openCvWorldDll.Split(Path.AltDirectorySeparatorChar, Path.DirectorySeparatorChar);
        parts[parts.Length - 1] = "opencv_videoio_ffmpeg470_64.dll";
        var openCvFfmpegDll = string.Join(Path.DirectorySeparatorChar.ToString(), parts);
        hOpenCvFfmpeg = LoadLibrary(openCvFfmpegDll);
        if (hOpenCvFfmpeg == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to load ffmpeg library '" + openCvFfmpegDll + "'");
        }

        hOpenCvCom = LoadLibrary(openCvComDll);
        if (hOpenCvCom == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to open autoit com library " + openCvComDll);
        }

        IntPtr DllActivateManifest_addr = GetProcAddress(hOpenCvCom, "DllActivateManifest");
        if (DllActivateManifest_addr == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Unable to find DllActivateManifest method");
        }
        DllActivateManifest_t = (DllActivateManifest_api) Marshal.GetDelegateForFunctionPointer(DllActivateManifest_addr, typeof(DllActivateManifest_api));

        IntPtr DllDeactivateActCtx_addr = GetProcAddress(hOpenCvCom, "DllDeactivateActCtx");
        if (DllDeactivateActCtx_addr == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Unable to find DllDeactivateActCtx method");
        }
        DllDeactivateActCtx_t = (DllDeactivateActCtx_api) Marshal.GetDelegateForFunctionPointer(DllDeactivateActCtx_addr, typeof(DllDeactivateActCtx_api));
    }

    public static void DllClose()
    {
        FreeLibrary(hOpenCvCom);
        FreeLibrary(hOpenCvFfmpeg);
        FreeLibrary(hOpenCvWorld);
    }

    public static bool DllActivateManifest(string manifest = null)
    {
        if (string.IsNullOrWhiteSpace(manifest)) {
            manifest = Environment.GetEnvironmentVariable("OPENCV_ACTCTX_MANIFEST");
        }
        return DllActivateManifest_t(manifest);
    }

    public static bool DllDeactivateActCtx()
    {
        return DllDeactivateActCtx_t();
    }
}
"@

$BuildType = If ($BuildType -eq "Debug") { $BuildType } Else { "Release" }
$PostSuffix = If ($BuildType -eq "Debug") { "d" } Else { "" }

[AutoItOpenCV]::DllOpen(
    "$PSScriptRoot\..\opencv-4.7.0-windows\opencv\build\x64\vc16\bin\opencv_world470$($PostSuffix).dll",
    "$PSScriptRoot\..\autoit-opencv-com\build_x64\bin\$($BuildType)\autoit_opencv_com470$($PostSuffix).dll"
)
[AutoItOpenCV]::DllActivateManifest() | Out-Null

$cv = _OpenCV_ObjCreate("cv")
$cv.samples.addSamplesDataSearchPath($PSScriptRoot)
$cv.samples.addSamplesDataSearchPath("$PSScriptRoot\..\opencv-4.7.0-windows\opencv\sources\samples\data")

Example1
Example2
Example3
Example4

[AutoItOpenCV]::DllDeactivateActCtx() | Out-Null
[AutoItOpenCV]::DllClose()
