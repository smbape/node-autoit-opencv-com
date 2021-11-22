#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
Example()
_OpenCV_Unregister_And_Close()

Func Example()
	Local $cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	Local $iLeft = 200
	Local $iTop = 200
	Local $iWidth = 400
	Local $iHeight = 400

	Local $aRect[4] = [$iLeft, $iTop, $iWidth, $iHeight]
	Local $img = _OpenCV_GetDesktopScreenMat($aRect)

	$cv.imshow("Screen capture", $img)
	$cv.waitKey()
	$cv.destroyAllWindows()
EndFunc   ;==>Example
