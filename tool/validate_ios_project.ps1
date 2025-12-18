# iOS Project Validation Tool
# Validates Xcode project.pbxproj structure for common corruption issues
# Usage: Run from iOS project directory containing .xcodeproj folder
# 
# Checks:
# - SmartCallBlock target configuration list integrity
# - CallDirectoryExtension target configuration list integrity  
# - Project structure validity
# - Build configuration existence and proper linking
#
# Returns: 0 if valid, 1 if issues found
param()

$projectFile = "SmartCallBlock.xcodeproj/project.pbxproj"

Write-Host "=== iOS Project Final Validation ===" -ForegroundColor Cyan

if (-not (Test-Path $projectFile)) {
    Write-Host "Project file not found!" -ForegroundColor Red
    exit 1
}

$content = Get-Content $projectFile -Raw

Write-Host "Checking SmartCallBlock target..." -ForegroundColor Yellow
$smartCallBlockOK = ($content -match "buildConfigurationList = 7B4F1C3B2C1B8F9E00123458") -and 
                   ($content -match "7B4F1C3B2C1B8F9E00123458.*Build configuration list for PBXNativeTarget.*SmartCallBlock") -and
                   ($content -match "7B4F1C3C2C1B8F9E00123458.*Debug.*= \{") -and
                   ($content -match "7B4F1C3D2C1B8F9E00123458.*Release.*= \{")

Write-Host "  SmartCallBlock target: $(if($smartCallBlockOK) {'✓ PASS'} else {'✗ FAIL'})" -ForegroundColor $(if($smartCallBlockOK) {"Green"} else {"Red"})

Write-Host "Checking CallDirectoryExtension target..." -ForegroundColor Yellow
$extensionOK = ($content -match "buildConfigurationList = 7B4F1C592C1B912400123456") -and
               ($content -match "7B4F1C592C1B912400123456.*Build configuration list for PBXNativeTarget.*CallDirectoryExtension") -and
               ($content -match "7B4F1C572C1B912400123456.*Debug.*= \{") -and
               ($content -match "7B4F1C582C1B912400123456.*Release.*= \{")

Write-Host "  CallDirectoryExtension target: $(if($extensionOK) {'✓ PASS'} else {'✗ FAIL'})" -ForegroundColor $(if($extensionOK) {"Green"} else {"Red"})

Write-Host "Checking project structure..." -ForegroundColor Yellow
$structureOK = ($content -match '^// !\$\*UTF8\*\$!') -and ($content -match 'rootObject = [A-F0-9]{24}')
Write-Host "  Project structure: $(if($structureOK) {'✓ PASS'} else {'✗ FAIL'})" -ForegroundColor $(if($structureOK) {"Green"} else {"Red"})

$allOK = $smartCallBlockOK -and $extensionOK -and $structureOK

Write-Host ""
Write-Host "=== FINAL RESULT ===" -ForegroundColor Cyan
if ($allOK) {
    Write-Host "🎉 PROJECT IS READY FOR XCODE!" -ForegroundColor Green
    Write-Host "All configurations properly linked and validated." -ForegroundColor Green
} else {
    Write-Host "❌ PROJECT NEEDS MORE FIXES" -ForegroundColor Red
}

exit $(if($allOK) {0} else {1})