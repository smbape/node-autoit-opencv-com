#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Misc.au3>
#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

Global $tmpl, $tSize, $tSource, $tBlend, $hWnd, $hPen, $hGui, $hDC, $hBitmap, $hGraphic, $hBMPBuff, $hGraphicGUI, $user32_dll
Global $aRect, $iLeft, $iTop, $iWidth, $iHeight
Global $cv

_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")
Example()

Func Example()
	$cv = _OpenCV_get()
	If Not IsObj($cv) Then Return

	_Initialize()

	Search()

	; Local $aStartPos, $aEndPos

	Do
		Select
			Case _IsPressed("01", $user32_dll) ; Ctrl mouse button to move
				ClearRect()
				; $aStartPos = MouseGetPos()
				Do
					Sleep(10)
				Until Not _IsPressed("01", $user32_dll)
				; $aEndPos = MouseGetPos()

				;_GDIPlus_GraphicsDrawLine($hGraphic, $aEndPos[0], $aEndPos[1], $aStartPos[0], $aStartPos[1], $hPen)
				Search()
			Case _IsPressed("04", $user32_dll) Or _IsPressed("11", $user32_dll) ; Middle mouse button 0r Ctrl key <=======  Clear screen of rectangles.
				ClearRect()
		EndSelect
		Sleep(50)
	Until _IsPressed("1B", $user32_dll) ; ESC key

	_Release()
EndFunc   ;==>Example

Func Search()
	Local $hTopTimer, $hTimer, $img

	$hTopTimer = TimerInit()

	ConsoleWrite("Rect: [" & $iWidth & " x " & $iHeight & " from (" & $iLeft & ", " & $iTop & ")]" & @CRLF)

	; The higher the value, the higher the match is exact
	Local $threshold = 0.8

	$hTimer = TimerInit()
	$img = _OpenCV_GetDesktopScreenMat($aRect)
	ConsoleWrite("Capturing screen took " & TimerDiff($hTimer) & "ms" & @CRLF)

	; Ignore the alpha channel when matching the template => $CV_COLOR_BGRA2BGR
	; Only consider gray scale colors when matching the template => $CV_COLOR_BGRA2GRAY
	; using cveCanny and/or gray scale can significantly reduce the matching time but also reduce the matching accuracy
	$hTimer = TimerInit()
	Local $aMatches = _OpenCV_FindTemplate($img, $tmpl, $threshold, Default, Default, Default, $CV_COLOR_BGRA2GRAY)
	ConsoleWrite("Finding matches took " & TimerDiff($hTimer) & "ms" & @CRLF)

	Local $iMatches = UBound($aMatches)
	ConsoleWrite("Number of matches: " & $iMatches & @CRLF)

	; Local $aRedColor = _OpenCV_RGB(255, 0, 0)
	Local $aMatchRect = _OpenCV_Rect(0, 0, $tmpl.width, $tmpl.height)

	; WinMove($hGui, "", $iLeft, $iTop, $iWidth, $iHeight)

	GUISetState(@SW_LOCK, $hGui)
	For $i = 0 To $iMatches - 1
		$aMatchRect[0] = $aMatches[$i][0]
		$aMatchRect[1] = $aMatches[$i][1]

		; Draw a red rectangle around the matched position
		; $cv.rectangle($img, $aMatchRect, $aRedColor, 1)
		_GDIPlus_GraphicsDrawRect($hGraphic, $aMatchRect[0], $aMatchRect[1], $aMatchRect[2], $aMatchRect[3], $hPen)
	Next

	$tSize.X = $iWidth
	$tSize.Y = $iHeight
	_WinAPI_UpdateLayeredWindow($hGui, $hWnd, 0, $tSize, $hDC, $tSource, 0, $tBlend, $ULW_ALPHA)
	GUISetState(@SW_UNLOCK, $hGui)

	ConsoleWrite("Search took " & TimerDiff($hTopTimer) & "ms" & @CRLF)
	ConsoleWrite(@CRLF)
EndFunc   ;==>Search

Func ClearRect()
	_GDIPlus_GraphicsClear($hGraphic)
	_WinAPI_UpdateLayeredWindow($hGui, $hWnd, 0, $tSize, $hDC, $tSource, 0, $tBlend, $ULW_ALPHA)
EndFunc   ;==>ClearRect

Func _Initialize()
	$cv.imshow("Image", $cv.imread(_OpenCV_FindFile("samples\data\mario.png")))
	$tmpl = $cv.imread(_OpenCV_FindFile("samples\data\mario_coin.png"))

	; Search on the first screen. Leave empty to search on all screens
	; Reducing the search area improves the search time
	$aRect = _OpenCV_GetDesktopScreenRect(1)
	$iLeft = $aRect[0]
	$iTop = $aRect[1]
	$iWidth = $aRect[2]
	$iHeight = $aRect[3]

	#Region GUI
	$hGui = GUICreate("L1", $iWidth, $iHeight, $iLeft, $iTop, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST))
	GUISetState(@SW_SHOW, $hGui)

	$tSize = DllStructCreate($tagSIZE)
	$tSource = DllStructCreate($tagPOINT)

	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$tBlend.Alpha = 255
	$tBlend.Format = 1

	$hWnd = _WinAPI_GetWindowDC(_WinAPI_GetDesktopWindow()) ; DC of entire screen (desktop)
	$hPen = _GDIPlus_PenCreate(0xFFFF0000, 1)
	#EndRegion GUI

	$hDC = _WinAPI_CreateCompatibleDC($hWnd)
	$hBitmap = _WinAPI_CreateCompatibleBitmap($hWnd, $iWidth, $iHeight)
	_WinAPI_SelectObject($hDC, $hBitmap)
	$hGraphic = _GDIPlus_GraphicsCreateFromHDC($hDC)
	$hBMPBuff = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphic)
	$hGraphicGUI = _GDIPlus_ImageGetGraphicsContext($hBMPBuff)

	_GDIPlus_GraphicsClear($hGraphic) ; Add ,0x01000000) to disable underling desktop

	$user32_dll = DllOpen("user32.dll")
EndFunc   ;==>_Initialize

Func _Release()
	_GDIPlus_GraphicsDispose($hGraphicGUI)
	_GDIPlus_BitmapDispose($hBMPBuff)
	_GDIPlus_GraphicsDispose($hGraphic)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hDC)
	_GDIPlus_PenDispose($hPen)
	GUIDelete($hGui)
	$cv.destroyAllWindows()
	DllClose($user32_dll)
EndFunc   ;==>_Release

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
