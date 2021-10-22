#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <GUIConstantsEx.au3>

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

If IsObj($cv) Then
	Local $iLeft = 200
	Local $iTop = 200
	Local $iWidth = 400
	Local $iHeight = 400

	Local $aRect[4] = [$iLeft, $iTop, $iWidth, $iHeight]
	Local $tBits = _OpenCV_GetDesktopScreenBits($aRect)
	Local $img = ObjCreate("OpenCV.cv.Mat").create($iHeight, $iWidth, $CV_8UC4, DllStructGetPtr($tBits))

	$cv.imshow("Screen capture", $img)
	$cv.waitKey()
	$cv.destroyAllWindows()
EndIf

_OpenCV_Unregister_And_Close()
