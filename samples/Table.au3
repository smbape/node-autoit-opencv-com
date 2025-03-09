;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; #INDEX# ===================================================================================
; Title .........: Table
; AutoIt Version: 3.3.0.0+
; Language:       English
; Description ...: A simple Table control using an array of labels.
;                  This is an attempt at a cleaner, simpler, way of displaying data without using ListViews.
; Notes .........: GUI must exist BEFORE table is constructed/manipulated,
;                  i.e. GUISetState() must be called before _GUICtrlTable_Create
; ===========================================================================================



; #VARIABLES# ===============================================================================
Global $_aGUICtrlTableBordersINTERNALSTORE[1][2]
; ===========================================================================================



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Create
; Description ...: Creates a 'table' of label controls, and preps the 'border array'
; Syntax.........: _GUICtrlTable_Create($iLeft, $iTop, $iWidth, $iHeight, $iRows, $iColumns[, $iGapWidth = 1])
; Parameters ....: $iLeft - Horisontal position of first cell
;                  $iTop - Vertical position of first cell
;                  $iWidth - Initial width of each cell
;                  $iHeight - Initial height of each cell
;                  $iRows - Number of rows in table
;                  $iColumns - Number of columns in table
;                  $iGapWidth - Size (pixels) of gap between each cell (can be zero = no gaps)
; Return values .: Success - Returns array of label IDs for other functions ($ReturnedArray[ROW][COLUMN])
;                  Failure - (under construction)
; Notes .........: Rows/Columns are NOT zero-indexed. The first row IS row 1, the first column IS col 1 etc
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Create($iLeft, $iTop, $iWidth, $iHeight, $iRows, $iColumns, $iGapWidth = 1)

	Local $i, $j, $iCurrBoxLeft = 0, $iCurrBoxTop = 0, $aTemp
	Local $array[$iRows + 1][$iColumns + 1]

	If $iGapWidth < 0 Then $iGapWidth = 0
	$iGapWidth = Round($iGapWidth)

	For $i = 1 To $iRows
		For $j = 1 To $iColumns
			$array[$i][$j] = GUICtrlCreateLabel("", $iLeft + $iCurrBoxLeft, $iTop + $iCurrBoxTop, $iWidth, $iHeight)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			$iCurrBoxLeft += $iWidth + $iGapWidth
		Next
		$iCurrBoxLeft = 0
		$iCurrBoxTop += $iHeight + $iGapWidth
	Next

	ReDim $_aGUICtrlTableBordersINTERNALSTORE[UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) + 1][2]
	Dim $aTemp[$iRows + 1][$iColumns + 1][5]
	$_aGUICtrlTableBordersINTERNALSTORE[UBound($_aGUICtrlTableBordersINTERNALSTORE) - 1][0] = $array[1][1]
	$_aGUICtrlTableBordersINTERNALSTORE[UBound($_aGUICtrlTableBordersINTERNALSTORE) - 1][1] = $aTemp

	Return $array

EndFunc   ;==>_GUICtrlTable_Create



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Delete
; Description ...: Deletes the labels associated with this table, including borders, also nulls array entries
; Syntax.........: _GUICtrlTable_Delete(ByRef $array)
; Parameters ....: $array - array returned from _GUICtrlTable_Create
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Delete(ByRef $array)

	Local $i, $j, $aRetrievedTableBorders, $test

	If IsArray($array) = 0 Then Return

	;- Get border array from store -
	$test = ""
	For $i = 1 To UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) - 1
		$test = $_aGUICtrlTableBordersINTERNALSTORE[$i][0]
		If $array[1][1] = $test Then
			$aRetrievedTableBorders = $_aGUICtrlTableBordersINTERNALSTORE[$i][1]
			$test = $i
			ExitLoop
		EndIf
	Next

	For $i = 1 To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			GUICtrlDelete($array[$i][$j])
		Next
	Next

	_GUICtrlTable_Set_Border_All($array, 0)

	$array = 0
	$aRetrievedTableBorders = 0

	;- Put retrieved borders back
	$_aGUICtrlTableBordersINTERNALSTORE[$test][0] = ""
	$_aGUICtrlTableBordersINTERNALSTORE[$test][1] = $aRetrievedTableBorders

EndFunc   ;==>_GUICtrlTable_Delete



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Move
; Description ...: Moves the x/y position of the table (including borders)
; Syntax.........: _GUICtrlTable_Move(ByRef $array, $iLeft, $iTop)
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iLeft - new Horisontal position of first cell
;                  $iTop - new Vertical position of first cell
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Move(ByRef $array, $iLeft, $iTop)

	Local $i, $j, $k, $aTemp, $aTemp2, $iMoveLeft, $iMoveTop, $test, $aRetrievedTableBorders

	If IsArray($array) = 0 Then Return

	;- Get border array from store -
	$test = ""
	For $i = 1 To UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) - 1
		$test = $_aGUICtrlTableBordersINTERNALSTORE[$i][0]
		If $array[1][1] = $test Then
			$aRetrievedTableBorders = $_aGUICtrlTableBordersINTERNALSTORE[$i][1]
			$test = $i
			ExitLoop
		EndIf
	Next

	$aTemp = ControlGetPos("", "", $array[1][1])
	$iMoveLeft = $aTemp[0] - $iLeft
	$iMoveTop = $aTemp[1] - $iTop
	For $i = 1 To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			$aTemp = ControlGetPos("", "", $array[$i][$j])
			GUICtrlSetPos($array[$i][$j], $aTemp[0] - $iMoveLeft, $aTemp[1] - $iMoveTop)
			For $k = 1 To 4
				$aTemp2 = ControlGetPos("", "", $aRetrievedTableBorders[$i][$j][$k])
				If IsArray($aTemp2) = 0 Then ContinueLoop
				GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $aTemp2[0] - $iMoveLeft, $aTemp2[1] - $iMoveTop)
			Next
		Next
	Next

