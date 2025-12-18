# Script to update development team settings in project.pbxproj
$projectPath = "D:\MyRepo\AI-App\Source\smart-call-block\IOS\SmartCallBlock.xcodeproj\project.pbxproj"

# Read content
$content = Get-Content $projectPath -Raw

# Replace all empty DEVELOPMENT_TEAM with placeholder
$content = $content -replace 'DEVELOPMENT_TEAM = "";', 'DEVELOPMENT_TEAM = "YOUR_TEAM_ID";'

# Update bundle identifiers to use proper format
$content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.smartcallblock\.app;', 'PRODUCT_BUNDLE_IDENTIFIER = "com.yourcompany.smartcallblock";'
$content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = com\.smartcallblock\.app\.extension;', 'PRODUCT_BUNDLE_IDENTIFIER = "com.yourcompany.smartcallblock.extension";'

# Write back to file
$content | Out-File -FilePath $projectPath -Encoding UTF8 -NoNewline

Write-Host "Updated development team and bundle identifiers!"
Write-Host ""
Write-Host "⚠️  IMPORTANT: You need to update the following:"
Write-Host "1. Replace 'YOUR_TEAM_ID' with your actual Apple Developer Team ID"
Write-Host "2. Replace 'com.yourcompany.smartcallblock' with your unique bundle identifier"
Write-Host "3. Ensure you have valid certificates and provisioning profiles"