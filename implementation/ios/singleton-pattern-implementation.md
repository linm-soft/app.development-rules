# iOS Singleton Pattern Implementation Guide

> Detailed implementation guide for Singleton pattern in iOS with SwiftUI

---

## 📋 Overview

The Singleton pattern ensures a class has only one instance and provides a global point of access to it. Perfect for managers that should exist once throughout the app lifecycle.

**When to use:**
- Dialog/Alert managers
- Configuration managers
- Cache managers
- Analytics managers
- Network managers

---

## 🔐 Basic Singleton Implementation

### Simple Singleton (Thread-Safe)

```swift
class DialogManager: ObservableObject {
    static let shared = DialogManager()
    
    @Published var isShowingDialog = false
    @Published var dialogTitle = ""
    @Published var dialogMessage = ""
    @Published var actionButtons: [String] = []
    
    private init() {
        // Initialization code here
        print("DialogManager initialized")
    }
    
    func showAlert(title: String, message: String) {
        self.dialogTitle = title
        self.dialogMessage = message
        self.isShowingDialog = true
    }
    
    func dismiss() {
        self.isShowingDialog = false
        self.dialogTitle = ""
        self.dialogMessage = ""
        self.actionButtons = []
    }
}
```

### Key Points:
- `static let shared` - Creates single instance
- `private init()` - Prevents initialization elsewhere
- `@Published` properties - Makes it observable for SwiftUI
- `ObservableObject` - Allows use as `@EnvironmentObject`

---

## 💻 Real-World Example: SmartCallBlock DialogManager

```swift
class DialogManager: ObservableObject {
    static let shared = DialogManager()
    
    @Published var isShowingDialog = false
    @Published var dialogType: DialogType = .alert
    @Published var dialogTitle = ""
    @Published var dialogMessage = ""
    @Published var primaryAction: DialogAction?
    @Published var secondaryAction: DialogAction?
    
    private init() {}
    
    enum DialogType {
        case alert
        case confirm
        case warning
        case success
    }
    
    struct DialogAction {
        let title: String
        let style: UIAlertAction.Style
        let handler: () -> Void
    }
    
    // MARK: - Alert Methods
    func showAlert(title: String, message: String) {
        self.dialogType = .alert
        self.dialogTitle = title
        self.dialogMessage = message
        self.primaryAction = DialogAction(title: "OK", style: .default) {
            self.dismiss()
        }
        self.isShowingDialog = true
    }
    
    // MARK: - Confirmation Methods
    func showConfirm(
        title: String,
        message: String,
        confirmText: String = "Confirm",
        cancelText: String = "Cancel",
        onConfirm: @escaping () -> Void
    ) {
        self.dialogType = .confirm
        self.dialogTitle = title
        self.dialogMessage = message
        self.primaryAction = DialogAction(title: confirmText, style: .default) {
            onConfirm()
            self.dismiss()
        }
        self.secondaryAction = DialogAction(title: cancelText, style: .cancel) {
            self.dismiss()
        }
        self.isShowingDialog = true
    }
    
    // MARK: - Success Methods
    func showSuccess(title: String = "Success", message: String) {
        self.dialogType = .success
        self.dialogTitle = title
        self.dialogMessage = message
        self.primaryAction = DialogAction(title: "OK", style: .default) {
            self.dismiss()
        }
        self.isShowingDialog = true
    }
    
    // MARK: - Error Methods
    func showError(title: String = "Error", message: String) {
        self.dialogType = .warning
        self.dialogTitle = title
        self.dialogMessage = message
        self.primaryAction = DialogAction(title: "OK", style: .default) {
            self.dismiss()
        }
        self.isShowingDialog = true
    }
    
    // MARK: - Dismiss
    func dismiss() {
        self.isShowingDialog = false
    }
}
```

---

## 🎯 Usage in Views

### Method 1: As @EnvironmentObject (Recommended)

**Setup in App:**
```swift
@main
struct SmartCallBlockApp: App {
    let persistenceController = PersistenceController.shared
    let dialogManager = DialogManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(dialogManager)
        }
    }
}
```

**Usage in Views:**
```swift
struct BlockedNumbersListView: View {
    @EnvironmentObject private var dialogManager: DialogManager
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Button("Delete") {
                dialogManager.showConfirm(
                    title: "Delete Number",
                    message: "Are you sure?",
                    onConfirm: {
                        deleteNumber()
                    }
                )
            }
        }
    }
    
    private func deleteNumber() {
        // Perform deletion
        dialogManager.showSuccess(message: "Number deleted successfully")
    }
}
```

### Method 2: Direct Access via Singleton

```swift
struct MyView: View {
    var body: some View {
        Button("Show Alert") {
            DialogManager.shared.showAlert(
                title: "Info",
                message: "This is an alert"
            )
        }
    }
}
```

---

## ⚠️ Common Pitfalls

### ❌ WRONG: Using @StateObject
```swift
// DON'T DO THIS
struct MyView: View {
    @StateObject var dialogManager = DialogManager.shared  // ❌ Creates new instance
}
```

### ✅ CORRECT: Using @ObservedObject
```swift
// DO THIS
struct MyView: View {
    @ObservedObject var dialogManager = DialogManager.shared  // ✅ References singleton
}
```

**Why?**
- `@StateObject` creates and manages lifecycle
- `@ObservedObject` just observes changes
- For singletons, use `@ObservedObject`

---

## 🧪 Testing Singletons

### Mock Singleton for Preview

```swift
extension DialogManager {
    static let forPreview: DialogManager = {
        let manager = DialogManager()
        return manager
    }()
}

// In Preview
#Preview {
    MyView()
        .environmentObject(DialogManager.forPreview)
}
```

### Unit Test Example

```swift
class DialogManagerTests: XCTestCase {
    func testSingletonInstance() {
        let instance1 = DialogManager.shared
        let instance2 = DialogManager.shared
        
        XCTAssertTrue(instance1 === instance2)  // Same instance
    }
    
    func testShowAlert() {
        let manager = DialogManager.shared
        manager.showAlert(title: "Test", message: "Message")
        
        XCTAssertTrue(manager.isShowingDialog)
        XCTAssertEqual(manager.dialogTitle, "Test")
    }
}
```

---

## 🔗 Thread Safety Considerations

For thread-safe singleton in Swift:

```swift
class ThreadSafeSingleton: ObservableObject {
    static let shared = ThreadSafeSingleton()
    
    private let queue = DispatchQueue(label: "com.app.singleton")
    
    @Published private(set) var value: String = ""
    
    private init() {}
    
    func setValue(_ newValue: String) {
        queue.async {
            self.value = newValue
        }
    }
}
```

---

## 📚 Related Files

- **Pattern Overview**: [app-rules.md - Singleton Pattern](../../app-rules.md#-singleton-pattern-for-shared-managers)
- **Real Example**: [SmartCallBlock Dialog Implementation](../ios/smartcallblock-dialog-example.md)
- **Dialog/Overlay Pattern**: [dialog-overlay-implementation.md](./dialog-overlay-implementation.md)

---

## ✅ Checklist for Singleton Implementation

- [ ] Class inherits from `ObservableObject` (if using SwiftUI)
- [ ] `static let shared` property created
- [ ] `private init()` prevents other initialization
- [ ] `@Published` properties for observable state
- [ ] Documentation for all public methods
- [ ] Unit tests for singleton behavior
- [ ] Preview with `.forPreview` static method
- [ ] Thread-safe if accessing from multiple threads
- [ ] Proper cleanup/reset methods if needed
- [ ] Memory doesn't leak (no retain cycles)