EndFunc   ;==>_GUICtrlTable_Move



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_CellGetID
; Description ...: Retrieves the label control ID for the specified cell, enables user modification
; Syntax.........: _GUICtrlTable_CellGetID(ByRef $array, $iRow, $iCol)
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - Cell row value
;                  $iCol - Cell column value
; Return values .: Success - Returns label control ID for specified 'cell'
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_CellGetID(ByRef $array, $iRow, $iCol)

	If IsArray($array) = 0 Then Return
	Return $array[$iRow][$iCol]

EndFunc   ;==>_GUICtrlTable_CellGetID



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_CellGetPos
; Description ...: Retrieves the label position for the specified cell, enables user modification
; Syntax.........: _GUICtrlTable_CellGetPos(ByRef $array, $iRow, $iCol)
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - Cell row value
;                  $iCol - Cell column value
; Return values .: Success - Returns array as per ControlGetPos ($arra[0] = left, [1] = top etc)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_CellGetPos(ByRef $array, $iRow, $iCol)

	If IsArray($array) = 0 Then Return
	Return ControlGetPos("", "", $array[$iRow][$iCol])

EndFunc   ;==>_GUICtrlTable_CellGetPos



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_ColumnWidth
; Description ...: Changes the width of a specified column of cells/labels
; Syntax.........: _GUICtrlTable_Set_ColumnWidth(ByRef $array, $iCol, $iWidth)
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iCol - table column value
;                  $iWidth - new width of column
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_ColumnWidth(ByRef $array, $iCol, $iWidth)

	Local $i, $j, $k, $iCurrBoxLeft, $bFirst, $aTemp, $aTemp2, $iGapWidth, $test, $aRetrievedTableBorders

	If IsArray($array) = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	;- Get border array from store -
	$test = ""
	For $i = 1 To UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) - 1
		$test = $_aGUICtrlTableBordersINTERNALSTORE[$i][0]
		If $array[1][1] = $test Then
			$aRetrievedTableBorders = $_aGUICtrlTableBordersINTERNALSTORE[$i][1]
			$test = $i
			ExitLoop
		EndIf
	Next

	$aTemp = ControlGetPos("", "", $array[1][1])
	$aTemp2 = ControlGetPos("", "", $array[1][2])
	$iGapWidth = $aTemp2[0] - ($aTemp[0] + $aTemp[2])
	If $iGapWidth < 0 Then $iGapWidth = 0

	For $i = 1 To UBound($array, 1) - 1
		$bFirst = True
		For $j = $iCol To UBound($array, 2) - 1
			$aTemp = ControlGetPos("", "", $array[$i][$j])
			If $bFirst = True Then $iCurrBoxLeft = $aTemp[0]
			$bFirst = False
			Switch $j
				Case $iCol
					GUICtrlSetPos($array[$i][$j], $iCurrBoxLeft, $aTemp[1], $iWidth)
					For $k = 1 To 4
						Switch $k
							Case 1
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $iCurrBoxLeft, $aTemp[1])
							Case 2
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $iCurrBoxLeft, $aTemp[1], $iWidth)
							Case 3
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $iCurrBoxLeft + $iWidth - 1, $aTemp[1])
							Case 4
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $iCurrBoxLeft, $aTemp[1] + $aTemp[3] - 1, $iWidth)
						EndSwitch
					Next
					$iCurrBoxLeft += $iWidth + $iGapWidth
				Case Else
					GUICtrlSetPos($array[$i][$j], $iCurrBoxLeft, $aTemp[1])
					For $k = 1 To 4
						Switch $k
							Case 1, 2
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $iCurrBoxLeft, $aTemp[1])
							Case 3
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $iCurrBoxLeft + $aTemp[2] - 1, $aTemp[1])
							Case 4
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $iCurrBoxLeft, $aTemp[1] + $aTemp[3] - 1)
						EndSwitch
					Next
					$iCurrBoxLeft += $aTemp[2] + $iGapWidth
			EndSwitch
		Next
	Next

EndFunc   ;==>_GUICtrlTable_Set_ColumnWidth



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_RowHeight
; Description ...: Changes the height of a specified row of cells/labels
; Syntax.........: _GUICtrlTable_Set_RowHeight(ByRef $array, $iRow, $iHeight)
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - table row value
;                  $iHeight - new height for row
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_RowHeight(ByRef $array, $iRow, $iHeight)

	Local $i, $j, $k, $iCurrBoxTop, $bFirst, $aTemp, $aTemp2, $iGapWidth, $test, $aRetrievedTableBorders

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return

	;- Get border array from store -
	$test = ""
	For $i = 1 To UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) - 1
		$test = $_aGUICtrlTableBordersINTERNALSTORE[$i][0]
		If $array[1][1] = $test Then
			$aRetrievedTableBorders = $_aGUICtrlTableBordersINTERNALSTORE[$i][1]
			$test = $i
			ExitLoop
		EndIf
	Next

	$aTemp = ControlGetPos("", "", $array[1][1])
	$aTemp2 = ControlGetPos("", "", $array[1][2])
	$iGapWidth = $aTemp2[0] - ($aTemp[0] + $aTemp[2])
	If $iGapWidth < 0 Then $iGapWidth = 0

	$bFirst = True
	For $i = $iRow To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			$aTemp = ControlGetPos("", "", $array[$i][$j])
			If $bFirst = True Then $iCurrBoxTop = $aTemp[1]
			$bFirst = False
			Switch $i
				Case $iRow
					GUICtrlSetPos($array[$i][$j], $aTemp[0], $iCurrBoxTop, $aTemp[2], $iHeight)
					For $k = 1 To 4
						Switch $k
							Case 1
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $aTemp[0], $iCurrBoxTop, 1, $iHeight)
							Case 2
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $aTemp[0], $iCurrBoxTop)
							Case 3
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $aTemp[0] + $aTemp[2] - 1, $iCurrBoxTop, 1, $iHeight)
							Case 4
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $aTemp[0], $iCurrBoxTop + $iHeight - 1)
						EndSwitch
					Next
				Case Else
					GUICtrlSetPos($array[$i][$j], $aTemp[0], $iCurrBoxTop)
					For $k = 1 To 4
						Switch $k
							Case 1, 2
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $aTemp[0], $iCurrBoxTop)
							Case 3
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $aTemp[0] + $aTemp[2] - 1, $iCurrBoxTop)
							Case 4
								GUICtrlSetPos($aRetrievedTableBorders[$i][$j][$k], $aTemp[0], $iCurrBoxTop + $aTemp[3] - 1)
						EndSwitch
					Next
			EndSwitch
		Next
		Switch $i
			Case $iRow
				$iCurrBoxTop += $iHeight + $iGapWidth
			Case Else
				$iCurrBoxTop += $aTemp[3] + $iGapWidth
		EndSwitch
	Next

