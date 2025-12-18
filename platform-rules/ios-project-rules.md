# iOS Project Rules & Best Practices

> Universal rules for ALL iOS Swift/SwiftUI projects. Apply to any iOS app regardless of domain or functionality.

---

## 📱 UNIVERSAL APPLICATION

**🎯 Apply these rules to ANY iOS project:**
- **✅ Todo/Task Management Apps** - Apply data management patterns
- **✅ Social/Chat Apps** - Apply networking and UI patterns  
- **✅ E-commerce Apps** - Apply security and payment patterns
- **✅ Productivity Apps** - Apply Core Data and sync patterns
- **✅ Utility Apps** - Apply system integration patterns
- **✅ Entertainment Apps** - Apply media and performance patterns

**🔄 Examples in this document use generic terminology:**
- `DataItem` instead of specific entity names
- `DataManager` instead of domain-specific managers  
- `ItemsList` instead of feature-specific views
- Universal patterns that adapt to any use case

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "IOS_PROJECT_RULES"...
```

**Purpose:** Let user know AI is referencing iOS project rules.

---

## 🤖 AI GUIDELINES & DOCUMENTATION REFERENCES

**📂 Complete AI Instructions:** [`../ai-guidelines.md`](../ai-guidelines.md)
**📂 App Rules:** [`../app-rules.md`](../app-rules.md)
**📂 Workflow Commands:** [`../workflow-commands.md`](../workflow-commands.md)
**📂 iOS UI Workflow:** [`ios-ui-workflow.md`](./ios-ui-workflow.md)

**📚 Universal Documentation Pattern:**
- **iOS Architecture:** `[project]/DOCS/ios/architecture.md`
- **Build Guide:** `[project]/DOCS/ios/build-guide.md`
- **Database Schema:** `[project]/DOCS/ios/database-schema.md`
- **API Reference:** `[project]/DOCS/api/ios-api-reference.md`
- **Setup Guide:** `[project]/DOCS/ios/setup-guide.md`

**Quick AI Reference:**
- Apply universal rules from app-rules.md
- Use iOS-specific implementation patterns
- Follow iOS Human Interface Guidelines
- Reference project-specific DOCS/ for technical implementation details
- Apply these rules to ANY iOS project
- Always create TODO list before starting work

---

## 1. PROJECT STRUCTURE & ORGANIZATION ⚠️ CRITICAL

### 1.1. Standard iOS Project Structure
```
MyApp/
├── MyApp/                          # Main app target
│   ├── App/
│   │   ├── MyAppApp.swift         # App entry point
│   │   ├── ContentView.swift      # Main content view
│   │   └── Info.plist             # App configuration
│   ├── Views/                     # SwiftUI views
│   │   ├── Home/
│   │   ├── Settings/
│   │   └── Shared/
│   ├── ViewModels/               # MVVM view models
│   ├── Models/                   # Data models
│   ├── Services/                 # Business logic
│   ├── Utilities/                # Helper classes
│   ├── Resources/                # Assets, strings, etc.
│   │   ├── Assets.xcassets
│   │   ├── Localizable.strings
│   │   └── Colors.xcassets
│   └── Extensions/               # Swift extensions
├── MyAppTests/                   # Unit tests
├── MyAppUITests/                 # UI tests
├── MyAppExtension/               # App extensions (if any)
└── docs/                         # Documentation
```

### 1.2. Bundle ID Format ⚠️ REQUIRED

**Standard Bundle ID Format:** `linm.soft.[appname]`

**Examples:**
```xml
<!-- Info.plist -->
<key>CFBundleIdentifier</key>
<string>linm.soft.myapp</string>

