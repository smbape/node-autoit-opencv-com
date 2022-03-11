#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	Local $img = _OpenCV_imread_and_check("samples\data\pic1.png")
	Local $img_grey = $cv.cvtColor($img, $CV_COLOR_BGR2GRAY)
	$cv.threshold($img_grey, 100, 255, $CV_THRESH_BINARY)
	Local $thresh = $cv.extended[1]
	Local $contours = $cv.findContours($thresh, $CV_RETR_TREE, $CV_CHAIN_APPROX_SIMPLE)

	ConsoleWrite("Found " & UBound($contours) & " contours" & @CRLF & @CRLF)

	$cv.drawContours($img, $contours, -1, _OpenCV_Scalar(0, 0, 255), 2)

	$cv.imshow("Image", $img)
	$cv.waitKey()
	$cv.destroyAllWindows()
EndFunc   ;==>Example

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
