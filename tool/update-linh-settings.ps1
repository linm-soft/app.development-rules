# Script to update development team settings with Linh's App ID
$projectPath = "D:\MyRepo\AI-App\Source\smart-call-block\IOS\SmartCallBlock.xcodeproj\project.pbxproj"

# Read content
$content = Get-Content $projectPath -Raw

# Replace development team with Linh's team ID
$content = $content -replace 'DEVELOPMENT_TEAM = "YOUR_TEAM_ID";', 'DEVELOPMENT_TEAM = "LINH_TEAM_ID";'

# Update bundle identifiers with Linh's App ID format
$content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = "com\.yourcompany\.smartcallblock";', 'PRODUCT_BUNDLE_IDENTIFIER = "com.linh.smartcallblock";'
$content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = "com\.yourcompany\.smartcallblock\.extension";', 'PRODUCT_BUNDLE_IDENTIFIER = "com.linh.smartcallblock.extension";'

# Write back to file
$content | Out-File -FilePath $projectPath -Encoding UTF8 -NoNewline

Write-Host "Updated development team and bundle identifiers for Linh's App ID!"
Write-Host ""
Write-Host "Updated settings:"
Write-Host "- DEVELOPMENT_TEAM = 'LINH_TEAM_ID'"
Write-Host "- Main app bundle: com.linh.smartcallblock"
Write-Host "- Extension bundle: com.linh.smartcallblock.extension"
Write-Host ""
Write-Host "⚠️  Remember to replace 'LINH_TEAM_ID' with actual Team ID from Apple Developer Account"