<!-- Other examples -->
<string>linm.soft.todolist</string>
<string>linm.soft.notekeeper</string>
<string>linm.soft.weatherapp</string>
```

**Naming Rules:**
- Use lowercase only: `todolist` not `TodoList`
- No hyphens or underscores: `notekeeper` not `note-keeper` 
- Remove spaces: `weatherapp` not `weather app`
- Keep it short but descriptive

**Cross-Platform Consistency:**
- Must match Android applicationId format
- Ensures unified app identification
- Compatible with build automation scripts

---

### 1.3. File Naming Conventions
**Views:** `HomeView.swift`, `SettingsView.swift`
**ViewModels:** `HomeViewModel.swift`, `SettingsViewModel.swift`
**Models:** `User.swift`, `DataItem.swift`
**Services:** `NetworkService.swift`, `DataService.swift`

### 1.4. Domain-Specific Customization Examples

#### 📝 Todo/Task Apps:
```
Models: Task.swift, Category.swift, Priority.swift
ViewModels: TaskListViewModel.swift, TaskDetailViewModel.swift
Services: TaskService.swift, SyncService.swift
```

#### 💬 Chat/Social Apps:
```
Models: Message.swift, User.swift, Conversation.swift  
ViewModels: ChatViewModel.swift, UserProfileViewModel.swift
Services: MessageService.swift, AuthService.swift
```

#### 🛒 E-commerce Apps:
```
Models: Product.swift, Order.swift, Cart.swift
ViewModels: ProductListViewModel.swift, CartViewModel.swift
Services: PaymentService.swift, InventoryService.swift
```

#### 🎵 Media/Entertainment Apps:
```
Models: MediaItem.swift, Playlist.swift, Artist.swift
ViewModels: PlayerViewModel.swift, LibraryViewModel.swift  
Services: MediaService.swift, DownloadService.swift
```

**🎯 Adaptation Pattern:**
- Replace `DataItem` with domain entity (`Task`, `Message`, `Product`, etc.)
- Replace `DataManager` with domain manager (`TaskManager`, `ChatManager`, etc.)
- Keep architectural patterns and coding standards identical
- Maintain universal naming conventions and file organization

---

## 📋 UNIVERSAL PRINCIPLES FOR ALL iOS APPS

### 🎯 Core Principles (Apply to ANY domain):
1. **Single Responsibility** - Each class/struct has one clear purpose
2. **MVVM Architecture** - Separate business logic from UI logic
3. **Reactive Programming** - Use `@Published` and `ObservableObject`
4. **Safe Programming** - Optional handling, error management
5. **Performance First** - `@MainActor`, background processing
6. **Accessibility Support** - VoiceOver, Dynamic Type, accessibility labels
7. **Localization Ready** - Externalized strings, locale-aware formatting
8. **Security Conscious** - Keychain storage, certificate pinning

### 🔄 Adaptation Guidelines:
- **Keep patterns identical** across all app types
- **Change only terminology** to match your domain
- **Maintain file structure** and naming conventions  
- **Apply same quality standards** regardless of app complexity
- **Use same tools and frameworks** for consistency

---

## 2. SWIFT CODING STANDARDS ⚠️ CRITICAL

### 2.1. Swift Style Guidelines
```swift
// GOOD: Clear, descriptive naming
class DataManager: ObservableObject {
    @Published var isEnabled: Bool = false
    @Published var items: [DataItem] = []
    
    func addDataItem(_ name: String) {
        // Implementation
    }
}

// BAD: Unclear naming
class DM {
    var e: Bool = false
    var nums: [BN] = []
}
```

### 2.2. Optional Handling ⚠️ CRITICAL
```swift
// GOOD: Safe optional unwrapping
func processPhoneNumber(_ number: String?) {
    guard let phoneNumber = number, !phoneNumber.isEmpty else {
        showError("Invalid phone number")
        return
    }
    
    // Process valid phone number
    blockNumber(phoneNumber)
}

// GOOD: Nil coalescing
let displayName = user.name ?? "Unknown User"

// BAD: Force unwrapping
let name = user.name! // Dangerous!
```

### 2.3. Error Handling ⚠️ CRITICAL
```swift
// GOOD: Proper error handling
func saveUserData(_ userData: UserData) async {
    do {
        try await dataService.save(userData)
        await showSuccess("Data saved successfully")
    } catch {
        await showError("Failed to save data: \(error.localizedDescription)")
        logger.logError("Save failed", error: error)
    }
}

