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

### 🎯 **Architecture & Pattern Documentation Routing**

**⚠️ IMPORTANT FOR AI ASSISTANT:**

When user requests implementation of any architecture pattern:

1. **Pattern Definition** ← YOU ARE HERE (app-rules.md)
   - High-level pattern explanation
   - Generic code examples (generic names like "MyView", "MyManager")
   - Purpose and benefits

2. **Detailed Implementation Guides** ← ROUTE HERE
   - Location: `implementation/[platform]/[pattern-name].md`
   - Examples: 
     - `implementation/ios/singleton-pattern.md`
     - `implementation/ios/repository-pattern.md`
     - `implementation/android/repository-pattern.md`
   - Content: Real-world code with actual project context

3. **Real Project Examples** ← VERIFY HERE
   - Location: `[project]/DOCS/[platform]/`
   - Example: `smart-call-block/DOCS/ios/architecture.md`
   - Content: Actual SmartCallBlock implementation (DialogManager, BlockedNumberRepository, etc.)

**AI Decision Tree for Implementation Requests:**
```
User asks for pattern implementation?
├─ Pattern not yet implemented?
│  ├─ Check: implementation/[platform]/[pattern-name].md exists?
│  └─ If NO: Create detailed implementation guide there
│
├─ Pattern already implemented in a project?
│  ├─ Check: [project]/DOCS/[platform]/architecture.md
│  └─ Reference the actual code from that project
│
└─ Generic pattern explanation needed?
   └─ Reference the patterns section in app-rules.md (THIS FILE)
```

**When adding implementation guides:**
- ✅ Create in `implementation/ios/` or `implementation/android/`
- ✅ Include step-by-step setup instructions
- ✅ Link back to project examples (smart-call-block, etc.)
- ✅ Add to app-rules.md as reference links
- ❌ Don't duplicate detailed code here in app-rules.md

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
- **Singleton Pattern** for shared managers (DialogManager, CallBlockManager)

#### ⚠️ Architecture Pattern Documentation Routing

**Current Section (app-rules.md):**
- ✅ Pattern definitions and purpose
- ✅ Generic code examples
- ✅ Both iOS & Android implementations

**For Detailed Implementations:**
- 📍 Location: `implementation/[platform]/[pattern-name].md`
- Example: `implementation/ios/singleton-pattern-implementation.md`
- Content: Step-by-step setup, integration points, common pitfalls

**For Real Project Code:**
- 📍 Location: `smart-call-block/DOCS/ios/architecture.md`
- Content: Actual DialogManager, Repository implementations from SmartCallBlock
- Reference: How DialogManager is used in BlockedNumbersListView, etc.

**AI Note:** When user asks to implement a pattern:
1. Show relevant code example from THIS SECTION (generic understanding)
2. Link to detailed implementation guide (if exists in `implementation/`)
3. Reference actual project code (if exists in project DOCS)
4. If implementation guide missing → Create it and document the process

#### 🔐 Singleton Pattern for Shared Managers

**Purpose:** Centralized access to managers across the entire app

**Detailed Implementation & Examples:** See [Singleton Pattern Implementation Guide](./implementation/ios/singleton-pattern-implementation.md)

**Key Concepts:**
- Static `shared` instance
- Private `init()` prevents other initialization
- `@Published` properties for SwiftUI observation
- Use `@ObservedObject` (not `@StateObject`) for singletons

**Quick Example:**
```swift
class DialogManager: ObservableObject {
    static let shared = DialogManager()
    
    @Published var isShowingDialog = false
    @Published var dialogTitle = ""
    
    private init() {}
    
    func showAlert(title: String, message: String) {
        self.dialogTitle = title
        self.isShowingDialog = true
    }
}
```

**Usage:**
```swift
struct MyView: View {
    @ObservedObject var dialogManager = DialogManager.shared
    
    var body: some View {
        Button("Show Alert") {
            dialogManager.showAlert(title: "Info", message: "Hello")
        }
    }
}
```

**For detailed implementation, testing, and real-world examples:**
→ See [implementation/ios/singleton-pattern-implementation.md](./implementation/ios/singleton-pattern-implementation.md)

#### 📚 Repository Pattern for Data Access

**Purpose:** Centralize data access logic and provide abstraction over data sources

**Detailed Implementation & Examples:** See [Repository Pattern Implementation Guide](./implementation/ios/repository-pattern-implementation.md)

**Key Concepts:**
- Protocol defines data operations interface
- Implementation handles Core Data/Room specifics
- Easy to mock for testing
- Reusable across multiple views

**Quick Example (iOS):**
```swift
protocol BlockedNumberRepository {
    func fetchAll() -> [BlockedNumber]
    func add(_ number: BlockedNumber) throws
    func delete(_ number: BlockedNumber) throws
    func search(_ query: String) -> [BlockedNumber]
}

class BlockedNumberRepositoryImpl: BlockedNumberRepository {
    private var viewContext: NSManagedObjectContext
    
    func fetchAll() -> [BlockedNumber] {
        let request = NSFetchRequest<BlockedNumber>(entityName: "BlockedNumber")
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func add(_ number: BlockedNumber) throws {
        viewContext.insert(number)
        try viewContext.save()
    }
    
    // ... other methods
}
```

**Quick Example (Android):**
```java
public interface BlockedNumberRepository {
    void add(BlockedNumber number);
    void delete(BlockedNumber number);
    LiveData<List<BlockedNumber>> getAll();
}

public class BlockedNumberRepositoryImpl implements BlockedNumberRepository {
    private BlockedNumberDao dao;
    
    @Override
    public void add(BlockedNumber number) {
        new AddAsyncTask(dao).execute(number);
    }
    
    // ... other methods
}
```

