# Cross-Platform Development Rules & Guidelines

> Universal rules và best practices cho cả iOS (Swift) và Android (Java) projects

---

## 🚨 RECENT UPDATES (December 19, 2025)

### Dialog & Overlay Pattern Implementation (iOS):
- **Singleton DialogManager**: Centralized dialog state with `@Published` properties
- **CommonDialogOverlay**: Uses `@ObservedObject` to observe singleton (not `@StateObject`)
- **Overlay Application**: Applied in feature views, not at app root (Swift compilation order)
- **Single Source of Truth**: All dialogs use `DialogManager.shared.show*()`
- **Pattern Verified**: Build succeeds, no compilation order issues

### Critical iOS Fixes Completed:
- **Smart Quotes Fix**: Resolved compilation errors caused by curly quotes in Swift files
- **UTF-8 Encoding Fix**: Fixed malformed bullet point characters (â€¢ → •)
- **AppIcon Asset**: Added proper AppIcon.appiconset configuration with all required sizes
- **Xcode Crash Resolved**: Fixed project.pbxproj ID collision in SmartCallBlock project
- **Development Team Updated**: All iOS projects now use `TeamLinm2805` for code signing
- **New Troubleshooting Guide**: Added comprehensive Xcode crash troubleshooting procedures
- **Documentation Enhanced**: Updated iOS development checklists and procedures

**See:** [Project Changelog](../smart-call-block/CHANGELOG_2025.md) | [iOS Troubleshooting Guide](checklists/ios/ios-xcode-crash-troubleshooting.md)

### 🔧 iOS Project Migration: Xcode Corruption Fix

**For applying the fix to other iOS projects experiencing similar crashes:**

#### 🎯 Quick Migration Steps:
1. **Validate Project**: Run `tool/validate_ios_project.ps1` in project directory
2. **Backup Current**: `Copy-Item project.pbxproj project.pbxproj.backup`
3. **Check for ID Conflicts**: Look for duplicate UUIDs in build configurations
4. **Fix References**: Ensure buildConfigurationList IDs match their definitions
5. **Update Team**: Set `DEVELOPMENT_TEAM = TeamLinm2805` in all configs

#### 📝 Validation Tool:
```powershell
# Run from iOS project directory
..\..\development-rules\tool\validate_ios_project.ps1
```

#### 🚨 Common Signs Requiring This Fix:
- Xcode crashes with `[XCConfigurationList name]: unrecognized selector`
- `EXC_CRASH (SIGABRT)` when opening .xcodeproj
- Build configuration parsing errors
- Inconsistent target configuration lists

#### 📋 Fix Pattern:
```
Problem: Target references buildConfigurationList ID that doesn't exist
Solution: Create unique IDs for configuration lists vs build configurations
Result: All references properly linked, no ID collisions
```

**Tool Location**: `development-rules/tool/validate_ios_project.ps1`

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "CROSS_PLATFORM_RULES"...
```

**Purpose:** Let user know AI is referencing cross-platform project rules.

---

## 📁 UNIVERSAL DOCUMENTATION STRUCTURE (December 17, 2025)

### 🎯 **Development Rules (Current Location)**
- **`app-rules.md`** - Universal rules for all platforms (THIS FILE)
- **`ai-guidelines.md`** - Complete AI workflow and development guidelines
- **`platform-rules/`** - Platform-specific development rules
- **`guides/`** - Migration guides and development workflows
- **`tool/build/`** - Build automation and PowerShell scripts

### 📂 **Project Documentation Pattern**
Each project follows this standard structure:
- **`[project]/DOCS/`** - Complete project documentation
  - **`project-summary.md`** - Project status and architecture overview
  - **`version-tracking.md`** - Version history and release management
  - **`feature-tracking.md`** - Feature implementation matrix
  - **`android/`** - Android platform documentation
  - **`ios/`** - iOS platform documentation
  - **`api/`** - Complete API reference documentation

### 🔄 **Universal Documentation Routing Strategy**
**For any project development:**
1. **Development Standards** → Use files in this directory (development-rules)
2. **Technical Implementation** → Reference `[project]/DOCS/[platform]/`
3. **API Integration** → Reference `[project]/DOCS/api/`
4. **Project Status** → Reference `[project]/DOCS/project-summary.md`

---

## 🎯 PLATFORM DETECTION & AUTO-ROUTING

### 📱 Automatic Platform Detection
AI should automatically detect platform and route to appropriate rules:

```yaml
Platform Detection Rules:
  iOS Project:
    - File extensions: .swift, .m, .h, .xib, .storyboard
    - Project files: .xcodeproj, .xcworkspace
    - Frameworks: UIKit, SwiftUI, Foundation
    - Route to: platform-rules/ios-project-rules.md
    
  Android Project:
    - File extensions: .java, .kt, .xml
    - Project files: build.gradle, AndroidManifest.xml
    - Frameworks: Android SDK, Support Library
    - Route to: platform-rules/android-project-rules.md
    
  Cross-Platform:
    - Both platforms present
    - Use this file for universal guidelines
