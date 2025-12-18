# Application ID Migration Guide / Hướng Dẫn Chuyển Đổi App ID

> Complete guide for migrating application ID from old format to new standard format
> Hướng dẫn đầy đủ để chuyển đổi application ID từ định dạng cũ sang định dạng tiêu chuẩn mới

---

## � Post-Migration Validation / Xác Thực Sau Khi Migration

### Critical Validation Steps

**⚠️ IMPORTANT:** After changing App ID, validate ALL references are updated.

#### 1. Package References in Layout Files
```powershell
# Search for old package references in XML layouts
grep -r "com\.[old-package]\." app/src/main/res/layout/
# Example: Find remaining com.callblocker references
grep -r "com\.callblocker\." app/src/main/res/layout/
```

**Common Issue:** Custom View references in layouts often missed during migration.
```xml
<!-- ❌ OLD - Often forgotten -->
<com.callblocker.BarChartView 
    android:id="@+id/chart" />

<!-- ✅ NEW - Must update -->
<linm.soft.smartcallblock.BarChartView 
    android:id="@+id/chart" />
```

#### 2. Java/Kotlin Import Statements
```powershell
# Check for remaining old package imports
grep -r "import com\.[old-package]\." app/src/main/java/
```

#### 3. AndroidManifest.xml References
```powershell
# Verify all component references updated
grep -r "com\.[old-package]" app/src/main/AndroidManifest.xml
```

#### 4. Build Success Validation
```powershell
# Clean build to verify no compilation errors
./gradlew clean assembleDebug
```

**Build Success Criteria:**
- ✅ No "class not found" errors
- ✅ All custom views resolve correctly  
- ✅ No missing import statements
- ✅ APK generates successfully

---

## �📋 Migration Summary / Tóm Tắt Chuyển Đổi

### Standard Migration Process

**Required Format:** `linm.soft.[appname]`

**Migration Template:**
- **Android:** `[old-package]` → `linm.soft.[appname]`
- **iOS:** `[old-bundle-id]` → `linm.soft.[appname]`

### Examples:
- **Smart Call Block:** `com.callblocker` → `linm.soft.smartcallblock` ✅ **COMPLETED**
- **Daily Speak:** `com.dailyspeak` → `linm.soft.dailyspeak`
- **Quick Snooze:** `com.quicksnooze` → `linm.soft.quicksnooze`

---

## � Pre-Migration Checklist / Kiểm Tra Trước Khi Migration

### 📂 Project Structure Analysis

**CRITICAL:** Check project structure before starting migration to avoid build tool detection issues.

#### 1. Identify Project Structure Type
```bash
# Type A: Separate Android/iOS folders
project-root/
  android-app/        # Contains build.gradle
  ios-app/           # Contains .xcodeproj

# Type B: Combined project (like Smart Call Block)  
project-root/
  ANDROID/           # Contains build.gradle
  IOS/              # Contains .xcodeproj

# Type C: Single platform
project-root/
  app/              # Contains build.gradle OR .xcodeproj
```

#### 2. Update Build Tools First (Type B Projects)
For combined Android/iOS projects, ensure build detection works:
```powershell
# Test app detection BEFORE migration
cd development-rules/tool/build
.\build-app.ps1
# Should detect both Android and iOS apps
```

**⚠️ If apps not detected:** Update `modules/app-detection.ps1` before proceeding.

### 🔍 Package Reference Audit

#### 1. Find All Package References
```bash
# Search for old package references in Java files
grep -r "import [old-package]" src/
grep -r "package [old-package]" src/

# Search for fully qualified class names (COMMON ERROR SOURCE)
grep -r "[old-package]\." src/
```

#### 2. Common Problem Patterns
```java
// ❌ CRITICAL ERROR PATTERN - Fully qualified class names
com.oldpackage.dialog.CommonDialog dialog = new com.oldpackage.dialog.CommonDialog.Builder(this)

// ❌ CRITICAL ERROR PATTERN - Hardcoded package in imports  
import com.oldpackage.utils.*;

// ❌ CRITICAL ERROR PATTERN - Package in string literals
String packageName = "com.oldpackage";
```

### 🛠️ Build Environment Validation

#### 1. Clean Build Test (Before Migration)
```bash
# Android
./gradlew clean build
# Must succeed before migration

# iOS  
# Clean Build Folder in Xcode (Cmd+Shift+K)
# Must succeed before migration
```

#### 2. Dependency Verification
```gradle
// Check for hardcoded package references in build.gradle
dependencies {
    // Look for old package names in implementation statements
}
```

---

## �🚨 Critical Warnings / Cảnh Báo Quan Trọng

### ⚠️ **BREAKING CHANGE WARNING**

