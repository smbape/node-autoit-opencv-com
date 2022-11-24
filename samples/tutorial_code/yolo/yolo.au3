#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <InetConstants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include <WinAPIDiag.au3>
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\autoit-addon\addon.au3"

;~ Sources:
;~     https://www.autoitscript.com/forum/topic/202987-real-time-object-detection-using-yolov3-wrapper/
;~     https://learnopencv.com/deep-learning-based-object-detection-using-yolov3-with-opencv-python-c/

_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()
Global $addon_dll = _Addon_FindDLL()
Global $dnn = _OpenCV_ObjCreate("cv.dnn")

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("OpenCV object detection", 1273, 796, 191, 18)

Global $InputSource = GUICtrlCreateInput(@ScriptDir & "\scooter-5180947_1920.jpg", 264, 8, 449, 21)
Global $BtnSource = GUICtrlCreateButton("Browse", 723, 6, 75, 25)

Global $InputModelNames = GUICtrlCreateInput(@ScriptDir & "\yolov3.txt", 264, 44, 449, 21)
Global $BtnModelNames = GUICtrlCreateButton("Browse", 723, 42, 75, 25)

Global $InputModelConfiguration = GUICtrlCreateInput(@ScriptDir & "\yolov3.cfg", 264, 80, 449, 21)
Global $BtnModelConfiguration = GUICtrlCreateButton("Browse", 723, 78, 75, 25)

Global $InputModelWeights = GUICtrlCreateInput(@ScriptDir & "\yolov3.weights", 264, 116, 449, 21)
Global $BtnModelWeights = GUICtrlCreateButton("Browse", 723, 114, 75, 25)

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 832, 48, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

Global $BtnExec = GUICtrlCreateButton("Dectect Objects", 832, 8, 91, 25)