```

---

## 🌍 UNIVERSAL DEVELOPMENT PRINCIPLES

### 1. Project Structure Standards

#### 📁 General Organization
```
Platform-Agnostic Structure:
├── src/main/              # iOS: Project folder, Android: src/main
├── docs/                  # Documentation (both platforms)
├── assets/               # iOS: Assets.xcassets, Android: res/
├── tests/                # iOS: Tests folder, Android: test/
└── README.md             # Project documentation
```

#### 📂 Platform-Specific Routing
- **iOS Projects**: Route to `platform-rules/ios-project-rules.md`
- **Android Projects**: Route to `platform-rules/android-project-rules.md`
- **Shared Guidelines**: Apply universal rules from this file

### 2. App Identification Consistency ⚠️ CRITICAL

**Required:** Identical identification format across both platforms

#### 📱 Standard Format
```
Required Pattern: linm.soft.[appname]
```

**Platform Implementation:**

**Android** (`app/build.gradle`):
```gradle
android {
    namespace 'linm.soft.[appname]'
    defaultConfig {
        applicationId "linm.soft.[appname]"
    }
}
```

**iOS** (`project.pbxproj`):
```xml
PRODUCT_BUNDLE_IDENTIFIER = linm.soft.[appname];
```

**iOS App Groups** (`[App].entitlements`):
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.linm.soft.[appname]</string>
</array>
```

#### ✅ Cross-Platform Validation
```bash
# Verify consistency across platforms
Android: grep "applicationId" app/build.gradle
iOS: grep "PRODUCT_BUNDLE_IDENTIFIER" *.xcodeproj/project.pbxproj
iOS Groups: grep "group.linm.soft" *.entitlements
```

**Examples:**
- Smart Call Block: `linm.soft.smartcallblock`
- Daily Speak: `linm.soft.dailyspeak`
- Quick Snooze: `linm.soft.quicksnooze`

### 3. Code Quality Standards ⚠️ CRITICAL

#### 🔄 Null Safety (Cross-Platform)
**iOS (Swift):**
```swift
// Use optionals properly
var phoneNumber: String? = nil
if let number = phoneNumber {
    // Safe to use number
}

// Guard statements for early returns
guard let validNumber = phoneNumber else {
    return
}
```

**Android (Java):**
```java
// Use @Nullable/@NonNull annotations
@Nullable String phoneNumber = null;
if (phoneNumber != null) {
    // Safe to use phoneNumber
}

// Check before use
if (TextUtils.isEmpty(phoneNumber)) {
    return;
}
```

#### ⚠️ Error Handling (Cross-Platform)
**iOS (Swift):**
```swift
do {
    let result = try riskyOperation()
    handleSuccess(result)
} catch {
    handleError(error)
}
```

**Android (Java):**
```java
try {
    Result result = riskyOperation();
    handleSuccess(result);
} catch (Exception e) {
    handleError(e);
}
```

### 3. Architecture Patterns ⚠️ REQUIRED

#### 📋 Recommended Patterns
**iOS:**
- **MVVM** with SwiftUI/UIKit
- **Coordinator Pattern** for navigation
- **Repository Pattern** for data access

**Android:**
- **MVVM** with ViewBinding/DataBinding
- **Repository Pattern** with Room/SQLite
- **Navigation Component** for navigation

#### 🗄️ Data Persistence
**iOS:**
- **Core Data** for complex relationships
- **UserDefaults** for simple key-value storage
- **Keychain** for secure storage

**Android:**
- **Room Database** for complex data
- **SharedPreferences** for simple storage
- **Keystore** for secure storage

### 4. UI/UX Standards ⚠️ REQUIRED

#### 🎨 Platform-Native Design
**iOS:**
- Follow **iOS Human Interface Guidelines**
- Use **SwiftUI** for modern apps
- Implement **iOS navigation patterns**
- Use **SF Symbols** for icons

**Android:**
- Follow **Material Design 3** guidelines
- Use **Material Components**
- Implement **Android navigation patterns**
- Use **Material Icons**

#### 📱 Responsive Design
**Both Platforms:**
- Support multiple screen sizes
- Implement proper layout constraints
- Test on various devices
- Handle orientation changes

### 5. Performance Standards ⚠️ CRITICAL

#### 🚀 Loading & Response Times
**iOS:**
```swift
// Async/await for network calls
Task {
    do {
        let data = try await networkCall()
        await MainActor.run {
            updateUI(data)
        }
    } catch {
        handleError(error)
    }
}
```

