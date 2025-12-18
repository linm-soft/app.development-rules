param([ValidateSet("android", "ios", "auto")][string]$Platform = "auto", [switch]$Help = $false, [switch]$UpdateConfig = $false, [string]$NewVersion = "", [switch]$UpdateAppId = $false)

function Write-Info { param($msg); Write-Host $msg -ForegroundColor Blue }
function Write-Success { param($msg); Write-Host $msg -ForegroundColor Green }
function Write-Error { param($msg); Write-Host $msg -ForegroundColor Red }
function Write-Warning { param($msg); Write-Host $msg -ForegroundColor Yellow }

function Get-AndroidVersion {
    param($AppPath)
    $buildGradle = Join-Path $AppPath "app\build.gradle"
    if (Test-Path $buildGradle) {
        $content = Get-Content $buildGradle -Raw
        if ($content -match 'versionName\s+"(v?[0-9.]+)"') {
            $version = $matches[1]
            if (-not $version.StartsWith("v")) { $version = "v$version" }
            return $version
        }
    }
    return "v1.0.0"
}

function Get-AndroidAppId {
    param($AppPath)
    $buildGradle = Join-Path $AppPath "app\build.gradle"
    if (Test-Path $buildGradle) {
        $content = Get-Content $buildGradle -Raw
        if ($content -match 'applicationId\s+"([^"]+)"') {
            return $matches[1]
        }
    }
    return "com.example.app"
}

function Get-iOSVersion {
    param($AppPath)
    $infoPlist = Join-Path $AppPath "*/Info.plist"
    $plistFiles = Get-ChildItem $AppPath -Filter "Info.plist" -Recurse
    foreach ($plist in $plistFiles) {
        try {
            if ($IsWindows) {
                # Windows - use PowerShell XML parsing
                [xml]$plistXml = Get-Content $plist.FullName
                $versionNode = $plistXml.plist.dict.ChildNodes | Where-Object { $_.InnerText -eq "CFBundleShortVersionString" }
                if ($versionNode -and $versionNode.NextSibling) {
                    $version = $versionNode.NextSibling.InnerText
                    return "v$version"
                }
            } else {
                # macOS - use defaults command
                $version = & defaults read "$($plist.FullName)" CFBundleShortVersionString 2>/dev/null
                if ($version) { return "v$version" }
            }
        } catch {
            continue
        }
    }
    return "v1.0.0"
}

function Get-iOSAppId {
    param($AppPath)
    $infoPlist = Join-Path $AppPath "*/Info.plist"
    $plistFiles = Get-ChildItem $AppPath -Filter "Info.plist" -Recurse
    foreach ($plist in $plistFiles) {
        try {
            if ($IsWindows) {
                [xml]$plistXml = Get-Content $plist.FullName
                $bundleIdNode = $plistXml.plist.dict.ChildNodes | Where-Object { $_.InnerText -eq "CFBundleIdentifier" }
                if ($bundleIdNode -and $bundleIdNode.NextSibling) {
                    return $bundleIdNode.NextSibling.InnerText
                }
            } else {
                $bundleId = & defaults read "$($plist.FullName)" CFBundleIdentifier 2>/dev/null
                if ($bundleId) { return $bundleId }
            }
        } catch {
            continue
        }
    }
    return "com.example.app"
}