Global $LabelSource = GUICtrlCreateLabel("Source Image", 271, 148, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSource = GUICtrlCreateGroup("", 20, 171, 610, 616)
Global $PicSource = GUICtrlCreatePic("", 25, 182, 600, 600)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Object detection", 863, 148, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 644, 171, 610, 616)
Global $PicResult = GUICtrlCreatePic("", 649, 182, 600, 600)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;; Initialize the parameters
Global $confThreshold = 0.5  ; Confidence threshold
Global $nmsThreshold = 0.4   ; Non-maximum suppression threshold
Global $inpWidth = 416       ; Width of network's input image
Global $inpHeight = 416      ; Height of network's input image

Global $sSource, $sModelNames, $sModelConfiguration, $sModelWeights
Global $nMsg

_DownloadWeights(ControlGetText($FormGUI, "", $InputModelWeights))
Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSource
			$sSource = ControlGetText($FormGUI, "", $InputSource)
			$sSource = FileOpenDialog("Select an image", $OPENCV_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sSource)
			If @error Then
				$sSource = ""
			Else
				ControlSetText($FormGUI, "", $InputSource, $sSource)
			EndIf
		Case $BtnModelNames
			$sModelNames = ControlGetText($FormGUI, "", $InputModelNames)
			$sModelNames = FileOpenDialog("Select a model names", $OPENCV_SAMPLES_DATA_PATH, "Model names (*.names;*.txt)", $FD_FILEMUSTEXIST, $sModelNames)
			If @error Then
				$sModelNames = ""
			Else
				ControlSetText($FormGUI, "", $InputModelNames, $sModelNames)
			EndIf
		Case $BtnModelConfiguration
			$sModelConfiguration = ControlGetText($FormGUI, "", $InputModelConfiguration)
			$sModelConfiguration = FileOpenDialog("Select a model configuration", $OPENCV_SAMPLES_DATA_PATH, "Model configuration (*.cfg)", $FD_FILEMUSTEXIST, $sModelConfiguration)
			If @error Then
				$sModelConfiguration = ""
			Else
				ControlSetText($FormGUI, "", $InputModelConfiguration, $sModelConfiguration)
			EndIf
		Case $BtnModelWeights
			$sModelWeights = ControlGetText($FormGUI, "", $InputModelWeights)
			$sModelWeights = FileOpenDialog("Select a model weights", $OPENCV_SAMPLES_DATA_PATH, "Model weights (*.onnx;*.weights)", $FD_FILEMUSTEXIST, $sModelWeights)
			If @error Then
				$sModelWeights = ""
			Else
				ControlSetText($FormGUI, "", $InputModelWeights, $sModelWeights)
			EndIf
		Case $BtnExec
			Main()
	EndSwitch
WEnd

Func Main()
	$sSource = ControlGetText($FormGUI, "", $InputSource)
	If $sSource == "" Then Return

	$sModelNames = ControlGetText($FormGUI, "", $InputModelNames)
	If $sModelNames == "" Then Return

	$sModelConfiguration = ControlGetText($FormGUI, "", $InputModelConfiguration)

	$sModelWeights = ControlGetText($FormGUI, "", $InputModelWeights)

	$_cv_gdi_resize = _IsChecked($CheckboxUseGDI)

	;;! [Load image]
	Local $image = _OpenCV_imread_and_check($sSource)
	If @error Then Return
	_OpenCV_imshow_ControlPic($image, $FormGUI, $PicSource)
	;;! [Load image]

	Local $hTimer

	Local $classes = FileReadToArray($sModelNames)
	If @error Then
		ConsoleWriteError("!>Error: Unable to read model names " & $sModelNames & @CRLF)
	EndIf

	; Local $net = $dnn.readNetFromDarknet($sModelConfiguration, $sModelWeights)

	$hTimer = TimerInit()
	Local $net
	If $sModelConfiguration == "" Then
		$net = $dnn.readNet($sModelWeights)
	Else
		$net = $dnn.readNet($sModelWeights, $sModelConfiguration)
	EndIf
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $dnn.readNet    ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	; $net.setPreferableBackend($CV_DNN_DNN_BACKEND_OPENCV)
	; $net.setPreferableTarget($CV_DNN_DNN_TARGET_CPU)

	$hTimer = TimerInit()
	ProcessFrame($net, $classes, $image)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ProcessFrame    ' & TimerDiff($hTimer) & ' ms' & @CRLF & @CRLF)
EndFunc   ;==>Main

Func ProcessFrame($net, $classes, $frame)
	Local $hTimer

	Local $aPicPos = ControlGetPos($FormGUI, "", $PicResult)
	Local $iDstWidth = $aPicPos[2]
	Local $iDstHeight = $aPicPos[3]
	Local $fRatio = $frame.width / $frame.height

	If $fRatio * $iDstHeight > $iDstWidth Then
		$iDstHeight = $iDstWidth / $fRatio
	ElseIf $fRatio * $iDstHeight < $iDstWidth Then
		$iDstWidth = $iDstHeight * $fRatio
	EndIf

	;; Reduce frame image to improve object detection
	$frame = _OpenCV_resizeAndCenter($frame, $iDstWidth, $iDstHeight)

	;; Create a 4D blob from a frame.
	Local $blob = $dnn.blobFromImage($frame, 1 / 255, _OpenCV_Size($inpWidth, $inpHeight), _OpenCV_Scalar(0, 0, 0), True, False)

	;; Sets the input to the network
	$net.setInput($blob)

	;; Runs the forward pass to get output of the output layers
	$hTimer = TimerInit()
	Local $outs = $net.forward($net.getUnconnectedOutLayersNames())
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : forward         ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	;; Remove the bounding boxes with low confidence
	$hTimer = TimerInit()
	postprocess($frame, $outs, $classes)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : postprocess     ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	;; Put efficiency information.
	;; The function getPerfProfile returns the overall time for inference(t)
	;; and the timings for each of the layers(in layersTimes)
	; Local $t = $net.getPerfProfile()
	; Local $label = 'Inference time: ' & Round($t * 1000.0 / $cv.getTickFrequency(), 2) & ' ms'
	; $cv.putText($frame, $label, _OpenCV_Point(0, 15), $CV_FONT_HERSHEY_SIMPLEX, 0.5, _OpenCV_Scalar(0, 0, 0xFF))

	_OpenCV_imshow_ControlPic($frame, $FormGUI, $PicResult)
EndFunc   ;==>ProcessFrame

;; Remove the bounding boxes with low confidence using non-maxima suppression
Func postprocess($frame, $outs, $classes)
	Local $frameHeight = $frame.height
	Local $frameWidth = $frame.width

	;; Scan through all the bounding boxes output from the network and keep only the
	;; ones with high confidence scores. Assign the box's class label as the class with the highest score.
	Local $classIds = _OpenCV_ObjCreate("VectorOfInt")
	Local $confidences = _OpenCV_ObjCreate("VectorOfFloat")
	Local $boxes = _OpenCV_ObjCreate("VectorOfRect2d")
	Local $Mat = _OpenCV_ObjCreate("cv.Mat")

	Local $hTimer

	Local $left, $top, $width, $height

	If $addon_dll == "" Then
		; Slower
		$hTimer = TimerInit()

		Local $detection = $Mat.create(1, 0, $CV_32F)
		Local $scores = $Mat.create(1, 0, $CV_32F)

		Local $out, $data, $step, $cols, $sizeof
		Local $confidence, $classIdPoint
		Local $center_x, $center_y

		For $i = 0 To UBound($outs) - 1
			$out = $outs[$i]
			$data = Ptr($out.data)
			$step = $out.Step
			$cols = $out.cols
			$sizeof = $step / $cols
			$detection.cols = $cols
			$scores.cols = $cols - 5

			For $j = 0 To $out.rows - 1
				; Slower
				; Local $detection = $out.row($j)
				; Local $scores = $detection.colRange(5, $out.cols)

				; Slower
				; $detection.data = $out.ptr($j, 0)
				; $scores.data = $out.ptr($j, 5)

				$detection.data = $data + $step * $j
				$scores.data = Ptr($detection.data) + 5 * $sizeof

				$cv.minMaxLoc($scores)
				$confidence = $cv.extended[1]
				$classIdPoint = $cv.extended[3]

				If $confidence > $confThreshold Then
					$center_x = $detection.at(0) * $frameWidth
					$center_y = $detection.at(1) * $frameHeight
					$width = $detection.at(2) * $frameWidth
					$height = $detection.at(3) * $frameHeight
					$left = $center_x - $width / 2
					$top = $center_y - $height / 2

					$classIds.push_back($classIdPoint[0])
					$confidences.push_back($confidence)
					$boxes.push_back(_OpenCV_Rect($left, $top, $width, $height))
				EndIf
			Next
		Next

		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : AutoIt yolo_postprocess  ' & TimerDiff($hTimer) & ' ms' & @CRLF)
	Else
		;;: [doing the loop in a compiled code is 150 times faster than doing it in autoit]
		$hTimer = TimerInit()
		Local $vOuts = _OpenCV_ObjCreate("VectorOfMat").create($outs)
		_OpenCV_DllCall($addon_dll, "none:cdecl", "yolo_postprocess", _
				"ptr", $frame.self, _
				"ptr", $vOuts.self, _
				"float", $confThreshold, _
				"float", $nmsThreshold, _
				"ptr", $classIds.self, _
				"ptr", $confidences.self, _
				"ptr", $boxes.self _
				)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : DllCall yolo_postprocess ' & TimerDiff($hTimer) & ' ms' & @CRLF)
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
	EndIf

	;; Perform non maximum suppression to eliminate redundant overlapping boxes with
	;; lower confidences.
	Local $indices = $dnn.NMSBoxes($boxes, $confidences, $confThreshold, $nmsThreshold)
	Local $idx, $box
	For $i = 0 To UBound($indices) - 1
		$idx = $indices[$i]
		$box = $boxes.at($idx)
		drawPred($classIds.at($idx), $confidences.at($idx), $box, $frame, $classes)
	Next
EndFunc   ;==>postprocess

Func drawPred($classId, $conf, $box, $frame, $classes)
	Local $thickness = 2

	;; Draw a bounding box.
	$cv.rectangle($frame, $box, _OpenCV_Scalar(0xFF, 0xB2, 0x32), $thickness)

	;; Get the label for the class name and its confidence
	Local $label = StringFormat("%.4f", $conf)
	If IsArray($classes) Then
		$label = StringFormat("%s:%s", $classes[$classId], $label)
	EndIf

	Local $left = $box[0] + $thickness
	Local $top = $box[1] + $thickness
	Local $fLabelBackgroundOpacity = 0x7F / 0xFF

	If $_cv_gdi_resize And $__g_hGDIPDll > 0 Then
		Local $LabelBrush = _GDIPlus_BrushCreateSolid(0xFF000000)
		Local $hLabelBackgroundBrush = _GDIPlus_BrushCreateSolid(BitOR(0x00FFFFFF, BitShift($fLabelBackgroundOpacity * 0xFF, -24))) ;color format AARRGGBB (hex)
		Local $hImage = $frame.convertToBitmap(False)

		Local $hFormat = _GDIPlus_StringFormatCreate()
		Local $hFamily = _GDIPlus_FontFamilyCreate("Calibri")
		Local $hFont = _GDIPlus_FontCreate($hFamily, 12)

		Local $tLabelLayout = _GDIPlus_RectFCreate(0, 0, $frame.width, $frame.height)

		Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hImage)

		$tLabelLayout = _GDIPlus_GraphicsMeasureString($hGraphics, $label, $hFont, $tLabelLayout, $hFormat)
		$tLabelLayout = $tLabelLayout[0]
		$tLabelLayout.X = $left
		$tLabelLayout.Y = $top

		_GDIPlus_GraphicsSetSmoothingMode($hGraphics, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
		_GDIPlus_GraphicsFillRect($hGraphics, $left, $top, $tLabelLayout.Width, $tLabelLayout.Height, $hLabelBackgroundBrush)
		_GDIPlus_GraphicsDrawStringEx($hGraphics, $label, $hFont, $tLabelLayout, $hFormat, $LabelBrush)

		_GDIPlus_GraphicsDispose($hGraphics)

		_GDIPlus_FontDispose($hFont)
		_GDIPlus_FontFamilyDispose($hFamily)
		_GDIPlus_StringFormatDispose($hFormat)

		_GDIPlus_ImageDispose($hImage)
		_GDIPlus_BrushDispose($hLabelBackgroundBrush)
		_GDIPlus_BrushDispose($LabelBrush)
	Else
		Local $fontFace = $CV_FONT_HERSHEY_SIMPLEX
		Local $fontScale = 0.5
		Local $fontThickness = 1
		Local $labelSize = $cv.getTextSize($label, $fontFace, $fontScale, $fontThickness)
		Local $baseLine = $cv.extended[1]
		Local $width = $labelSize[0]
		Local $height = $labelSize[1] + $baseLine

		;; Draw a transparent label background

		If $fLabelBackgroundOpacity < 1 Then
			$left = _Max(0, $left - $thickness) + $thickness
			$top = _Max(0, $top - $thickness) + $thickness
			$width = _Min($left + $width, $frame.width) - $left
			$height = _Min($top + $height, $frame.height) - $top

			Local $aLabelBox = _OpenCV_Rect($left, $top, $width, $height)
			Local $oLabelRect = _OpenCV_ObjCreate("cv.Mat").create($height, $width, $CV_8UC3, _OpenCV_Scalar(0xFF, 0xFF, 0xFF))
			Local $oLabelROI = _OpenCV_ObjCreate("cv.Mat").create($frame, $aLabelBox)

			$oLabelRect = $cv.addWeighted($oLabelRect, $fLabelBackgroundOpacity, _OpenCV_ObjCreate("cv.Mat").create($frame, $aLabelBox), 1 - $fLabelBackgroundOpacity, 0)
			$oLabelRect.copyTo($oLabelROI)
		Else
			$cv.rectangle( _
					$frame, _
					_OpenCV_Rect($left, $top, $width, $height), _
					_OpenCV_Scalar(0xFF, 0xFF, 0xFF), _
					$CV_FILLED _
					)
		EndIf

		;; Display the label in the label background
		$cv.putText($frame, $label, _OpenCV_Point($left, $top + $labelSize[1]), $fontFace, $fontScale, _OpenCV_Scalar(0, 0, 0), $fontThickness)
	EndIf
EndFunc   ;==>drawPred

Func _DownloadWeights($sFilePath)
	Local $sUrl = "https://pjreddie.com/media/files/yolov3.weights"
	Local $iActualSize = FileGetSize($sFilePath)
	Local $iExpectedSize = InetGetSize($sUrl)

	If @error Or $iExpectedSize <= 0 Or (FileExists($sFilePath) And $iActualSize == $iExpectedSize) Then Return

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetSize ' & $iActualSize & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : InetGetSize ' & $iExpectedSize & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Downloading ' & $sUrl & @CRLF) ;### Debug Console
	InetGet($sUrl, $sFilePath, $INET_FORCERELOAD)
EndFunc   ;==>_DownloadWeights

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
