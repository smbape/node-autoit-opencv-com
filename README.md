# OpenCV autoit udf

Do you want to use [OpenCV](https://opencv.org/) v4+ in [AutoIt v3](https://www.autoitscript.com/) ?  
If yes, then this udf might be for you.

In fact, the dll being a [Component Object Model (COM)](https://docs.microsoft.com/en-us/windows/win32/com/the-component-object-model) dll, it can be used in any client dans can use COM components. For example [Office VBA](https://docs.microsoft.com/en-us/office/vba/api/overview/), [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2).

# Usage of the UDF

## Prerequisites

  - Download and extract [opencv-4.5.4-vc14_vc15.exe](https://sourceforge.net/projects/opencvlibrary/files/4.5.4/opencv-4.5.4-vc14_vc15.exe/download) into a folder
  - Download and extract [autoit-opencv-4.5.4-com-v1.2.1-rc.0.7z](https://github.com/smbape/node-autoit-opencv-com/releases/download/v1.2.1-rc.0/autoit-opencv-4.5.4-com-v1.2.1-rc.0.7z) into a folder

## Usage

### AutoIt

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_OpenCV_Open_And_Register("opencv-4.5.4-vc14_vc15\opencv\build\x64\vc15\bin\opencv_world454.dll", "autoit-opencv-com\autoit_opencv_com454.dll")
Example()
_OpenCV_Unregister_And_Close()

Func Example()
  Local $cv = _OpenCV_get()
  If Not IsObj($cv) Then Return

  Local $img = _OpenCV_imread_and_check(_OpenCV_FindFile("samples\data\lena.jpg"))
  $cv.imshow("Image", $img)
  $cv.waitKey()
  $cv.destroyAllWindows()
EndFunc   ;==>Example
```

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "autoit-opencv-com\udf\opencv_udf_utils.au3"
#include <GUIConstantsEx.au3>

_OpenCV_Open_And_Register("opencv-4.5.4-vc14_vc15\opencv\build\x64\vc15\bin\opencv_world454.dll", "autoit-opencv-com\autoit_opencv_com454.dll")
Example()
_OpenCV_Unregister_And_Close()

Func Example()
  Local $cv = _OpenCV_get()
  If Not IsObj($cv) Then Return

  #Region ### START Koda GUI section ### Form=
  Local $FormGUI = GUICreate("show image in autoit gui", 400, 400, 200, 200)
  Local $Pic = GUICtrlCreatePic("", 0, 0, 400, 400)
  GUISetState(@SW_SHOW)
  #EndRegion ### END Koda GUI section ###

  Local $img = _OpenCV_imread_and_check(_OpenCV_FindFile("samples\data\lena.jpg"))

  _OpenCV_imshow_ControlPic($img, $FormGUI, $Pic)

  Local $nMsg
  While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
      Case $GUI_EVENT_CLOSE
        ExitLoop
    EndSwitch
  WEnd

  $cv.destroyAllWindows()
EndFunc   ;==>Example
```

### PowerShell

```powershell
# Opencv bin dir must be in your path and you must have registered the autoit_opencv_com454.dll dll

function _OpenCV_ObjCreate($sClassname) {
    New-Object -ComObject "OpenCV.$sClassname"
}

function Example1() {
    $cv = _OpenCV_ObjCreate("cv")
    $img = $cv.imread("samples\data\lena.jpg")
    $cv.imshow("image", $img)
    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

Example1
```

## Running examples

```sh
# download autoit-opencv-4.5.4-com-v1.2.1-rc.0.7z
curl -L 'https://github.com/smbape/node-autoit-opencv-com/releases/download/v1.2.1-rc.0/autoit-opencv-4.5.4-com-v1.2.1-rc.0.7z' -o autoit-opencv-4.5.4-com-v1.2.1-rc.0.7z

# extract autoit-opencv-4.5.4-com-v1.2.1-rc.0.7z
7z x autoit-opencv-4.5.4-com-v1.2.1-rc.0.7z -aoa -oautoit-opencv-com

# download opencv-4.5.4-vc14_vc15.exe
curl -L 'https://github.com/opencv/opencv/releases/download/4.5.4/opencv-4.5.4-vc14_vc15.exe' -o opencv-4.5.4-vc14_vc15.exe

# extract opencv-4.5.4-vc14_vc15.exe 
./opencv-4.5.4-vc14_vc15.exe -oopencv-4.5.4-vc14_vc15 -y

# download the source files
curl -L 'https://github.com/smbape/node-autoit-opencv-com/archive/refs/tags/v1.2.1-rc.0.zip' -o autoit-opencv-4.5.4-com-v1.2.1-rc.0-src.zip

# extract autoit-opencv-4.5.4-com-v1.2.1-rc.0-src.zip
7z x autoit-opencv-4.5.4-com-v1.2.1-rc.0-src.zip -aoa 'node-autoit-opencv-com-1.2.1-rc.0\autoit-addon\*' 'node-autoit-opencv-com-1.2.1-rc.0\samples\*'
mkdir -p autoit-opencv-com
cp -rf node-autoit-opencv-com-1.2.1-rc.0/* ./
rm -rf node-autoit-opencv-com-1.2.1-rc.0
```

Now you can run any file in the `samples\tutorial_code` folder.

### \[optional\] Build the addon dll

This shows how to put performance critical tasks in c++ functions, export those functions in a dll and then use them in autoit.

Look at `samples\tutorial_code\Histograms_Matching\calcHist_Demo.au3` for an example of usage.

#### Prerequisite

  - Install [CMAKE >= 3.5](https://cmake.org/download/)
  - Install [visual studio >= 10](https://visualstudio.microsoft.com/vs/community/)

#### Building

Run `build.bat` script located in the `autoit-addon` folder. 

## How to translate python/c++ code to the UDF

The transformation will usually be straight from python.

The translation usually involves 3 steps:

  - Finding the functions/constants names.
  - Transform the parameter types according to the UDF parameter. This step might involve looking at the [opencv documentation](https://docs.opencv.org/4.5.4/index.html).
  - Adjust the parameter order. This step might involve looking at the [opencv documentation](https://docs.opencv.org/4.5.4/index.html).

### Finding the functions/constants names

For a function named **foo**, there is usually a function named **foo**

For a constant **FOO**, there is usually a Global Const ending with `_FOO` and starting with `$CV_`.

Look into `cv_enums.au3` to find and `cv_interface.au3` to search for constants.

### Transform the parameter types

For **cv::Point**, **cv::Range**, **cv::Rect**, **cv::Scalar** and **cv::Size** types,  
there are `_OpenCV_`**Point**, `_OpenCV_`**Range**, `_OpenCV_`**Rect**, `_OpenCV_`**Scalar** and `_OpenCV_`**Size** functions to convert parameters.

For **cv::ScalarAll**, there is **\_OpenCV_ScalarAll** function.

Types which are **\*OfArrays** like **InputArrayOfArrays**, are harder to translate because in AutoIt they are all Arrays or `VARIANT`.  
It is always safe to use a `VectorOfMat` for those types.

However, if you really need to, transform an Array in a typed Array with the corresponding `VectorOf` constructor.  
For example, to transform an Array of `Int` to a `VectorOfInt`, do

```autoit
Local $aInt[3] = [1, 2, 3]
Local $oVectorOfInt = ObjCreate("OpenCV.VectorOfInt").create($aInt)
```

### Adjust the parameter order

Parameters which are **OutputArray** or **OutputArrayOfArrays** will be at the end in the order of appearance.  
They will also be available in the $cv.extended Array in the order of appearance.  
Simply put, everything that is returned by python is available in $cv.extended

### Python translation example

Let's translate the following python code
```python
blurred = cv2.GaussianBlur(image, (3, 3), 0)
T, thresh_img = cv2.threshold(blurred, 215, 255, cv2.THRESH_BINARY)
cnts, _ = cv2.findContours(thresh_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
```

#### First line

```python
blurred = cv2.GaussianBlur(image, (3, 3), 0)
```

The [GaussianBlur](https://docs.opencv.org/4.5.4/d4/d86/group__imgproc__filter.html#gaabe8c836e97159a9193fb0b11ac52cf1) documentation gives the following information
```txt
void cv::GaussianBlur   (   InputArray    src,
    OutputArray   dst,
    Size    ksize,
    double    sigmaX,
    double    sigmaY = 0,
    int   borderType = BORDER_DEFAULT 
  )     
Python:
  cv.GaussianBlur(  src, ksize, sigmaX[, dst[, sigmaY[, borderType]]] ) ->  dst

```

`dst` is an output array. It will be therefore put at the end and returned.  

The AutoIt version of the function is
```txt
AutoIt:
  cv.GaussianBlur(  src, ksize, sigmaX[, sigmaY[, borderType[, dst]]] ) ->  dst
```

The python code will therefore become
```autoit
$blurred = $cv.GaussianBlur($image, _OpenCV_Size(3, 3), 0)
```

#### Second line

```python
T, thresh_img = cv2.threshold(blurred, 215, 255, cv2.THRESH_BINARY)
```

The [threshold](https://docs.opencv.org/4.5.4/d7/d1b/group__imgproc__misc.html#gae8a4a146d1ca78c626a53577199e9c57) documentation gives the following information
```txt
double cv::threshold  (   InputArray    src,
    OutputArray   dst,
    double    thresh,
    double    maxval,
    int   type 
  )     
Python:
  cv.threshold( src, thresh, maxval, type[, dst]  ) ->  retval, dst

```

The AutoIt version of the function is
```txt
AutoIt:
  cv.threshold( src, thresh, maxval, type[, dst]  ) ->  retval, dst
```

Applying the same steps leads to

```autoit
$T = $cv.threshold($blurred, 215, 255, $CV_THRESH_BINARY)
$thresh_img = $cv.extended[1]

; Or

$thresh_img = ObjCreate("OpenCV.cv.Mat")
$T = $cv.threshold($blurred, 215, 255, $CV_THRESH_BINARY, $thresh_img)

; Or

$cv.threshold($blurred, 215, 255, $CV_THRESH_BINARY)
$T = $cv.extended[0]
$thresh_img = $cv.extended[1]

```

#### Third line

```python
cnts, _ = cv2.findContours(thresh_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
```

The [findContours](https://docs.opencv.org/4.5.4/d3/dc0/group__imgproc__shape.html#gadf1ad6a0b82947fa1fe3c3d497f260e0) documentation gives the following information
```txt
void cv::findContours   (   InputArray    image,
    OutputArrayOfArrays   contours,
    OutputArray   hierarchy,
    int   mode,
    int   method,
    Point   offset = Point() 
  )     
Python:
  cv.findContours(  image, mode, method[, contours[, hierarchy[, offset]]]  ) ->  contours, hierarchy
```

The AutoIt version of the function is
```txt
AutoIt:
  cv.findContours(  image, mode, method[, offset[, contours[, hierarchy]]]  ) ->  contours, hierarchy
```

The python code will become
```autoit
$cnts = $cv.findContours($thresh_img, $CV_RETR_EXTERNAL, $CV_CHAIN_APPROX_SIMPLE)
$_ = $cv.extended[1]
```

#### Final result

Python
```python
blurred = cv2.GaussianBlur(image, (3, 3), 0)
T, thresh_img = cv2.threshold(blurred, 215, 255, cv2.THRESH_BINARY)
cnts, _ = cv2.findContours(thresh_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
```

AutoIt
```autoit
$blurred = $cv.GaussianBlur($image, _OpenCV_Size(3, 3), 0)

$T = $cv.threshold($blurred, 215, 255, $CV_THRESH_BINARY)
$thresh_img = $cv.extended[1]

$cnts = $cv.findContours($thresh_img, $CV_RETR_EXTERNAL, $CV_CHAIN_APPROX_SIMPLE)
$_ = $cv.extended[1]
```

## Developpement

### Prerequisites

  - Install [CMAKE >= 3.5](https://cmake.org/download/)
  - Install [visual studio >= 2017](https://visualstudio.microsoft.com/vs/community/)
  - Install [Git for Windows](https://gitforwindows.org/)
  - Install [nodejs](https://nodejs.org/en/download/)
  - Install [Python >= 3.8](https://www.python.org/downloads/)

### Environment

In Git BASH, excute the following commands

```sh
# get the source files
git clone https://github.com/smbape/node-autoit-opencv-com
cd node-autoit-opencv-com

# Install nodejs dependencies
npm ci

# download opencv-4.5.4
curl -L 'https://github.com/opencv/opencv/releases/download/4.5.4/opencv-4.5.4-vc14_vc15.exe' -o opencv-4.5.4-vc14_vc15.exe
./opencv-4.5.4-vc14_vc15.exe -oopencv-4.5.4-vc14_vc15 -y
```

### Generate the UDF files

```sh
cmd.exe //c 'autoit-opencv-com\build.bat'
```

## History

A [previous attempt](https://github.com/smbape/node-emgucv-autoit-generator) to bring OpenCV usage to AutoIt was functionnal but not practical.  
The user has to know too much information before correctly use the UDF.

This is an attempt to make the usage of OpenCV less painfull in AutoIt
