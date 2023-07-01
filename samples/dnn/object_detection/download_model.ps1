#requires -version 5.0

[CmdletBinding()]
param (
    [Parameter(Position=0, Mandatory)][string] $Model,
    [Parameter(Position=1)][string] $Destination = "",
    [string] $Zoo =  "",
    [string] $Python = "python",
    [boolean] $Force = $False
)
# "powershell.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"
# "pwsh.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0
trap { throw $Error[0] }

Import-Module "$PSScriptRoot/../../dotnet/opencv_utils.psm1"

if ([string]::IsNullOrEmpty($Destination)) {
    $Destination = Join-Path $PSScriptRoot "models"
}

if ([string]::IsNullOrEmpty($Zoo)) {
    $Zoo = Join-Path $PSScriptRoot "models.yml"
}

function DownloadYOLOv5() {
    $onnx =[System.IO.Path]::GetFullPath("$Destination/$Model.onnx")

    if ((Test-Path -Path "$onnx") -and -not $Force) {
        $onnx
        return
    }

    if (!(Test-Path -Path "$Destination/yolov5")) {
        git clone "https://github.com/ultralytics/yolov5" "$Destination/yolov5"
        & cd "$Destination/yolov5"
        python -m pip install -r requirements.txt
    }

    python "$Destination/yolov5/export.py" --include onnx --opset 12 --weights "$Model.pt"
    $onnx
}

function DownloadYOLOv8() {
    $onnx =[System.IO.Path]::GetFullPath("$Destination/$Model.onnx")

    if ((Test-Path -Path "$onnx") -and -not $Force) {
        $onnx
        return
    }

    pip install ultralytics
    yolo export model=$Model.pt imgsz=640 format=onnx opset=12
    $onnx
}

$DNN_ROOT_PATH = _OpenCV_FindFile -Path "samples/dnn" -SearchPaths @(
    "opencv\sources"
    "opencv-4.8.0-*\opencv\sources"
)

$SAMPLES_PATH = _OpenCV_FindFile -Path "samples"
$PYTHON_VENV_PATH = Join-Path $SAMPLES_PATH ".venv"

foreach($exe in (where.exe "$Python")) {
    $PythonCmd = Get-Command "$exe"
    # Torch is not yet supported on windows python 3.11
    if ($PythonCmd.Version.Major -ne 3 -or $PythonCmd.Version.Minor -ne 11) {
        break
    }
}

if (!(Test-Path -Path $PYTHON_VENV_PATH)) {
    Write-Host "$($PythonCmd.Source) -m venv $PYTHON_VENV_PATH"
    & $PythonCmd.Source -m venv "$PYTHON_VENV_PATH"
    attrib +h "$PYTHON_VENV_PATH"

    # Activate venv
    & "$PYTHON_VENV_PATH\Scripts\Activate.ps1"

    python -m pip install --upgrade pip
    pip install opencv-python PyYAML requests
} else {
    # Activate venv
    & "$PYTHON_VENV_PATH\Scripts\Activate.ps1"
}

if (!(Test-Path -Path $Destination)) {
    mkdir $Destination
}
cd "$Destination"

if ($Model.StartsWith("yolov5")) {
    DownloadYOLOv5
} elseif ($Model.StartsWith("yolov8")) {
    DownloadYOLOv8
} else {
    $Env:PYTHONPATH = "$DNN_ROOT_PATH"
    $script = Join-Path $PSScriptRoot download_model.py
    python $script $Model --zoo $Zoo
}