function Update-AndroidAppId {
    param($AppPath, $NewAppId)
    $buildGradle = Join-Path $AppPath "app\build.gradle"
    if (Test-Path $buildGradle) {
        $content = Get-Content $buildGradle -Raw
        
        # Update applicationId to new format
        $content = $content -replace 'applicationId\s+"[^"]+"', "applicationId `"$NewAppId`""
        
        Set-Content $buildGradle -Value $content -NoNewline
        Write-Success "✅ Updated Android App ID: $NewAppId"
        return $true
    }
    return $false
}

function Update-iOSAppId {
    param($AppPath, $NewAppId)
    $updated = $false
    
    $plistFiles = Get-ChildItem $AppPath -Filter "Info.plist" -Recurse
    foreach ($plist in $plistFiles) {
        try {
            if ($IsWindows) {
                # Windows - XML editing
                [xml]$plistXml = Get-Content $plist.FullName
                $bundleIdNode = $plistXml.plist.dict.ChildNodes | Where-Object { $_.InnerText -eq "CFBundleIdentifier" }
                if ($bundleIdNode -and $bundleIdNode.NextSibling) {
                    $bundleIdNode.NextSibling.InnerText = $NewAppId
                    $plistXml.Save($plist.FullName)
                    $updated = $true
                }
            } else {
                # macOS - defaults command
                & defaults write "$($plist.FullName)" CFBundleIdentifier "$NewAppId"
                $updated = $true
            }
        } catch {
            Write-Warning "⚠️ Could not update $($plist.Name)"
        }
    }
    
    if ($updated) {
        Write-Success "✅ Updated iOS Bundle ID: $NewAppId"
    }
    return $updated
}

function Convert-ToLinmSoftFormat {
    param($AppName)
    # Convert app name to linm.soft format
    $cleanName = $AppName.ToLower() -replace '[^a-z0-9]', ''
    return "linm.soft.$cleanName"
}

function Build-App {
    param($SelectedApp, $Version)
    
    Write-Info "🚀 Building $($SelectedApp.Name) ($($SelectedApp.Type)) version $Version"
    
    if ($SelectedApp.Type -eq "Android") {
        Write-Info "📱 Building Android APK..."
        
        Push-Location $SelectedApp.Path
        try {
            Write-Info "🧹 Cleaning previous build..."
            & .\gradlew.bat clean
            
            Write-Info "🔨 Building APK..."
            & .\gradlew.bat assembleDebug
            
            # Check for APK output
            $apkPath = Get-ChildItem "app\build\outputs\apk\debug\*.apk" | Select-Object -First 1
            if ($apkPath) {
                Write-Success "✅ Android build completed!"
                Write-Info "📱 APK: $($apkPath.FullName)"
                
                # Copy to test-app if exists
                $testApp = "..\..\test-app"
                if (-not (Test-Path $testApp)) {
                    New-Item -ItemType Directory -Path $testApp -Force | Out-Null
                }
                Copy-Item $apkPath.FullName $testApp -Force
                Write-Success "📁 APK copied to test-app folder"
            } else {
                Write-Error "❌ Build failed - no APK generated"
            }
        } finally {
            Pop-Location
        }
        
    } elseif ($SelectedApp.Type -eq "iOS") {
        Write-Warning "⚠️ Hiện tại không thể build iOS trên Windows"
        Write-Info "💡 iOS build yêu cầu macOS với Xcode"
        Write-Host ""
        
        $updateChoice = Read-Host "Bạn có muốn chỉ update version không? (y/n)"
        
        if ($updateChoice -match '^[Yy]') {
            Write-Info "📝 Chế độ update version cho iOS app..."
            
            # Ask for new version
            Write-Host "📝 Current version: $Version"
            $versionChoice = Read-Host "Select option: 1=keep current, 2=enter new (1/2)"
            
            $newVersion = $Version
            if ($versionChoice -eq "2") {
                do {
                    $newVer = Read-Host "Enter new version (vX.X.X format)"
                    if ($newVer -match '^v\d+\.\d+\.\d+$') {
                        $newVersion = $newVer
                        break
                    } else {
                        Write-Error "❌ Invalid format. Use vX.X.X"
                    }
                } while ($true)
            }
            
            # Update iOS version
            if ($newVersion -ne $Version) {
                Write-Info "📝 Updating iOS version: $newVersion"
                Update-iOSVersion $SelectedApp.Path $newVersion
            } else {
                Write-Info "✅ Keeping current version: $Version"
            }
            
            Write-Success "✅ iOS version update completed!"
            Write-Info "💡 Copy project to Mac để build với Xcode"
        } else {
            Write-Info "👍 Version update skipped"
        }
    }
}

function Update-AndroidVersion {
    param($AppPath, $NewVersion)
    $buildGradle = Join-Path $AppPath "app\build.gradle"
    if (Test-Path $buildGradle) {
        $content = Get-Content $buildGradle -Raw
        $versionNumber = $NewVersion -replace '^v', ''
        
        # Update versionName
        $content = $content -replace 'versionName\s+"v?[0-9.]+"', "versionName `"$versionNumber`""
        
        # Auto-increment versionCode
        if ($content -match 'versionCode\s+(\d+)') {
            $newCode = [int]$matches[1] + 1
            $content = $content -replace 'versionCode\s+\d+', "versionCode $newCode"
        }
        
        Set-Content $buildGradle -Value $content -NoNewline
        Write-Success "✅ Updated Android version: $NewVersion (versionCode: $newCode)"
        return $true
    }
    return $false
}