EndFunc   ;==>_GUICtrlTable_Set_RowHeight



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Text_Row
; Description ...: Changes the text of the cells in a row
; Syntax.........: _GUICtrlTable_Set_Text_Row(ByRef $array, $iRow, $sText[, $sDelimiter = "|"[, $iOverWriteBlank = 1]])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - table row value
;                  $sText - delimted text to add to cells
;                  $sDelimiter - character to act as text string delimiter
;                  $iOverWriteBlank - if not = 1, then blank elements in $aData will be ignored (i.e. keep existing data)
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Notes .........: If more delimiters exist in text than there are cells, the extra data is ignored
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Text_Row(ByRef $array, $iRow, $sText, $sDelimiter = "|", $iOverWriteBlank = 1)

	Local $i

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return

	Local $aString = StringSplit($sText, $sDelimiter)

	Local $iUpperlimit = UBound($array, 2) - 1
	If $aString[0] < $iUpperlimit Then $iUpperlimit = $aString[0]

	For $i = 1 To $iUpperlimit
		If $iOverWriteBlank <> 1 And $aString[$i] = "" Then ContinueLoop
		GUICtrlSetData($array[$iRow][$i], $aString[$i])
	Next

EndFunc   ;==>_GUICtrlTable_Set_Text_Row



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Text_Column
; Description ...: Changes the text of the cells in a column
; Syntax.........: _GUICtrlTable_Set_Text_Column(ByRef $array, $iCol, $sText[, $sDelimiter = "|"[, $iOverWriteBlank = 1]])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iCol - table column value
;                  $sText - delimted text to add to cells
;                  $sDelimiter - character to act as text string delimiter
;                  $iOverWriteBlank - if not = 1, then blank elements in $aData will be ignored (i.e. keep existing data)
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Notes .........: If more delimiters exist in text than there are cells, the extra data is ignored
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Text_Column(ByRef $array, $iCol, $sText, $sDelimiter = "|", $iOverWriteBlank = 1)

	Local $i

	If IsArray($array) = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	Local $aString = StringSplit($sText, $sDelimiter)

	Local $iUpperlimit = UBound($array, 1) - 1
	If $aString[0] < $iUpperlimit Then $iUpperlimit = $aString[0]

	For $i = 1 To $iUpperlimit
		If $iOverWriteBlank <> 1 And $aString[$i] = "" Then ContinueLoop
		GUICtrlSetData($array[$i][$iCol], $aString[$i])
	Next

EndFunc   ;==>_GUICtrlTable_Set_Text_Column



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Text_Cell
; Description ...: Changes the text of the cells in a single cell
; Syntax.........: _GUICtrlTable_Set_Text_Cell(ByRef $array, $iRow, $iCol, $sText[, $iOverWriteBlank = 1])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - cell row value
;                  $iCol - cell column value
;                  $sText - text to add to cell
;                  $iOverWriteBlank - if not = 1, then blank elements in $aData will be ignored (i.e. keep existing data)
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Text_Cell(ByRef $array, $iRow, $iCol, $sText, $iOverWriteBlank = 1)

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	If $iOverWriteBlank <> 1 And $sText = "" Then Return

	GUICtrlSetData($array[$iRow][$iCol], $sText)

EndFunc   ;==>_GUICtrlTable_Set_Text_Cell



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Text_FromArray
; Description ...: Inserts data from a 2D array into table
; Syntax.........: _GUICtrlTable_Set_Text_FromArray(ByRef $array, ByRef $aData[, $iOverWriteBlank = 1])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $aData - 2D array containing data, format is $aData[Rows][Columns]
;                  $iOverWriteBlank - if not 1, then blank elements in $aData will be ignored (i.e. keep existing data)
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Text_FromArray(ByRef $array, ByRef $aData, $iOverWriteBlank = 1)

	Local $i, $j, $iRowUpper, $iColUpper

	If IsArray($array) = 0 Then Return
	If IsArray($aData) = 0 Then Return
	If UBound($aData, 2) = 0 Then Return ;<2D
	If UBound($aData, 3) <> 0 Then Return ;>2D

	$iRowUpper = UBound($array, 1)
	If UBound($aData, 1) < $iRowUpper Then $iRowUpper = UBound($aData, 1)

	$iColUpper = UBound($array, 2)
	If UBound($aData, 2) < $iColUpper Then $iColUpper = UBound($aData, 2)

	For $i = 1 To $iRowUpper - 1
		For $j = 1 To $iColUpper - 1
			If $iOverWriteBlank <> 1 And $aData[$i][$j] = "" Then ContinueLoop
			GUICtrlSetData($array[$i][$j], $aData[$i][$j])
		Next
	Next

EndFunc   ;==>_GUICtrlTable_Set_Text_FromArray



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Get_Text_Row
; Description ...: Returns the data from a row of cells
; Syntax.........: _GUICtrlTable_Get_Text_Row(ByRef $array, $iRow[, $sDelimiter = "|"])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - table row value
;                  $sDelimiter - character to put between cell returns
; Return values .: Success - returns delimited string of cell data from specified row
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Get_Text_Row(ByRef $array, $iRow, $sDelimiter = "|")

	Local $i, $sString

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return ;set error too

	$sString = ""
	For $i = 1 To UBound($array, 2) - 1
		$sString &= GUICtrlRead($array[$iRow][$i]) & $sDelimiter
	Next

	Return StringTrimRight($sString, 1)

