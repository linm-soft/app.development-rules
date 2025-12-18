# iOS Build Error Fixes - Emergency Procedures

> Quick fixes for common iOS build errors encountered during development

---

## 🚨 CRITICAL ERRORS & IMMEDIATE FIXES

### Error: "Cannot find type 'BlockedNumber' in scope"
### Error: "Cannot find type 'CallHistory' in scope"

**Root Cause**: Core Data code generation conflict
**Immediate Fix**:
1. Edit `.xcdatamodel/contents` file directly
2. Change `codeGenerationType="class"` to `codeGenerationType="category"`
3. Clean build folder and rebuild

**PowerShell Fix**:
```powershell
# Quick fix for Core Data entities
$dataModelFile = "SmartCallBlock\DataModel.xcdatamodeld\DataModel.xcdatamodel\contents"
(Get-Content $dataModelFile) -replace 'codeGenerationType="class"', 'codeGenerationType="category"' | Set-Content $dataModelFile
```

---

### Error: "None of the input catalogs contained a matching app icon set"

**Root Cause**: App icons not in AppIcon.appiconset folder
**Immediate Fix**:
```powershell
# Move icons to correct location
Move-Item "Assets.xcassets\Icon-*.png" "Assets.xcassets\AppIcon.appiconset\"
```

**Verification**:
```powershell
# Verify icons are in correct location
Get-ChildItem "Assets.xcassets\AppIcon.appiconset\Icon-*.png"
```

---

## 🔧 POST-FIX VALIDATION

### After Core Data Fix
- [ ] Entities visible in Xcode Data Model Inspector
- [ ] Codegen shows correct setting:
  - "Category/Extension" if manual files exist
  - "Class Definition" if using auto-generation
- [ ] Swift files import CoreData successfully
- [ ] @FetchRequest works without type errors
- [ ] No "Cannot find type" errors in any Swift files

### After App Icon Fix  
- [ ] All Icon-*.png files inside AppIcon.appiconset folder
- [ ] No loose icon files in main Assets.xcassets folder
- [ ] Contents.json references match actual files
- [ ] Build succeeds without asset catalog errors
- [ ] No "None of the input catalogs contained a matching icon set" errors

### Critical Success Indicators
- [ ] **Build Output Clean**: No red error messages in build log
- [ ] **Issue Navigator Empty**: No issues shown in Xcode Issue Navigator
- [ ] **Project Builds Successfully**: Can archive for distribution
- [ ] **Core Data Types Available**: Autocomplete works for BlockedNumber/CallHistory

---

## ⚡ EMERGENCY REBUILD PROCEDURE

### When multiple errors occur:

1. **Stop Xcode** completely
2. **Fix Core Data** configuration (category vs class)
3. **Organize app icons** into AppIcon.appiconset
4. **Clean derived data**:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/*
   ```
5. **Clean build folder** in Xcode (⇧⌘K)
6. **Rebuild project** (⌘B)

### 🚨 If errors PERSIST after above steps:

**Problem**: Xcode cache không được refresh sau khi fix
**Root Cause**: Incremental build không detect changes trong .xcdatamodel files

**ULTIMATE FIX PROCEDURE**:

#### Option A: Switch to Auto-Generated Core Data
```powershell
# 1. Change Core Data to auto-generation
$dataModelFile = "SmartCallBlock\DataModel.xcdatamodeld\DataModel.xcdatamodel\contents"
(Get-Content $dataModelFile) -replace 'codeGenerationType="category"', 'codeGenerationType="class"' | Set-Content $dataModelFile

# 2. Remove manual Core Data files
Remove-Item "SmartCallBlock\*+CoreDataClass.swift", "SmartCallBlock\*+CoreDataProperties.swift" -Force
```

#### Option B: Keep Manual Core Data Files
```powershell
# Keep codeGenerationType="category" and ensure manual files exist
# Verify all manual Core Data class files are present and properly configured
```

**Post-Fix Steps**:
1. **Quit Xcode hoàn toàn** (không chỉ close project)
2. **Clean Derived Data**: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
3. **Restart Xcode** từ đầu
4. **Clean Build Folder** (⇧⌘K)
5. **Build Project** (⌘B)

**⚠️ CRITICAL**: Phải quit và restart Xcode hoàn toàn, không phải chỉ clean build!

---

## 📋 PREVENTION CHECKLIST

Before any Core Data changes:
- [ ] Check current codeGenerationType setting
- [ ] Verify if manual Core Data class files exist
- [ ] Use "Category/Extension" when manual classes present

Before any asset changes:
- [ ] Ensure icons go into AppIcon.appiconset folder
- [ ] Never leave icons loose in main Assets.xcassets
- [ ] Verify Contents.json matches file structure

---

## 🎯 QUICK DIAGNOSTICS

**Check Core Data Configuration**:
```bash
grep -r "codeGenerationType" *.xcdatamodel/contents
```

**Check Asset Structure**:
```bash
find Assets.xcassets -name "Icon-*.png" -exec dirname {} \;
```

**Expected Output**: All paths should show `Assets.xcassets/AppIcon.appiconset`

---

## 📚 RELATED DOCUMENTS

- [iOS Common Issues Checklist](ios-common-issues-checklist.md)
- [iOS SwiftUI Development Checklist](ios-swiftui-development-checklist.md)
- [iOS CallKit Integration Checklist](ios-callkit-integration-checklist.md)