Changing application ID is a **CRITICAL CHANGE** that:
- **Breaks app updates** - Users will see this as a completely new app
- **Users lose all data** - Settings, blocked numbers, statistics will be lost
- **Requires new app store listing** - Cannot update existing app
- **Affects user experience** - Users must manually reinstall

**Vietnamese:**
- **Phá vỡ cập nhật ứng dụng** - Người dùng sẽ thấy đây là ứng dụng hoàn toàn mới
- **Người dùng mất tất cả dữ liệu** - Cài đặt, số bị chặn, thống kê sẽ bị mất
- **Cần listing mới trên cửa hàng** - Không thể cập nhật ứng dụng hiện có
- **Ảnh hưởng trải nghiệm** - Người dùng phải cài đặt lại thủ công

---

## 🔄 Migration Steps / Các Bước Thực Hiện

### 1. Android Configuration Updates

#### 1.1. Update `app/build.gradle`
```gradle
android {
    namespace 'linm.soft.[appname]'    // Change from old package
    
    defaultConfig {
        applicationId "linm.soft.[appname]"  // Change from old package
    }
}
```

#### 1.2. Package Structure Migration
```
OLD: src/main/java/[old-package-path]/
NEW: src/main/java/linm/soft/[appname]/
```

#### 1.3. Update All Java Files
- **Package declarations:** `package [old-package];` → `package linm.soft.[appname];`
- **Import statements:** `import [old-package].*` → `import linm.soft.[appname].*`
- **⚠️ CRITICAL:** **Fully Qualified Class Names** - Must be updated manually

**Step-by-Step Java File Migration:**

1. **Find All References First:**
```bash
# Find package declarations
grep -r "package [old-package]" src/

# Find import statements  
grep -r "import [old-package]" src/

# 🚨 CRITICAL: Find fully qualified class names (COMMON ERROR)
grep -r "[old-package]\." src/
```

2. **Update Package Declarations:**
```java
// Before
package com.oldpackage;

// After  
package linm.soft.[appname];
```

3. **Update Import Statements:**
```java
// Before
import com.oldpackage.utils.*;
import com.oldpackage.dialog.CommonDialog;

// After
import linm.soft.[appname].utils.*;
import linm.soft.[appname].dialog.CommonDialog;
```

4. **🚨 CRITICAL: Update Fully Qualified Class Names:**
```java
// ❌ BEFORE (This causes compilation errors!)
com.oldpackage.dialog.CommonDialog dialog = new com.oldpackage.dialog.CommonDialog.Builder(this)
    .setType(com.oldpackage.dialog.DialogType.INFO)

// ✅ AFTER
linm.soft.[appname].dialog.CommonDialog dialog = new linm.soft.[appname].dialog.CommonDialog.Builder(this)
    .setType(linm.soft.[appname].dialog.DialogType.INFO)
```

5. **Verify No Old References Remain:**
```bash
# This should return NO results
grep -r "[old-package]" src/
```

### 2. iOS Configuration Updates

#### 2.1. Update Xcode Project Configuration
```xml
<!-- Before -->
PRODUCT_BUNDLE_IDENTIFIER = [old-bundle-id];

<!-- After -->
PRODUCT_BUNDLE_IDENTIFIER = linm.soft.[appname];
```

**Update in both:**
- Debug configuration
- Release configuration

#### 2.2. Update Entitlements (App Groups)
**File:** `[AppName].entitlements`
```xml
<!-- Before -->
<key>com.apple.security.application-groups</key>
<array>
    <string>group.[old-bundle-id]</string>
</array>

<!-- After -->
<key>com.apple.security.application-groups</key>
<array>
    <string>group.linm.soft.[appname]</string>
</array>
```

#### 2.3. Update Swift Files (App Group References)
Search for and update hardcoded app group references in Swift files:

```swift
// Before
FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.[old-bundle-id]")

// After  
FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.linm.soft.[appname]")
```

**Common files to check:**
- CallDirectoryHandler.swift
- Any Core Data or shared storage code
- Extension files

#### 2.4. Info.plist References
The bundle identifier is dynamically resolved via `$(PRODUCT_BUNDLE_IDENTIFIER)` - no direct changes needed.

### 3. PowerShell Migration Script

**⚠️ IMPORTANT:** Test build detection FIRST before using migration scripts.

```powershell
# 1. TEST BUILD DETECTION (Do this first!)
cd development-rules/tool/build
.\build-app.ps1
# Verify both Android and iOS apps are detected

# 2. If apps not detected, check project structure:
# For combined projects (ANDROID/IOS folders), may need app-detection.ps1 updates

# 3. Use migration scripts (only after detection works)
# Update Android App ID
Update-AndroidAppId -AppPath "path/to/android/project" -NewAppId "linm.soft.[appname]"

# Update iOS Bundle ID  
Update-iOSAppId -AppPath "path/to/ios/project" -NewAppId "linm.soft.[appname]"
```

