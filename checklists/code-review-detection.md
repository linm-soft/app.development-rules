# 🔍 Code Review & Detection - Master Checklist

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "code-review-detection"...
```

**Purpose:** Let user know AI is running master compliance review checklist.

---

## Overview

**This is the MASTER checklist for full code review ("review all" command).**

For targeted reviews, use specific checklists:
- [Project Structure](./review-project-structure.md)
- [Multi-language Support](./review-multi-language.md)
- [Theme & Dark Mode](./review-theme-dark-mode.md)
- [Bottom Navigation](./review-bottom-navigation.md)
- [MainProfile Fragment](./review-mainprofile.md)
- [Hardcoded Strings](./review-hardcoded-strings.md)
- [Dialog Rules](./review-dialog-rules.md)
- [Permissions Handling](./review-permissions.md)

---

## Quick Review Workflow

### When to Use Which Checklist

| User Command | AI Action | Checklist to Read |
|--------------|-----------|-------------------|
| `review all` | Full compliance review | 👉 THIS FILE (master) |
| `review app` | Smart review (skip baseline) | 👉 THIS FILE (master) |
| `review strings` | Check hardcoded strings only | 👉 [review-hardcoded-strings.md](./review-hardcoded-strings.md) |
| `review theme` | Check dark mode compliance | 👉 [review-theme-dark-mode.md](./review-theme-dark-mode.md) |
| `review mainprofile` | Check MainProfile implementation | 👉 [review-mainprofile.md](./review-mainprofile.md) |
| `review permissions` | Check permission sync | 👉 [review-permissions.md](./review-permissions.md) |
| `review dialogs` | Check dialog implementation | 👉 [review-dialog-rules.md](./review-dialog-rules.md) |
| `review bottom nav` | Check bottom navigation | 👉 [review-bottom-navigation.md](./review-bottom-navigation.md) |
| `review structure` | Check project structure | 👉 [review-project-structure.md](./review-project-structure.md) |

---

## Master Detection Commands

Run ALL for complete review:

### 1. Hardcoded Strings in Layouts

```powershell
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String 'android:(text|hint|contentDescription)="[^@]' | 
    Select-Object -Property Path, LineNumber, Line
```

### 2. Hardcoded Strings in Java

```powershell
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String '(setText|makeText|setContentDescription)\s*\([^,]*"' | 
    Select-Object -Property Path, LineNumber, Line
```

### 3. Hardcoded Hex Colors

```powershell
Get-ChildItem -Path "app\src\main\res" -Filter "*.xml" -Recurse | 
    Select-String '#[0-9A-Fa-f]{6,8}' | 
    Where-Object { $_.Line -notmatch '<!--' } |
    Select-Object -Property Path, LineNumber, Line
```

### 4. Dark Color Anti-pattern

```powershell
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String '@color/\w+_dark' | 
    Select-Object -Property Path, LineNumber, Line
