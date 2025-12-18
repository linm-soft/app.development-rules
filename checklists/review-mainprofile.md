# ✅ MainProfile Fragment Checklist

## Quick Check

Verify MainProfile fragment has all required sections:

### 1. Check MainProfile.java Exists

```powershell
$profile = Get-ChildItem -Path "app\src\main\java" -Filter "MainProfile.java" -Recurse

if ($profile) {
    Write-Host "✅ MainProfile.java found: $($profile.FullName)" -ForegroundColor Green
    $content = Get-Content $profile.FullName -Raw
} else {
    Write-Host "❌ CRITICAL: MainProfile.java NOT FOUND (REQUIRED)" -ForegroundColor Red
    exit
}
```

**Expected:** ✅ File MUST exist

### 2. Check Required Sections in Code

```powershell
$required = @(
    @{Pattern='getAppPermissions|PermissionInfo'; Name='Permissions Section'; Critical=$true},
    @{Pattern='switchDarkMode|setDefaultNightMode'; Name='Dark Mode Toggle'; Critical=$true},
    @{Pattern='Language|Tiếng Việt|languageSelector'; Name='Language Selector'; Critical=$true},
    @{Pattern='BuildConfig\.VERSION_NAME'; Name='Version Display'; Critical=$true},
    @{Pattern='BuildConfig\.BUILD_TIME|releaseDate'; Name='Release Date'; Critical=$true},
    @{Pattern='Linh\.BoDinh|support@soft-linm\.com|soft-linm\.com'; Name='Developer Info'; Critical=$true}
)

$passed = 0
$failed = 0

foreach ($check in $required) {
    if ($content -match $check.Pattern) {
        Write-Host "✅ $($check.Name)" -ForegroundColor Green
        $passed++
    } else {
        if ($check.Critical) {
            Write-Host "❌ MISSING: $($check.Name) (REQUIRED)" -ForegroundColor Red
            $failed++
        } else {
            Write-Host "⚠️  $($check.Name) not found" -ForegroundColor Yellow
        }
    }
}

Write-Host "`nResult: $passed/$($required.Count) sections implemented" -ForegroundColor Cyan
```

**Expected:** ✅ All 6 sections MUST be present

### 3. Check Layout File Exists

```powershell
$layouts = @(
    "app\src\main\res\layout\main_profile.xml",
    "app\src\main\res\layout\fragment_profile.xml"
)

$found = $false
foreach ($layout in $layouts) {
    if (Test-Path $layout) {
        Write-Host "✅ Layout found: $layout" -ForegroundColor Green
        $found = $true
        break
    }
}

if (-not $found) {
    Write-Host "❌ MISSING: MainProfile layout file" -ForegroundColor Red
}
```

### 4. Check Permission Synchronization

```powershell
$manifest = Get-Content "app\src\main\AndroidManifest.xml" -Raw
$mainActivity = Get-Content "app\src\main\java\com\*\MainActivity.java" -Raw
$mainProfile = Get-Content $profile.FullName -Raw

# Count permissions in each place
$manifestCount = ([regex]::Matches($manifest, 'uses-permission')).Count
$termsCount = ([regex]::Matches($mainActivity, 'TYPE_PERMISSION')).Count  
$profileCount = ([regex]::Matches($mainProfile, 'PermissionInfo\(')).Count

Write-Host "`nPermission Synchronization:" -ForegroundColor Cyan
Write-Host "  Manifest: $manifestCount permissions"
Write-Host "  Terms Dialog: $termsCount items"
Write-Host "  Profile List: $profileCount items"

if ($manifestCount -eq $termsCount -and $manifestCount -eq $profileCount) {
    Write-Host "✅ Permissions synchronized across all 3 places" -ForegroundColor Green
} else {
    Write-Host "❌ WARNING: Permission count mismatch!" -ForegroundColor Red
    Write-Host "   Must sync: AndroidManifest.xml, MainActivity.getPermissionTerms(), MainProfile.getAppPermissions()" -ForegroundColor Yellow
}
```

### 5. Check String Resources

```powershell
$stringFiles = @(
    "app\src\main\res\values\strings_profile.xml",
    "app\src\main\res\values-vi\strings_profile.xml"
)

foreach ($file in $stringFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file exists" -ForegroundColor Green
    } else {
        Write-Host "❌ MISSING: $file" -ForegroundColor Red
    }
}
```

## Compliance Checklist

**Critical (MUST have):**
- [ ] MainProfile.java exists in project
- [ ] Permissions section implemented
- [ ] Dark Mode toggle implemented  
- [ ] Language selector implemented
- [ ] Version display (BuildConfig.VERSION_NAME)
- [ ] Release date (BuildConfig.BUILD_TIME)
- [ ] Developer info (Linh.BoDinh, support@soft-linm.com)
- [ ] Layout file exists (main_profile.xml or fragment_profile.xml)
- [ ] Permissions synchronized in 3 places
- [ ] String resources in both EN and VI

**Optional (Recommended):**
- [ ] User info section (if login enabled)
- [ ] Settings organized in sections
- [ ] Clickable website link
- [ ] Clickable email link

**Result:**
- ✅ All critical checks pass = COMPLIANT
- ❌ Any critical check fails = FIX REQUIRED

---

*For implementation details, see: [mainprofile-fragment.md](../implementation/mainprofile-fragment.md)*
