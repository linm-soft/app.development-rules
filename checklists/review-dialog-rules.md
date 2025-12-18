# ✅ Dialog Implementation Checklist

## Quick Check

Verify dialogs follow custom layout pattern:

### 1. Check for AlertDialog.Builder Anti-pattern

```powershell
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'AlertDialog\.Builder.*\.(setTitle|setMessage)' | 
    Select-Object -Property Path, LineNumber
```

**Expected:**
- ✅ No output = GOOD (using custom layouts)
- ❌ Has output = BAD (must use custom layout instead)

### 2. Check Dialog Layout Files

```powershell
$dialogLayouts = Get-ChildItem "app\src\main\res\layout\dialog_*.xml"

Write-Host "Found $($dialogLayouts.Count) dialog layouts:" -ForegroundColor Cyan
$dialogLayouts | ForEach-Object { 
    Write-Host "  ✅ $($_.Name)" -ForegroundColor Green 
}

if ($dialogLayouts.Count -eq 0) {
    Write-Host "⚠️  No dialog layouts found" -ForegroundColor Yellow
}
```

### 3. Check DialogUtils Usage

```powershell
$hasDialogUtils = Get-ChildItem -Path "app\src\main\java" -Filter "DialogUtils.java" -Recurse

if ($hasDialogUtils) {
    Write-Host "✅ DialogUtils.java exists" -ForegroundColor Green
    
    # Check if setDialogWidth is called
    Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
        Select-String 'DialogUtils\.setDialogWidth' | 
        ForEach-Object {
            Write-Host "✅ setDialogWidth called in $($_.Path)" -ForegroundColor Green
        }
} else {
    Write-Host "⚠️  DialogUtils.java not found" -ForegroundColor Yellow
}
```

### 4. Check dialog_background.xml

```powershell
if (Test-Path "app\src\main\res\drawable\dialog_background.xml") {
    Write-Host "✅ dialog_background.xml exists" -ForegroundColor Green
} else {
    Write-Host "❌ MISSING: dialog_background.xml" -ForegroundColor Red
}
```

### 5. Check Dialog Strings

```powershell
$dialogStrings = Select-String -Path "app\src\main\res\values\strings*.xml" -Pattern 'name="dialog_'

if ($dialogStrings) {
    Write-Host "✅ Dialog strings found: $($dialogStrings.Count)" -ForegroundColor Green
    
    # Check Vietnamese translations
    $viDialogStrings = Select-String -Path "app\src\main\res\values-vi\strings*.xml" -Pattern 'name="dialog_'
    
    if ($viDialogStrings.Count -eq $dialogStrings.Count) {
        Write-Host "✅ Vietnamese translations complete" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Vietnamese translations may be incomplete" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  No dialog strings found" -ForegroundColor Yellow
}
```

## Compliance Checklist

**Critical (MUST NOT have):**
- [ ] NO `AlertDialog.Builder` with `setTitle/setMessage`

**Required (MUST have):**
- [ ] Custom dialog layouts (`dialog_*.xml`)
- [ ] Dialog uses `dialog.setContentView(R.layout.dialog_xxx)`
- [ ] `DialogUtils.setDialogWidth()` called after `show()`
- [ ] `drawable/dialog_background.xml` exists
- [ ] Dialog strings in both EN and VI

**Pattern Check:**
```java
// ✅ CORRECT Pattern
Dialog dialog = new Dialog(context);
dialog.setContentView(R.layout.dialog_confirm);
dialog.show();
DialogUtils.setDialogWidth(dialog); // After show()

// ❌ WRONG Pattern
new AlertDialog.Builder(context)
    .setTitle("Title")
    .setMessage("Message")
    .show();
```

**Result:**
- ✅ All checks pass = COMPLIANT
- ❌ AlertDialog.Builder found = FIX REQUIRED
- ⚠️ Missing DialogUtils = Recommended to add

---

*For implementation details, see: [dialog-rules.md](../implementation/dialog-rules.md)*
