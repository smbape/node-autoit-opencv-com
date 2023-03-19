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
;~     https://github.com/sjinzh/awesome-yolo-object-detection
;~     https://github.com/ultralytics/yolov5
;~     https://github.com/ultralytics/yolov5/issues/251
;~     https://learnopencv.com/object-detection-using-yolov5-and-opencv-dnn-in-c-and-python/
;~     https://github.com/ultralytics/ultralytics/blob/main/examples/YOLOv8-CPP-Inference/inference.cpp
;~     https://docs.opencv.org/4.x/d4/d2f/tf_det_tutorial_dnn_conversion.html

#cs
git clone https://github.com/ultralytics/yolov5
cd yolov5
pip install -r requirements.txt
python export.py --include onnx --opset 12 --weights yolov5s.pt

pip install ultralytics
yolo export model=yolov8s.pt imgsz=640 format=onnx opset=12
#ce

_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
_GDIPlus_Startup()
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()
Global $addon_dll = _Addon_FindDLL()

Global Const $OPENCV_SAMPLES_DATA_PATH = _OpenCV_FindFile("samples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("OpenCV object detection", 1273, 796, 191, 18)

Global $LabelImage = GUICtrlCreateLabel("Image", 215, 8, 47, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputSource = GUICtrlCreateInput(_PathFull($cv.samples.findFile("scooter-5180947_1920.jpg")), 264, 8, 449, 21)
Global $BtnSource = GUICtrlCreateButton("Browse", 723, 6, 75, 25)

Global $LabelModelNames = GUICtrlCreateLabel("Model names", 163, 44, 97, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputModelNames = GUICtrlCreateInput(_PathFull($cv.samples.findFile("coco.txt")), 264, 44, 449, 21)
Global $BtnModelNames = GUICtrlCreateButton("Browse", 723, 42, 75, 25)

Global $LabelModelWeights = GUICtrlCreateLabel("Model weights", 157, 80, 103, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputModelWeights = GUICtrlCreateInput(_PathFull($cv.samples.findFile("yolov5s.onnx")), 264, 80, 449, 21)
Global $BtnModelWeights = GUICtrlCreateButton("Browse", 723, 78, 75, 25)

Global $LabelModelConfiguration = GUICtrlCreateLabel("Model configuration", 120, 116, 140, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputModelConfiguration = GUICtrlCreateInput("", 264, 116, 449, 21)
Global $BtnModelConfiguration = GUICtrlCreateButton("Browse", 723, 114, 75, 25)

Global $LabelModelSize = GUICtrlCreateLabel("Model size", 832, 12, 81, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $InputModelWidth = GUICtrlCreateInput("640", 920, 12, 25, 21)
GUICtrlSetTip(-1, "Width of network's input image")
Global $InputModelHeight = GUICtrlCreateInput("640", 955, 12, 25, 21)
GUICtrlSetTip(-1, "Height of network's input image")

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 832, 48, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

Global $CheckboxUseCPP = GUICtrlCreateCheckbox("Use C++", 832, 78, 97, 17)
If $addon_dll == "" Then
	GUICtrlSetState(-1, $GUI_DISABLE)
Else
	GUICtrlSetState(-1, $GUI_CHECKED)
EndIf

Global $BtnExec = GUICtrlCreateButton("Dectect Objects", 832, 114, 91, 25)

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

; Make the starting point unpredictable
$cv.theRNG().state = $cv.getTickCount()

;; Initialize the parameters
Global $confidence_threshold = 0.45  ; a threshold used to filter boxes by model confidence
Global $score_threshold      = 0.25  ; a threshold used to filter boxes by score
Global $nms_threshold        = 0.45  ; a threshold used in non maximum suppression

Global $sSource, $sModelNames, $sModelConfiguration, $sModelWeights
Global $nMsg

_DownloadFile(@ScriptDir & "\yolov3.weights", "https://pjreddie.com/media/files/yolov3.weights")
_DownloadFile(@ScriptDir & "\yolov5s.onnx", "https://github.com/doleron/yolov5-opencv-cpp-python/raw/main/config_files/yolov5s.onnx")
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
			$sModelConfiguration = FileOpenDialog("Select a model configuration", $OPENCV_SAMPLES_DATA_PATH, "Model configuration (*.prototxt;*.pbtxt;*.cfg;*.xml)", $FD_FILEMUSTEXIST, $sModelConfiguration)
			If @error Then
				$sModelConfiguration = ""
			Else
				ControlSetText($FormGUI, "", $InputModelConfiguration, $sModelConfiguration)
			EndIf
		Case $BtnModelWeights
			$sModelWeights = ControlGetText($FormGUI, "", $InputModelWeights)
			$sModelWeights = FileOpenDialog("Select a model weights", $OPENCV_SAMPLES_DATA_PATH, "Model weights (*.caffemodel;*.pb;*.t7;*.net;*.weights;*.bin;*.onnx)", $FD_FILEMUSTEXIST, $sModelWeights)
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
	Local $hTimer

	$sSource = ControlGetText($FormGUI, "", $InputSource)
	If $sSource == "" Then Return

	$sModelNames = ControlGetText($FormGUI, "", $InputModelNames)
	If $sModelNames == "" Then Return

	$sModelConfiguration = ControlGetText($FormGUI, "", $InputModelConfiguration)

	$sModelWeights = ControlGetText($FormGUI, "", $InputModelWeights)

	$_cv_gdi_resize = _IsChecked($CheckboxUseGDI)

	;;! [Load image]
	$hTimer = TimerInit()
	Local $image = _OpenCV_imread_and_check($sSource)
	If @error Then Return
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Load image               ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	$hTimer = TimerInit()
	_OpenCV_imshow_ControlPic($image, $FormGUI, $PicSource)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Show image               ' & TimerDiff($hTimer) & ' ms' & @CRLF)
	;;! [Load image]

	Local $classes = FileReadToArray($sModelNames)
	If @error Then
		ConsoleWriteError("!>Error: Unable to read model names " & $sModelNames & @CRLF)
		Return
	EndIf

	$hTimer = TimerInit()
	Local $net = $cv.dnn.readNet($sModelWeights, $sModelConfiguration)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $cv.dnn.readNet          ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	; $net.setPreferableBackend($CV_DNN_DNN_BACKEND_OPENCV)
	; $net.setPreferableTarget($CV_DNN_DNN_TARGET_CPU)

    Local $layerNames = $net.getLayerNames()
    Local $lastLayerId = $net.getLayerId($layerNames[UBound($layerNames) - 1])
    Local $lastLayer = $net.getLayer($lastLayerId)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $lastLayer.type          ' & $lastLayer.type & @CRLF) ;### Debug Console

	Local Const $inpWidth = Number(ControlGetText($FormGUI, "", $InputModelWidth))
	Local Const $inpHeight = Number(ControlGetText($FormGUI, "", $InputModelHeight))

	$hTimer = TimerInit()
	ProcessImage($net, $inpWidth, $inpHeight, $classes, $image)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ProcessImage             ' & TimerDiff($hTimer) & ' ms' & @CRLF & @CRLF)
EndFunc   ;==>Main

Func ProcessImage($net, $spatial_width, $spatial_height, $classes, $image_displayed)
	Local $hTimer

	;; The model expects images of size [ $spatial_width x $spatial_height ]
	;; Performing a high quality shrinking, instead of the provided one in blobFromImage
	;; improves detection
	Local $image = _OpenCV_resizeAndCenter($image_displayed, _OpenCV_Params( _
			"width", $spatial_width, _
			"height", $spatial_height, _
			"center", False _
			))

	Local $aPicPos = ControlGetPos($FormGUI, "", $PicResult)
	$image_displayed = _OpenCV_resizeAndCenter($image_displayed, _OpenCV_Params( _
			"width", $aPicPos[2], _
			"height", $aPicPos[3], _
			"center", False _
			))

	Local $scale = $image_displayed.width / $image.width

	;; Fill missing pixels with 0
	Local $pad_width = $spatial_width - $image.width
	Local $pad_height = $spatial_height - $image.height
	If $pad_width > 0 Or $pad_height > 0 Then
		Local $padded = $cv.Mat.zeros($spatial_width, $spatial_height, CV_MAKETYPE($image.depth(), $image.channels()))
		$image.copyTo($cv.Mat.create($padded, _OpenCV_Rect(0, 0, $image.width, $image.height)))
		$image = $padded
	EndIf

	;; Create a 4D blob from a frame.
	Local $blob = $cv.dnn.blobFromImage($image, _OpenCV_Params( _
			"scalefactor", 1 / 255, _
			"size", _OpenCV_Size($spatial_width, $spatial_height), _
			"swapRB", True _ ; yolo models expects RGB images, but opencv read BGR images
			))

	;; Sets the input to the network
	$net.setInput($blob)

	;; Runs the forward pass to get output of the output layers
	$hTimer = TimerInit()
	Local $outs = $net.forward($net.getUnconnectedOutLayersNames())
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : forward                  ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	;; Remove the bounding boxes with low confidence
	$hTimer = TimerInit()
	postprocess($spatial_width, $spatial_height, $classes, $image, $scale, $image_displayed, $outs)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : postprocess              ' & TimerDiff($hTimer) & ' ms' & @CRLF)

	;; Put efficiency information.
	;; The function getPerfProfile returns the overall time for inference(t)
	;; and the timings for each of the layers(in layersTimes)
	; Local $t = $net.getPerfProfile()
	; Local $label = 'Inference time: ' & Round($t * 1000.0 / $cv.getTickFrequency(), 2) & ' ms'
	; $cv.putText($image, $label, _OpenCV_Point(0, 15), $CV_FONT_HERSHEY_SIMPLEX, 0.5, _OpenCV_Scalar(0, 0, 0xFF))

	_OpenCV_imshow_ControlPic($image_displayed, $FormGUI, $PicResult)
EndFunc   ;==>ProcessImage

Func postprocess($spatial_width, $spatial_height, $classes, $image, $scale, $image_displayed, $outs)
	;; Scan through all the bounding boxes output from the network and keep only the
	;; ones with high confidence scores. Assign the box's class label as the class with the highest score.
	Local $class_ids = _OpenCV_ObjCreate("VectorOfInt")
	Local $scores = _OpenCV_ObjCreate("VectorOfFloat")
	Local $bboxes = _OpenCV_ObjCreate("VectorOfRect2d")

	Local $hTimer

	If Not _IsChecked($CheckboxUseCPP) Then
		; Slower
		$hTimer = TimerInit()
		yolo_postprocess( _
				$spatial_width, _
				$spatial_height, _
				UBound($classes), _
				$image.width, _
				$image.height, _
				$scale, _
				$outs, _
				$class_ids, _
				$scores, _
				$bboxes _
				)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : AutoIt yolo_postprocess  ' & TimerDiff($hTimer) & ' ms' & @CRLF)
	Else
		;;: [doing the loop in a compiled code is 150 times faster than doing it in autoit]
		$hTimer = TimerInit()
		$outs = _OpenCV_ObjCreate("VectorOfMat").create($outs)
		_OpenCV_DllCall($addon_dll, "none:cdecl", "yolo_postprocess", _
				"int", $spatial_width, _
				"int", $spatial_height, _
				"ulong_ptr", UBound($classes), _
				"int", $image.width, _
				"int", $image.height, _
				"float", $scale, _
				"ptr", $outs.self, _
				"float", $confidence_threshold, _
				"float", $score_threshold, _
				"ptr", $class_ids.self, _
				"ptr", $scores.self, _
				"ptr", $bboxes.self _
				)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : c++ yolo_postprocess     ' & TimerDiff($hTimer) & ' ms' & @CRLF)
		;;: [doing the loop in a compiled code is way faster than doing it in autoit]
	EndIf

	Local Const $colors = $cv.Mat.zeros(1, UBound($classes), $CV_8UC3)
	$cv.randu($colors, 0.0, 255.0)

	;; Perform non maximum suppression to eliminate redundant overlapping bounding boxes with lower scores.
	Local $indices = $cv.dnn.NMSBoxes($bboxes, $scores, $score_threshold, $nms_threshold)
	For $idx In $indices
		drawPred($image_displayed, $class_ids.at($idx), $scores.at($idx), $bboxes.at($idx), $classes, $colors)
	Next
EndFunc   ;==>postprocess

Func yolo_postprocess($spatial_width, $spatial_height, $num_classes, $img_width, $img_height, $scale, $outs, $class_ids, $scores, $bboxes)
	Local Const $UNSUPPORTED_YOLO_VERSION = "!>Error: Unsupported yolo version. Supported versions are v3, v5, v8."
	Local $offset, $scale_x, $scale_y

	Local $detection = $cv.Mat.create(1, 0, $CV_32F)
	Local $classes_scores = $cv.Mat.create(1, 0, $CV_32F)

	Local $out, $data, $steps, $step_row, $step_col
	Local $maxScore, $maxClassLoc
	Local $center_x, $center_y
	Local $left, $top, $width, $height

	For $out In $outs
		If $out.dims <> 2 And $out.dims <> 3 Then
			ConsoleWriteError($UNSUPPORTED_YOLO_VERSION & ' out.dims != 2 && out.dims != 3' & @CRLF)
			Return
		EndIf

		If $out.dims == 2 Then
			;; yolo v3
			$offset = 5 ;
			$scale_x = $scale * $img_width
			$scale_y = $scale * $img_height
		Else
			If $out.sizes[0] <> 1 Then
				ConsoleWriteError($UNSUPPORTED_YOLO_VERSION & ' out.size[0] != 1' & @CRLF)
				Return
			EndIf

			$out = $out.reshape(1, $out.sizes[1])
			$scale_x = $scale * $img_width / $spatial_width
			$scale_y = $scale * $img_height / $spatial_height

			;; yolov5 has an output of shape (batchSize, 25200, 85) (Num classes + box[x,y,w,h] + confidence[c])
			;; yolov8 has an output of shape (batchSize, 84,  8400) (Num classes + box[x,y,w,h])
			If $out.rows == $num_classes + 4 Then
				;; yolo v8
				$offset = 4
				$out = $cv.transpose($out)
			ElseIf $out.cols == $num_classes + 5 Then
				;; yolo v5
				$offset = 5
			Else
				ConsoleWriteError($UNSUPPORTED_YOLO_VERSION & @CRLF)
				Return
			EndIf
		EndIf

		$data = Ptr($out.data)
		$steps = $out.steps
		$step_row = $steps[0]
		$step_col = $steps[1]

		$detection.cols = $out.cols
		$classes_scores.cols = $out.cols - $offset

		For $j = 0 To $out.rows - 1
			; Slower
			; $detection = $out.row($j)
			; $classes_scores = $detection.colRange($offset, $out.cols)

			; Slower
			; $detection.data = $out.ptr($j, 0)
			; $classes_scores.data = $out.ptr($j, $offset)

			$detection.data = $data + $j * $step_row
			$classes_scores.data = Ptr($detection.data) + $offset * $step_col

			If $offset == 5 And $detection.at(4) < $confidence_threshold Then
				ContinueLoop
			EndIf

			$cv.minMaxLoc($classes_scores)
			$maxScore = $cv.extended[1]
			$maxClassLoc = $cv.extended[3]

			If $maxScore >= $score_threshold Then
				$center_x = $detection.at(0) * $scale_x
				$center_y = $detection.at(1) * $scale_y
				$width = $detection.at(2) * $scale_x
				$height = $detection.at(3) * $scale_y
				$left = $center_x - $width / 2
				$top = $center_y - $height / 2

				$class_ids.push_back($maxClassLoc[0])
				$scores.push_back($maxScore)
				$bboxes.push_back(_OpenCV_Rect($left, $top, $width, $height))
			EndIf
		Next
	Next
EndFunc   ;==>yolo_postprocess

Func drawPred($image, $class_id, $conf, $bbox, $classes, $colors)
	Local $thickness = 2
	Local $color = $colors.Vec3b_at($class_id)

	;; Draw a bounding box.
	$cv.rectangle($image, $bbox, $color, $thickness)

	;; Get the label for the class name and its confidence
	Local $label = StringFormat("%s:%.3f", $classes[$class_id], $conf)

	Local $left = $bbox[0] + $thickness
	Local $top = $bbox[1] + $thickness
	Local $fLabelBackgroundOpacity = 0x7F / 0xFF

	If $_cv_gdi_resize And $__g_hGDIPDll > 0 Then
		Local $LabelBrush = _GDIPlus_BrushCreateSolid(0xFF000000)
		Local $hLabelBackgroundBrush = _GDIPlus_BrushCreateSolid(BitOR(0x00FFFFFF, BitShift($fLabelBackgroundOpacity * 0xFF, -24))) ;color format AARRGGBB (hex)
		Local $hImage = $image.convertToBitmap(False)

		Local $hFormat = _GDIPlus_StringFormatCreate()
		Local $hFamily = _GDIPlus_FontFamilyCreate("Calibri")
		Local $hFont = _GDIPlus_FontCreate($hFamily, 12)

		Local $tLabelLayout = _GDIPlus_RectFCreate(0, 0, $image.width, $image.height)

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
			$width = _Min($left + $width, $image.width) - $left
			$height = _Min($top + $height, $image.height) - $top

			Local $aLabelBox = _OpenCV_Rect($left, $top, $width, $height)
			Local $oLabelRect = $cv.Mat.create($height, $width, $CV_8UC3, _OpenCV_Scalar(0xFF, 0xFF, 0xFF))
			Local $oLabelROI = $cv.Mat.create($image, $aLabelBox)

			$oLabelRect = $cv.addWeighted($oLabelRect, $fLabelBackgroundOpacity, $cv.Mat.create($image, $aLabelBox), 1 - $fLabelBackgroundOpacity, 0)
			$oLabelRect.copyTo($oLabelROI)
		Else
			$cv.rectangle( _
					$image, _
					_OpenCV_Rect($left, $top, $width, $height), _
					_OpenCV_Scalar(0xFF, 0xFF, 0xFF), _
					$CV_FILLED _
					)
		EndIf

		;; Display the label in the label background
		$cv.putText($image, $label, _OpenCV_Point($left, $top + $labelSize[1]), $fontFace, $fontScale, _OpenCV_Scalar(0, 0, 0), $fontThickness)
	EndIf
EndFunc   ;==>drawPred

Func _DownloadFile($sFilePath, $sUrl)
	Local $iActualSize = FileGetSize($sFilePath)
	Local $iExpectedSize = InetGetSize($sUrl)

	If @error Or $iExpectedSize <= 0 Or (FileExists($sFilePath) And $iActualSize == $iExpectedSize) Then Return

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetSize ' & $iActualSize & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : InetGetSize ' & $iExpectedSize & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Downloading ' & $sUrl & @CRLF) ;### Debug Console
	InetGet($sUrl, $sFilePath, $INET_FORCERELOAD)
EndFunc   ;==>_DownloadFile

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_GDIPlus_Shutdown()
	_OpenCV_Close()
EndFunc   ;==>_OnAutoItExit