```

### 5. Database Migration Compliance ⚠️ CRITICAL

```powershell
# Check if DatabaseHelper exists and has proper migration
if (Test-Path "app\src\main\java\com\*\DatabaseHelper.java") {
    $dbFile = Get-ChildItem -Path "app\src\main\java" -Filter "*DatabaseHelper.java" -Recurse | Select-Object -First 1
    if ($dbFile) {
        Write-Host "📊 Found DatabaseHelper: $($dbFile.Name)" -ForegroundColor Yellow
        
        # Check DATABASE_VERSION
        $versionLine = Select-String -Path $dbFile.FullName -Pattern "DATABASE_VERSION\s*=\s*(\d+)"
        if ($versionLine) {
            Write-Host "✅ DATABASE_VERSION: $($versionLine.Matches[0].Groups[1].Value)" -ForegroundColor Green
        } else {
            Write-Host "❌ MISSING: DATABASE_VERSION constant" -ForegroundColor Red
        }
        
        # Check onUpgrade method
        $upgradeMethod = Select-String -Path $dbFile.FullName -Pattern "onUpgrade.*SQLiteDatabase.*int.*int"
        if ($upgradeMethod) {
            Write-Host "✅ onUpgrade method exists" -ForegroundColor Green
        } else {
            Write-Host "❌ MISSING: onUpgrade method" -ForegroundColor Red
        }
        
        # Check for ALTER TABLE statements
        $alterTables = Select-String -Path $dbFile.FullName -Pattern "ALTER TABLE" | Measure-Object
        if ($alterTables.Count -gt 0) {
            Write-Host "✅ Migration statements: $($alterTables.Count) ALTER TABLE found" -ForegroundColor Green
        } else {
            Write-Host "⚠️ WARNING: No ALTER TABLE migration statements found" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "ℹ️ No DatabaseHelper found - skipping migration check" -ForegroundColor Cyan
}
```

### 6. UI & User Experience Compliance ⚠️ CRITICAL (Rules 2.9-2.17)

```powershell
Write-Host "`n🎨 === UI & USER EXPERIENCE COMPLIANCE ===" -ForegroundColor Magenta

# Rule 2.10 - Material Design 3 Check
Write-Host "`n📱 Material Design 3 Compliance:" -ForegroundColor Yellow
$themeFiles = @("app\src\main\res\values\themes.xml", "app\src\main\res\values-night\themes.xml")
foreach ($file in $themeFiles) {
    if (Test-Path $file) {
        $md3 = Select-String -Path $file -Pattern "Theme\.Material3\."
        if ($md3) {
            Write-Host "✅ Material Design 3 theme found in $file" -ForegroundColor Green
        } else {
            Write-Host "❌ MISSING: Material Design 3 theme in $file" -ForegroundColor Red
        }
    }
}

# Rule 2.11 - Dialog Standards Check
Write-Host "`n💬 Dialog Framework Compliance:" -ForegroundColor Yellow
$dialogLayouts = Get-ChildItem -Path "app\src\main\res\layout" -Filter "dialog_*.xml" -ErrorAction SilentlyContinue
if ($dialogLayouts.Count -gt 0) {
    Write-Host "✅ Custom dialog layouts found: $($dialogLayouts.Count)" -ForegroundColor Green
    foreach ($dialog in $dialogLayouts) {
        Write-Host "   - $($dialog.Name)" -ForegroundColor Cyan
    }
} else {
    Write-Host "⚠️ No custom dialog layouts found (dialog_*.xml)" -ForegroundColor Yellow
}

# Rule 2.12 - Permissions Check
Write-Host "`n🔐 Permissions Compliance:" -ForegroundColor Yellow
$manifest = "app\src\main\AndroidManifest.xml"
if (Test-Path $manifest) {
    $permissions = Select-String -Path $manifest -Pattern "uses-permission.*android\.permission\."
    if ($permissions.Count -gt 0) {
        Write-Host "✅ Permissions declared: $($permissions.Count)" -ForegroundColor Green
        # Check for proper permission handling in Java
        $permissionCheck = Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
            Select-String "(checkSelfPermission|requestPermissions)" | Measure-Object
        if ($permissionCheck.Count -gt 0) {
            Write-Host "✅ Runtime permission handling found" -ForegroundColor Green
        } else {
            Write-Host "❌ MISSING: Runtime permission handling code" -ForegroundColor Red
        }
    }
}

# Rule 2.14 - Theme & Dark Mode Support
Write-Host "`n🌙 Dark Mode Compliance:" -ForegroundColor Yellow
$nightColors = "app\src\main\res\values-night\colors.xml"
if (Test-Path $nightColors) {
    Write-Host "✅ Dark mode colors found" -ForegroundColor Green
} else {
    Write-Host "❌ MISSING: Dark mode color resources (values-night/colors.xml)" -ForegroundColor Red
}

# Rule 2.15 - MainProfile Fragment
Write-Host "`n👤 MainProfile Implementation:" -ForegroundColor Yellow
$profileFragment = Get-ChildItem -Path "app\src\main\java" -Filter "*MainProfile*.java" -Recurse -ErrorAction SilentlyContinue
$profileLayout = Get-ChildItem -Path "app\src\main\res\layout" -Filter "*main_profile*.xml" -ErrorAction SilentlyContinue
if ($profileFragment -and $profileLayout) {
    Write-Host "✅ MainProfile fragment and layout found" -ForegroundColor Green
} else {
    Write-Host "⚠️ MainProfile fragment or layout missing" -ForegroundColor Yellow
}

Write-Host "`n🎨 === UI/UX COMPLIANCE CHECK COMPLETE ===" -ForegroundColor Magenta
```

## Expected Result

- ✅ **No output** = No hardcoded values (GOOD)
- ❌ **Has output** = MUST FIX before submit

## AI Review Workflow

1. Auto-check after editing files
2. Show findings to user
3. User confirms which to fix
4. Fix confirmed issues
5. Re-run to verify

**DO NOT auto-fix without user confirmation!**

## Allowed Exceptions

- Layout dimensions: `android:layout_width="48dp"` (OK - specific to view)
- Boolean/numeric: `android:enabled="true"` (OK - not translatable)
- Log tags: `String TAG = "Activity"` (OK - not user-facing)
- URL/Email constants (OK - configuration)

**NOT allowed:**
- User-facing text (NEVER hardcode)
- Colors (NEVER hardcode hex)

---

## Structural Compliance Checks

### Project Structure

**Check these files/folders exist:**

```powershell
# Check MainProfile fragment exists (REQUIRED)
Test-Path "app\src\main\java\com\*\MainProfile.java"

# Check fragments folder exists
Test-Path "app\src\main\java\com\*\fragments" -or 
Test-Path "app\src\main\java\com\*\*\MainProfile.java"
```

**Expected:**
- ✅ `MainProfile.java` MUST exist
- ✅ Located in root package or fragments subfolder

### Theme Files (REQUIRED for Dark Mode)

```powershell
# Check theme files exist
$checks = @(
    "app\src\main\res\values\attrs.xml",
    "app\src\main\res\values\styles_theme.xml",
    "app\src\main\res\values-night\styles_theme.xml",
    "app\src\main\res\drawable\dialog_background.xml"
)

foreach ($file in $checks) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ MISSING: $file" -ForegroundColor Red
    }
}
```

**Expected:**
- ✅ All 4 files MUST exist
- ❌ Missing any = Dark mode broken

### Bottom Navigation

```powershell
# Check labelVisibilityMode in layouts
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String 'BottomNavigationView' -Context 0,5 | 
    ForEach-Object { 
        if ($_.Line -match 'BottomNavigationView' -and 
            $_.Context.PostContext -notmatch 'labelVisibilityMode') {
            Write-Host "❌ Missing labelVisibilityMode: $($_.Path)" -ForegroundColor Red
        }
    }

