# Version and App ID Functions Module
# Functions to read and update app versions and IDs

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

Write-Verbose "Loaded: build-functions.ps1"