**Migration Script Troubleshooting:**
- **Apps not detected:** Check project structure type (A/B/C above)
- **Script fails:** Ensure paths are correct for your structure
- **Build fails:** Check for remaining old package references

---

## ✅ Verification Checklist / Danh Sách Kiểm Tra

### Android Verification
- [ ] `app/build.gradle` applicationId updated to `linm.soft.[appname]`
- [ ] `app/build.gradle` namespace updated to `linm.soft.[appname]`
- [ ] All Java package declarations updated
- [ ] All import statements updated  
- [ ] ⚠️ **CRITICAL:** All fully qualified class names updated
- [ ] Directory structure moved correctly
- [ ] No remaining references to old package (run: `grep -r "oldpackage" src/`)
- [ ] Clean build successful
- [ ] **Build script detects app correctly**

### iOS Verification  
- [ ] Xcode project PRODUCT_BUNDLE_IDENTIFIER updated (Debug)
- [ ] Xcode project PRODUCT_BUNDLE_IDENTIFIER updated (Release)
- [ ] App Group identifier updated in entitlements file
- [ ] App Group references updated in Swift files
- [ ] CallDirectoryExtension references updated (if applicable)
- [ ] No hardcoded bundle ID references in Swift files
- [ ] Clean build successful in Xcode
- [ ] **Build script detects app correctly**

### Cross-Platform Consistency
- [ ] Android and iOS use identical format: `linm.soft.[appname]`
- [ ] Follows development rules standard format: `linm.soft.[appname]`
- [ ] Compatible with build automation scripts

### Smart Call Block - Migration Verification ✅
- [x] Android applicationId: `linm.soft.smartcallblock`
- [x] Android namespace: `linm.soft.smartcallblock`
- [x] iOS Bundle ID: `linm.soft.smartcallblock` (Debug & Release)
- [x] All Java package declarations updated (20+ files)
- [x] All import statements corrected
- [x] CommonDialog package references fixed
- [x] Directory structure migrated successfully
- [x] Clean build successful ✅
- [x] APK generation working ✅

### Testing Verification
- [ ] App installs correctly with new package name
- [ ] All features function properly
- [ ] No crashes or runtime errors
- [ ] App permissions work correctly

---

## 🛠️ Build & Deploy Considerations / Lưu Ý Xây Dựng & Triển Khai

### Development Environment
1. **Clean Build Required**
   ```bash
   # Android
   ./gradlew clean build
   
   # iOS  
   # Clean Build Folder in Xcode (Cmd+Shift+K)
   ```

2. **Update Development Certificates**
   - **iOS:** Update provisioning profiles for new bundle identifier and App Groups
   - **Android:** Generate new signing keys if needed for production

### App Store Deployment
1. **Create New App Listings**
   - Google Play Console: Create new app with new package name
   - App Store Connect: Create new app with new bundle identifier

2. **iOS Specific Requirements**
   - **App Groups:** Configure new App Group identifier in Apple Developer Portal
   - **Call Directory Extension:** Update entitlements for call blocking features
   - **Provisioning Profiles:** Generate new profiles with updated identifiers

3. **Update Store Assets**
   - Screenshots may need app name updates
   - App descriptions should mention migration if relevant

---

## 📊 Current Migration Status / Tình Trạng Chuyển Đổi Hiện Tại

### ✅ Completed Migrations (December 17, 2025)

#### Smart Call Block App
- **Android Package:** `linm.soft.smartcallblock` ✅
- **iOS Bundle ID:** `linm.soft.smartcallblock` ✅
- **Migration Date:** December 17, 2025
- **Status:** Production ready
- **Package Structure:** All Java files updated to new package structure
- **Build Status:** ✅ Successful compilation and APK generation
- **Notes:** Successfully migrated from `com.callblocker.*` packages

**Files Updated:**
- ✅ Android `app/build.gradle` - applicationId and namespace
- ✅ iOS `project.pbxproj` - PRODUCT_BUNDLE_IDENTIFIER (Debug & Release)
- ✅ All Java package declarations (20+ files)
- ✅ All Java import statements updated
- ✅ Directory structure reorganized
- ✅ CommonDialog and DialogType package references fixed

**Common Issues Resolved:**
- Package import errors when using fully qualified class names
- Build script app detection for combined Android/iOS project structure
- Compilation errors due to incorrect package references

---

## 🔧 Migration Lessons Learned / Bài Học Rút Ra