// GOOD: Result type for complex operations
func fetchUserData() async -> Result<[UserData], Error> {
    do {
        let data = try await dataService.fetchUserData()
        return .success(data)
    } catch {
        return .failure(error)
    }
}
```

---

## 3. SWIFTUI BEST PRACTICES ⚠️ REQUIRED

### 3.1. View Structure
```swift
struct ContentView: View {
    // MARK: - Properties
    @StateObject private var viewModel = ContentViewModel()
    @State private var showingAlert = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                headerSection
                contentSection
                footerSection
            }
            .navigationTitle("App Name")
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        VStack {
            // Header content
        }
    }
}
```

### 3.2. State Management ⚠️ CRITICAL
```swift
// GOOD: Proper state management
class DataListViewModel: ObservableObject {
    @Published var items: [DataItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @MainActor
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            items = try await dataService.fetchData()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// GOOD: Using @MainActor for UI updates
@MainActor
func updateUI() {
    // Safe UI updates
}
```

### 3.3. Modifiers & Styling
```swift
// GOOD: Consistent styling with custom modifiers
extension View {
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
    }
}

// Usage
Button("Save Data") {
    saveData()
}
.primaryButtonStyle()
```

---

## 4. SWIFT SYNTAX BEST PRACTICES ⚠️ CRITICAL

### 4.1. String Interpolation & Quotes
```swift
// ❌ BAD: Extra quotes or malformed strings  
Text("call.phoneNumber ?? "Unknown""  // Syntax error
Text("Duration: \\(duration)s")        // Wrong escape sequence

// ✅ GOOD: Proper string interpolation
Text(call.phoneNumber ?? "Unknown")
Text("Duration: \(duration)s")

// ✅ GOOD: Multi-line strings
let message = """
    This is a multi-line string
    with proper formatting
    """

// ✅ GOOD: Complex interpolation
Text("Call from \(call.callerName ?? call.phoneNumber ?? "Unknown") at \(formattedDate)")
```

### 4.2. Optional Handling
```swift
// ❌ BAD: Force unwrapping
let name = call.callerName!

// ✅ GOOD: Safe optional binding
if let name = call.callerName {
    Text(name)
}

// ✅ GOOD: Nil coalescing
Text(call.callerName ?? "Unknown Caller")

// ✅ GOOD: Guard statements for early returns
guard let phoneNumber = call.phoneNumber else {
    return Text("Invalid Call")
}
```

### 4.3. Common Syntax Errors to Avoid
```swift
// ❌ BAD: Missing semicolon in multi-statement lines
let name = "John" let age = 30  // Error

// ✅ GOOD: Separate lines or semicolon
let name = "John"
let age = 30

// ❌ BAD: Incorrect string concatenation
let message = "Hello " + name + ", you have " + String(count) + " messages"

// ✅ GOOD: String interpolation
let message = "Hello \(name), you have \(count) messages"

// ❌ BAD: Consecutive statements without proper separation  
} Text("Next line")  // Missing newline

// ✅ GOOD: Proper structure
}

Text("Next line")
```

### 4.4. SwiftUI Syntax Patterns
```swift
// ❌ BAD: Inline complex logic
Text(call.wasBlocked ? (call.phoneNumber != nil ? call.phoneNumber! : "Unknown") : "Allowed")

// ✅ GOOD: Extract to computed properties
private var displayText: String {
    if call.wasBlocked {
        return call.phoneNumber ?? "Unknown"
    } else {
        return "Allowed"
    }
}

// ✅ GOOD: Use in view
Text(displayText)
```

### 4.5. Code Review Checklist for Syntax
- [ ] **String interpolation**: All `\(variable)` syntax correct
- [ ] **Quote marks**: No extra or missing quotes
- [ ] **Optional handling**: No force unwrapping (`!`) unless absolutely necessary  
- [ ] **Line separation**: Proper newlines between statements
- [ ] **Escape sequences**: Correct backslash usage - NO literal `\n` in code
- [ ] **Closing braces**: All opened blocks properly closed
- [ ] **Formatting characters**: No escaped newlines (`\n`) or tabs (`\t`) in Swift code
- [ ] **Function declarations**: No duplicate function definitions
- [ ] **Parameter labels**: Explicit parameter names for clarity

### 4.6. ⚠️ COMMON SWIFT ERRORS TO PREVENT

**Duplicate Function Declarations:**
```swift
// ❌ BAD: Duplicate function definitions
private func processData() { ... }   // First definition
// ... other code ...
private func processData() { ... }   // DUPLICATE - Remove this!