function Update-iOSVersion {
    param($AppPath, $NewVersion)
    $versionNumber = $NewVersion -replace '^v', ''
    $updated = $false
    
    $plistFiles = Get-ChildItem $AppPath -Filter "Info.plist" -Recurse
    foreach ($plist in $plistFiles) {
        try {
            if ($IsWindows) {
                # Windows - XML editing
                [xml]$plistXml = Get-Content $plist.FullName
                $versionNode = $plistXml.plist.dict.ChildNodes | Where-Object { $_.InnerText -eq "CFBundleShortVersionString" }
                if ($versionNode -and $versionNode.NextSibling) {
                    $versionNode.NextSibling.InnerText = $versionNumber
                    $plistXml.Save($plist.FullName)
                    $updated = $true
                }
                
                # Update build number with timestamp
                $buildNode = $plistXml.plist.dict.ChildNodes | Where-Object { $_.InnerText -eq "CFBundleVersion" }
                if ($buildNode -and $buildNode.NextSibling) {
                    $timestamp = Get-Date -Format "yyyyMMddHHmm"
                    $buildNode.NextSibling.InnerText = $timestamp
                    $plistXml.Save($plist.FullName)
                }
            } else {
                # macOS - defaults command
                & defaults write "$($plist.FullName)" CFBundleShortVersionString "$versionNumber"
                $timestamp = Get-Date -Format "yyyyMMddHHmm"
                & defaults write "$($plist.FullName)" CFBundleVersion "$timestamp"
                $updated = $true
            }
        } catch {
            Write-Warning "⚠️ Could not update $($plist.Name)"
        }
    }
    
    if ($updated) {
        Write-Success "✅ Updated iOS version: $NewVersion"
    }
    return $updated
}