EndFunc   ;==>_GUICtrlTable_Get_Text_Row



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Get_Text_Column
; Description ...: Returns the data from a column of cells
; Syntax.........: _GUICtrlTable_Get_Text_Column(ByRef $array, $iCol[, $sDelimiter = "|"])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iCol - table column value
;                  $sDelimiter - character to put between cell returns
; Return values .: Success - returns delimited string of cell data from specified column
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Get_Text_Column(ByRef $array, $iCol, $sDelimiter = "|")

	Local $i, $sString

	If IsArray($array) = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return ;set error too

	$sString = ""
	For $i = 1 To UBound($array, 1) - 1
		$sString &= GUICtrlRead($array[$i][$iCol]) & $sDelimiter
	Next

	Return StringTrimRight($sString, 1)

EndFunc   ;==>_GUICtrlTable_Get_Text_Column



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Get_Text_Cell
; Description ...: Returns the data from a specified cell
; Syntax.........: _GUICtrlTable_Get_Text_Cell(ByRef $array, $iRow, $iCol)
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - cell row value
;                  $iCol - cell Column value
; Return values .: Success - returns cell data from specified cell
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Get_Text_Cell(ByRef $array, $iRow, $iCol)

	If IsArray($array) = 0 Then Return

	If $iRow = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	Return GUICtrlRead($array[$iRow][$iCol])

EndFunc   ;==>_GUICtrlTable_Get_Text_Cell



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Get_Text_All
; Description ...: Returns all the data from a table
; Syntax.........: _GUICtrlTable_Get_Text_All(ByRef $array)
; Parameters ....: $array - array returned from _GUICtrlTable_Create
; Return values .: Success - returns a 2d array of cell data e.g. $array[row][column]
;                  Failure - (under construction)
; Notes .........: zero elements of returned array are empty
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Get_Text_All(ByRef $array)

	Local $i, $j, $aTemp

	If IsArray($array) = 0 Then Return
	$aTemp = $array

	For $i = 1 To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			$aTemp[$i][$j] = GUICtrlRead($array[$i][$j])
		Next
	Next

	Return $aTemp

