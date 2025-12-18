# ✅ XML Namespace Declaration Checklist

## Quick Detection Commands

### 1. Find Incorrect Namespace Declarations

```powershell
# Find namespaces declared in child elements (not root)
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    ForEach-Object { 
        $content = Get-Content $_.FullName -Raw
        if ($content -match '(?s)<[^>]+\n[^>]*xmlns:[^=]+="[^"]*"') { 
            Write-Host "$($_.Name): Potential namespace issue" -ForegroundColor Yellow
        }
    }
```

**Expected:**
- ✅ No output = GOOD (all namespaces at root)
- ❌ Has output = FIX REQUIRED

### 2. Verify Namespace Usage

```powershell
# Check if app: prefix is used but xmlns:app is missing
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String 'app:' | 
    Select-Object -Property Path, LineNumber, Line
```

### 3. Check Duplicate Namespaces

```powershell
# Find files with duplicate namespace declarations
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    ForEach-Object { 
        $content = Get-Content $_.FullName
        $namespaceCount = ($content | Select-String "xmlns:").Count
        if ($namespaceCount -gt 3) { 
            Write-Host "$($_.Name): $namespaceCount namespace declarations" -ForegroundColor Red
        }
    }
```

## Common Issues & Fixes

### Issue 1: Namespace in CardView
```xml
❌ WRONG:
<ScrollView xmlns:android="...">
    <CardView xmlns:app="...">  <!-- Wrong place -->

✅ CORRECT:
<ScrollView xmlns:android="..."
    xmlns:app="...">  <!-- At root -->
    <CardView>
```

### Issue 2: Namespace in ConstraintLayout
```xml
❌ WRONG:
<LinearLayout xmlns:android="...">
    <ConstraintLayout xmlns:app="...">  <!-- Wrong place -->

✅ CORRECT:
<LinearLayout xmlns:android="..."
    xmlns:app="...">  <!-- At root -->
    <ConstraintLayout>
```

### Issue 3: Include Tag Conflicts
```xml
❌ WRONG:
<include layout="@layout/header" 
    xmlns:app="..." />  <!-- Conflicts with parent -->

✅ CORRECT:
<include layout="@layout/header" />  <!-- No namespace needed -->
```

## Standard Namespaces

Always declare these at root element:
```xml
xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:app="http://schemas.android.com/apk/res-auto"
xmlns:tools="http://schemas.android.com/tools"
```

## Compliance Checklist

- [ ] All `xmlns:*` declarations at root element (line 2-3)
- [ ] NO namespace declarations in child elements
- [ ] NO duplicate namespace declarations
- [ ] All `app:*` attributes work correctly
- [ ] All `tools:*` attributes work correctly
- [ ] Build succeeds without XML parsing errors
- [ ] Android Studio shows no XML syntax warnings

**Result:**
- ✅ All checks pass = COMPLIANT
- ❌ Any namespace issues found = FIX REQUIRED

---

*Related rule: [android-project-rules.md](../platform-rules/android-project-rules.md) - Rule 2.24*