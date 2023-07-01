#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open(_OpenCV_FindDLL("opencv_world480*"), _OpenCV_FindDLL("autoit_opencv_com480*"))
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	Local $img = _OpenCV_imread_and_check($cv.samples.findFile("lena.jpg"))
	Local $angle = 20
	Local $scale = 0.8

	Local $rotated = _OpenCV_RotateBound($img, $angle, $scale)
	$cv.imshow("Bound Rotation", $rotated)
	$cv.waitKey()
	$cv.destroyAllWindows()
EndFunc   ;==>Example

Func _OnAutoItExit()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