# Check for color selectors
Test-Path "app\src\main\res\color\bottom_nav_color.xml"
```

**Expected:**
- ✅ `labelVisibilityMode="selected"` must be set
- ✅ Color selector file must exist
- ❌ Missing = UI inconsistent

### Multi-language Support

```powershell
# Check both language folders exist
$enFiles = Get-ChildItem "app\src\main\res\values\strings*.xml"
$viFiles = Get-ChildItem "app\src\main\res\values-vi\strings*.xml"

Write-Host "English strings: $($enFiles.Count)"
Write-Host "Vietnamese strings: $($viFiles.Count)"

if ($enFiles.Count -ne $viFiles.Count) {
    Write-Host "❌ WARNING: File count mismatch!" -ForegroundColor Red
}

# Check string names match
foreach ($enFile in $enFiles) {
    $basename = $enFile.Name
    $viFile = "app\src\main\res\values-vi\$basename"
    
    if (-not (Test-Path $viFile)) {
        Write-Host "❌ MISSING: $viFile" -ForegroundColor Red
    } else {
        $enNames = Select-String -Path $enFile.FullName -Pattern 'name="([^"]+)"' | 
                   ForEach-Object { $_.Matches.Groups[1].Value }
        $viNames = Select-String -Path $viFile -Pattern 'name="([^"]+)"' | 
                   ForEach-Object { $_.Matches.Groups[1].Value }
        
        $missing = Compare-Object $enNames $viNames | Where-Object { $_.SideIndicator -eq '<=' }
        if ($missing) {
            Write-Host "❌ Strings missing in Vietnamese: $($missing.InputObject -join ', ')" -ForegroundColor Red
        }
    }
}
```

**Expected:**
- ✅ Same number of strings*.xml files in both folders
- ✅ String names identical in both languages
- ❌ Mismatch = Translation incomplete

### MainProfile Fragment Content

```powershell
# Check MainProfile has required sections
$profile = Get-Content "app\src\main\java\com\*\*\MainProfile.java" -Raw