EndFunc   ;==>_GUICtrlTable_Get_Text_All



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_TextColor_Row
; Description ...: Sets the text color of a row of cells
; Syntax.........: _GUICtrlTable_Set_TextColor_Row(ByRef $array, $iRow[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - table row value
;                  $iColor - color to set text
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_TextColor_Row(ByRef $array, $iRow, $iColor = 0x000000)

	Local $i

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return

	For $i = 1 To UBound($array, 2) - 1
		GUICtrlSetColor($array[$iRow][$i], $iColor)
	Next

EndFunc   ;==>_GUICtrlTable_Set_TextColor_Row



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_TextColor_Column
; Description ...: Sets the text color of a column of cells
; Syntax.........: _GUICtrlTable_Set_TextColor_Column(ByRef $array, $iCol[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iCol - table column value
;                  $iColor - color to set text
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_TextColor_Column(ByRef $array, $iCol, $iColor = 0x000000)

	Local $i

	If IsArray($array) = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	For $i = 1 To UBound($array, 1) - 1
		GUICtrlSetColor($array[$i][$iCol], $iColor)
	Next

EndFunc   ;==>_GUICtrlTable_Set_TextColor_Column



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_TextColor_Cell
; Description ...: Sets the text color of a specified cell
; Syntax.........: _GUICtrlTable_Set_TextColor_Cell(ByRef $array, $iRow, $iCol[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - cell row value
;                  $iCol - cell column value
;                  $iColor - color to set text
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_TextColor_Cell(ByRef $array, $iRow, $iCol, $iColor = 0x000000)

	If IsArray($array) = 0 Then Return

	If $iRow = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	GUICtrlSetColor($array[$iRow][$iCol], $iColor)

EndFunc   ;==>_GUICtrlTable_Set_TextColor_Cell



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_TextColor_All
; Description ...: Sets the text color of all cells in table
; Syntax.........: _GUICtrlTable_Set_TextColor_All(ByRef $array[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iColor - color to set text
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_TextColor_All(ByRef $array, $iColor = 0x000000)

	Local $i, $j

	If IsArray($array) = 0 Then Return

	For $i = 1 To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			GUICtrlSetColor($array[$i][$j], $iColor)
		Next
	Next

EndFunc   ;==>_GUICtrlTable_Set_TextColor_All



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_TextFont_Row
; Description ...: Sets the text size, weight, attribute and font of a row of cells
; Syntax.........: _GUICtrlTable_Set_TextFont_Row(ByRef $array, $iRow, $iSize[, $iWeight = 400[, $iAttribute = 0[, $sFontname = "MS Sans Serif"]]])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - table row value
;                  $iSize - font size
;                  $iWeight - weight of font (bold etc)
;                  $iAttribute - italic=2 underlined=4 strike=8 (add together)
;                  $sFontname - name of font to use
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_TextFont_Row(ByRef $array, $iRow, $iSize, $iWeight = 400, $iAttribute = 0, $sFontname = "MS Sans Serif")

	Local $i

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return

	For $i = 1 To UBound($array, 2) - 1
		GUICtrlSetFont($array[$iRow][$i], $iSize, $iWeight, $iAttribute, $sFontname)
	Next

EndFunc   ;==>_GUICtrlTable_Set_TextFont_Row



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_TextFont_Column
; Description ...: Sets the text size, weight, attribute and font of a column of cells
; Syntax.........: _GUICtrlTable_Set_TextFont_Column(ByRef $array, $iCol, $iSize[, $iWeight = 400[, $iAttribute = 0[, $sFontname = "MS Sans Serif"]]])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iCol - table column value
;                  $iSize - font size
;                  $iWeight - weight of font (bold etc)
;                  $iAttribute - italic=2 underlined=4 strike=8 (add together)
;                  $sFontname - name of font to use
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_TextFont_Column(ByRef $array, $iCol, $iSize, $iWeight = 400, $iAttribute = 0, $sFontname = "MS Sans Serif")

	Local $i

	If IsArray($array) = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	For $i = 1 To UBound($array, 1) - 1
		GUICtrlSetFont($array[$i][$iCol], $iSize, $iWeight, $iAttribute, $sFontname)
	Next

EndFunc   ;==>_GUICtrlTable_Set_TextFont_Column



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_TextFont_Cell
; Description ...: Sets the text size, weight, attribute and font of a specified cell
; Syntax.........: _GUICtrlTable_Set_TextFont_Cell(ByRef $array, $iRow, $iCol, $iSize[, $iWeight = 400[, $iAttribute = 0[, $sFontname = "MS Sans Serif"]]])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - cell row value
;                  $iCol - cell column value
;                  $iSize - font size
;                  $iWeight - weight of font (bold etc)
;                  $iAttribute - italic=2 underlined=4 strike=8 (add together)
;                  $sFontname - name of font to use
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_TextFont_Cell(ByRef $array, $iRow, $iCol, $iSize, $iWeight = 400, $iAttribute = 0, $sFontname = "MS Sans Serif")

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	GUICtrlSetFont($array[$iRow][$iCol], $iSize, $iWeight, $iAttribute, $sFontname)

EndFunc   ;==>_GUICtrlTable_Set_TextFont_Cell



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_TextFont_All
; Description ...: Sets the text size, weight, attribute and font of all cells in table
; Syntax.........: _GUICtrlTable_Set_TextFont_All(ByRef $array[, $iSize = 8.5[, $iWeight = 400[, $iAttribute = 0[, $sFontname = "MS Sans Serif"]]])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iSize - font size
;                  $iWeight - weight of font (bold etc)
;                  $iAttribute - italic=2 underlined=4 strike=8 (add together)
;                  $sFontname - name of font to use
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_TextFont_All(ByRef $array, $iSize = 8.5, $iWeight = 400, $iAttribute = 0, $sFontname = "MS Sans Serif")

	Local $i, $j

	If IsArray($array) = 0 Then Return

	For $i = 1 To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			GUICtrlSetFont($array[$i][$j], $iSize, $iWeight, $iAttribute, $sFontname)
		Next
	Next

EndFunc   ;==>_GUICtrlTable_Set_TextFont_All



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_CellColor_Row
; Description ...: Sets the cell background color of a row of cells
; Syntax.........: _GUICtrlTable_Set_CellColor_Row(ByRef $array, $iRow[, $iColor = 0xFFFFFF])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - table row value
;                  $iColor - background color for cell ( -2 = transparent)
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_CellColor_Row(ByRef $array, $iRow, $iColor = 0xFFFFFF)

	Local $i

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return

	For $i = 1 To UBound($array, 2) - 1
		GUICtrlSetBkColor($array[$iRow][$i], $iColor)
	Next

EndFunc   ;==>_GUICtrlTable_Set_CellColor_Row



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_CellColor_Column
; Description ...: Sets the cell background color of a column of cells
; Syntax.........: _GUICtrlTable_Set_CellColor_Col(ByRef $array, $iCol[, $iColor = 0xFFFFFF])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iCol - table column value
;                  $iColor - background color for cell ( -2 = transparent)
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_CellColor_Column(ByRef $array, $iCol, $iColor = 0xFFFFFF)

	Local $i

	If IsArray($array) = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	For $i = 1 To UBound($array, 1) - 1
		GUICtrlSetBkColor($array[$i][$iCol], $iColor)
	Next

EndFunc   ;==>_GUICtrlTable_Set_CellColor_Column



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_CellColor_Cell
; Description ...: Sets the cell background color of a specified of cell
; Syntax.........: _GUICtrlTable_Set_CellColor_Cell(ByRef $array, $iRow, $iCol[, $iColor = 0xFFFFFF])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - cell row value
;                  $iCol - cell column value
;                  $iColor - background color for cell ( -2 = transparent)
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_CellColor_Cell(ByRef $array, $iRow, $iCol, $iColor = 0xFFFFFF)

	If IsArray($array) = 0 Then Return

	If $iRow = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	GUICtrlSetBkColor($array[$iRow][$iCol], $iColor)

EndFunc   ;==>_GUICtrlTable_Set_CellColor_Cell



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_CellColor_All
; Description ...: Sets the cell background color of all cells in a table
; Syntax.........: _GUICtrlTable_Set_CellColor_All(ByRef $array[, $iColor = 0xFFFFFF])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iColor - background color for cells ( -2 = transparent)
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_CellColor_All(ByRef $array, $iColor = 0xFFFFFF)

	Local $i, $j

	If IsArray($array) = 0 Then Return

	For $i = 1 To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			GUICtrlSetBkColor($array[$i][$j], $iColor)
		Next
	Next

EndFunc   ;==>_GUICtrlTable_Set_CellColor_All



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Justify_Row
; Description ...: Sets the justification (text position in cell) of a row of cells
; Syntax.........: _GUICtrlTable_Set_Justify_Row(ByRef $array, $iRow, $iJustify[, $iVCenter = 0])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - table row value
;                  $iJustify - left = 0, center = 1, right = 2
;                  $iVCenter - vertical position, top = 0, center = 1
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Justify_Row(ByRef $array, $iRow, $iJustify, $iVCenter = 0)

	Local $i

	If $iJustify < 0 Or $iJustify > 2 Then Return
	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return

	If $iVCenter <> 0 Then $iJustify += 0x0200

	For $i = 1 To UBound($array, 2) - 1
		GUICtrlSetStyle($array[$iRow][$i], $iJustify)
	Next

EndFunc   ;==>_GUICtrlTable_Set_Justify_Row



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Justify_Column
; Description ...: Sets the justification (text position in cell) of a column of cells
; Syntax.........: _GUICtrlTable_Set_Justify_Column(ByRef $array, $iCol, $iJustify[, $iVCenter = 0])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iCol - table column value
;                  $iJustify - left = 0, center = 1, right = 2
;                  $iVCenter - vertical position, top = 0, center = 1
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Justify_Column(ByRef $array, $iCol, $iJustify, $iVCenter = 0)

	Local $i

	If $iJustify < 0 Or $iJustify > 2 Then Return
	If IsArray($array) = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	If $iVCenter <> 0 Then $iJustify += 0x0200

	For $i = 1 To UBound($array, 1) - 1
		GUICtrlSetStyle($array[$i][$iCol], $iJustify)
	Next

EndFunc   ;==>_GUICtrlTable_Set_Justify_Column



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Justify_Cell
; Description ...: Sets the justification (text position in cell) of a specified cell
; Syntax.........: _GUICtrlTable_Set_Justify_Cell(ByRef $array, $iRow, $iCol, $iJustify[, $iVCenter = 0])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - cell row value
;                  $iCol - cell column value
;                  $iJustify - left = 0, center = 1, right = 2
;                  $iVCenter - vertical position, top = 0, center = 1
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Justify_Cell(ByRef $array, $iRow, $iCol, $iJustify, $iVCenter = 0)

	If $iJustify < 0 Or $iJustify > 2 Then Return
	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	If $iVCenter <> 0 Then $iJustify += 0x0200

	GUICtrlSetStyle($array[$iRow][$iCol], $iJustify)

EndFunc   ;==>_GUICtrlTable_Set_Justify_Cell



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Justify_All
; Description ...: Sets the justification (text position in cell) of all cells in table
; Syntax.........: _GUICtrlTable_Set_Justify_All(ByRef $array, $iJustify[, $iVCenter = 0])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iJustify - left = 0, center = 1, right = 2
;                  $iVCenter - vertical position, top = 0, center = 1
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Justify_All(ByRef $array, $iJustify, $iVCenter = 0)

	Local $i, $j
	If $iJustify < 0 Or $iJustify > 2 Then Return
	If IsArray($array) = 0 Then Return

	If $iVCenter <> 0 Then $iJustify += 0x0200

	For $i = 1 To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			GUICtrlSetStyle($array[$i][$j], $iJustify)
		Next
	Next

EndFunc   ;==>_GUICtrlTable_Set_Justify_All



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Border_Row
; Description ...: Draws a border on specified row of cells
; Syntax.........: _GUICtrlTable_Set_Border_Row(ByRef $array, $iRow, $iType[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - table row value
;                  $iType - left = 1, top = 2, right = 4, bottom = 8 (add values, e.g. full border = 15) NoBorder = 0
;                  $iColor - color of border to add
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; Credits .......: Authenticity (demonstrated API/dll z-order calls)
; ===========================================================================================
Func _GUICtrlTable_Set_Border_Row(ByRef $array, $iRow, $iType, $iColor = 0x000000)

	Local $hLabel, $i, $aTemp, $test, $aRetrievedTableBorders

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return

	;- Get border array from store -
	$test = ""
	For $i = 1 To UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) - 1
		$test = $_aGUICtrlTableBordersINTERNALSTORE[$i][0]
		If $array[1][1] = $test Then
			$aRetrievedTableBorders = $_aGUICtrlTableBordersINTERNALSTORE[$i][1]
			$test = $i
			ExitLoop
		EndIf
	Next

	For $i = 1 To UBound($array, 2) - 1
		$aTemp = ControlGetPos("", "", $array[$iRow][$i])
		;none = 0
		Switch $iType
			Case 0
				GUICtrlDelete($aRetrievedTableBorders[$iRow][$i][1])
				GUICtrlDelete($aRetrievedTableBorders[$iRow][$i][2])
				GUICtrlDelete($aRetrievedTableBorders[$iRow][$i][3])
				GUICtrlDelete($aRetrievedTableBorders[$iRow][$i][4])
		EndSwitch
		;left border = 1
		Switch $iType
			Case 1, 3, 5, 7, 9, 11, 13, 15
				GUICtrlDelete($aRetrievedTableBorders[$iRow][$i][1])
				$aRetrievedTableBorders[$iRow][$i][1] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1], 1, $aTemp[3])
				GUICtrlSetBkColor(-1, $iColor)
				$hLabel = GUICtrlGetHandle(-1)
				;set label to top
				DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		EndSwitch
		;top border = 2
		Switch $iType
			Case 2, 3, 6, 7, 10, 11, 14, 15
				GUICtrlDelete($aRetrievedTableBorders[$iRow][$i][2])
				$aRetrievedTableBorders[$iRow][$i][2] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1], $aTemp[2], 1)
				GUICtrlSetBkColor(-1, $iColor)
				$hLabel = GUICtrlGetHandle(-1)
				DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		EndSwitch
		;right border = 4
		Switch $iType
			Case 4, 5, 6, 7, 12, 13, 14, 15
				GUICtrlDelete($aRetrievedTableBorders[$iRow][$i][3])
				$aRetrievedTableBorders[$iRow][$i][3] = GUICtrlCreateLabel("", $aTemp[0] + $aTemp[2] - 1, $aTemp[1], 1, $aTemp[3])
				GUICtrlSetBkColor(-1, $iColor)
				$hLabel = GUICtrlGetHandle(-1)
				DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		EndSwitch
		;bottom border = 8
		Switch $iType
			Case 8, 9, 10, 11, 12, 13, 14, 15
				GUICtrlDelete($aRetrievedTableBorders[$iRow][$i][4])
				$aRetrievedTableBorders[$iRow][$i][4] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1] + $aTemp[3] - 1, $aTemp[2], 1)
				GUICtrlSetBkColor(-1, $iColor)
				$hLabel = GUICtrlGetHandle(-1)
				DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		EndSwitch
	Next

	;- Put retrieved borders back
	$_aGUICtrlTableBordersINTERNALSTORE[$test][1] = $aRetrievedTableBorders

	;refresh window (not needed?)
	;DllCall("User32.dll", "int", "InvalidateRect", "hwnd", "", "ptr", 0, "int", True)

EndFunc   ;==>_GUICtrlTable_Set_Border_Row



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Border_Column
; Description ...: Draws a border on specified column of cells
; Syntax.........: _GUICtrlTable_Set_Border_Column(ByRef $array, $iCol, $iType[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iCol - table col value
;                  $iType - left = 1, top = 2, right = 4, bottom = 8 (add values, e.g. full border = 15) NoBorder = 0
;                  $iColor - color of border to add
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; Credits .......: Authenticity (demonstrated API/dll z-order calls)
; ===========================================================================================
Func _GUICtrlTable_Set_Border_Column(ByRef $array, $iCol, $iType, $iColor = 0x000000)

	Local $hLabel, $i, $aTemp, $test, $aRetrievedTableBorders

	If IsArray($array) = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	;- Get border array from store -
	$test = ""
	For $i = 1 To UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) - 1
		$test = $_aGUICtrlTableBordersINTERNALSTORE[$i][0]
		If $array[1][1] = $test Then
			$aRetrievedTableBorders = $_aGUICtrlTableBordersINTERNALSTORE[$i][1]
			$test = $i
			ExitLoop
		EndIf
	Next

	For $i = 1 To UBound($array, 1) - 1
		$aTemp = ControlGetPos("", "", $array[$i][$iCol])
		;none = 0
		Switch $iType
			Case 0
				GUICtrlDelete($aRetrievedTableBorders[$i][$iCol][1])
				GUICtrlDelete($aRetrievedTableBorders[$i][$iCol][2])
				GUICtrlDelete($aRetrievedTableBorders[$i][$iCol][3])
				GUICtrlDelete($aRetrievedTableBorders[$i][$iCol][4])
		EndSwitch
		;left border = 1
		Switch $iType
			Case 1, 3, 5, 7, 9, 11, 13, 15
				GUICtrlDelete($aRetrievedTableBorders[$i][$iCol][1])
				$aRetrievedTableBorders[$i][$iCol][1] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1], 1, $aTemp[3])
				GUICtrlSetBkColor(-1, $iColor)
				$hLabel = GUICtrlGetHandle(-1)
				;set label to top
				DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		EndSwitch
		;top border = 2
		Switch $iType
			Case 2, 3, 6, 7, 10, 11, 14, 15
				GUICtrlDelete($aRetrievedTableBorders[$i][$iCol][2])
				$aRetrievedTableBorders[$i][$iCol][2] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1], $aTemp[2], 1)
				GUICtrlSetBkColor(-1, $iColor)
				$hLabel = GUICtrlGetHandle(-1)
				DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		EndSwitch
		;right border = 4
		Switch $iType
			Case 4, 5, 6, 7, 12, 13, 14, 15
				GUICtrlDelete($aRetrievedTableBorders[$i][$iCol][3])
				$aRetrievedTableBorders[$i][$iCol][3] = GUICtrlCreateLabel("", $aTemp[0] + $aTemp[2] - 1, $aTemp[1], 1, $aTemp[3])
				GUICtrlSetBkColor(-1, $iColor)
				$hLabel = GUICtrlGetHandle(-1)
				DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		EndSwitch
		;bottom border = 8
		Switch $iType
			Case 8, 9, 10, 11, 12, 13, 14, 15
				GUICtrlDelete($aRetrievedTableBorders[$i][$iCol][4])
				$aRetrievedTableBorders[$i][$iCol][4] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1] + $aTemp[3] - 1, $aTemp[2], 1)
				GUICtrlSetBkColor(-1, $iColor)
				$hLabel = GUICtrlGetHandle(-1)
				DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
		EndSwitch

	Next

	;- Put retrieved borders back
	$_aGUICtrlTableBordersINTERNALSTORE[$test][1] = $aRetrievedTableBorders

	;refresh window
	;DllCall("User32.dll", "int", "InvalidateRect", "hwnd", "", "ptr", 0, "int", True)

