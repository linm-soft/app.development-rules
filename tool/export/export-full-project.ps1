param(
    [Parameter(Mandatory=$false)]
    [string]$SourcePath = "",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("android", "ios", "both")]
    [string]$Platform = "both",
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "SmartCallBlock",
    
    [switch]$IncludeTimestamp = $true,
    [switch]$ShowVerbose = $false,
    [switch]$OpenOutputFolder = $true,
    [switch]$CreateZipFile = $true,
    [switch]$KeepFolders = $false,
    [switch]$SkipGradle = $false
)

# Full Project Export Tool
# Exports complete workspace excluding development-rules for Android Studio / Xcode

$ToolVersion = "1.0.0"
$ScriptPath = $PSScriptRoot

Write-Host "Full Project Export Tool v$ToolVersion" -ForegroundColor Cyan
Write-Host "-----------------------------------------------------" -ForegroundColor DarkGray

# Auto-detect source path if not provided
if (-not $SourcePath) {
    $SourcePath = Split-Path $PSScriptRoot -Parent | Split-Path -Parent | Split-Path -Parent
    Write-Host "Auto-detected source path: $SourcePath" -ForegroundColor Yellow
}

if (-not (Test-Path $SourcePath)) {
    Write-Host "Source path not found: $SourcePath" -ForegroundColor Red
    exit 1
}

# Debug: List contents of source path
Write-Host "Contents of source path:" -ForegroundColor Cyan
Get-ChildItem $SourcePath | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Gray }

# Set default output path - create temp folder for staging
if (-not $OutputPath) {
    $ExportDir = Join-Path $SourcePath "Export"
    $OutputPath = Join-Path $ExportDir "temp_staging"
}

Write-Host "Source: $SourcePath" -ForegroundColor White
Write-Host "Staging: $OutputPath" -ForegroundColor White
Write-Host "Platform: $Platform" -ForegroundColor White

