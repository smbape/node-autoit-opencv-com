$ErrorActionPreference = "Stop"

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
    $img = $cv.imread("samples\data\lena.jpg")
    $cv.imshow("image", $img)
    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

function Example2() {
    $cv = _OpenCV_ObjCreate("cv")
    $threshold = 180
    $dCurrentArea = 1000

    $src = $cv.imread("samples\data\pic1.png")
    $src_gray = $cv.cvtColor($src, $cv.COLOR_BGR2GRAY_)
    $src_gray = $cv.GaussianBlur($src_gray, @(5, 5), 0)
    $cv.threshold($src_gray, $threshold, 255, $cv.THRESH_BINARY_, $src_gray) | Out-Null

    $good_contours = _OpenCV_ObjCreate("VectorOfMat")
    $contours = $cv.findContours($src_gray, $cv.RETR_TREE_, $cv.CHAIN_APPROX_SIMPLE_) # $cv.RETR_LIST_, $cv.RETR_EXTERNAL_, $cv.RETR_TREE_

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

    $cap = (_OpenCV_ObjCreate("VideoCapture")).create("samples\data\vtest.avi")
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
    $img = $cv.imread("samples\data\lena.jpg")

    $blurred = $Null
    $cv.GaussianBlur($img, @(5, 5), 0, [ref] $blurred) | Out-Null
    $cv.imshow("image", $blurred)
    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

Add-Type -TypeDefinition @"
using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.InteropServices;

public static class AutoItOpenCV
{
    [DllImport("kernel32.dll")]
    private static extern IntPtr LoadLibrary(string dllToLoad);

    [DllImport("kernel32.dll")]
    private static extern bool FreeLibrary(IntPtr hModule);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    private static extern IntPtr GetProcAddress(IntPtr hModule, string name);

    private delegate long DllInstall_api(bool bInstall, [In, MarshalAs(UnmanagedType.LPWStr)] string cmdLine);

    private static IntPtr _h_opencv_world_dll = IntPtr.Zero;
    private static IntPtr _h_autoit_opencv_com_dll = IntPtr.Zero;
    private static DllInstall_api DllInstall;

    public static void DllOpen(string opencv_world_dll, string autoit_opencv_com_dll)
    {
        _h_opencv_world_dll = LoadLibrary(opencv_world_dll);
        if (_h_opencv_world_dll == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to load opencv library " + opencv_world_dll);
        }

        _h_autoit_opencv_com_dll = LoadLibrary(autoit_opencv_com_dll);
        if (_h_autoit_opencv_com_dll == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to open autoit com library " + autoit_opencv_com_dll);
        }

        IntPtr DllInstall_addr = GetProcAddress(_h_autoit_opencv_com_dll, "DllInstall");
        if (DllInstall_addr == IntPtr.Zero)
        {
            throw new Win32Exception();
        }

        DllInstall = (DllInstall_api)Marshal.GetDelegateForFunctionPointer(DllInstall_addr, typeof(DllInstall_api));
    }

    public static void DllClose()
    {
        FreeLibrary(_h_autoit_opencv_com_dll);
        FreeLibrary(_h_opencv_world_dll);
    }

    public static void Register(string cmdLine = "user")
    {
        var hr = DllInstall(true, cmdLine);
        if (hr < 0)
        {
            throw new Win32Exception("!>Error: DllInstall " + hr);
        }
    }

    public static void Unregister(string cmdLine = "user")
    {
        var hr = DllInstall(false, cmdLine);
        if (hr < 0)
        {
            throw new Win32Exception("!>Error: DllInstall " + hr);
        }
    }
}
"@

$BUILD_TYPE = If ($env:BUILD_TYPE -eq "Debug") { $env:BUILD_TYPE } Else { "Release" }
$DLL_SUFFFIX = If ($BUILD_TYPE -eq "Debug") { "d" } Else { "" }

[AutoItOpenCV]::DllOpen(
    "$PSScriptRoot\..\opencv-4.6.0-vc14_vc15\opencv\build\x64\vc15\bin\opencv_world460$($DLL_SUFFFIX).dll",
    "$PSScriptRoot\..\autoit-opencv-com\build_x64\$($BUILD_TYPE)\autoit_opencv_com460$($DLL_SUFFFIX).dll"
)

[AutoItOpenCV]::Register()

Example1
Example2
Example3
Example4

[AutoItOpenCV]::Unregister()
[AutoItOpenCV]::DllClose()
