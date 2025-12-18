# ✅ App ID Migration Validation Checklist

## Quick Validation Commands

### 1. Find Remaining Old Package References

```powershell
# Search all source files for old package references
$OldPackage = "com.callblocker"  # Replace with your old package
$ProjectPath = "app/src"

# Check layout XML files
Get-ChildItem -Path "$ProjectPath" -Filter "*.xml" -Recurse | 
    Select-String -Pattern $OldPackage | 
    Select-Object Path, LineNumber, Line

# Check Java/Kotlin files
Get-ChildItem -Path "$ProjectPath" -Filter "*.java" -Recurse | 
    Select-String -Pattern $OldPackage | 
    Select-Object Path, LineNumber, Line
```

**Expected:**
- ✅ No results = ALL references updated
- ❌ Any results = FIX REQUIRED

### 2. Validate Custom Views in Layouts

```powershell
# Find custom view references that might need package updates
Get-ChildItem -Path "app/src/main/res/layout" -Filter "*.xml" -Recurse | 
    Select-String -Pattern "<[a-zA-Z]+\.[a-zA-Z]+\." | 
    Select-Object Path, LineNumber, Line
```

### 3. Check AndroidManifest Components

```powershell
# Find service/receiver/activity declarations with old package
Select-String -Path "app/src/main/AndroidManifest.xml" -Pattern "android:name.*com\." | 
    Select-Object LineNumber, Line
```

### 4. Build Validation

```powershell
# Clean build to verify no compilation errors
Remove-Item -Recurse -Force "app\build" -ErrorAction SilentlyContinue
.\gradlew clean assembleDebug
```

## Migration Steps Checklist

### Pre-Migration
- [ ] Backup current project
- [ ] Document current App ID and package structure
- [ ] Identify all custom views and components
- [ ] Note any ProGuard rules referencing packages

### During Migration
- [ ] Update `applicationId` in `build.gradle`
- [ ] Update package declaration in all Java/Kotlin files
- [ ] Move files to new package directory structure
- [ ] Update import statements
- [ ] Update AndroidManifest.xml component names

### Post-Migration Validation
- [ ] NO old package references in layout XMLs
- [ ] NO old import statements in Java/Kotlin
- [ ] NO old package names in AndroidManifest.xml
- [ ] Clean build succeeds without errors
- [ ] App launches without crashes
- [ ] All custom views render correctly
- [ ] All activities/services/receivers work

## Common Issues & Solutions

### Issue 1: Custom View Not Found
```
Error: Class referenced in the layout file, com.oldpackage.CustomView, was not found
```

**Solution:**
```xml
<!-- Find in layout files -->
<com.oldpackage.CustomView ... />

<!-- Replace with new package -->
<linm.soft.newpackage.CustomView ... />
```

### Issue 2: Import Statements Not Updated
```
Error: package com.oldpackage does not exist
```

**Solution:**
```java
// Find in Java files
import com.oldpackage.SomeClass;

// Replace with new package  
import linm.soft.newpackage.SomeClass;
```

### Issue 3: Service/Receiver Not Found
```
Error: Unable to instantiate service com.oldpackage.SomeService
```

**Solution:**
```xml
<!-- AndroidManifest.xml -->
<service android:name="com.oldpackage.SomeService" />

<!-- Update to -->
<service android:name="linm.soft.newpackage.SomeService" />
```

## Detection Commands by File Type

### XML Layout Files
```powershell
grep -r "com\.[old-package]\." app/src/main/res/layout/
```

### Java/Kotlin Source
```powershell
grep -r "import com\.[old-package]\." app/src/main/java/
grep -r "package com\.[old-package]" app/src/main/java/
```

### AndroidManifest
```powershell
grep "com\.[old-package]" app/src/main/AndroidManifest.xml
```

### ProGuard Rules
```powershell
grep -r "com\.[old-package]" app/proguard-rules.pro
```

## Success Criteria

### Build Success
- ✅ `.\gradlew clean assembleDebug` completes without errors
- ✅ No "class not found" compilation errors
- ✅ No missing import statements
- ✅ APK builds successfully

### Runtime Success
- ✅ App launches without crashes
- ✅ All custom views inflate correctly
- ✅ All activities navigate properly
- ✅ All services start without errors

### Code Quality
- ✅ All package declarations consistent
- ✅ All import statements use new package
- ✅ All XML references use new package
- ✅ No hardcoded old package strings

## Compliance Verification

**Final Check:**
```powershell
# Run comprehensive search for any remaining old references
$OldPackage = "com.callblocker"
grep -r "$OldPackage" app/src/ | grep -v ".class" | grep -v "build/"
```

**Result:**
- ✅ No output = MIGRATION COMPLETE
- ❌ Any output = REFERENCES STILL EXIST - FIX REQUIRED

---

*Related rule: [android-project-rules.md](../platform-rules/android-project-rules.md) - Rule 2.26*