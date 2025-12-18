# Build Utilities Module
# Common utility functions for build scripts

function Write-Info { param($msg); Write-Host $msg -ForegroundColor Blue }
function Write-Success { param($msg); Write-Host $msg -ForegroundColor Green }
function Write-Error { param($msg); Write-Host $msg -ForegroundColor Red }
function Write-Warning { param($msg); Write-Host $msg -ForegroundColor Yellow }

function Convert-ToLinmSoftFormat {
    param($AppName)
    # Convert app name to linm.soft format
    $cleanName = $AppName.ToLower() -replace '[^a-z0-9]', ''
    return "linm.soft.$cleanName"
}

Write-Verbose "Loaded: build-utils.ps1"