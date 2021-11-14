#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <GUIConstantsEx.au3>

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Global $cv = _OpenCV_get()

If IsObj($cv) Then
	Global $iLeft = 200
	Global $iTop = 200
	Global $iWidth = 400
	Global $iHeight = 400

	Global $aRect[4] = [$iLeft, $iTop, $iWidth, $iHeight]
	Global $tBits = _OpenCV_GetDesktopScreenBits($aRect)
	Global $img = ObjCreate("OpenCV.cv.Mat").create($iHeight, $iWidth, $CV_8UC4, DllStructGetPtr($tBits))

	$cv.imshow("Screen capture", $img)
	$cv.waitKey()
	$cv.destroyAllWindows()
EndIf

_OpenCV_Unregister_And_Close()
