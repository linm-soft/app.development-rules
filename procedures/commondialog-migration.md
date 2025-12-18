# 🔄 CommonDialog Migration Procedures

> Comprehensive guide for migrating from AlertDialog to CommonDialog Framework

## 📋 MIGRATION PHASES

### Phase 1: Analysis & Planning

#### 1.1 Identify Old Dialog Implementations
```powershell
# Find all AlertDialog usages
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'AlertDialog\.Builder|new AlertDialog' | 
    Group-Object Path | 
    ForEach-Object {
        Write-Host "File: $($_.Name)" -ForegroundColor Cyan
        $_.Group | ForEach-Object { Write-Host "  Line $($_.LineNumber): $($_.Line.Trim())" }
    }
```

#### 1.2 Categorize Dialog Types
Create inventory using this template:

| File | Method | Current Type | Proposed Migration | Priority | Notes |
|------|--------|--------------|-------------------|----------|-------|
| Activity.java | showConfirm() | AlertDialog | DialogType.CONFIRM | High | Simple replacement |
| Service.java | showError() | AlertDialog | DialogType.ERROR | High | Error handling |
| Fragment.java | showCustom() | Custom Dialog | DialogType.CUSTOM | Medium | Needs layout review |

#### 1.3 Create Migration Timeline
- **Phase 1 Complete**: [Date] - Analysis finished
- **Phase 2 Start**: [Date] - Begin implementations
- **Phase 3 Complete**: [Date] - All migrations done
- **Phase 4 Complete**: [Date] - Cleanup finished

---

### Phase 2: Implementation

#### 2.1 Set Up CommonDialog Framework
```powershell
# Verify framework files exist
$requiredFiles = @(
    "app\src\main\java\com\smartcallblock\common\dialog\CommonDialog.java",
    "app\src\main\java\com\smartcallblock\common\dialog\DialogType.java",
    "app\src\main\res\layout\dialog_common_base.xml"
)

$requiredFiles | ForEach-Object {
    if (Test-Path $_) {
        Write-Host "✅ $($_)" -ForegroundColor Green
    } else {
        Write-Host "❌ MISSING: $($_)" -ForegroundColor Red
    }
}
```

#### 2.2 Migrate Dialog by Dialog
For each dialog to migrate:

**Step 1: Create backup copy**
```java
// BEFORE - Keep as comment during testing
/*
new AlertDialog.Builder(context)
    .setTitle("Confirmation")
    .setMessage("Are you sure?")
    .setPositiveButton("Yes", (d, w) -> doAction())
    .setNegativeButton("Cancel", null)
    .show();
*/
```

**Step 2: Implement CommonDialog**
```java
// AFTER - New implementation
new CommonDialog.Builder(context)
    .setType(DialogType.CONFIRM)
    .setTitle("Confirmation")
    .setMessage("Are you sure?")
    .setPositiveButton("Yes", this::doAction)
    .setNegativeButton("Cancel")
    .show();
```

**Step 3: Test thoroughly**
- [ ] Dialog appears correctly
- [ ] Buttons work as expected
- [ ] Styling matches app theme
- [ ] No memory leaks

#### 2.3 Update String Resources
```powershell
# Check for hardcoded strings in new dialogs
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'CommonDialog.*\.setTitle\("[^R]' | 
    ForEach-Object {
        Write-Host "⚠️  Hardcoded string at $($_.Path):$($_.LineNumber)" -ForegroundColor Yellow
        Write-Host "   $($_.Line.Trim())"
    }
```

---

### Phase 3: Cleanup & Removal

#### 3.1 Remove Old AlertDialog Code
**CRITICAL: Only after all testing passes**

```powershell
# Search for remaining AlertDialog references
$alertDialogRefs = Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'AlertDialog\.Builder|new AlertDialog' 

if ($alertDialogRefs.Count -gt 0) {
    Write-Host "⚠️  Found $($alertDialogRefs.Count) remaining AlertDialog references:" -ForegroundColor Yellow
    $alertDialogRefs | ForEach-Object {
        Write-Host "  $($_.Path):$($_.LineNumber) - $($_.Line.Trim())"
    }
    Write-Host "❌ DO NOT PROCEED - Complete migration first" -ForegroundColor Red
} else {
    Write-Host "✅ No AlertDialog references found - Safe to cleanup" -ForegroundColor Green
}
```

#### 3.2 Remove Unused Import Statements
```java
// Remove these imports from migrated files:
// import androidx.appcompat.app.AlertDialog;
// import android.app.AlertDialog; (if any)
```

