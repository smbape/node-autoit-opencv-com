#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.7.0/d4/d1b/tutorial_histogram_equalization.html
;~     https://github.com/opencv/opencv/blob/4.7.0/samples/cpp/tutorial_code/Histograms_Matching/EqualizeHist_Demo.cpp

_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")
$cv.samples.addSamplesDataSearchPath($OPENCV_SAMPLES_DATA_PATH)
$cv.samples.addSamplesDataSearchPath(_OpenCV_FindFile("samples\data", Default, Default, Default, _OpenCV_Tuple( _
        "opencv\sources", _
        "opencv-4.7.0-*\sources", _
        "opencv-4.7.0-*\opencv\sources" _
        )))

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Histogram Equalization", 1065, 617, 192, 124)

Global $InputSource = GUICtrlCreateInput(_PathFull($cv.samples.findFile("lena.jpg")), 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Global $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Equalized Image", 735, 60, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 83, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $sImage = ""
Global $nMsg

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sImage = ControlGetText($FormGUI, "", $InputSource)
			$sImage = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sImage)
			If @error Then
				$sImage = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sImage)
				Main()
			EndIf
	EndSwitch
WEnd

Func Main()
	$sImage = ControlGetText($FormGUI, "", $InputSource)
	If $sImage == "" Then Return

	;;! [Load image]
	Local $src = _OpenCV_imread_and_check($sImage, $CV_IMREAD_COLOR)
	If @error Then Return
	;;! [Load image]

	;;! [Convert to grayscale]
	$src = $cv.cvtColor($src, $CV_COLOR_BGR2GRAY)
	;;! [Convert to grayscale]

	;;! [Apply Histogram Equalization]
	Local $dst = $cv.equalizeHist($src)
	;;! [Apply Histogram Equalization]

	;;! [Display]
	_OpenCV_imshow_ControlPic($src, $FormGUI, $PicSource)
	_OpenCV_imshow_ControlPic($dst, $FormGUI, $PicResult)
	;;! [Display]
EndFunc   ;==>Main

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