**For detailed implementation, testing, and real-world examples:**
→ See [implementation/ios/repository-pattern-implementation.md](./implementation/ios/repository-pattern-implementation.md)

#### 🗺️ Coordinator Pattern for Navigation

**Purpose:** Centralize navigation logic and manage app flow

**Detailed Implementation & Examples:** See [Coordinator Pattern Implementation Guide](./implementation/ios/coordinator-pattern-implementation.md)

**Key Concepts:**
- Base Coordinator protocol for all coordinators
- AppCoordinator manages root navigation
- Child coordinators for feature flows
- Views/ViewControllers use weak coordinator reference
- Handles deep linking easily

**Quick Example (iOS):**
```swift
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
    }
}

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    func start() {
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: false)
    }
    
    func showSettings() {
        let settingsVC = SettingsViewController()
        navigationController.pushViewController(settingsVC, animated: true)
    }
}
```

**Quick Example (Android):**
```java
public interface Coordinator {
    void start();
    void navigate(String destination);
}

public class AppCoordinator implements Coordinator {
    private Activity activity;
    
    public AppCoordinator(Activity activity) {
        this.activity = activity;
    }
    
    @Override
    public void start() {
        navigateToHome();
    }
    
    @Override
    public void navigate(String destination) {
        switch (destination) {
            case "home": navigateToHome(); break;
            case "settings": navigateToSettings(); break;
        }
    }
    
    private void navigateToHome() {
        Intent intent = new Intent(activity, HomeActivity.class);
        activity.startActivity(intent);
    }
}
```

**For detailed implementation, testing, and deep linking examples:**
→ See [implementation/ios/coordinator-pattern-implementation.md](./implementation/ios/coordinator-pattern-implementation.md)

#### 🔔 iOS Dialog/Overlay Pattern ⚠️ CRITICAL

**✅ See Implementation Standards:**
- **Complete code examples**: [`implementation/ios/dialog-overlay-implementation.md`](./implementation/ios/dialog-overlay-implementation.md)
- **Real SmartCallBlock example**: [`implementation/ios/smartcallblock-dialog-example.md`](./implementation/ios/smartcallblock-dialog-example.md)
- **iOS architecture guide**: [`platform-rules/ios-project-rules.md`](./platform-rules/ios-project-rules.md)

#### 🎨 iOS SwiftUI View Preview ⚠️ REQUIRED

**MANDATORY for all SwiftUI Views:**
Every SwiftUI View struct must include `#Preview` macro for development canvas support.

**Documentation Routing:**
- **Rule & Checklist** ← YOU ARE HERE (app-rules.md)
  - High-level requirements
  - Generic examples
  - What to include in every preview
  
- **Detailed Implementation Guide** ← SEE HERE FOR MORE
  - Location: `guides/ui-resource-workflow.md`
  - Content: Advanced preview patterns, common issues, troubleshooting
  
- **Real Project Examples** ← REFERENCE HERE
  - Location: `smart-call-block/DOCS/ios/ui-components.md`
  - Content: Actual SmartCallBlock view implementations with previews

**Purpose:**
- Live preview rendering in Xcode Canvas
- Faster development iteration
- Real-time UI feedback without building

**Implementation Pattern:**
```swift
struct MyCustomView: View {
    var body: some View {
        VStack {
            Text("Hello World")
        }
    }
}

// ✅ REQUIRED: Always include #Preview macro
#Preview {
    MyCustomView()
        .environment(\.managedObjectContext, PersistenceController(inMemory: true).container.viewContext)
        .environmentObject(CallBlockManager.forPreview())
        // Add other required environment objects
}
```

**Checklist for Every New View:**
- [ ] View struct created with `View` protocol
- [ ] Body implemented with SwiftUI elements
- [ ] `#Preview` macro added at end of file
- [ ] Preview includes required `@Environment` objects
- [ ] Preview includes required `@EnvironmentObject` managers
- [ ] Preview uses mock/sample data for display
- [ ] Preview builds without compilation errors
- [ ] Canvas renders correctly in Xcode

**Examples with Different Scenarios:**

**Simple View (no dependencies):**
```swift
#Preview {
    SimpleButtonView()
}
```

**View with Core Data:**
```swift
#Preview {
    let context = PersistenceController(inMemory: true).container.viewContext
    MyListView()
        .environment(\.managedObjectContext, context)
}
```

**View with Manager Objects:**
```swift
#Preview {
    MyDetailView()
        .environment(\.managedObjectContext, PersistenceController(inMemory: true).container.viewContext)
        .environmentObject(CallBlockManager.forPreview())
        .environmentObject(SubscriptionManager.forPreview())
}
```

**View with Sample Data:**
```swift
#Preview {
    let context = PersistenceController(inMemory: true).container.viewContext
    
    // Create sample data
    let item = MyModel(context: context)
    item.name = "Sample Item"
    item.date = Date()
    
    try? context.save()
    
    return MyView()
        .environment(\.managedObjectContext, context)
}
```

**Migration Note:**
- **Old pattern**: `struct MyView_Previews: PreviewProvider { static var previews: some View { ... } }`
- **New pattern**: `#Preview { ... }`
- Update all existing PreviewProvider structs to use `#Preview` macro (SwiftUI 15+)

#### 📋 Android Dialog Pattern
**Recommended:**
- **DialogFragment** or **AlertDialog.Builder** with ViewModel coordination
- **LiveData/StateFlow** for dialog state management
- Centralized DialogManager if cross-activity dialogs needed

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
- **Dialog/Overlay Not Showing**: Ensure `CommonDialogOverlay()` is applied in feature view
- **"Cannot find DialogManager in scope"**: Apply overlay in feature views, not app root (compilation order)
- **@StateObject vs @ObservedObject**: Use `@ObservedObject` for singletons in overlays

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