# Create staging directory
if (Test-Path $OutputPath) {
    Write-Host "Staging directory exists, removing..." -ForegroundColor Yellow
    Remove-Item $OutputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null

# Define base exclusion patterns
$ExcludePatterns = @(
    # Project folders to exclude
    "development-rules*",
    "test-app*",
    "Export*",
    
    # Version control
    ".git/*",
    ".git\\*",
    ".git",
    
    # OS files
    "*.DS_Store*",
    "*Thumbs.db*",
    
    # Temporary files
    "*.tmp*",
    "*.temp*",
    "*.log",
    "*.logs",
    
    # IDE and editor files
    "*node_modules*",
    "*.idea*",
    "*.vscode*",
    "*\.vs*",
    "*.ai-progress*",
    
    # Android build artifacts
    "*/build/*",
    "*/build\\*",
    "*\\build\\*",
    "*\\build/*", 
    "*/generated/*",
    "*/generated\\*",
    "*\\generated\\*",
    "*\\generated/*",
    "*/intermediates/*",
    "*/intermediates\\*",
    "*\\intermediates\\*",
    "*\\intermediates/*",
    "*/outputs/*",
    "*/outputs\\*",
    "*\\outputs\\*",
    "*\\outputs/*",
    "*tmp*",
    "*/debug/*",
    "*/debug\\*",
    "*/release/*",
    "*/release\\*",
    "*.gradle/*",
    "*\.gradle*",
    "*gradlew*",
    "*gradle.properties*",
    "*local.properties*",
    "*.apk",
    "*.aab",
    "*.dex",
    "*.class",
    
    # iOS build artifacts
    "*DerivedData*",
    "*.xcworkspace*",
    "*.xcuserdata*",
    "*Pods*",
    "Podfile.lock",
    "*Build/*",
    "*Build\\*",
    "*.github*",
    
    # Other build artifacts
    "*bin/*",
    "*bin\\*",
    "*obj/*", 
    "*obj\\*",
    "*dist/*",
    "*dist\\*",
    "*target/*",
    "*target\\*",
    "*out/*",
    "*out\\*"
)

# Add Gradle-specific exclusions if SkipGradle is enabled
if ($SkipGradle) {
    Write-Host "Gradle skip mode enabled - excluding all Gradle files" -ForegroundColor Yellow
    $GradleExclusions = @(
        "*gradle*",
        "*Gradle*",
        "*.gradle",
        "build.gradle*",
        "settings.gradle*",
        "gradle.properties*",
        "gradlew*",
        "gradlew.bat*",
        "local.properties*",
        "gradle/*",
        "gradle\\*",
        ".gradle/*",
        ".gradle\\*",
        "*gradle-wrapper*",
        "proguard-rules.pro*"
    )
    $ExcludePatterns += $GradleExclusions
}

function Test-ShouldExclude {
    param([string]$Path, [string[]]$Patterns)
    
    # Check each pattern
    foreach ($pattern in $Patterns) {
        if ($Path -like $pattern) {
            return $true
        }
    }
    
    # Additional specific checks for build folders
    if ($Path -match "\\build\\|/build/|\\build$|/build$") {
        return $true
    }
    
    # Check if path contains build artifacts folders
    $buildArtifacts = @("generated", "intermediates", "outputs", "tmp", "DerivedData")
    foreach ($artifact in $buildArtifacts) {
        if ($Path -match "\\$artifact\\|/$artifact/|\\$artifact$|/$artifact$") {
            return $true
        }
    }
    
    # Specific check for .gradle folder (but not files containing 'gradle')
    if ($Path -match "\\\.gradle\\|/\.gradle/|\\\.gradle$|/\.gradle$") {
        return $true
    }
    
    return $false
}

function Copy-ProjectFiles {
    param(
        [string]$Source,
        [string]$Destination,
        [string[]]$PlatformFolders = @()
    )
    
    Write-Host "Copying project files from: $Source" -ForegroundColor Green
    Write-Host "To destination: $Destination" -ForegroundColor Green
    
    # Check if source exists
    if (-not (Test-Path $Source)) {
        Write-Host "ERROR: Source path does not exist: $Source" -ForegroundColor Red
        return @{ Copied = 0; Skipped = 0 }
    }
    
    $TotalFiles = 0
    $CopiedFiles = 0
    $SkippedFiles = 0
    
    # Get all items recursively
    $Items = Get-ChildItem -Path $Source -Recurse -Force
    $TotalFiles = $Items.Count
    
    foreach ($Item in $Items) {
        $RelativePath = $Item.FullName.Substring($Source.Length + 1)
        
        # Check if should be excluded
        if (Test-ShouldExclude -Path $RelativePath -Patterns $ExcludePatterns) {
            $SkippedFiles++
            if ($ShowVerbose) {
                Write-Host "Skipped: $RelativePath" -ForegroundColor DarkGray
            }
            continue
        }
        
        # Check platform-specific filtering
        if ($PlatformFolders.Count -gt 0) {
            $ShouldInclude = $false
            foreach ($folder in $PlatformFolders) {
                if ($RelativePath.StartsWith($folder, [StringComparison]::OrdinalIgnoreCase)) {
                    $ShouldInclude = $true
                    break
                }
            }
            # Also include root-level files and DOCs
            if (-not $ShouldInclude -and ($RelativePath.IndexOf('\') -eq -1 -or $RelativePath.StartsWith("DOCs", [StringComparison]::OrdinalIgnoreCase))) {
                $ShouldInclude = $true
            }
            
            if (-not $ShouldInclude) {
                $SkippedFiles++
                continue
            }
        }
        
        $DestPath = Join-Path $Destination $RelativePath
        
        if ($Item.PSIsContainer) {
            # Create directory
            if (-not (Test-Path $DestPath)) {
                New-Item -ItemType Directory -Path $DestPath -Force | Out-Null
                if ($ShowVerbose) {
                    Write-Host "Created: $RelativePath" -ForegroundColor Blue
                }
            }
        } else {
            # Copy file
            $DestDir = Split-Path $DestPath -Parent
            if (-not (Test-Path $DestDir)) {
                New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
            }
            
            Copy-Item $Item.FullName $DestPath -Force
            $CopiedFiles++
            
            if ($ShowVerbose) {
                Write-Host "Copied: $RelativePath" -ForegroundColor Green
            }
        }
    }
    
    return @{
        Total = $TotalFiles
        Copied = $CopiedFiles
        Skipped = $SkippedFiles
    }
}

# Execute export based on platform
$Results = @{}

# Copy all project files to staging (single output)
Write-Host "`nCreating export..." -ForegroundColor Cyan
$ProjectSourcePath = Join-Path $SourcePath "smart-call-block"
$ExportResults = Copy-ProjectFiles -Source $ProjectSourcePath -Destination $OutputPath
$Results["Export"] = $ExportResults

Write-Host "Export staging completed!" -ForegroundColor Green
Write-Host "   Files copied: $($ExportResults.Copied)" -ForegroundColor White
Write-Host "   Files skipped: $($ExportResults.Skipped)" -ForegroundColor Gray

# Create export info file
$ExportInfo = @{
    ExportDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    SourcePath = $SourcePath
    Platform = $Platform
    ProjectName = $ProjectName
    ExcludePatterns = $ExcludePatterns
    Results = $Results
    Version = $ToolVersion
} | ConvertTo-Json -Depth 3

$InfoPath = Join-Path $OutputPath "export-info.json"
$ExportInfo | Out-File -FilePath $InfoPath -Encoding UTF8

# Create README for exported project
$ReadmeContent = "# $ProjectName - Exported Project`n`n"
$ReadmeContent += "**Export Date:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")`n"
$ReadmeContent += "**Platform:** $Platform`n"
$ReadmeContent += "**Source:** $SourcePath`n`n"
$ReadmeContent += "## Directory Structure`n`n"

if ($Platform -eq "android" -or $Platform -eq "both") {
    $ReadmeContent += "### Android`n"
    $ReadmeContent += "- **Location:** Android/`n"
    $ReadmeContent += "- **Build Tool:** Android Studio`n"
    $ReadmeContent += "- **Main Project:** Android/ANDROID/`n"
    $ReadmeContent += "- **Documentation:** Android/DOCs/android/`n`n"
    $ReadmeContent += "**To build in Android Studio:**`n"
    $ReadmeContent += "1. Open Android Studio`n"
    $ReadmeContent += "2. File -> Open -> Select Android/ANDROID/ folder`n"
    $ReadmeContent += "3. Sync project with Gradle files`n"
    $ReadmeContent += "4. Build -> Make Project`n`n"
}

if ($Platform -eq "ios" -or $Platform -eq "both") {
    $ReadmeContent += "### iOS`n"
    $ReadmeContent += "- **Location:** iOS/`n"
    $ReadmeContent += "- **Build Tool:** Xcode`n"
    $ReadmeContent += "- **Main Project:** iOS/IOS/SmartCallBlock.xcodeproj`n"
    $ReadmeContent += "- **Documentation:** iOS/DOCs/ios/`n`n"
    $ReadmeContent += "**To build in Xcode:**`n"
    $ReadmeContent += "1. Open Xcode`n"
    $ReadmeContent += "2. File -> Open -> Select iOS/IOS/SmartCallBlock.xcodeproj`n"
    $ReadmeContent += "3. Select target device or simulator`n"
    $ReadmeContent += "4. Product -> Build`n`n"
}

if ($Platform -eq "both") {
    $ReadmeContent += "### Complete Project`n"
    $ReadmeContent += "- **Location:** Complete/`n"
    $ReadmeContent += "- **Contains:** All project files (Android + iOS + Documentation)`n"
    $ReadmeContent += "- **Use this if:** You need access to both platforms or complete documentation`n`n"
}

$ReadmeContent += "## Excluded Files`n`n"
$ReadmeContent += "The following patterns were excluded from export:`n"
$ReadmeContent += ($ExcludePatterns -join "`n") + "`n`n"
$ReadmeContent += "## Export Statistics`n`n"

foreach ($exportKey in $Results.Keys) {
    $stat = $Results[$exportKey]
    $ReadmeContent += "- **$exportKey**: $($stat.Copied) files copied, $($stat.Skipped) files skipped`n"
}

$ReadmeContent += "`n## Notes`n`n"
$ReadmeContent += "- This export excludes the development-rules folder and build artifacts`n"
$ReadmeContent += "- All documentation is preserved in the DOCs/ directory`n"
$ReadmeContent += "- Check export-info.json for detailed export information`n"
$ReadmeContent += "- For issues, refer to the original project repository`n`n"
$ReadmeContent += "**Generated by:** Export Tool v$ToolVersion`n"

$ReadmePath = Join-Path $OutputPath "README.md"
$ReadmeContent | Out-File -FilePath $ReadmePath -Encoding UTF8

# Create ZIP files if requested
$ZipFiles = @()
if ($CreateZipFile) {
    Write-Host "`nCreating ZIP file..." -ForegroundColor Cyan
    
    # Create ZIP from staging folder
    $ZipPath = "$(Split-Path $OutputPath -Parent)\SmartCallBlock_Export_$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"
    
    if (Test-Path $OutputPath) {
        Write-Host "Creating export ZIP..." -ForegroundColor Yellow
        Compress-Archive -Path "$OutputPath\*" -DestinationPath $ZipPath -CompressionLevel Optimal
        $ZipFiles += $ZipPath
        Write-Host "Export ZIP: $(Split-Path $ZipPath -Leaf)" -ForegroundColor Green
    }
    
    # Clean up staging folder
    Write-Host "Cleaning up staging folder..." -ForegroundColor DarkYellow
    if (Test-Path $OutputPath) {
        Remove-Item $OutputPath -Recurse -Force
    }
}

# Summary
Write-Host "`nExport Summary" -ForegroundColor Magenta
Write-Host "-----------------------------------------------------" -ForegroundColor DarkGray
Write-Host "Output Location: $OutputPath" -ForegroundColor White

foreach ($exportType in $Results.Keys) {
    $stat = $Results[$exportType]
    Write-Host "$exportType`: $($stat.Copied) files, $($stat.Skipped) skipped" -ForegroundColor White
}

Write-Host "Generated: README.md & export-info.json" -ForegroundColor White

if ($ZipFiles.Count -gt 0) {
    Write-Host "`nZIP Files Created:" -ForegroundColor Cyan
    foreach ($zipFile in $ZipFiles) {
        if (Test-Path $zipFile) {
            $fileName = Split-Path $zipFile -Leaf
            $fileSize = [math]::Round((Get-Item $zipFile).Length / 1MB, 2)
            Write-Host "   $fileName ($fileSize MB)" -ForegroundColor White
            Write-Host "   $zipFile" -ForegroundColor Gray
        } else {
            Write-Host "   ERROR: ZIP file not created - $zipFile" -ForegroundColor Red
        }
    }
    
    Write-Host "`nZIP files are ready for Android Studio / Xcode import!" -ForegroundColor Yellow
}

# Open output folder
if ($OpenOutputFolder -and (Test-Path $OutputPath)) {
    Write-Host "Opening output folder..." -ForegroundColor Green
    Start-Process "explorer.exe" -ArgumentList $OutputPath
}

Write-Host "`nExport completed successfully!" -ForegroundColor Green

if ($CreateZipFile -and $ZipFiles.Count -gt 0) {
    Write-Host "ZIP files saved to: $OutputPath" -ForegroundColor Cyan
} else {
    Write-Host "Files saved to: $OutputPath" -ForegroundColor Cyan
}