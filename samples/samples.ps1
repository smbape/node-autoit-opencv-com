function _OpenCV_ObjCreate($sClassname) {
    New-Object -ComObject "OpenCV.$sClassname"
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
    $tmp = $cv.GaussianBlur($src_gray, @(5, 5), 0, 0)
    $src_gray = $tmp
    $cv.threshold($src_gray, $threshold, 255, $cv.THRESH_BINARY_, $src_gray) | Out-Null
    
    $good_contours = _OpenCV_ObjCreate("VectorOfMat")
    $contours = $cv.findContours($src_gray, $cv.RETR_TREE_, $cv.CHAIN_APPROX_SIMPLE_) # $cv.RETR_LIST_, $cv.RETR_EXTERNAL_, $cv.RETR_TREE_

    for ($i = 0; $i -lt $contours.count; $i++) {
        $dArea = $cv.contourArea($contours[$i])
        if ($dArea -ge $dCurrentArea) {
            $good_contours.push_back($contours[$i])
        }
    }

    $src_displayed = $src.Clone()

    $size = $good_contours.size()
    for ($i = 0; $i -lt $size; $i++) {
        $cv.drawContours($src_displayed, $good_contours, $i, @(0, 255, 0), 3) | Out-Null

        # Draw circle in center of Concave
        $moments = $cv.moments($good_contours.at($i))
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

    $cap = (_OpenCV_ObjCreate("cv.VideoCapture")).create("samples\data\vtest.avi")
    if (-not $cap.isOpened()) {
        Write-Error '!>Error: cannot open the video file.'
        return
    }

    $frame = _OpenCV_ObjCreate("cv.Mat")

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

$ErrorActionPreference = "Stop"

Example1
Example2
Example3
