#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://docs.opencv.org/4.5.4/d8/d01/tutorial_discrete_fourier_transform.html
;~     https://github.com/opencv/opencv/blob/4.5.4/samples/cpp/tutorial_code/core/discrete_fourier_transform/discrete_fourier_transform.cpp

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

Local Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Local $FormGUI = GUICreate("Discrete Fourier Transform", 1065, 617, 192, 124)

Local $InputSource = GUICtrlCreateInput($OPENCV_SAMPLES_DATA_PATH & "\lena.jpg", 264, 24, 449, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
Local $BtnSource = GUICtrlCreateButton("Open", 723, 22, 75, 25)

Local $LabelSource = GUICtrlCreateLabel("Input Image", 231, 60, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupSource = GUICtrlCreateGroup("", 20, 83, 510, 516)
Local $PicSource = GUICtrlCreatePic("", 25, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $LabelResult = GUICtrlCreateLabel("spectrum magnitude", 735, 60, 148, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Local $GroupResult = GUICtrlCreateGroup("", 532, 83, 510, 516)
Local $PicResult = GUICtrlCreatePic("", 537, 94, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GDIPlus_Startup()

Local $sImage = ""
Local $nMsg

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sImage = ControlGetText($FormGUI, "", $InputSource)
			$sImage = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.jpg;*.jpeg;*.png;*.gif)", $FD_FILEMUSTEXIST, $sImage)
			If @error Then
				$sImage = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sImage)
				Main()
			EndIf
	EndSwitch
WEnd

_GDIPlus_Shutdown()
_OpenCV_Unregister_And_Close()

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
	$padded = $cv.copyMakeBorder($I, 0, $m - $I.rows, 0, $n - $I.cols, $CV_BORDER_CONSTANT, _OpenCV_ScalarAll(0))
	;;! [expand]

	;;! [complex_and_real]
	Local $planes[2]
	$planes[0] = $padded.convertTo($CV_32F, 1.0, 0.0)
	$planes[1] = ObjCreate("OpenCV.cv.Mat").zeros($padded.rows, $padded.cols, $CV_32F)
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
	$magI = ObjCreate("OpenCV.cv.Mat").create($magI, _OpenCV_Rect(0, 0, BitAND($magI.cols, -2), BitAND($magI.rows, -2)))

	; rearrange the quadrants of Fourier image  so that the origin is at the image center
	Local $cx = $magI.cols / 2 ;
	Local $cy = $magI.rows / 2 ;

	Local $q0 = ObjCreate("OpenCV.cv.Mat").create($magI, _OpenCV_Rect(0, 0, $cx, $cy)) ;     ; Top-Left - Create a ROI per quadrant
	Local $q1 = ObjCreate("OpenCV.cv.Mat").create($magI, _OpenCV_Rect($cx, 0, $cx, $cy)) ;   ; Top-Right
	Local $q2 = ObjCreate("OpenCV.cv.Mat").create($magI, _OpenCV_Rect(0, $cy, $cx, $cy)) ;   ; Bottom-Left
	Local $q3 = ObjCreate("OpenCV.cv.Mat").create($magI, _OpenCV_Rect($cx, $cy, $cx, $cy)) ; ; Bottom-Right

	Local $tmp = ObjCreate("OpenCV.cv.Mat") ; swap quadrants (Top-Left with Bottom-Right)
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
