# App Detection Module - Fixed Version
# VS Code workspace detection and app scanning

function Find-Apps {
    Write-Info "Detecting apps in current VS Code workspace..."
    
    $androidApps = @()
    $iOSApps = @()
    
    # Get current directory and scan for workspace
    $currentPath = (Get-Location).Path
    Write-Info "Current path: $currentPath"
    
    # Define search paths based on known workspace structure
    $searchPaths = @()
    
    # If we're in development-rules, find sibling app folders
    if ($currentPath -like "*development-rules*") {
        Write-Info "Multi-folder workspace detected"
        
        # Navigate to find Android and iOS app folders
        $devRulesPath = $currentPath
        while ($devRulesPath -and -not ($devRulesPath.EndsWith("development-rules"))) {
            $devRulesPath = Split-Path $devRulesPath -Parent
        }
        
        if ($devRulesPath) {
            $androidAppPath = Split-Path $devRulesPath -Parent
            $searchPaths += Join-Path $androidAppPath "smart-call-block"
            
            # Try to find iOS app path
            $baseAIPath = Split-Path $androidAppPath -Parent
            $iOSAppPath = Join-Path $baseAIPath "IOS.App"
            if (Test-Path $iOSAppPath) {
                $searchPaths += Join-Path $iOSAppPath "smart-call-block"
            }
        }
    } else {
        # Regular single-folder workspace
        $searchPaths += $currentPath
        
        # Also check parent directories
        $parent = Split-Path $currentPath -Parent
        if ($parent) {
            $searchPaths += $parent
        }
    }
    
    # Scan each search path for Android/iOS apps
    foreach ($path in $searchPaths) {
        if (-not (Test-Path $path)) {
            continue
        }
        
        Write-Info "Scanning: $path"
        
        # Check for Android app (build.gradle) - both direct and ANDROID subfolder
        $androidPaths = @($path, (Join-Path $path "ANDROID"))
        foreach ($androidPath in $androidPaths) {
            $androidBuildFile = Join-Path $androidPath "app\build.gradle"
            if (Test-Path $androidBuildFile) {
                $appName = Split-Path $path -Leaf
                $version = Get-AndroidVersion $androidPath
                $appId = Get-AndroidAppId $androidPath
                
                $androidApps += @{
                    Name = $appName
                    Type = "Android"
                    Path = $androidPath
                    Version = $version
                    AppId = $appId
                }
                Write-Info "Found Android app: $appName ($version)"
                break
            }
        }
        
        # Check for iOS app (xcodeproj) - both direct and IOS subfolder
        $iOSPaths = @($path, (Join-Path $path "IOS"))
        foreach ($iOSPath in $iOSPaths) {
            $xcodeProj = Get-ChildItem -Path $iOSPath -Filter "*.xcodeproj" -ErrorAction SilentlyContinue
            if ($xcodeProj) {
                $appName = Split-Path $path -Leaf
                $version = Get-iOSVersion $iOSPath
                $bundleId = Get-iOSAppId $iOSPath
                
                $iOSApps += @{
                    Name = $appName
                    Type = "iOS"
                    Path = $iOSPath
                    Version = $version
                    AppId = $bundleId
                }
                Write-Info "Found iOS app: $appName ($version)"
                break
            }
        }
    }
    
    Write-Info "Scan complete. Found $($androidApps.Count) Android, $($iOSApps.Count) iOS apps"
    
    # Return combined results
    $allApps = @()
    $allApps += $androidApps
    $allApps += $iOSApps
    
    return $allApps
}

Write-Verbose "Loaded: app-detection.ps1 (Fixed Version)"