function Find-Apps {
    Write-Info "🔍 Detecting apps in current VS Code workspace..."
    
    $androidApps = @()
    $iOSApps = @()
    
    # Try to read VS Code workspace configuration
    $workspaceRoot = $null
    $workspaceFolders = @()
    
    # Method 1: Look for .vscode/settings.json or workspace file that might contain folder info
    $currentPath = (Get-Location).Path
    $searchPath = $currentPath
    
    while ($searchPath -and (Split-Path $searchPath -Parent)) {
        # Check for .vscode folder
        $vscodeFolder = Join-Path $searchPath ".vscode"
        if (Test-Path $vscodeFolder) {
            $workspaceRoot = $searchPath
            Write-Info "✅ Found workspace with .vscode: $workspaceRoot"
            break
        }
        
        # Check for .code-workspace files
        $workspaceFiles = Get-ChildItem $searchPath -Filter "*.code-workspace" -ErrorAction SilentlyContinue
        if ($workspaceFiles.Count -gt 0) {
            $workspaceRoot = $searchPath
            Write-Info "✅ Found .code-workspace file: $workspaceRoot"
            break
        }
        
        $searchPath = Split-Path $searchPath -Parent
    }
    
    # If we're in a multi-folder workspace (like shown in VS Code explorer)
    # We need to detect which folders are actually part of the workspace
    
    if ($workspaceRoot) {
        # For the specific case where we see: smart-call-block, smart-call-block, development-rules
        # This suggests a multi-folder workspace with different paths
        
        # Check if we're in development-rules and there are sibling smart-call-block folders
        if ($currentPath -like "*development-rules*") {
            Write-Info "📂 Multi-folder workspace detected"
            
            # We're in: D:\MyRepo\AI-App\Android.App\development-rules\tool\build
            # Android smart-call-block should be at: D:\MyRepo\AI-App\Android.App\smart-call-block
            # iOS smart-call-block should be at: D:\MyRepo\AI-App\IOS.App\smart-call-block
            
            # Get to Android.App level (go up from tool/build to development-rules, then to Android.App)
            $devRulesPath = $currentPath
            while ($devRulesPath -and -not ($devRulesPath -like "*development-rules" -and -not ($devRulesPath -like "*development-rules\*"))) {
                $devRulesPath = Split-Path $devRulesPath -Parent
            }
            $androidAppPath = Split-Path $devRulesPath -Parent  # This should be Android.App
            
            # Pattern 1: Android smart-call-block in same Android.App folder
            $androidSmartCallBlock = Join-Path $androidAppPath "smart-call-block"
            
            # Pattern 2: iOS smart-call-block in parallel IOS.App folder
            $aiAppPath = Split-Path $androidAppPath -Parent  # This should be AI-App
            $iosAppPath = Join-Path $aiAppPath "IOS.App"
            $iOSSmartCallBlock = Join-Path $iosAppPath "smart-call-block"
            
            Write-Info "🔍 Checking Android path: $androidSmartCallBlock"
            Write-Info "🔍 Checking iOS path: $iOSSmartCallBlock"
            
            # Check Android smart-call-block
            if (Test-Path $androidSmartCallBlock) {
                $buildGradlePath = Join-Path $androidSmartCallBlock "app\build.gradle"
                if (Test-Path $buildGradlePath) {
                    $version = Get-AndroidVersion $androidSmartCallBlock
                    $appId = Get-AndroidAppId $androidSmartCallBlock
                    $androidApps += @{ 
                        Name = "smart-call-block"; 
                        Path = $androidSmartCallBlock; 
                        Type = "Android"; 
                        Version = $version; 
                        AppId = $appId 
                    }
                    Write-Info "  📱 Found Android app: smart-call-block - $version ($appId)"
                }
            }
            
            # Check iOS smart-call-block
            if (Test-Path $iOSSmartCallBlock) {
                $xcodeProj = Get-ChildItem $iOSSmartCallBlock -Filter "*.xcodeproj" -Directory -ErrorAction SilentlyContinue
                if ($xcodeProj.Count -gt 0) {
                    $version = Get-iOSVersion $iOSSmartCallBlock
                    $appId = Get-iOSAppId $iOSSmartCallBlock
                    $iOSApps += @{ 
                        Name = "smart-call-block"; 
                        Path = $iOSSmartCallBlock; 
                        Type = "iOS"; 
                        Version = $version; 
                        AppId = $appId 
                    }
                    Write-Info "  🍎 Found iOS app: smart-call-block - $version ($appId)"
                }
            }
        }
    }
    
    # Fallback: if no specific workspace pattern found, scan current directory only
    if ($androidApps.Count -eq 0 -and $iOSApps.Count -eq 0) {
        Write-Info "🔍 Scanning current directory as fallback"
        
        # Check current folder for app
        $buildGradlePath = Join-Path $currentPath "app\build.gradle"
        if (Test-Path $buildGradlePath) {
            $version = Get-AndroidVersion $currentPath
            $appId = Get-AndroidAppId $currentPath
            $folderName = Split-Path $currentPath -Leaf
            $androidApps += @{ 
                Name = $folderName; 
                Path = $currentPath; 
                Type = "Android"; 
                Version = $version; 
                AppId = $appId 
            }
        }
        
        $xcodeProj = Get-ChildItem $currentPath -Filter "*.xcodeproj" -Directory -ErrorAction SilentlyContinue
        if ($xcodeProj.Count -gt 0) {
            $version = Get-iOSVersion $currentPath
            $appId = Get-iOSAppId $currentPath
            $folderName = Split-Path $currentPath -Leaf
            $iOSApps += @{ 
                Name = $folderName; 
                Path = $currentPath; 
                Type = "iOS"; 
                Version = $version; 
                AppId = $appId 
            }
        }
    }
    
    return @{ Android = $androidApps; iOS = $iOSApps; Total = $androidApps.Count + $iOSApps.Count }
}