### Smart Call Block Migration Experience

#### Common Compilation Errors
1. **Package Reference Issues**
   ```java
   // ❌ Error - Old package reference
   com.callblocker.common.dialog.CommonDialog dialog = new com.callblocker.common.dialog.CommonDialog.Builder(this)
   
   // ✅ Fixed - Correct package reference  
   linm.soft.smartcallblock.common.dialog.CommonDialog dialog = new linm.soft.smartcallblock.common.dialog.CommonDialog.Builder(this)
   ```

2. **Build Script Detection**
   - Issue: Build tools couldn't detect apps in combined Android/iOS project structure
   - Solution: Updated app detection to check both direct folders and ANDROID/IOS subfolders

#### Migration Best Practices
1. **Use Find-Replace Carefully**
   - Search for all occurrences of old package name
   - Verify each replacement manually for accuracy
   - Test compilation after each major change

2. **Directory Structure**
   - Move source files to match new package structure
   - Update build tools to handle new structure
   - Verify all paths in build scripts

3. **Testing Strategy**
   - Clean build after every change
   - Test build script app detection BEFORE and AFTER migration
   - Test on multiple environments
   - Verify APK/IPA generation

4. **Common Error Prevention**
   ```bash
   # Always check these BEFORE declaring migration complete:
   
   # 1. No old package references remain
   grep -r "oldpackagename" src/
   
   # 2. Build script can detect apps
   cd development-rules/tool/build && .\build-app.ps1
   
   # 3. Clean compilation
   ./gradlew clean build  # Android
   # Clean + Build in Xcode  # iOS
   ```

---

## 📊 Impact Assessment / Đánh Giá Tác Động

### User Impact
- **Existing Users:** Must uninstall old app and install new app
- **Data Loss:** All user data (blocked numbers, settings, history) will be lost
- **User Communication:** Need clear communication about migration

### Development Impact
- **Build Scripts:** Update any hardcoded package references
- **CI/CD:** Update deployment configurations
- **Testing:** Full regression testing required
- **Documentation:** Update all references in documentation

### Business Impact
- **App Store Ratings:** Start from zero ratings
- **Download Statistics:** Reset to zero
- **User Acquisition:** Need to rebuild user base

---

## 🔗 Related Documentation / Tài Liệu Liên Quan

- [Setup Rules](../rules/setup-rules.md) - Standard application ID format requirements
- [Critical Changes Checklist](../checklists/critical-changes-checklist.md) - Change detection and confirmation process
- [Android Project Rules](../ANDROID_PROJECT_RULES.md) - Android-specific development standards  
- [iOS Project Rules](../IOS_PROJECT_RULES.md) - iOS-specific development standards

---

## 📞 Next Steps / Các Bước Tiếp Theo

1. **Test Migration**
   - Build and test both Android and iOS apps
   - Verify all functionality works with new package names
   - Test on physical devices

2. **Plan User Communication**
   - Prepare user notification about app migration
   - Create migration instructions for users
   - Plan rollout strategy

3. **Update Documentation**
   - Update all project documentation with new package names
   - Update README files and build instructions
   - Update any external references

4. **Store Preparation**
   - Create new app listings on respective stores
   - Prepare new certificates and provisioning profiles
   - Update CI/CD configurations

---

## 🔧 Migration Tools / Công Cụ Chuyển Đổi

The development-rules include PowerShell functions for automated migration:

```powershell
# 🚨 STEP 1: Always test build detection FIRST
cd D:\MyRepo\AI-App\Source\development-rules\tool\build
.\build-app.ps1
# Both Android and iOS apps must be detected

# STEP 2: Get current App IDs (before migration)
Get-AndroidAppId -AppPath "path/to/android"
Get-iOSAppId -AppPath "path/to/ios"

# STEP 3: Update App IDs (only if detection works)
Update-AndroidAppId -AppPath "path/to/android" -NewAppId "linm.soft.[appname]"
Update-iOSAppId -AppPath "path/to/ios" -NewAppId "linm.soft.[appname]"

# STEP 4: Verify migration success  
.\build-app.ps1 -QuickBuild -AppName [appname]
```

**⚠️ Critical Notes:**
- **Build detection must work BEFORE using migration tools**
- **For combined Android/iOS projects:** May need app-detection.ps1 updates first
- **Always test build after migration**

**Location:** `development-rules/tool/build/modules/build-functions.ps1`

---

**Migration Template Created:** December 17, 2025  
**Status:** ✅ **READY FOR USE**  
**Last Updated:** December 17, 2025  
**Smart Call Block Migration:** ✅ **COMPLETED**  
**Applies To:** All apps requiring package ID migration