#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open(_OpenCV_FindDLL("opencv_world480*"), _OpenCV_FindDLL("autoit_opencv_com480*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return
	Local $bMethod = 1

	Local $img = _OpenCV_imread_and_check(_OpenCV_FindFile("samples\tutorial_code\yolo\scooter-5180947_1920.jpg"))

	Local $resized

	If $bMethod Then
		$resized = $img.GdiplusResize(600, 400)
	Else
		Local $hImage = $img.convertToBitmap()

		Local $hResizedImage = _GDIPlus_ImageResize($hImage, 600, 400)
		_GDIPlus_BitmapDispose($hImage)

		$resized = $cv.createMatFromBitmap($hResizedImage)
		_GDIPlus_BitmapDispose($hResizedImage)
	EndIf

	$cv.imshow("Resized with GDI+", $resized)
	$cv.waitKey()
	$cv.destroyAllWindows()
EndFunc   ;==>Example

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