if ($Help) {
    Write-Info "Enhanced App Build Script with Auto Config"
    Write-Info "==========================================="
    Write-Host "Features:"
    Write-Host "1. Multi-app workspace detection with version/appid"
    Write-Host "2. Auto-platform detection" 
    Write-Host "3. Automatic version and config updates"
    Write-Host "4. Separate Android/iOS scripts"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\build-app.ps1 [-Platform android|ios|auto] [-NewVersion v1.2.0] [-UpdateConfig] [-UpdateAppId]"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\build-app.ps1                          # Scan and show current versions"
    Write-Host "  .\build-app.ps1 -UpdateConfig            # Update configs with new versions"
    Write-Host "  .\build-app.ps1 -NewVersion v1.2.0       # Set specific version"
    Write-Host "  .\build-app.ps1 -UpdateAppId              # Convert App IDs to linm.soft format"
    exit 0
}

Write-Info "Enhanced App Build System with Auto Config!"
Write-Info "==========================================="
Write-Info "🔍 Scanning workspace for apps with versions/appids..."

$apps = Find-Apps

if ($apps.Total -eq 0) {
    Write-Error "❌ No apps found in workspace"
    exit 1
}

Write-Success "📊 Found $($apps.Total) apps:"
Write-Host ""

# Show Android apps
if ($apps.Android.Count -gt 0) {
    Write-Info "📱 Android Apps:"
    $apps.Android | ForEach-Object {
        Write-Host "   • $($_.Name)"
        Write-Host "     Version: $($_.Version)" -ForegroundColor Cyan
        Write-Host "     AppID: $($_.AppId)" -ForegroundColor Cyan
        Write-Host ""
    }
}

# Show iOS apps
if ($apps.iOS.Count -gt 0) {
    Write-Info "🍎 iOS Apps:"
    $apps.iOS | ForEach-Object {
        Write-Host "   • $($_.Name)"
        Write-Host "     Version: $($_.Version)" -ForegroundColor Cyan
        Write-Host "     BundleID: $($_.AppId)" -ForegroundColor Cyan
        Write-Host ""
    }
}

