#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("MustDeclareVars", 1)

#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))

Local $cv = _OpenCV_get()

If IsObj($cv) Then
	Local $img = _OpenCV_imread_and_check(_OpenCV_FindFile("samples\data\mario.png"))
	Local $tmpl = _OpenCV_imread_and_check(_OpenCV_FindFile("samples\data\mario_coin.png"))

	; The higher the value, the higher the match is exact
	Local $threshold = 0.8

	Local $aMatches = _OpenCV_FindTemplate($img, $tmpl, $threshold)

	Local $aRedColor = _OpenCV_RGB(255, 0, 0)
	Local $aMatchRect[4] = [0, 0, $tmpl.width, $tmpl.height]

	For $i = 0 To UBound($aMatches) - 1
		$aMatchRect[0] = $aMatches[$i][0]
		$aMatchRect[1] = $aMatches[$i][1]

		; Draw a red rectangle around the matched position
		$cv.rectangle($img, $aMatchRect, $aRedColor)
	Next

	$cv.imshow("Find template example", $img)
	$cv.waitKey()

	$cv.destroyAllWindows()
EndIf

_OpenCV_Unregister_And_Close()