EndFunc   ;==>_GUICtrlTable_Set_Border_Column



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Border_Cell
; Description ...: Draws a border on specified cell
; Syntax.........: _GUICtrlTable_Set_Border_Cell(ByRef $array, $iRow, $iCol, $iType[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iRow - cell row value
;                  $iCol - cell col value
;                  $iType - left = 1, top = 2, right = 4, bottom = 8 (add values, e.g. full border = 15) NoBorder = 0
;                  $iColor - color of border to add
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; Credits .......: Authenticity (demonstrated API/dll z-order calls)
; ===========================================================================================
Func _GUICtrlTable_Set_Border_Cell(ByRef $array, $iRow, $iCol, $iType, $iColor = 0x000000)

	Local $hLabel, $aTemp, $test, $aRetrievedTableBorders, $i

	If IsArray($array) = 0 Then Return
	If $iRow = 0 Then Return
	If $iCol = 0 Then Return
	If Number($iRow) > UBound($array, 1) - 1 Then Return
	If Number($iCol) > UBound($array, 2) - 1 Then Return

	;- Get border array from store -
	$test = ""
	For $i = 1 To UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) - 1
		$test = $_aGUICtrlTableBordersINTERNALSTORE[$i][0]
		If $array[1][1] = $test Then
			$aRetrievedTableBorders = $_aGUICtrlTableBordersINTERNALSTORE[$i][1]
			$test = $i
			ExitLoop
		EndIf
	Next

	$aTemp = ControlGetPos("", "", $array[$iRow][$iCol])

	;none = 0
	Switch $iType
		Case 0
			GUICtrlDelete($aRetrievedTableBorders[$iRow][$iCol][1])
			GUICtrlDelete($aRetrievedTableBorders[$iRow][$iCol][2])
			GUICtrlDelete($aRetrievedTableBorders[$iRow][$iCol][3])
			GUICtrlDelete($aRetrievedTableBorders[$iRow][$iCol][4])
	EndSwitch
	;left border = 1
	Switch $iType
		Case 1, 3, 5, 7, 9, 11, 13, 15
			GUICtrlDelete($aRetrievedTableBorders[$iRow][$iCol][1])
			$aRetrievedTableBorders[$iRow][$iCol][1] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1], 1, $aTemp[3])
			GUICtrlSetBkColor(-1, $iColor)
			$hLabel = GUICtrlGetHandle(-1)
			;set label to top
			DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
	EndSwitch
	;top border = 2
	Switch $iType
		Case 2, 3, 6, 7, 10, 11, 14, 15
			GUICtrlDelete($aRetrievedTableBorders[$iRow][$iCol][2])
			$aRetrievedTableBorders[$iRow][$iCol][2] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1], $aTemp[2], 1)
			GUICtrlSetBkColor(-1, $iColor)
			$hLabel = GUICtrlGetHandle(-1)
			DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
	EndSwitch
	;right border = 4
	Switch $iType
		Case 4, 5, 6, 7, 12, 13, 14, 15
			GUICtrlDelete($aRetrievedTableBorders[$iRow][$iCol][3])
			$aRetrievedTableBorders[$iRow][$iCol][3] = GUICtrlCreateLabel("", $aTemp[0] + $aTemp[2] - 1, $aTemp[1], 1, $aTemp[3])
			GUICtrlSetBkColor(-1, $iColor)
			$hLabel = GUICtrlGetHandle(-1)
			DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
	EndSwitch
	;bottom border = 8
	Switch $iType
		Case 8, 9, 10, 11, 12, 13, 14, 15
			GUICtrlDelete($aRetrievedTableBorders[$iRow][$iCol][4])
			$aRetrievedTableBorders[$iRow][$iCol][4] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1] + $aTemp[3] - 1, $aTemp[2], 1)
			GUICtrlSetBkColor(-1, $iColor)
			$hLabel = GUICtrlGetHandle(-1)
			DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
	EndSwitch

	;- Put retrieved borders back
	$_aGUICtrlTableBordersINTERNALSTORE[$test][1] = $aRetrievedTableBorders

	;refresh window
	;DllCall("User32.dll", "int", "InvalidateRect", "hwnd", "", "ptr", 0, "int", True)