# Update configs if requested
if ($UpdateConfig -or $NewVersion -or $UpdateAppId) {
    if ($UpdateAppId) {
        Write-Info "🔧 App ID Update Mode - Converting to linm.soft format"
        
        # Update Android apps
        $apps.Android | ForEach-Object {
            Write-Info "📱 Updating Android app: $($_.Name)"
            $newAppId = Convert-ToLinmSoftFormat $_.Name
            Update-AndroidAppId $_.Path $newAppId
        }
        
        # Update iOS apps
        $apps.iOS | ForEach-Object {
            Write-Info "🍎 Updating iOS app: $($_.Name)"
            $newAppId = Convert-ToLinmSoftFormat $_.Name
            Update-iOSAppId $_.Path $newAppId
        }
        
        Write-Success "✅ All App IDs updated to linm.soft format!"
        Write-Info "💡 Re-run script to see updated App IDs"
        exit 0
    }
    
    if ($UpdateConfig -or $NewVersion) {
        Write-Info "🔧 Config Update Mode"
        
        if ($NewVersion) {
            if ($NewVersion -notmatch '^v\d+\.\d+\.\d+$') {
                Write-Error "❌ Invalid version format. Use vX.X.X (e.g., v1.2.0)"
                exit 1
            }
            Write-Info "📝 Updating all apps to version: $NewVersion"
        } else {
            $NewVersion = Read-Host "Enter new version (vX.X.X format)"
            if ($NewVersion -notmatch '^v\d+\.\d+\.\d+$') {
                Write-Error "❌ Invalid version format"
                exit 1
            }
        }
        
        # Update Android apps
        $apps.Android | ForEach-Object {
            Write-Info "📱 Updating Android app: $($_.Name)"
            Update-AndroidVersion $_.Path $NewVersion
        }
        
        # Update iOS apps
        $apps.iOS | ForEach-Object {
            Write-Info "🍎 Updating iOS app: $($_.Name)"
            Update-iOSVersion $_.Path $NewVersion
        }
        
        Write-Success "✅ All configs updated!"
    }
} else {
    Write-Info "💡 Use -UpdateConfig to update versions, or -NewVersion v1.2.0 to set specific version"
    
    # Ask user if they want to build the detected apps
    if ($apps.Total -gt 0) {
        Write-Host ""
        Write-Info "🔨 Build Options:"
        
        $buildChoice = Read-Host "Do you want to build the detected app(s)? (y/n)"
        
        if ($buildChoice -match '^[Yy]') {
            # If multiple apps, ask which one to build
            if ($apps.Total -eq 1) {
                $selectedApp = if ($apps.Android.Count -gt 0) { $apps.Android[0] } else { $apps.iOS[0] }
                Write-Success "✅ Building: $($selectedApp.Name) ($($selectedApp.Type))"
                
                # Ask for version if needed
                $buildVersion = $selectedApp.Version
                Write-Host "📝 Current version: $buildVersion"
                $versionChoice = Read-Host "Select option: 1=current, 2=new (1/2)"
                
                if ($versionChoice -eq "2") {
                    do {
                        $newVer = Read-Host "Enter version (vX.X.X format)"
                        if ($newVer -match '^v\d+\.\d+\.\d+$') {
                            $buildVersion = $newVer
                            break
                        } else {
                            Write-Error "❌ Invalid format. Use vX.X.X"
                        }
                    } while ($true)
                }
                
                # Update version and build
                if ($buildVersion -ne $selectedApp.Version) {
                    Write-Info "📝 Updating to version: $buildVersion"
                    if ($selectedApp.Type -eq "Android") {
                        Update-AndroidVersion $selectedApp.Path $buildVersion
                    } else {
                        Update-iOSVersion $selectedApp.Path $buildVersion
                    }
                }
                
                # Start build process
                Write-Info "🔨 Starting build for $($selectedApp.Name)..."
                Build-App $selectedApp $buildVersion
                
            } else {
                # Multiple apps - show selection
                Write-Info "📱 Multiple apps detected. Select which to build:"
                $allApps = $apps.Android + $apps.iOS
                
                for ($i = 0; $i -lt $allApps.Count; $i++) {
                    $app = $allApps[$i]
                    Write-Info "  $($i + 1). $($app.Name) ($($app.Type)) - $($app.Version)"
                }
                
                do {
                    $selection = Read-Host "Select app to build (1-$($allApps.Count))"
                    $index = [int]$selection - 1
                    
                    if ($index -ge 0 -and $index -lt $allApps.Count) {
                        $selectedApp = $allApps[$index]
                        Write-Success "✅ Selected: $($selectedApp.Name) ($($selectedApp.Type))"
                        
                        # Continue with build process...
                        $buildVersion = $selectedApp.Version
                        Write-Host "📝 Current version: $buildVersion"
                        $versionChoice = Read-Host "Select option: 1=current, 2=new (1/2)"
                        
                        if ($versionChoice -eq "2") {
                            do {
                                $newVer = Read-Host "Enter version (vX.X.X format)"
                                if ($newVer -match '^v\d+\.\d+\.\d+$') {
                                    $buildVersion = $newVer
                                    break
                                } else {
                                    Write-Error "❌ Invalid format. Use vX.X.X"
                                }
                            } while ($true)
                        }
                        
                        # Update version and build
                        if ($buildVersion -ne $selectedApp.Version) {
                            Write-Info "📝 Updating to version: $buildVersion"
                            if ($selectedApp.Type -eq "Android") {
                                Update-AndroidVersion $selectedApp.Path $buildVersion
                            } else {
                                Update-iOSVersion $selectedApp.Path $buildVersion
                            }
                        }
                        
                        # Start build process
                        Write-Info "🔨 Starting build for $($selectedApp.Name)..."
                        Build-App $selectedApp $buildVersion
                        break
                        
                    } else {
                        Write-Warning "⚠️ Invalid selection. Please select 1-$($allApps.Count)"
                    }
                } while ($true)
            }
        } else {
            Write-Info "👍 Build skipped. App detection completed."
        }
    }
}

Write-Info ""
Write-Success "✅ Features available:"
Write-Host "1. ✅ Auto-detect version từ config files"
Write-Host "2. ✅ Auto-detect AppID/BundleID"
Write-Host "3. ✅ Tự động update config files"
Write-Host "4. ✅ Multi-app workspace support"

Write-Info ""
Write-Info "Available specialized scripts:"
Write-Host "- build-android.ps1  (Android builds)"  
Write-Host "- build-ios.ps1      (iOS builds)"
