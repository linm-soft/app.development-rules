#!/usr/bin/env pwsh
param(
    [Parameter(Mandatory=$false)]
    [string]$AppName = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Version = "",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("debug", "release")]
    [string]$Configuration = "debug",
    
    [switch]$AutoVersion = $false,
    [switch]$CleanBuild = $true,
    [switch]$CopyToTest = $true,
    [switch]$Help = $false
)

# Import universal build functions
. "$PSScriptRoot\build-universal.ps1" -Help:$false

function Main-Android {
    if ($Help) {
        Write-Info "======================================"
        Write-Info "Android Build Script"
        Write-Info "======================================"
        Write-Host ""
        Write-Info "USAGE:"
        Write-Host "  build-android.ps1 [OPTIONS]"
        Write-Host ""
        Write-Info "OPTIONS:"
        Write-Host "  -AppName name        Specific Android app name"
        Write-Host "  -Version v1.2.0      Set version (vX.X.X format)"
        Write-Host "  -Configuration debug|release  Build config"
        Write-Host "  -AutoVersion         Auto-increment version"
        Write-Host "  -CleanBuild          Clean before build"
        Write-Host "  -CopyToTest          Copy outputs to test-app"
        Write-Host "  -Help                Show this help"
        exit 0
    }
    
    Write-Info "======================================"
    Write-Info "Android Build Script"
    Write-Info "======================================"
    Write-Host ""
    
    # Find Android apps
    $apps = Find-WorkspaceApps
    $androidApps = $apps.Android
    
    if ($androidApps.Count -eq 0) {
        Write-Error "❌ No Android apps found in workspace"
        exit 1
    }
    
    # Select app
    $selectedApp = if ($AppName) {
        $found = $androidApps | Where-Object { $_.Name -eq $AppName }
        if (-not $found) {
            Write-Error "❌ Android app '$AppName' not found"
            exit 1
        }
        $found
    } else {
        if ($androidApps.Count -eq 1) {
            $androidApps[0]
        } else {
            Write-Info "📱 Multiple Android apps found:"
            for ($i = 0; $i -lt $androidApps.Count; $i++) {
                Write-Info "  $($i + 1). $($androidApps[$i].Name)"
            }
            do {
                $selection = Read-Host "Select app (1-$($androidApps.Count))"
                $index = [int]$selection - 1
                if ($index -ge 0 -and $index -lt $androidApps.Count) {
                    $androidApps[$index]
                    break
                }
                Write-Warning "⚠️ Invalid selection"
            } while ($true)
        }
    }
    
    Write-Success "✅ Selected: $($selectedApp.Name)"
    
    # Set paths
    $Script:Config.AndroidPath = $selectedApp.Path
    
    # Get version and build
    $currentVersion = Get-ProjectVersion "android" $selectedApp.Path
    $buildVersion = Request-Version $currentVersion
    
    Write-Info "Building $($selectedApp.Name) version $buildVersion..."
    
    # Confirm and build
    $confirm = Read-Host "Continue with Android build? (y/n)"
    if ($confirm -match '^[Yy]') {
        Set-ProjectVersion "android" $selectedApp.Path $buildVersion
        $result = Build-AndroidProject $selectedApp.Path $Configuration
        
        if ($result) {
            Write-Success "🎉 Android build successful!"
            Write-Info "📱 APK: $result"
        } else {
            Write-Error "❌ Android build failed"
            exit 1
        }
    } else {
        Write-Warning "Build cancelled"
    }
}

# Run main function
Main-Android