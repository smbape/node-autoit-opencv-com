#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.4/da/d7f/tutorial_back_projection.html
;~     https://github.com/opencv/opencv/blob/4.5.4/samples/cpp/tutorial_code/Histograms_Matching/calcBackProject_Demo1.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

Local Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Local $FormGUI = GUICreate("Back Projection", 1263, 601, 187, 122)

Local $InputSource = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\lena.jpg", 364, 16, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $BtnSource = GUICtrlCreateButton("Open", 823, 14, 75, 25)

Local $LabelBins = GUICtrlCreateLabel("* Hue  bins: 25", 364, 72, 110, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $SliderBins = GUICtrlCreateSlider(491, 72, 394, 45)
GUICtrlSetLimit(-1, 180, 2)
GUICtrlSetData(-1, 25)

Local $LabelSource = GUICtrlCreateLabel("Source image", 144, 128, 49, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSource = GUICtrlCreateGroup("", 10, 150, 410, 416)
Local $PicSource = GUICtrlCreatePic("", 15, 161, 400, 400)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelBackProj = GUICtrlCreateLabel("BackProj", 468, 128, 67, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupBackProj = GUICtrlCreateGroup("", 426, 150, 410, 416)
Local $PicBackProj = GUICtrlCreatePic("", 431, 161, 400, 400)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelHistogram = GUICtrlCreateLabel("Histogram", 792, 128, 75, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupHistogram = GUICtrlCreateGroup("", 842, 150, 410, 416)
Local $PicHistogram = GUICtrlCreatePic("", 847, 161, 400, 400)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetOnEvent($GUI_EVENT_CLOSE, "_cleanExit")
GUICtrlSetOnEvent($BtnSource, "_handleBtnSourceClick")
GUICtrlSetOnEvent($SliderBins, "Hist_and_Backproj")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GUICtrlSlider_SetTicFreq($SliderBins, 1)

_GDIPlus_Startup()

Local $sInputSource = ""
Local $src, $hsv, $hue

Main()

Local $current_bins = GUICtrlRead($SliderBins)
Local $last_bins = $current_bins

While 1
	$current_bins = GUICtrlRead($SliderBins)
	If $last_bins <> $current_bins Then
		Hist_and_Backproj()
		$last_bins = $current_bins
	EndIf
	Sleep(50) ; Sleep to reduce CPU usage
WEnd

_GDIPlus_Shutdown()

Func Main()
	$sInputSource = ControlGetText($FormGUI, "", $InputSource)
	If $sInputSource == "" Then Return

	;;! [Read the image]
	$src = _OpenCV_imread_and_check($sInputSource, $CV_IMREAD_COLOR)
	If @error Then
		$sInputSource = ""
		Return
	EndIf
	;;! [Read the image]

	;;! [Transform it to HSV]
	$hsv = $cv.cvtColor($src, $CV_COLOR_BGR2HSV)
	;;! [Transform it to HSV]

	;;! [Use only the Hue value]
	$hue = ObjCreate("OpenCV.cv.Mat").create($hsv.rows, $hsv.cols, $hsv.depth())
	Local $ahsv[1] = [$hsv]
	Local $ahue[1] = [$hue]
	Local $ch[2] = [0, 0]
	$cv.mixChannels($ahsv, $ahue, $ch)
	;;! [Use only the Hue value]

	;;! [Create Trackbar to enter the number of bins]
	Hist_and_Backproj()
	;;! [Create Trackbar to enter the number of bins]

	;;! [Show the image]
	_OpenCV_imshow_ControlPic($src, $FormGUI, $PicSource)
	;;! [Show the image]

EndFunc   ;==>Main

Func _handleBtnSourceClick()
	$sInputSource = ControlGetText($FormGUI, "", $InputSource)
	$sInputSource = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sInputSource)
	If @error Then
		$sInputSource = ""
		Return
	EndIf

	ControlSetText($FormGUI, "", $InputSource, $sInputSource)
	Main()
EndFunc   ;==>_handleBtnSourceClick

Func Hist_and_Backproj()
	If $sInputSource == "" Then Return

	Local $bins = GUICtrlRead($SliderBins)
	GUICtrlSetData($LabelBins, "* Hue  bins: " & $bins)

	Local $ahue[1] = [$hue]
	Local $channels[0]

	;;! [initialize]
	Local $histSize[1] = [_Max($bins, 2)]
	Local $hue_range[2] = [0, 180]
	Local $ranges[2] = [$hue_range[0], $hue_range[1]]
	;;! [initialize]

	;;! [Get the Histogram and normalize it]
	Local $hist = $cv.calcHist($ahue, $channels, ObjCreate("OpenCV.cv.Mat"), $histSize, $ranges, False)
	$cv.normalize($hist, $hist, 0, 255, $CV_NORM_MINMAX, -1, ObjCreate("OpenCV.cv.Mat"))
	;;! [Get the Histogram and normalize it]

	;;! [Get Backprojection]
	Local $backproj = $cv.calcBackProject($ahue, $channels, $hist, $ranges, 1)
	;;! [Get Backprojection]

	;;! [Draw the backproj]
	_OpenCV_imshow_ControlPic($backproj, $FormGUI, $PicBackProj)
	;;! [Draw the backproj]

	;;! [Draw the histogram]
	Local $w = 400, $h = 400
	Local $bin_w = Round($w / $histSize[0])
	Local $histImg = ObjCreate("OpenCV.cv.Mat").zeros($h, $w, $CV_8UC3)

	For $i = 0 To $bins - 1
		$cv.rectangle($histImg, _OpenCV_Point($i * $bin_w, $h), _OpenCV_Point(($i + 1) * $bin_w, $h - Round($hist.float_at($i) * $h / 255.0)), _
				_OpenCV_Scalar(0, 0, 255), $CV_FILLED)
	Next

	; _cveImshowMat( "Histogram", $histImg )
	_OpenCV_imshow_ControlPic($histImg, $FormGUI, $PicHistogram)
	;;! [Draw the histogram]
EndFunc   ;==>Hist_and_Backproj

Func _cleanExit()
	If @GUI_WinHandle <> $FormGUI Then
		Return
	EndIf

	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()

	Exit
EndFunc   ;==>_cleanExit
