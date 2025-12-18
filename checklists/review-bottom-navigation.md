# ✅ Bottom Navigation Checklist

## Quick Check

Verify Bottom Navigation implementation:

### 1. Check labelVisibilityMode

```powershell
$layouts = Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse

foreach ($layout in $layouts) {
    $content = Get-Content $layout.FullName -Raw
    
    if ($content -match 'BottomNavigationView') {
        Write-Host "`nChecking $($layout.Name)..." -ForegroundColor Cyan
        
        if ($content -match 'labelVisibilityMode\s*=\s*"selected"') {
            Write-Host "✅ labelVisibilityMode=`"selected`" found" -ForegroundColor Green
        } else {
            Write-Host "❌ MISSING or WRONG: labelVisibilityMode" -ForegroundColor Red
            Write-Host "   File: $($layout.FullName)" -ForegroundColor Yellow
        }
    }
}
```

**Expected:** ✅ `app:labelVisibilityMode="selected"` MUST be set

### 2. Check Color Selector File

```powershell
if (Test-Path "app\src\main\res\color\bottom_nav_color.xml") {
    Write-Host "✅ bottom_nav_color.xml exists" -ForegroundColor Green
    
    # Check it uses @color references (not hex)
    $content = Get-Content "app\src\main\res\color\bottom_nav_color.xml" -Raw
    if ($content -match '#[0-9A-Fa-f]{6,8}') {
        Write-Host "❌ WARNING: Contains hardcoded hex colors" -ForegroundColor Red
    } else {
        Write-Host "✅ Uses @color references" -ForegroundColor Green
    }
} else {
    Write-Host "❌ MISSING: bottom_nav_color.xml" -ForegroundColor Red
}
```

### 3. Check Item Background Drawable

```powershell
$bgFiles = @(
    "app\src\main\res\drawable\bottom_nav_item_background.xml",
    "app\src\main\res\drawable\bottom_nav_background.xml"
)

$found = $false
foreach ($file in $bgFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file exists" -ForegroundColor Green
        $found = $true
        break
    }
}

if (-not $found) {
    Write-Host "⚠️  No item background drawable found" -ForegroundColor Yellow
}
```

### 4. Check BottomNavigationView Attributes

```powershell
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String 'BottomNavigationView' -Context 0,10 | 
    ForEach-Object {
        $context = $_.Context.PostContext -join "`n"
        
        Write-Host "`nChecking attributes in $($_.Path)..." -ForegroundColor Cyan
        
        if ($context -match 'itemIconTint') {
            Write-Host "✅ itemIconTint set" -ForegroundColor Green
        } else {
            Write-Host "⚠️  itemIconTint not set" -ForegroundColor Yellow
        }
        
        if ($context -match 'itemTextColor') {
            Write-Host "✅ itemTextColor set" -ForegroundColor Green
        } else {
            Write-Host "⚠️  itemTextColor not set" -ForegroundColor Yellow
        }
    }
```

## Compliance Checklist

- [ ] **Item Count Limit**: The number of menu items MUST NOT exceed 5.
- [ ] `app:labelVisibilityMode="selected"` is set (REQUIRED)
- [ ] Color selector file exists (`bottom_nav_color.xml`)
- [ ] Color selector uses `@color/` references (not hex)
- [ ] Item background drawable exists (optional but recommended)
- [ ] `app:itemIconTint` uses color selector
- [ ] `app:itemTextColor` uses color selector

**Result:**
- ✅ All required checks pass = COMPLIANT
- ❌ labelVisibilityMode missing = FIX REQUIRED
- ⚠️ Optional items missing = Recommended to add

---

*For implementation details, see: [bottom-navigation.md](../implementation/bottom-navigation.md)*
