# ✅ Theme & Dark Mode Checklist

## Quick Check

Verify theme files and dark mode support:

### 1. Check Required Theme Files

```powershell
$themeFiles = @(
    "app\src\main\res\values\attrs.xml",
    "app\src\main\res\values\styles_theme.xml",
    "app\src\main\res\values-night\styles_theme.xml",
    "app\src\main\res\drawable\dialog_background.xml"
)

foreach ($file in $themeFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ MISSING: $file" -ForegroundColor Red
    }
}
```

**Expected:** ✅ All 4 files MUST exist

### 2. Check for Dark Color Anti-pattern

```powershell
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String '@color/\w+_dark' | 
    Select-Object -Property Path, LineNumber, Line
```

**Expected:** 
- ✅ No output = GOOD (using theme-aware colors)
- ❌ Has output = FIX REQUIRED (remove `_dark` suffix)

### 3. Check CardView Background

```powershell
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String '<.*CardView' -Context 0,10 | 
    Where-Object { 
        $_.Line -match 'CardView' -and 
        $_.Context.PostContext -notmatch 'cardBackgroundColor'
    } | 
    ForEach-Object {
        Write-Host "❌ CardView missing cardBackgroundColor:" -ForegroundColor Red
        Write-Host "   $($_.Path):$($_.LineNumber)" -ForegroundColor Yellow
    }
```

**Expected:**
- ✅ No output = All CardViews have `cardBackgroundColor`
- ❌ Has output = FIX REQUIRED

### 4. Check Color Files in Both Modes

```powershell
$colorFiles = Get-ChildItem "app\src\main\res\values\colors*.xml" | Select-Object -ExpandProperty Name

foreach ($file in $colorFiles) {
    $nightFile = "app\src\main\res\values-night\$file"
    if (Test-Path $nightFile) {
        Write-Host "✅ $file has dark mode version" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $file missing dark mode version" -ForegroundColor Yellow
    }
}
```

### 5. Check for Hardcoded Hex Colors

```powershell
Get-ChildItem -Path "app\src\main\res" -Filter "*.xml" -Recurse | 
    Select-String '#[0-9A-Fa-f]{6,8}' | 
    Where-Object { $_.Line -notmatch '<!--' } |
    Select-Object -Property Path, LineNumber, Line
```

**Expected:**
- ✅ No output = GOOD
- ❌ Has output = Replace with `@color/` references

## Compliance Checklist

- [ ] `attrs.xml` exists with custom theme attributes
- [ ] `styles_theme.xml` exists in `values/` (Light theme)
- [ ] `styles_theme.xml` exists in `values-night/` (Dark theme)
- [ ] `dialog_background.xml` exists
- [ ] NO `_dark` suffix used directly in layouts
- [ ] All CardViews have `app:cardBackgroundColor`
- [ ] NO hardcoded hex colors in layouts
- [ ] Color selectors use `@color/` references (not hex)
- [ ] Color files exist in both `values/` and `values-night/`

**Result:**
- ✅ All checks pass = COMPLIANT
- ❌ Any check fails = FIX REQUIRED

---

*For implementation details, see: [theme-settings.md](../implementation/theme-settings.md)*
