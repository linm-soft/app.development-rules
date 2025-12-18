# Script to update bundle identifiers to linm.soft
$projectPath = "D:\MyRepo\AI-App\Source\smart-call-block\IOS\SmartCallBlock.xcodeproj\project.pbxproj"

# Read content
$content = Get-Content $projectPath -Raw

# Update bundle identifiers with linm.soft format
$content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = "com\.linh\.smartcallblock";', 'PRODUCT_BUNDLE_IDENTIFIER = "linm.soft.smartcallblock";'
$content = $content -replace 'PRODUCT_BUNDLE_IDENTIFIER = "com\.linh\.smartcallblock\.extension";', 'PRODUCT_BUNDLE_IDENTIFIER = "linm.soft.smartcallblock.extension";'

# Write back to file
$content | Out-File -FilePath $projectPath -Encoding UTF8 -NoNewline

Write-Host "Updated bundle identifiers to linm.soft format!"
Write-Host ""
Write-Host "New bundle identifiers:"
Write-Host "- Main app: linm.soft.smartcallblock"
Write-Host "- Extension: linm.soft.smartcallblock.extension"