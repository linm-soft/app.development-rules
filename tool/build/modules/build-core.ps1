# Build Core Module
# Main build logic for Android and iOS apps

function Build-App {
    param($SelectedApp, $Version)
    
    Write-Info "Building $($SelectedApp.Name) ($($SelectedApp.Type)) version $Version"
    
    if ($SelectedApp.Type -eq "Android") {
        Write-Info "Building Android APK..."
        
        Push-Location $SelectedApp.Path
        try {
            Write-Info "Cleaning previous build..."
            & .\gradlew.bat clean
            
            Write-Info "Building APK..."
            & .\gradlew.bat assembleDebug
            
            # Check for APK output
            $apkPath = Get-ChildItem "app\build\outputs\apk\debug\*.apk" | Select-Object -First 1
            if ($apkPath) {
                Write-Success "Android build completed!"
                Write-Info "APK: $($apkPath.FullName)"
                
                # Copy to test-app if exists
                $testApp = "..\..\test-app"
                if (-not (Test-Path $testApp)) {
                    New-Item -ItemType Directory -Path $testApp -Force | Out-Null
                }
                Copy-Item $apkPath.FullName $testApp -Force
                Write-Success "APK copied to test-app folder"
            } else {
                Write-Error "Build failed - no APK generated"
            }
        } finally {
            Pop-Location
        }
        
    } elseif ($SelectedApp.Type -eq "iOS") {
        Write-Warning "Cannot build iOS on Windows"
        Write-Info "iOS build requires macOS with Xcode"
        Write-Host ""
        
        $updateChoice = Read-Host "Do you want to update version only? (y/n)"
        
        if ($updateChoice -match '^[Yy]') {
            Write-Info "Version update mode for iOS app..."
            
            # Ask for new version
            Write-Host "Current version: $Version"
            $versionChoice = Read-Host "Select option: 1=keep current, 2=enter new (1/2)"
            
            $newVersion = $Version
            if ($versionChoice -eq "2") {
                do {
                    $newVer = Read-Host "Enter new version (vX.X.X format)"
                    if ($newVer -match '^v\d+\.\d+\.\d+$') {
                        $newVersion = $newVer
                        break
                    } else {
                        Write-Error "Invalid format. Use vX.X.X"
                    }
                } while ($true)
            }
            
            # Update iOS version
            if ($newVersion -ne $Version) {
                Write-Info "Updating iOS version: $newVersion"
                Update-iOSVersion $SelectedApp.Path $newVersion
            } else {
                Write-Info "Keeping current version: $Version"
            }
            
            Write-Success "iOS version update completed!"
            Write-Info "Copy project to Mac to build with Xcode"
        } else {
            Write-Info "Version update skipped"
        }
    }
}

Write-Verbose "Loaded: build-core.ps1"