**Automated cleanup command:**
```powershell
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName
    $newContent = $content | Where-Object { $_ -notmatch "import.*AlertDialog" }
    
    if ($content.Count -ne $newContent.Count) {
        Write-Host "🧹 Cleaned imports in $($_.Name)" -ForegroundColor Cyan
        Set-Content -Path $_.FullName -Value $newContent
    }
}
```

#### 3.3 Remove Old Dialog Layouts (If Any)
```powershell
# Find old dialog layout files that might be unused
$oldDialogLayouts = Get-ChildItem "app\src\main\res\layout\dialog_*.xml" | Where-Object {
    $layoutName = $_.BaseName
    $isReferenced = Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
        Select-String "R\.layout\.$layoutName" -Quiet
    
    return -not $isReferenced
}

if ($oldDialogLayouts.Count -gt 0) {
    Write-Host "🗑️  Found potentially unused dialog layouts:" -ForegroundColor Yellow
    $oldDialogLayouts | ForEach-Object {
        Write-Host "  $($_.Name)" -ForegroundColor Yellow
    }
    Write-Host "💡 Review manually before deletion" -ForegroundColor Cyan
} else {
    Write-Host "✅ No unused dialog layouts found" -ForegroundColor Green
}
```

#### 3.4 Remove Old Dialog Utility Methods
Check for old dialog helper methods:
```powershell
# Find old dialog utility methods
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'public.*showAlert|public.*createDialog' | 
    ForEach-Object {
        Write-Host "🔍 Potential old dialog method at $($_.Path):$($_.LineNumber)" -ForegroundColor Cyan
        Write-Host "   $($_.Line.Trim())"
    }
```

---

### Phase 4: Validation

#### 4.1 Final Compliance Check
```powershell
# Run full compliance check
echo "=== FINAL COMPLIANCE CHECK ==="

# 1. No AlertDialog references
$alertCount = (Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'AlertDialog' | Measure-Object).Count

if ($alertCount -eq 0) {
    Write-Host "✅ No AlertDialog references found" -ForegroundColor Green
} else {
    Write-Host "❌ Found $alertCount AlertDialog references" -ForegroundColor Red
}

# 2. All dialogs use CommonDialog
$commonDialogCount = (Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'CommonDialog\.Builder' | Measure-Object).Count

Write-Host "📊 Found $commonDialogCount CommonDialog usages" -ForegroundColor Cyan

# 3. No unused layouts
Write-Host "🔍 Checking for unused dialog layouts..." -ForegroundColor Cyan
```

#### 4.2 Testing Checklist
- [ ] **All dialogs functional**: Every dialog works as before
- [ ] **No crashes**: App runs without dialog-related crashes
- [ ] **Styling consistent**: All dialogs match app theme
- [ ] **Performance unchanged**: No performance regression
- [ ] **Memory clean**: No memory leaks from new dialogs

#### 4.3 Code Review Requirements
- [ ] **Senior review**: Team lead approved all changes
- [ ] **Testing evidence**: Screenshots/videos of all dialogs working
- [ ] **Performance metrics**: Before/after measurements if applicable
- [ ] **Documentation updated**: Usage guides reflect new patterns

---

## 🚨 ROLLBACK PROCEDURE

If migration causes critical issues:

### Quick Rollback
1. **Restore from backup**: Use git to revert to pre-migration state
2. **Document issues**: Record what went wrong for future analysis
3. **Plan fixes**: Address issues before retry

### Safe Rollback Commands
```powershell
# Check current branch status
git status

# Rollback to specific commit (replace HASH)
git reset --hard COMMIT_HASH

# Or rollback all uncommitted changes
git checkout .
```

---

## 📊 SUCCESS METRICS

### Migration Completed When:
- [ ] **Zero AlertDialog references** in Java code
- [ ] **All dialogs use CommonDialog** framework
- [ ] **Clean imports** - no unused AlertDialog imports
- [ ] **Code review passed** with senior developer approval
- [ ] **Full testing completed** - no regression issues
- [ ] **Documentation updated** - team guides reflect new patterns

### Post-Migration Benefits:
- [ ] **Consistent UX** - all dialogs follow same design patterns
- [ ] **Faster development** - new dialogs easier to implement
- [ ] **Better maintenance** - centralized dialog logic
- [ ] **Code quality** - reduced duplication and complexity

---

## 🎯 NEXT STEPS AFTER MIGRATION

1. **Update coding standards** to require CommonDialog usage
2. **Train team** on new dialog patterns and APIs
3. **Create templates** for common dialog scenarios
4. **Monitor usage** in code reviews to ensure compliance
5. **Plan framework updates** based on team feedback

---

*This procedure should be followed for all projects adopting CommonDialog framework*