EndFunc   ;==>_GUICtrlTable_Set_Border_Cell



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Border_All
; Description ...: Draws a border on all cells in table
; Syntax.........: _GUICtrlTable_Set_Border_Cell(ByRef $array, iType[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iType - left = 1, top = 2, right = 4, bottom = 8 (add values, e.g. full border = 15) NoBorder = 0
;                  $iColor - color of border to add
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; Credits .......: Authenticity (demonstrated API/dll z-order calls)
; ===========================================================================================
Func _GUICtrlTable_Set_Border_All(ByRef $array, $iType, $iColor = 0x000000)

	Local $hLabel, $i, $aTemp, $test, $aRetrievedTableBorders

	If IsArray($array) = 0 Then Return

	;- Get border array from store -
	$test = ""
	For $i = 1 To UBound($_aGUICtrlTableBordersINTERNALSTORE, 1) - 1
		$test = $_aGUICtrlTableBordersINTERNALSTORE[$i][0]
		If $array[1][1] = $test Then
			$aRetrievedTableBorders = $_aGUICtrlTableBordersINTERNALSTORE[$i][1]
			$test = $i
			ExitLoop
		EndIf
	Next

	For $i = 1 To UBound($array, 1) - 1
		For $j = 1 To UBound($array, 2) - 1
			$aTemp = ControlGetPos("", "", $array[$i][$j])
			;none = 0
			Switch $iType
				Case 0
					GUICtrlDelete($aRetrievedTableBorders[$i][$j][1])
					GUICtrlDelete($aRetrievedTableBorders[$i][$j][2])
					GUICtrlDelete($aRetrievedTableBorders[$i][$j][3])
					GUICtrlDelete($aRetrievedTableBorders[$i][$j][4])
			EndSwitch
			;left border = 1
			Switch $iType
				Case 1, 3, 5, 7, 9, 11, 13, 15
					GUICtrlDelete($aRetrievedTableBorders[$i][$j][1])
					$aRetrievedTableBorders[$i][$j][1] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1], 1, $aTemp[3])
					GUICtrlSetBkColor(-1, $iColor)
					$hLabel = GUICtrlGetHandle(-1)
					;set label to top
					DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
			EndSwitch
			;top border = 2
			Switch $iType
				Case 2, 3, 6, 7, 10, 11, 14, 15
					GUICtrlDelete($aRetrievedTableBorders[$i][$j][2])
					$aRetrievedTableBorders[$i][$j][2] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1], $aTemp[2], 1)
					GUICtrlSetBkColor(-1, $iColor)
					$hLabel = GUICtrlGetHandle(-1)
					DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
			EndSwitch
			;right border = 4
			Switch $iType
				Case 4, 5, 6, 7, 12, 13, 14, 15
					GUICtrlDelete($aRetrievedTableBorders[$i][$j][3])
					$aRetrievedTableBorders[$i][$j][3] = GUICtrlCreateLabel("", $aTemp[0] + $aTemp[2] - 1, $aTemp[1], 1, $aTemp[3])
					GUICtrlSetBkColor(-1, $iColor)
					$hLabel = GUICtrlGetHandle(-1)
					DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
			EndSwitch
			;bottom border = 8
			Switch $iType
				Case 8, 9, 10, 11, 12, 13, 14, 15
					GUICtrlDelete($aRetrievedTableBorders[$i][$j][4])
					$aRetrievedTableBorders[$i][$j][4] = GUICtrlCreateLabel("", $aTemp[0], $aTemp[1] + $aTemp[3] - 1, $aTemp[2], 1)
					GUICtrlSetBkColor(-1, $iColor)
					$hLabel = GUICtrlGetHandle(-1)
					DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hLabel, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", 3)
			EndSwitch
		Next
	Next

	;- Put retrieved borders back
	$_aGUICtrlTableBordersINTERNALSTORE[$test][1] = $aRetrievedTableBorders

	;refresh window
	;DllCall("User32.dll", "int", "InvalidateRect", "hwnd", "", "ptr", 0, "int", True)

EndFunc   ;==>_GUICtrlTable_Set_Border_All



; #FUNCTION# ;===============================================================================
; Name...........: _GUICtrlTable_Set_Border_Table
; Description ...: Draws a border around the whole table
; Syntax.........: _GUICtrlTable_Set_Border_Table(ByRef $array[, $iColor = 0x000000])
; Parameters ....: $array - array returned from _GUICtrlTable_Create
;                  $iColor - color of border to add
; Return values .: Success - (under construction)
;                  Failure - (under construction)
; Author ........: AndyBiochem
; ===========================================================================================
Func _GUICtrlTable_Set_Border_Table(ByRef $array, $iColor = 0x000000)

	If IsArray($array) = 0 Then Return

	_GUICtrlTable_Set_Border_Row($array, 1, 2, $iColor)
	_GUICtrlTable_Set_Border_Row($array, UBound($array, 1) - 1, 8, $iColor)
	_GUICtrlTable_Set_Border_Column($array, 1, 1, $iColor)
	_GUICtrlTable_Set_Border_Column($array, UBound($array, 2) - 1, 4, $iColor)

EndFunc   ;==>_GUICtrlTable_Set_Border_Table
