# Text Encoding and Quote Prevention Script

# This script prevents and fixes common text encoding issues in iOS projects

param(
    [string]$ProjectPath = ".",
    [switch]$Fix,
    [switch]$Check
)

Write-Host "🔍 iOS Text Encoding Validator" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

$SwiftFiles = Get-ChildItem -Path $ProjectPath -Filter "*.swift" -Recurse
$IssuesFound = 0

function Test-SmartQuotes {
    param($FilePath)
    $Content = Get-Content $FilePath -Raw -Encoding UTF8
    $HasSmartQuotes = $Content -match '[""'']'
    return $HasSmartQuotes
}

function Test-EncodingIssues {
    param($FilePath)
    $Content = Get-Content $FilePath -Raw -Encoding UTF8
    $HasEncodingIssues = $Content -match 'â€[¢"]|Â|â‚¬'
    return $HasEncodingIssues
}

function Fix-TextIssues {
    param($FilePath)
    $Content = Get-Content $FilePath -Raw -Encoding UTF8
    
    # Fix smart quotes
    $Content = $Content.Replace([char]8220, [char]34)  # " -> "
    $Content = $Content.Replace([char]8221, [char]34)  # " -> "  
    $Content = $Content.Replace([char]8216, [char]39)  # ' -> '
    $Content = $Content.Replace([char]8217, [char]39)  # ' -> '
    
    # Fix common encoding issues
    $Content = $Content.Replace("â€¢", "•")  # Bullet point
    $Content = $Content.Replace("â€"", "—")  # Em dash
    $Content = $Content.Replace("â€™", "'")  # Right single quote
    $Content = $Content.Replace("â€œ", '"')  # Left double quote
    $Content = $Content.Replace("â€", '"')   # Right double quote
    
    Set-Content $FilePath $Content -Encoding UTF8 -NoNewline
    Write-Host "✅ Fixed: $($FilePath)" -ForegroundColor Green
}

# Check mode
if ($Check -or !$Fix) {
    Write-Host "📋 Checking for text encoding issues..." -ForegroundColor Yellow
    
    foreach ($File in $SwiftFiles) {
        $HasSmartQuotes = Test-SmartQuotes $File.FullName
        $HasEncodingIssues = Test-EncodingIssues $File.FullName
        
        if ($HasSmartQuotes -or $HasEncodingIssues) {
            $IssuesFound++
            Write-Host "⚠️  Issues found in: $($File.Name)" -ForegroundColor Red
            
            if ($HasSmartQuotes) {
                Write-Host "   - Smart quotes detected" -ForegroundColor Yellow
            }
            if ($HasEncodingIssues) {
                Write-Host "   - Encoding issues detected" -ForegroundColor Yellow
            }
        }
    }
    
    if ($IssuesFound -eq 0) {
        Write-Host "✅ No text encoding issues found!" -ForegroundColor Green
    } else {
        Write-Host "`n⚠️  Found issues in $IssuesFound file(s)" -ForegroundColor Red
        Write-Host "Run with -Fix parameter to automatically fix these issues" -ForegroundColor Yellow
    }
}

# Fix mode
if ($Fix) {
    Write-Host "🔧 Fixing text encoding issues..." -ForegroundColor Yellow
    
    foreach ($File in $SwiftFiles) {
        $HasSmartQuotes = Test-SmartQuotes $File.FullName
        $HasEncodingIssues = Test-EncodingIssues $File.FullName
        
        if ($HasSmartQuotes -or $HasEncodingIssues) {
            Fix-TextIssues $File.FullName
            $IssuesFound++
        }
    }
    
    Write-Host "`n✅ Fixed issues in $IssuesFound file(s)" -ForegroundColor Green
}

# AppIcon validation
Write-Host "`n🎨 Checking AppIcon configuration..." -ForegroundColor Cyan
$AppIconPath = Join-Path $ProjectPath "**/Assets.xcassets/AppIcon.appiconset/Contents.json"
$AppIconFiles = Get-ChildItem -Path $AppIconPath -Recurse -ErrorAction SilentlyContinue

if ($AppIconFiles.Count -eq 0) {
    Write-Host "❌ AppIcon.appiconset not found" -ForegroundColor Red
} else {
    foreach ($File in $AppIconFiles) {
        $Content = Get-Content $File.FullName -Raw | ConvertFrom-Json
        $RequiredSizes = @("20x20", "29x29", "40x40", "60x60", "76x76", "83.5x83.5", "1024x1024")
        $FoundSizes = $Content.images | ForEach-Object { $_.size } | Select-Object -Unique
        
        $MissingSizes = $RequiredSizes | Where-Object { $_ -notin $FoundSizes }
        
        if ($MissingSizes.Count -eq 0) {
            Write-Host "✅ AppIcon configuration complete" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Missing icon sizes: $($MissingSizes -join ', ')" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n🏁 Text encoding validation complete!" -ForegroundColor Cyan