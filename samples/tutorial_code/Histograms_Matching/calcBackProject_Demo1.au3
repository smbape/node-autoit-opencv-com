#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("GUIOnEventMode", 1)

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.7.0/da/d7f/tutorial_back_projection.html
;~     https://github.com/opencv/opencv/blob/4.7.0/samples/cpp/tutorial_code/Histograms_Matching/calcBackProject_Demo1.cpp

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
Global $FormGUI = GUICreate("Back Projection", 1263, 601, 187, 122)

Global $InputSource = GUICtrlCreateInput(_PathFull($cv.samples.findFile("lena.jpg")), 364, 16, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Open", 823, 14, 75, 25)

Global $LabelBins = GUICtrlCreateLabel("* Hue  bins: 25", 364, 72, 110, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $SliderBins = GUICtrlCreateSlider(491, 72, 394, 45)
GUICtrlSetLimit(-1, 180, 2)
GUICtrlSetData(-1, 25)

Global $LabelSource = GUICtrlCreateLabel("Source image", 144, 128, 49, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 10, 150, 410, 416)
Global $PicSource = GUICtrlCreatePic("", 15, 161, 400, 400)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelBackProj = GUICtrlCreateLabel("BackProj", 468, 128, 67, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupBackProj = GUICtrlCreateGroup("", 426, 150, 410, 416)
Global $PicBackProj = GUICtrlCreatePic("", 431, 161, 400, 400)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelHistogram = GUICtrlCreateLabel("Histogram", 792, 128, 75, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupHistogram = GUICtrlCreateGroup("", 842, 150, 410, 416)
Global $PicHistogram = GUICtrlCreatePic("", 847, 161, 400, 400)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetOnEvent($GUI_EVENT_CLOSE, "_cleanExit")
GUICtrlSetOnEvent($BtnSource, "_handleBtnSourceClick")
GUICtrlSetOnEvent($SliderBins, "Hist_and_Backproj")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GUICtrlSlider_SetTicFreq($SliderBins, 1)

Global $sInputSource = ""
Global $src, $hsv, $hue

Main()

Global $current_bins = GUICtrlRead($SliderBins)
Global $last_bins = $current_bins

While 1
	$current_bins = GUICtrlRead($SliderBins)
	If $last_bins <> $current_bins Then
		Hist_and_Backproj()
		$last_bins = $current_bins
	EndIf
	Sleep(50) ; Sleep to reduce CPU usage
WEnd

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
	$hue = $cv.Mat.create($hsv.rows, $hsv.cols, $hsv.depth())
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
	$sInputSource = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sInputSource)
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
	Local $hist = $cv.calcHist($ahue, $channels, Null, $histSize, $ranges)
	$cv.normalize($hist, $hist, 0, 255, $CV_NORM_MINMAX, -1, Null)
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
	Local $histImg = $cv.Mat.zeros($h, $w, $CV_8UC3)

	For $i = 0 To $bins - 1
		$cv.rectangle($histImg, _OpenCV_Point($i * $bin_w, $h), _OpenCV_Point(($i + 1) * $bin_w, $h - Round($hist.float_at($i) * $h / 255.0)), _
				_OpenCV_Scalar(0, 0, 255), $CV_FILLED)
	Next

	; _cveImshowMat( "Histogram", $histImg )
	_OpenCV_imshow_ControlPic($histImg, $FormGUI, $PicHistogram)
	;;! [Draw the histogram]
EndFunc   ;==>Hist_and_Backproj

Func _cleanExit()
	If @GUI_WinHandle <> $FormGUI Then Return
	Exit
EndFunc   ;==>_cleanExit

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
