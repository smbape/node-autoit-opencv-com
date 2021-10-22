#include-once

; @addtogroup core_hal_interface
; @{

; @name Return codes
; @{
Global Const $CV_HAL_ERROR_OK = 0
Global Const $CV_HAL_ERROR_NOT_IMPLEMENTED = 1
Global Const $CV_HAL_ERROR_UNKNOWN = -1
; @}

; @name Data types
; primitive types
; - schar  - signed 1 byte integer
; - uchar  - unsigned 1 byte integer
; - short  - signed 2 byte integer
; - ushort - unsigned 2 byte integer
; - int    - signed 4 byte integer
; - uint   - unsigned 4 byte integer
; - int64  - signed 8 byte integer
; - uint64 - unsigned 8 byte integer
; @{
Global Const $CV_CN_MAX = 512
Global Const $CV_CN_SHIFT = 3
Global Const $CV_DEPTH_MAX = BitShift(1, -$CV_CN_SHIFT)

Global Const $CV_8U = 0
Global Const $CV_8S = 1
Global Const $CV_16U = 2
Global Const $CV_16S = 3
Global Const $CV_32S = 4
Global Const $CV_32F = 5
Global Const $CV_64F = 6
Global Const $CV_16F = 7

Global Const $CV_MAT_DEPTH_MASK = $CV_DEPTH_MAX - 1

Func CV_MAT_DEPTH($flags)
	Return BitAND($flags, $CV_MAT_DEPTH_MASK)
EndFunc   ;==>CV_MAT_DEPTH

Func CV_MAKETYPE($depth, $cn)
	Return CV_MAT_DEPTH($depth) + BitShift($cn - 1, -$CV_CN_SHIFT)
EndFunc   ;==>CV_MAKETYPE

Global Const $CV_8UC1 = CV_MAKETYPE($CV_8U, 1)
Global Const $CV_8UC2 = CV_MAKETYPE($CV_8U, 2)
Global Const $CV_8UC3 = CV_MAKETYPE($CV_8U, 3)
Global Const $CV_8UC4 = CV_MAKETYPE($CV_8U, 4)

Func CV_8UC($n)
	Return CV_MAKETYPE($CV_8U, $n)
EndFunc   ;==>CV_8UC

Global Const $CV_8SC1 = CV_MAKETYPE($CV_8S, 1)
Global Const $CV_8SC2 = CV_MAKETYPE($CV_8S, 2)
Global Const $CV_8SC3 = CV_MAKETYPE($CV_8S, 3)
Global Const $CV_8SC4 = CV_MAKETYPE($CV_8S, 4)

Func CV_8SC($n)
	Return CV_MAKETYPE($CV_8S, $n)
EndFunc   ;==>CV_8SC

Global Const $CV_16UC1 = CV_MAKETYPE($CV_16U, 1)
Global Const $CV_16UC2 = CV_MAKETYPE($CV_16U, 2)
Global Const $CV_16UC3 = CV_MAKETYPE($CV_16U, 3)
Global Const $CV_16UC4 = CV_MAKETYPE($CV_16U, 4)

Func CV_16UC($n)
	Return CV_MAKETYPE($CV_16U, $n)
EndFunc   ;==>CV_16UC

Global Const $CV_16SC1 = CV_MAKETYPE($CV_16S, 1)
Global Const $CV_16SC2 = CV_MAKETYPE($CV_16S, 2)
Global Const $CV_16SC3 = CV_MAKETYPE($CV_16S, 3)
Global Const $CV_16SC4 = CV_MAKETYPE($CV_16S, 4)

Func CV_16SC($n)
	Return CV_MAKETYPE($CV_16S, $n)
EndFunc   ;==>CV_16SC

Global Const $CV_32SC1 = CV_MAKETYPE($CV_32S, 1)
Global Const $CV_32SC2 = CV_MAKETYPE($CV_32S, 2)
Global Const $CV_32SC3 = CV_MAKETYPE($CV_32S, 3)
Global Const $CV_32SC4 = CV_MAKETYPE($CV_32S, 4)

Func CV_32SC($n)
	Return CV_MAKETYPE($CV_32S, $n)
EndFunc   ;==>CV_32SC

Global Const $CV_32FC1 = CV_MAKETYPE($CV_32F, 1)
Global Const $CV_32FC2 = CV_MAKETYPE($CV_32F, 2)
Global Const $CV_32FC3 = CV_MAKETYPE($CV_32F, 3)
Global Const $CV_32FC4 = CV_MAKETYPE($CV_32F, 4)

Func CV_32FC($n)
	Return CV_MAKETYPE($CV_32F, $n)
EndFunc   ;==>CV_32FC

Global Const $CV_64FC1 = CV_MAKETYPE($CV_64F, 1)
Global Const $CV_64FC2 = CV_MAKETYPE($CV_64F, 2)
Global Const $CV_64FC3 = CV_MAKETYPE($CV_64F, 3)
Global Const $CV_64FC4 = CV_MAKETYPE($CV_64F, 4)

Func CV_64FC($n)
	Return CV_MAKETYPE($CV_64F, $n)
EndFunc   ;==>CV_64FC

Global Const $CV_16FC1 = CV_MAKETYPE($CV_16F, 1)
Global Const $CV_16FC2 = CV_MAKETYPE($CV_16F, 2)
Global Const $CV_16FC3 = CV_MAKETYPE($CV_16F, 3)
Global Const $CV_16FC4 = CV_MAKETYPE($CV_16F, 4)

Func CV_16FC($n)
	Return CV_MAKETYPE($CV_16F, $n)
EndFunc   ;==>CV_16FC
; @}

; @name Comparison operation
; @sa cv::CmpTypes
; @{
Global Const $CV_HAL_CMP_EQ = 0
Global Const $CV_HAL_CMP_GT = 1
Global Const $CV_HAL_CMP_GE = 2
Global Const $CV_HAL_CMP_LT = 3
Global Const $CV_HAL_CMP_LE = 4
Global Const $CV_HAL_CMP_NE = 5
; @}

; @name Border processing modes
; @sa cv::BorderTypes
; @{
Global Const $CV_HAL_BORDER_CONSTANT = 0
Global Const $CV_HAL_BORDER_REPLICATE = 1
Global Const $CV_HAL_BORDER_REFLECT = 2
Global Const $CV_HAL_BORDER_WRAP = 3
Global Const $CV_HAL_BORDER_REFLECT_101 = 4
Global Const $CV_HAL_BORDER_TRANSPARENT = 5
Global Const $CV_HAL_BORDER_ISOLATED = 16
; @}

; @name DFT flags
; @{
Global Const $CV_HAL_DFT_INVERSE = 1
Global Const $CV_HAL_DFT_SCALE = 2
Global Const $CV_HAL_DFT_ROWS = 4
Global Const $CV_HAL_DFT_COMPLEX_OUTPUT = 16
Global Const $CV_HAL_DFT_REAL_OUTPUT = 32
Global Const $CV_HAL_DFT_TWO_STAGE = 64
Global Const $CV_HAL_DFT_STAGE_COLS = 128
Global Const $CV_HAL_DFT_IS_CONTINUOUS = 512
Global Const $CV_HAL_DFT_IS_INPLACE = 1024
; @}

; @name SVD flags
; @{
Global Const $CV_HAL_SVD_NO_UV = 1
Global Const $CV_HAL_SVD_SHORT_UV = 2
Global Const $CV_HAL_SVD_MODIFY_A = 4
Global Const $CV_HAL_SVD_FULL_UV = 8
; @}

; @name Gemm flags
; @{
Global Const $CV_HAL_GEMM_1_T = 1
Global Const $CV_HAL_GEMM_2_T = 2
Global Const $CV_HAL_GEMM_3_T = 4
; @}

; @}