// ✅ GOOD: Single function definition
private func processData() { 
    // Single implementation
}
```

**Implicit vs Explicit Parameters:**
```swift
// ❌ UNCLEAR: Implicit first parameter
CustomButton("Save", action: saveData)
ComponentView("Title", parameter: value)

// ✅ GOOD: Explicit parameter labels
CustomButton(title: "Save", action: saveData)  
ComponentView(title: "Title", parameter: value)
```

**Prevention Steps:**
1. **Search for duplicates** using "Find in File" (⌘F) for function names
2. **Use explicit parameter labels** for better code readability
3. **Enable "Show All Issues"** in Xcode to catch redeclarations early
4. **Build frequently** to catch syntax errors during development

### 4.6. ⚠️ SYNTAX ERROR PREVENTION

**Common Swift Syntax Errors to Avoid:**

```swift
// ❌ BAD: Literal escape characters in code
.padding(.horizontal)\n
}\n

// ✅ GOOD: Proper line breaks
.padding(.horizontal)
}

// ❌ BAD: Escaped characters mixed with code
Text("Hello")\n.font(.title)

// ✅ GOOD: Natural formatting
Text("Hello")
    .font(.title)
```

**Prevention Steps:**
1. **Auto-format code** with Xcode (⌃I) after copying from docs
2. **Visual inspection** for `\n`, `\t`, or other escape sequences
3. **Build frequently** to catch syntax errors early
4. **Use Xcode autocomplete** instead of copying formatted code

---

## 5. CORE DATA INTEGRATION ⚠️ REQUIRED

### 4.1. Core Data Stack Setup
```swift
class PersistenceController {
    static let shared = PersistenceController()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            try? context.save()
        }
    }
}
```

### 4.2. SwiftUI + Core Data
```swift
// GOOD: Using @FetchRequest in SwiftUI
struct DataItemsList: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DataItem.dateCreated, ascending: false)],
        animation: .default)
    private var dataItems: FetchedResults<DataItem>
    
    var body: some View {
        List {
            ForEach(blockedNumbers, id: \.self) { number in
                BlockedNumberRow(number: number)
            }
            .onDelete(perform: deleteNumbers)
        }
    }
    
    private func deleteNumbers(offsets: IndexSet) {
        withAnimation {
            offsets.map { blockedNumbers[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}
```

---

## 5. CALLKIT INTEGRATION ⚠️ REQUIRED

### 5.1. Call Directory Extension
```swift
class CallDirectoryHandler: CXCallDirectoryProvider {
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        do {
            if context.isIncremental {
                addOrRemoveIncrementalBlockingPhoneNumbers(to: context)
            } else {
                addAllBlockingPhoneNumbers(to: context)
            }
            
            context.completeRequest()
        } catch {
            context.cancelRequest(withError: error)
        }
    }
    
    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        let blockedNumbers = getBlockedPhoneNumbers()
        
        for phoneNumber in blockedNumbers.sorted() {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }
}
```

### 5.2. Extension Data Sharing
```swift
// Shared App Group for data access
func getSharedDataURL() -> URL? {
    return FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: "group.linm.soft.[appname]"
    )
}
```

### 5.3. Entitlements Configuration ⚠️ CRITICAL

**File:** `[AppName].entitlements`

**Required Format:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Call Directory Extension -->
    <key>com.apple.developer.CallKit.call-blocking</key>
    <true/>
    
    <!-- App Groups - MUST match bundle identifier format -->
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.linm.soft.[appname]</string>
    </array>
</dict>
</plist>
```

**Critical Rules:**
- App Group identifier MUST follow `group.linm.soft.[appname]` format
- Must match main app bundle identifier pattern
- Required for Call Directory Extensions data sharing
- Must be configured in Apple Developer Portal

---

## 6. PERFORMANCE & OPTIMIZATION ⚠️ CRITICAL

### 6.1. Async/Await Best Practices
```swift
// GOOD: Proper async/await usage
class NetworkService {
    func fetchData() async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    @MainActor
    func updateUI(with data: Data) {
        // UI updates on main actor
    }
}

// GOOD: Task management
func loadContent() {
    Task {
        do {
            let data = try await networkService.fetchData()
            await updateUI(with: data)
        } catch {
            await showError(error)
        }
    }
}
```

### 6.2. Memory Management
```swift
// GOOD: Weak references to avoid retain cycles
class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default
            .publisher(for: .dataChanged)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
}
```

---

## 7. TESTING STANDARDS ⚠️ REQUIRED

### 7.1. Unit Testing
```swift
@testable import MyApp
import XCTest

class CallBlockManagerTests: XCTestCase {
    var callBlockManager: CallBlockManager!
    
    override func setUp() {
        super.setUp()
        callBlockManager = CallBlockManager()
    }
    
    func testBlockingNumber() {
        // Given
        let phoneNumber = "1234567890"
        
        // When
        callBlockManager.blockNumber(phoneNumber)
        
        // Then
        XCTAssertTrue(callBlockManager.isNumberBlocked(phoneNumber))
    }
    
    func testAsyncOperation() async {
        // Test async operations
        let result = await callBlockManager.fetchBlockedNumbers()
        XCTAssertNotNil(result)
    }
}
```

### 7.2. UI Testing
```swift
class MyAppUITests: XCTestCase {
    func testAddingBlockedNumber() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Add Number"].tap()
        app.textFields["Phone Number"].typeText("1234567890")
        app.buttons["Block"].tap()
        
        XCTAssertTrue(app.staticTexts["1234567890"].exists)
    }
}
```

---

## 8. ACCESSIBILITY ⚠️ REQUIRED

### 8.1. VoiceOver Support
```swift
// GOOD: Proper accessibility labels
Button("Save Item") {
    saveItem()
}
.accessibilityLabel("Save this item")
.accessibilityHint("Adds the item to your saved list")

// GOOD: Accessibility values for dynamic content
Text("\(itemCount) items saved")
    .accessibilityLabel("\(itemCount) items are currently saved")
```

### 8.2. Dynamic Type Support
```swift
// GOOD: Support for Dynamic Type
Text("Blocked Numbers")
    .font(.headline)
    .minimumScaleFactor(0.8)
```

---

## 9. SECURITY STANDARDS ⚠️ CRITICAL

### 9.1. Data Protection
```swift
// GOOD: Keychain storage for sensitive data
import Security

class KeychainService {
    func store(data: Data, forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
}
```

### 9.2. Network Security
```swift
// GOOD: Certificate pinning
class NetworkManager {
    func urlSession(_ session: URLSession, 
                   didReceive challenge: URLAuthenticationChallenge,
                   completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Implement certificate pinning
    }
}
```

---

## 10. LOCALIZATION ⚠️ REQUIRED

### 10.1. String Externalization
```swift
// GOOD: Using localized strings
Text("data_list_title")
    .localizedString()

// Localizable.strings
"data_list_title" = "Data List";
"add_item_button" = "Add Item";
```

### 10.2. Date and Number Formatting
```swift
// GOOD: Locale-aware formatting
let formatter = DateFormatter()
formatter.dateStyle = .medium
formatter.timeStyle = .short
let dateString = formatter.string(from: date)
```

---

## 📋 iOS-SPECIFIC CHECKLISTS

### ✅ Swift Syntax Review Checklist
- [ ] **String interpolation**: All `\(variable)` syntax correct, no `\\(variable)`
- [ ] **Quote marks**: No extra quotes like `"text"` → `"text"`  
- [ ] **Optional handling**: Proper `??` or `if let` instead of force unwrapping
- [ ] **Line separation**: No consecutive statements like `} Text("next")`
- [ ] **Escape sequences**: Correct backslash usage in strings
- [ ] **Closing braces**: All SwiftUI view builders properly closed
- [ ] **Enum cases**: All referenced enums are defined
- [ ] **Import statements**: Required frameworks imported (SwiftUI, CoreData, etc.)

### ✅ SwiftUI Implementation Checklist
- [ ] Views follow single responsibility principle
- [ ] State management properly implemented
- [ ] Navigation properly structured
- [ ] Modifiers used efficiently
- [ ] Preview providers included

### ✅ Core Data Implementation Checklist  
- [ ] Entity classes properly generated (with `+CoreDataClass.swift` extensions)
- [ ] Properties properly mapped in `+CoreDataProperties.swift` 
- [ ] `@FetchRequest` syntax correct with proper sort descriptors
- [ ] Core Data context properly injected via `.environment()`
- [ ] NSManagedObject references use correct entity names
- [ ] Fetch requests use proper type casting: `FetchedResults<EntityName>`
- [ ] Main actor used for UI updates
- [ ] Background tasks properly managed
- [ ] Memory leaks checked
- [ ] Launch time optimized
- [ ] Battery usage optimized

### ✅ App Store Checklist
- [ ] Privacy manifest included
- [ ] App Store guidelines followed
- [ ] Required device capabilities set
- [ ] Proper app icons and screenshots
- [ ] In-app purchases (if any) implemented correctly

---

## �️ CORE DATA BEST PRACTICES (NEW)

### Core Data File Generation

**SmartCallBlock Project Reference Implementation:**

**Setup (First Time Only):**
```bash
cd IOS/
python3 generate_core_data_files.py
```

**Configuration in Xcode:**
1. Open DataModel.xcdatamodel
2. Select each Entity
3. Set **Code Generation** to "Manual" (not "Class Definition")
4. Reason: Allows script-based auto-generation with proper formatting

**Python Generator Script:**
```python
# File: generate_core_data_files.py
# Parses DataModel.xcdatamodel XML
# Auto-generates:
#   - Entity+CoreDataClass.swift
#   - Entity+CoreDataProperties.swift
```

**Git Hook Integration:**
```bash
# File: .git/hooks/pre-commit
# Auto-runs generator if DataModel.xcdatamodel changed
# Automatically adds generated files to commit
```

**Workflow:**
```bash
# 1. Edit DataModel.xcdatamodel in Xcode
# 2. Commit changes (hook auto-generates files)
git commit -m "Update Core Data schema"

# 3. Generated files auto-included in commit
# No manual file generation needed!
```

**Schema Migration:**
- Enable automatic lightweight migration in AppDelegate/PersistenceController
- Set: `shouldInferMappingModelAutomatically = true`
- Set: `shouldMigrateStoreAutomatically = true`
- Implement migration detection to handle schema mismatches

**SmartCallBlock Example:**
```swift
// SmartCallBlockApp.swift
storeDescription.shouldInferMappingModelAutomatically = true
storeDescription.shouldMigrateStoreAutomatically = true

// Implement migration handler
private func handleSchemaMigration() {
    // Detect schema mismatch and handle gracefully
    // Remove incompatible stores for fresh migration
}
```

---

## 📚 RELATED DOCUMENTATION

- **Cross-Platform Rules**: [`CROSS_PLATFORM_RULES.md`](../CROSS_PLATFORM_RULES.md)
- **AI Guidelines**: [`AI_GUIDELINES.md`](../AI_GUIDELINES.md)
- **Workflow Commands**: [`WORKFLOW_COMMANDS.md`](./WORKFLOW_COMMANDS.md)
- **iOS Checklists**: [`checklists/ios/`](./checklists/ios/)
- **SmartCallBlock Updates**: [`../../smart-call-block/IOS/DEVELOPMENT_UPDATES.md`](../../smart-call-block/IOS/DEVELOPMENT_UPDATES.md)