**Android:**
```java
// AsyncTask replacement with ExecutorService
ExecutorService executor = Executors.newSingleThreadExecutor();
Handler mainHandler = new Handler(Looper.getMainLooper());

executor.execute(() -> {
    // Background work
    Result result = performNetworkCall();
    
    mainHandler.post(() -> {
        // Update UI on main thread
        updateUI(result);
    });
});
```

#### 🔋 Battery & Memory Optimization
**Both Platforms:**
- Proper lifecycle management
- Avoid memory leaks
- Efficient image loading
- Background task optimization

---

## 🔧 PLATFORM-SPECIFIC RULE ROUTING

### 📱 iOS Development
**When iOS project detected, route to:**
- [`IOS_PROJECT_RULES.md`](./IOS_PROJECT_RULES.md)
- iOS-specific checklists in `checklists/ios/`
- iOS implementation guides in `implementation/ios/`

### 🤖 Android Development  
**When Android project detected, route to:**
- [`ANDROID_PROJECT_RULES.md`](./ANDROID_PROJECT_RULES.md)
- Android-specific checklists in `checklists/android/`
- Android implementation guides in `implementation/android/`

### 🌐 Cross-Platform Projects
**When both platforms detected:**
- Apply universal rules from this file
- Route to platform-specific rules for each codebase
- Maintain shared documentation standards

---

## 📋 UNIVERSAL CHECKLISTS

### ✅ Code Quality Checklist
- [ ] Null safety implemented
- [ ] Error handling in place
- [ ] Performance optimized
- [ ] Memory leaks checked
- [ ] Platform guidelines followed

### ✅ Documentation Checklist  
- [ ] README.md updated
- [ ] API documentation current
- [ ] Setup instructions clear
- [ ] Architecture documented
- [ ] Troubleshooting guide included

### ✅ Testing Checklist
- [ ] Unit tests implemented
- [ ] Integration tests added
- [ ] UI tests created
- [ ] Performance tests run
- [ ] Device testing completed

### ✅ Deployment Checklist
- [ ] Build configurations set
- [ ] Code signing configured
  - **iOS**: Development team set to `TeamLinm2805`
  - **Android**: Keystore and signing config applied
- [ ] App store requirements met
- [ ] Privacy policies updated
- [ ] Release notes prepared

#### 🔧 iOS Deployment Configuration
**Standard Development Team Setup:**
```
DEVELOPMENT_TEAM = TeamLinm2805;
DevelopmentTeam = TeamLinm2805;
```

**Applied to all iOS targets:**
- Main app target
- App extensions (CallDirectoryExtension, etc.)
- Debug and Release configurations

#### 🤖 Android Deployment Configuration
**Standard Package Naming:**
```gradle
applicationId "linm.soft.[appname]"
```

---

## 🎯 AI ASSISTANT WORKFLOW

### 📋 Detection Process
1. **Scan project files** for platform indicators
2. **Route to appropriate rules** (iOS/Android/Cross-platform)
3. **Apply universal standards** from this file
4. **Reference platform-specific** guidelines as needed

### 🤖 AI Response Templates

**Platform Detected:**
```
🤖 AI Assistant: Detected [iOS/Android/Cross-platform] project
📋 Routing to: [PLATFORM]_PROJECT_RULES.md
⚠️ Applying universal standards from CROSS_PLATFORM_RULES
```

---

## 🔧 TROUBLESHOOTING & COMMON ISSUES

### iOS Project Issues:
- **Xcode Crashes**: See [iOS Xcode Crash Troubleshooting](checklists/ios/ios-xcode-crash-troubleshooting.md)
- **Project File Corruption**: Check for ID collisions in .pbxproj files
- **Code Signing**: Verify development team configuration (`TeamLinm2805`)

### Android Project Issues:
- **Build Failures**: Check Gradle sync and dependency versions
- **Package Conflicts**: Verify applicationId follows `linm.soft.[appname]` pattern

### Cross-Platform Issues:
- **Documentation**: Reference project-specific DOCS/ folders
- **API Integration**: Check project/DOCS/api/ for implementation details
- **Feature Parity**: Use feature-tracking.md for cross-platform consistency

**Rule Application:**
```
✅ Universal rules applied:
   - Code quality standards
   - Documentation requirements
   - Performance guidelines

📱 Platform-specific rules:
   - [Link to platform rules]
   - [Relevant checklists]
```

---

## 📚 RELATED DOCUMENTATION

- **iOS Rules**: [`IOS_PROJECT_RULES.md`](./IOS_PROJECT_RULES.md)
- **Android Rules**: [`ANDROID_PROJECT_RULES.md`](./ANDROID_PROJECT_RULES.md)
- **Workflow Commands**: [`WORKFLOW_COMMANDS.md`](./WORKFLOW_COMMANDS.md)
- **AI Guidelines**: [`AI_GUIDELINES.md`](./AI_GUIDELINES.md)