$required = @(
    @{Pattern='getAppPermissions|PermissionInfo'; Name='Permissions Section'},
    @{Pattern='switchDarkMode|setDefaultNightMode'; Name='Dark Mode Toggle'},
    @{Pattern='Language|Tiếng Việt'; Name='Language Selector'},
    @{Pattern='BuildConfig.VERSION_NAME'; Name='Version Display'},
    @{Pattern='BuildConfig.BUILD_TIME|releaseDate'; Name='Release Date'},
    @{Pattern='Linh\.BoDinh|support@soft-linm\.com'; Name='Developer Info'}
)

foreach ($check in $required) {
    if ($profile -match $check.Pattern) {
        Write-Host "✅ $($check.Name)" -ForegroundColor Green
    } else {
        Write-Host "❌ MISSING: $($check.Name)" -ForegroundColor Red
    }
}
```

**Expected:**
- ✅ All 6 sections present
- ❌ Missing any = Incomplete implementation

### Permission Synchronization

```powershell
# Extract permissions from 3 places
$manifest = Get-Content "app\src\main\AndroidManifest.xml" -Raw
$mainActivity = Get-Content "app\src\main\java\com\*\MainActivity.java" -Raw
$mainProfile = Get-Content "app\src\main\java\com\*\*\MainProfile.java" -Raw

# Find permission count in each
$manifestCount = ([regex]::Matches($manifest, 'uses-permission')).Count
$termsCount = ([regex]::Matches($mainActivity, 'TYPE_PERMISSION')).Count
$profileCount = ([regex]::Matches($mainProfile, 'PermissionInfo\(')).Count

Write-Host "Manifest permissions: $manifestCount"
Write-Host "Terms dialog items: $termsCount"
Write-Host "Profile permissions: $profileCount"

if ($manifestCount -ne $termsCount -or $manifestCount -ne $profileCount) {
    Write-Host "❌ WARNING: Permission count mismatch!" -ForegroundColor Red
    Write-Host "   Must sync: AndroidManifest.xml, MainActivity (terms), MainProfile (list)" -ForegroundColor Yellow
}
```

**Expected:**
- ✅ Same permission count in all 3 places
- ❌ Mismatch = Permissions not synchronized

### CardView Background Check

```powershell
# Find CardViews without cardBackgroundColor
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String '<.*CardView' -Context 0,10 | 
    Where-Object { 
        $_.Line -match 'CardView' -and 
        $_.Context.PostContext -notmatch 'cardBackgroundColor'
    } | 
    Select-Object Path, LineNumber | 
    ForEach-Object {
        Write-Host "❌ CardView missing cardBackgroundColor: $($_.Path):$($_.LineNumber)" -ForegroundColor Red
    }
```

**Expected:**
- ✅ No output = All CardViews have `cardBackgroundColor`
- ❌ Has output = Fix required (will break dark mode)

---

## Review Checklist Summary

Run these in order:

1. ✅ Hardcoded Strings (Layouts + Java)
2. ✅ Hardcoded Colors (Hex codes)
3. ✅ Dark Color Anti-pattern (`_dark` suffix)
4. ✅ Project Structure (MainProfile exists)
5. ✅ Theme Files (attrs.xml, styles, dialog background)
6. ✅ Bottom Navigation (`labelVisibilityMode`)
7. ✅ Multi-language (EN/VI file parity)
8. ✅ MainProfile Content (6 required sections)
9. ✅ Permission Sync (3 places match)
10. ✅ CardView Background (all have `cardBackgroundColor`)

**All checks pass = ✅ COMPLIANT**
**Any check fails = ❌ FIX REQUIRED**

---

*This checklist is COMPLETE - AI does not need Implementation files for review.*
