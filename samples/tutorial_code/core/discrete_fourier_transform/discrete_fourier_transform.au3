#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.12.0/d8/d01/tutorial_discrete_fourier_transform.html
;~     https://github.com/opencv/opencv/blob/4.12.0/samples/cpp/tutorial_code/core/discrete_fourier_transform/discrete_fourier_transform.cpp

_OpenCV_Open(_OpenCV_FindDLL("opencv_world4120*"), _OpenCV_FindDLL("autoit_opencv_com4120*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Discrete Fourier Transform", 1065, 617, 192, 124)

Global $InputSource = GUICtrlCreateInput($cv.samples.findFile("lena.jpg"), 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Global $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Global $LabelSource = GUICtrlCreateLabel("Input Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Global $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Spectrum magnitude", 735, 60, 148, 20)
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
	Local $I = _OpenCV_imread_and_check($sImage, $CV_IMREAD_GRAYSCALE)
	If @error Then
		$sImage = ""
		Return
	EndIf
	;;! [Load image]

	;;! [expand]
	Local $padded                            ;;expand input image to optimal size
	Local $m = $cv.getOptimalDFTSize($I.rows)
	Local $n = $cv.getOptimalDFTSize($I.cols)   ; on the border add zero values
	$padded = $cv.copyMakeBorder($I, 0, $m - $I.rows, 0, $n - $I.cols, $CV_BORDER_CONSTANT, Default, _OpenCV_ScalarAll(0))
	;;! [expand]

	;;! [complex_and_real]
	Local $planes[2]
	$planes[0] = $padded.convertTo($CV_32F, Default, 1.0, 0.0)
	$planes[1] = $cv.Mat.zeros($padded.rows, $padded.cols, $CV_32F)
	Local $complexI = $cv.merge($planes) ;         ; Add to the expanded another plane with zeros
	;;! [complex_and_real]

	;;! [dft]
	$complexI = $cv.dft($complexI) ;            ; this way the result may fit in the source matrix
	;;! [dft]

	; compute the magnitude and switch to logarithmic scale
	; => log(1 + sqrt(Re(DFT(I))^2 + Im(DFT(I))^2))
	;;! [magnitude]
	$cv.split($complexI, $planes)                   ; planes[0] = Re(DFT(I), planes[1] = Im(DFT(I))
	$cv.magnitude($planes[0], $planes[1], $planes[0])
	Local $magI = $planes[0]
	;;! [magnitude]

	;;! [log]
	$magI = $cv.add($magI, _OpenCV_ScalarAll(1)) ; switch to logarithmic scale
	$cv.log($magI, $magI)
	;;! [log]

	;;! [crop_rearrange]
	; crop the spectrum, if it has an odd number of rows or columns
	$magI = $cv.Mat.create($magI, _OpenCV_Rect(0, 0, BitAND($magI.cols, -2), BitAND($magI.rows, -2)))

	; rearrange the quadrants of Fourier image  so that the origin is at the image center
	Local $cx = $magI.cols / 2 ;
	Local $cy = $magI.rows / 2 ;

	Local $q0 = $cv.Mat.create($magI, _OpenCV_Rect(0, 0, $cx, $cy)) ;     ; Top-Left - Create a ROI per quadrant
	Local $q1 = $cv.Mat.create($magI, _OpenCV_Rect($cx, 0, $cx, $cy)) ;   ; Top-Right
	Local $q2 = $cv.Mat.create($magI, _OpenCV_Rect(0, $cy, $cx, $cy)) ;   ; Bottom-Left
	Local $q3 = $cv.Mat.create($magI, _OpenCV_Rect($cx, $cy, $cx, $cy)) ; ; Bottom-Right

	Local $tmp = _OpenCV_ObjCreate("cv.Mat") ; swap quadrants (Top-Left with Bottom-Right)
	$q0.copyTo($tmp)
	$q3.copyTo($q0)
	$tmp.copyTo($q3)

	$q1.copyTo($tmp)                        ; swap quadrant (Top-Right with Bottom-Left)
	$q2.copyTo($q1)
	$tmp.copyTo($q2)
	;;! [crop_rearrange]

	;;! [normalize]
	$cv.normalize($magI, $magI, 0, 1, $CV_NORM_MINMAX) ; Transform the matrix with float values into a
	; viewable image form (float between values 0 and 1).
	;;! [normalize]

	;;! [Display]
	_OpenCV_imshow_ControlPic($I, $FormGUI, $PicSource)
	_OpenCV_imshow_ControlPic($magI, $FormGUI, $PicResult)
	;;! [Display]
EndFunc   ;==>Main

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
