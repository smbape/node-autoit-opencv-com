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

$DNN_ROOT_PATH = _OpenCV_FindFile -Path "samples/dnn" -SearchPaths @(
    "opencv\sources"
    "opencv-4.11.0-*\opencv\sources"
)

$SAMPLES_PATH = _OpenCV_FindFile -Path "samples"
$PYTHON_VENV_PATH = Join-Path $SAMPLES_PATH ".venv"

if (!(Test-Path -Path $PYTHON_VENV_PATH)) {
    foreach($exe in (where.exe "$Python")) {
        $PythonCmd = Get-Command "$exe"
        break
    }

    Write-Host "$($PythonCmd.Source) -m venv $PYTHON_VENV_PATH"
    & $PythonCmd.Source -m venv "$PYTHON_VENV_PATH"
    attrib +h "$PYTHON_VENV_PATH"

    # Activate venv
    & "$PYTHON_VENV_PATH\Scripts\Activate.ps1"

    python -m pip install --upgrade pip
    python -m pip install --upgrade opencv-python PyYAML requests
} else {
    # Activate venv
    & "$PYTHON_VENV_PATH\Scripts\Activate.ps1"
}

if (!(Test-Path -Path $Destination)) {
    mkdir $Destination
}
cd "$Destination"

$Env:PYTHONPATH = "$DNN_ROOT_PATH"
$script = Join-Path $PSScriptRoot download_model.py
python $script $Model --zoo $Zoo
