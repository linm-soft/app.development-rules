# Smart Call Block - Build App Script (Modular Version)
# Version: 5.0 (Modular)
# Purpose: Build automation for Android/iOS apps with workspace detection

param(
    [string]$AppName = "",
    [string]$Version = "",
    [string]$Type = "",
    [switch]$Help,
    [switch]$QuickBuild,
    [switch]$ShowVersion
)

# Load required modules
$ModulePath = Split-Path $MyInvocation.MyCommand.Path
Write-Host "Loading modules from: $ModulePath\modules\"

# Load modules in correct order (utilities first)
try {
    . "$ModulePath\modules\build-utils.ps1"
    . "$ModulePath\modules\build-functions.ps1"
    . "$ModulePath\modules\app-detection.ps1"
    . "$ModulePath\modules\build-core.ps1"
    Write-Host "All modules loaded successfully" -ForegroundColor Green
} catch {
    Write-Host "Error loading modules: $_" -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Main Script Logic
Write-Host "Smart Call Block - Build System (Modular)" -ForegroundColor Green
Write-Host "Multi-platform build automation with workspace detection" -ForegroundColor Cyan

if ($Help) {
    Write-Info ""
    Write-Info "Smart Call Block Build System"
    Write-Info "============================="
    Write-Host "Features:"
    Write-Host "- Auto-detect version from config files"
    Write-Host "- Auto-detect AppID/BundleID"
    Write-Host "- Auto update config files"
    Write-Host "- Multi-app workspace support"
    Write-Host "- Modular architecture"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\build-app.ps1                      # Interactive build"
    Write-Host "  .\build-app.ps1 -AppName app         # Build specific app"
    Write-Host "  .\build-app.ps1 -Version v1.2.0      # Build with version"
    Write-Host "  .\build-app.ps1 -QuickBuild          # Skip confirmations"
    Write-Host ""
    exit 0
}

if ($ShowVersion) {
    Write-Info "Smart Call Block Build System v5.0 (Modular)"
    exit 0
}

Write-Info ""
Write-Info "Scanning workspace for apps..."

# Auto-detect apps in workspace
$allApps = Find-Apps

if ($allApps.Count -eq 0) {
    Write-Error "No apps found in VS Code workspace"
    Write-Warning "Make sure you have opened the correct workspace folder"
    exit 1
}

Write-Success "Found $($allApps.Count) app(s) in workspace:"
Write-Info ""

# Display found apps
for ($i = 0; $i -lt $allApps.Count; $i++) {
    $app = $allApps[$i]
    Write-Info "  $($i + 1). $($app.Name) ($($app.Type)) - $($app.Version)"
}

Write-Info ""

# Select app to build
$selectedApp = $null

if ($AppName) {
    # Find app by name if specified - handle multiple apps with same name
    $matchingApps = $allApps | Where-Object { $_.Name -eq $AppName }
    if ($matchingApps.Count -eq 0) {
        Write-Error "App '$AppName' not found"
        exit 1
    } elseif ($matchingApps.Count -eq 1) {
        $selectedApp = $matchingApps[0]
    } else {
        # Multiple apps with same name, let user choose by type
        Write-Info "Multiple apps named '$AppName' found:"
        for ($i = 0; $i -lt $matchingApps.Count; $i++) {
            Write-Info "  $($i + 1). $($matchingApps[$i].Name) ($($matchingApps[$i].Type))"
        }
        
        do {
            $selection = Read-Host "Select app (1-$($matchingApps.Count))"
            $index = [int]$selection - 1
            
            if ($index -ge 0 -and $index -lt $matchingApps.Count) {
                $selectedApp = $matchingApps[$index]
                break
            } else {
                Write-Warning "Invalid selection. Please select 1-$($matchingApps.Count)"
            }
        } while ($true)
    }
    Write-Success "Selected: $($selectedApp.Name) ($($selectedApp.Type))"
} elseif ($allApps.Count -eq 1) {
    # Single app - auto select
    $selectedApp = $allApps[0]
    Write-Success "Auto-selected: $($selectedApp.Name) ($($selectedApp.Type))"
} else {
    # Multiple apps - let user choose
    if (-not $QuickBuild) {
        $buildChoice = Read-Host "Do you want to build app(s)? (y/n)"
        if ($buildChoice -notmatch '^[Yy]') {
            Write-Info "Build skipped."
            exit 0
        }
    }
    
    do {
        $selection = Read-Host "Select app to build (1-$($allApps.Count))"
        $index = [int]$selection - 1
        
        if ($index -ge 0 -and $index -lt $allApps.Count) {
            $selectedApp = $allApps[$index]
            Write-Success "Selected: $($selectedApp.Name) ($($selectedApp.Type))"
            break
        } else {
            Write-Warning "Invalid selection. Please select 1-$($allApps.Count)"
        }
    } while ($true)
}

# Handle version selection
$buildVersion = $selectedApp.Version

if ($Version) {
    # Version provided as parameter
    if ($Version -match '^v\d+\.\d+\.\d+$') {
        $buildVersion = $Version
        Write-Info "Using specified version: $buildVersion"
    } else {
        Write-Error "Invalid version format. Use vX.X.X"
        exit 1
    }
} elseif (-not $QuickBuild) {
    # Interactive version selection
    Write-Host "Current version: $buildVersion"
    $versionChoice = Read-Host "Select option: 1=current, 2=new (1/2)"
    
    if ($versionChoice -eq "2") {
        do {
            $newVer = Read-Host "Enter version (vX.X.X format)"
            if ($newVer -match '^v\d+\.\d+\.\d+$') {
                $buildVersion = $newVer
                break
            } else {
                Write-Error "Invalid format. Use vX.X.X"
            }
        } while ($true)
    }
}

# Update version if changed
if ($buildVersion -ne $selectedApp.Version) {
    Write-Info "Updating to version: $buildVersion"
    if ($selectedApp.Type -eq "Android") {
        Update-AndroidVersion $selectedApp.Path $buildVersion
    } else {
        Update-iOSVersion $selectedApp.Path $buildVersion
    }
}

# Start build process
Write-Info "Starting build for $($selectedApp.Name)..."
Build-App $selectedApp $buildVersion

Write-Info ""
Write-Success "Features available:"
Write-Host "1. Auto-detect version from config files"
Write-Host "2. Auto-detect AppID/BundleID"
Write-Host "3. Auto update config files"
Write-Host "4. Multi-app workspace support"
Write-Host "5. Modular architecture"

Write-Info ""
Write-Info "Available specialized scripts:"
Write-Host "- build-android.ps1  (Android builds)"
Write-Host "- build-ios.ps1      (iOS builds)"