Global Const $CV_MAT_CN_MASK = BitShift($CV_CN_MAX - 1, -$CV_CN_SHIFT)

Func CV_MAT_CN($flags)
	Return BitShift(BitAND($flags, $CV_MAT_CN_MASK), $CV_CN_SHIFT) + 1
EndFunc   ;==>CV_MAT_CN

Global Const $CV_MAT_TYPE_MASK = $CV_DEPTH_MAX * $CV_CN_MAX - 1

Func CV_MAT_TYPE($flags)
	Return BitAND($flags, $CV_MAT_TYPE_MASK)
EndFunc   ;==>CV_MAT_TYPE

Global Const $CV_MAT_CONT_FLAG_SHIFT = 14
Global Const $CV_MAT_CONT_FLAG = BitShift(1, -$CV_MAT_CONT_FLAG_SHIFT)

Func CV_IS_MAT_CONT($flags)
	Return BitAND($flags, $CV_MAT_CONT_FLAG)
EndFunc   ;==>CV_IS_MAT_CONT

Global Const $CV_SUBMAT_FLAG_SHIFT = 15
Global Const $CV_SUBMAT_FLAG = BitShift(1, -$CV_SUBMAT_FLAG_SHIFT)

Func CV_IS_SUBMAT($flags)
	Return BitAND($flags, $CV_SUBMAT_FLAG)
EndFunc   ;==>CV_IS_SUBMAT
