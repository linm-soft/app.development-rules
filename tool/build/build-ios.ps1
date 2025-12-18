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

function Main-iOS {
    if ($Help) {
        Write-Info "======================================"
        Write-Info "iOS Build Script"
        Write-Info "======================================"
        Write-Host ""
        Write-Info "USAGE:"
        Write-Host "  build-ios.ps1 [OPTIONS]"
        Write-Host ""
        Write-Info "OPTIONS:"
        Write-Host "  -AppName name        Specific iOS app name"
        Write-Host "  -Version v1.2.0      Set version (vX.X.X format)"
        Write-Host "  -Configuration debug|release  Build config"
        Write-Host "  -AutoVersion         Auto-increment version"
        Write-Host "  -CleanBuild          Clean before build"
        Write-Host "  -CopyToTest          Copy outputs to test-app"
        Write-Host "  -Help                Show this help"
        Write-Host ""
        Write-Info "NOTE: iOS builds require macOS with Xcode installed"
        exit 0
    }
    
    if (-not $IsMacOS) {
        Write-Error "❌ iOS builds require macOS with Xcode"
        Write-Info "💡 Use the iOS helper script on Windows instead"
        exit 1
    }
    
    Write-Info "======================================"
    Write-Info "iOS Build Script"
    Write-Info "======================================"
    Write-Host ""
    
    # Find iOS apps
    $apps = Find-WorkspaceApps
    $iOSApps = $apps.iOS
    
    if ($iOSApps.Count -eq 0) {
        Write-Error "❌ No iOS apps found in workspace"
        exit 1
    }
    
    # Select app
    $selectedApp = if ($AppName) {
        $found = $iOSApps | Where-Object { $_.Name -eq $AppName }
        if (-not $found) {
            Write-Error "❌ iOS app '$AppName' not found"
            exit 1
        }
        $found
    } else {
        if ($iOSApps.Count -eq 1) {
            $iOSApps[0]
        } else {
            Write-Info "🍎 Multiple iOS apps found:"
            for ($i = 0; $i -lt $iOSApps.Count; $i++) {
                Write-Info "  $($i + 1). $($iOSApps[$i].Name)"
            }
            do {
                $selection = Read-Host "Select app (1-$($iOSApps.Count))"
                $index = [int]$selection - 1
                if ($index -ge 0 -and $index -lt $iOSApps.Count) {
                    $iOSApps[$index]
                    break
                }
                Write-Warning "⚠️ Invalid selection"
            } while ($true)
        }
    }
    
    Write-Success "✅ Selected: $($selectedApp.Name)"
    
    # Set paths
    $Script:Config.iOSPath = $selectedApp.Path
    
    # Get version and build
    $currentVersion = Get-ProjectVersion "ios" $selectedApp.Path
    $buildVersion = Request-Version $currentVersion
    
    Write-Info "Building $($selectedApp.Name) version $buildVersion..."
    
    # Confirm and build
    $confirm = Read-Host "Continue with iOS build? (y/n)"
    if ($confirm -match '^[Yy]') {
        Set-ProjectVersion "ios" $selectedApp.Path $buildVersion
        $result = Build-iOSProject $selectedApp.Path $Configuration
        
        if ($result) {
            Write-Success "🎉 iOS build successful!"
            Write-Info "📦 Archive: $result"
        } else {
            Write-Error "❌ iOS build failed"
            exit 1
        }
    } else {
        Write-Warning "Build cancelled"
    }
}

# Run main function
Main-iOS