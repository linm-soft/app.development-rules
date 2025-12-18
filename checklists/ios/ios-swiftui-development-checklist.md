# iOS SwiftUI Development Checklist

> Checklist cho AI Assistant khi develop iOS SwiftUI apps

---

## 📢 AI PROTOCOL
**When AI reads this file, announce:**
```
AI checking "iOS SwiftUI Development Checklist"...
```

---

## 🎯 PRE-DEVELOPMENT SETUP

### ✅ Project Configuration
- [ ] **Xcode Version**: Minimum Xcode 14.0+ for iOS 16+ features
- [ ] **Swift Version**: Swift 5.7+ for proper async/await support
- [ ] **Deployment Target**: iOS 16.0+ recommended for latest SwiftUI features
- [ ] **Bundle Identifier**: Unique reverse-domain notation (com.company.appname)
- [ ] **Team & Signing**: Development team configured for device testing
- [ ] **Capabilities**: Required entitlements added (CallKit, App Groups, etc.)

### ✅ Project Structure
- [ ] **App Entry Point**: `AppNameApp.swift` with proper `@main` attribute
- [ ] **Content View**: `ContentView.swift` as main UI entry point
- [ ] **MVVM Structure**: Views, ViewModels, Models folders created
- [ ] **Services Folder**: For business logic and data services
- [ ] **Extensions Folder**: Swift extensions and utilities
- [ ] **Resources Folder**: Assets, localization, configuration files

### ✅ Assets Management
- [ ] **Assets.xcassets**: Main asset catalog with proper Contents.json
- [ ] **AppIcon.appiconset**: App icons properly organized in dedicated folder
- [ ] **Icon Files Location**: All Icon-*.png files inside AppIcon.appiconset (NOT loose in Assets.xcassets)
- [ ] **Contents.json Validation**: AppIcon Contents.json references match actual files
- [ ] **Required Icon Sizes**: All iOS required icon sizes included (20x20@2x through 1024x1024@1x)

**⚠️ CRITICAL: Asset Organization**
```
✅ CORRECT Structure:
Assets.xcassets/
├── Contents.json
└── AppIcon.appiconset/
    ├── Contents.json
    ├── Icon-20@2x.png    # Icons HERE
    ├── Icon-20@3x.png
    └── ... (all icons)

❌ WRONG Structure:
Assets.xcassets/
├── Contents.json
├── Icon-20@2x.png      # Icons loose here (causes build errors)
├── Icon-20@3x.png
└── AppIcon.appiconset/
    └── Contents.json    # Empty appiconset folder
```

---

## 🎨 SWIFTUI VIEWS CHECKLIST

### ✅ View Structure Standards
- [ ] **Single Responsibility**: Each view handles one specific UI concern
- [ ] **Computed Properties**: Complex UI broken into computed properties
- [ ] **MARK Comments**: Sections properly marked (Properties, Body, View Components)
- [ ] **Preview Providers**: All views have working preview providers
- [ ] **Accessibility**: Labels and hints properly implemented

```swift
// ✅ GOOD: Proper view structure
struct ContentView: View {
    // MARK: - Properties
    @StateObject private var viewModel = ContentViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                headerSection
                contentSection
                footerSection
            }
        }
    }
    
    // MARK: - View Components
    private var headerSection: some View {
        // Header implementation
    }
}
```

### ✅ State Management
- [ ] **@State**: Used for simple view-local state only
- [ ] **@StateObject**: Used ONLY for app entry point, avoid in child views  
- [ ] **@EnvironmentObject**: Preferred for shared services (safer for previews)
- [ ] **@ObservedObject**: Used for passed-in observable objects
- [ ] **@Published**: ViewModels use @Published for UI-reactive properties
- [ ] **@MainActor**: UI updates properly annotated with @MainActor

**⚠️ CRITICAL: Preview-Safe State Management**
```swift
// ❌ CRASH RISK: @StateObject in child views causes preview crashes
struct ContentView: View {
    @StateObject private var callBlockManager = CallBlockManager.shared  // BAD
    
// ✅ SAFE: Use @EnvironmentObject for shared services
struct ContentView: View {
    @EnvironmentObject private var callBlockManager: CallBlockManager  // GOOD
    
// App provides environment object:
WindowGroup {
    ContentView()
        .environmentObject(CallBlockManager.shared)
}
```

### ✅ SwiftUI Preview Safety
- [ ] **In-Memory Context**: Previews use `PersistenceController(inMemory: true)`
- [ ] **Mock Data**: Sample data created for preview context
- [ ] **Environment Objects**: All shared services provided to previews
- [ ] **Preview-Safe Managers**: Services have `.forPreview()` factory methods
- [ ] **No Shared State**: Avoid `.shared` singletons in previews

```swift
// ✅ SAFE PREVIEW IMPLEMENTATION
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController(inMemory: true).container.viewContext
        
        // Create sample data
        let sampleEntity = SampleEntity(context: context)
        sampleEntity.name = "Preview Data"
        try? context.save()
        
        return ContentView()
            .environment(\\.managedObjectContext, context)
            .environmentObject(CallBlockManager.forPreview())
    }
}
```

### ✅ Navigation Implementation
- [ ] **NavigationView**: Proper navigation container setup
- [ ] **NavigationLink**: Programmatic navigation implemented
- [ ] **Sheet Presentation**: Modal sheets properly managed with @State
- [ ] **Alert Handling**: Error and confirmation alerts implemented
- [ ] **Dismiss Actions**: Proper back/dismiss functionality

---

## 📱 UI/UX STANDARDS CHECKLIST

### ✅ iOS Design Guidelines
- [ ] **Human Interface Guidelines**: Following Apple's HIG principles
- [ ] **Native Controls**: Using SwiftUI native controls (Toggle, Picker, etc.)
- [ ] **Color System**: Using Color.primary, Color.secondary for dynamic colors
- [ ] **Typography**: Proper font styles (.title, .headline, .body, etc.)
- [ ] **Spacing**: Consistent padding and spacing using system values

### ✅ Responsive Design
- [ ] **Device Support**: iPhone and iPad layouts properly handled
- [ ] **Orientation**: Portrait and landscape support where appropriate
- [ ] **Dynamic Type**: Text scales properly with accessibility settings
- [ ] **Safe Areas**: Content respects safe area insets
- [ ] **Adaptive Layout**: UI adapts to different screen sizes

### ✅ Dark Mode Support
- [ ] **Color Assets**: Colors defined in Assets.xcassets with dark variants
- [ ] **Dynamic Colors**: Using system colors that adapt automatically
- [ ] **Image Assets**: App icons and images with dark mode variants
- [ ] **Testing**: App tested in both light and dark modes

---

## 🔧 ARCHITECTURE CHECKLIST

### ✅ MVVM Pattern Implementation
- [ ] **View**: Only handles UI presentation and user interactions
- [ ] **ViewModel**: Contains all business logic and state management
- [ ] **Model**: Data structures and Core Data entities properly defined
- [ ] **ObservableObject**: ViewModels conform to ObservableObject protocol
- [ ] **Separation of Concerns**: Clear boundaries between layers

```swift
// ✅ GOOD: Proper MVVM structure
class CallBlockViewModel: ObservableObject {
    @Published var blockedNumbers: [BlockedNumber] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataService: DataService
    
    func loadBlockedNumbers() async {
        await MainActor.run { isLoading = true }
        // Load data...
        await MainActor.run { isLoading = false }
    }
}
```

### ✅ Dependency Injection
- [ ] **Service Injection**: Services injected into ViewModels via initializer
- [ ] **Environment Objects**: Shared services available via @EnvironmentObject
- [ ] **Testability**: Dependencies can be mocked for unit testing
- [ ] **Protocol-Based**: Services defined as protocols for flexibility

### ✅ Error Handling
- [ ] **Result Types**: Complex operations return Result<Success, Error>
- [ ] **User-Friendly Errors**: Technical errors converted to user messages
- [ ] **Error Logging**: Errors properly logged for debugging
- [ ] **Recovery Actions**: Users can retry failed operations
- [ ] **Offline Handling**: Graceful offline/network error handling

---

## 📊 DATA MANAGEMENT CHECKLIST

### ✅ Core Data Integration
- [ ] **Data Model**: .xcdatamodeld file properly configured
- [ ] **Code Generation**: Choose ONE approach consistently:
  - **Auto-Generated**: `codeGenerationType="class"` + NO manual class files
  - **Manual Classes**: `codeGenerationType="category"` + manual +CoreDataClass.swift files
- [ ] **Entity Configuration**: Entities use representedClassName matching Swift class names
- [ ] **Persistence Controller**: Singleton pattern for Core Data stack
- [ ] **App Groups**: Configured for data sharing with extensions
- [ ] **Background Context**: Background saves don't block UI
- [ ] **Migration**: Version management for data model changes

**⚠️ CRITICAL: Core Data Class Configuration**
```xml
<!-- Option A: Auto-Generated (recommended for simple cases) -->
<entity name="BlockedNumber" representedClassName="BlockedNumber" syncable="YES" codeGenerationType="class">

<!-- Option B: Manual Classes (for custom business logic) -->
<entity name="BlockedNumber" representedClassName="BlockedNumber" syncable="YES" codeGenerationType="category">
```

**🚨 NEVER MIX**: Don't use `codeGenerationType="class"` with manual Core Data files - causes conflicts!

### ✅ Core Data Error Recovery
- [ ] **Version File**: .xccurrentversion file exists in .xcdatamodeld bundle
- [ ] **Bundle Verification**: Model file existence verified during initialization
- [ ] **Error Logging**: Detailed error information logged for debugging
- [ ] **Store Recovery**: Corrupted store recovery mechanism implemented
- [ ] **Fallback Model**: Programmatic model creation as backup option

```swift
// ✅ GOOD: Robust Core Data initialization
init(inMemory: Bool = false) {
    // Verify model exists in bundle
    guard let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
        print("ERROR: DataModel.momd not found in bundle")
        container = self.createContainerWithProgrammaticModel()
        return
    }
    
    container = NSPersistentContainer(name: "DataModel")
    
    container.loadPersistentStores { storeDescription, error in
        if let error = error as NSError? {
            print("Core Data Error: \\(error.localizedDescription)")
            if !inMemory {
                self.attemptStoreRecovery()
            }
        }
    }
}
```

### ✅ SwiftUI + Core Data
- [ ] **@FetchRequest**: Proper fetch requests in SwiftUI views
- [ ] **Managed Object Context**: Context passed via environment
- [ ] **Automatic Updates**: UI automatically updates with data changes
- [ ] **Delete Operations**: Proper delete handling with animations
- [ ] **Sorting/Filtering**: FetchRequest configured with sort descriptors

```swift
// ✅ GOOD: Core Data in SwiftUI
@FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \BlockedNumber.dateAdded, ascending: false)],
    animation: .default
) private var blockedNumbers: FetchedResults<BlockedNumber>
```

### ✅ Data Validation
- [ ] **Input Validation**: User input validated before Core Data saves
- [ ] **Phone Number Format**: Phone numbers properly formatted/validated
- [ ] **Duplicate Prevention**: Duplicate entries prevented
- [ ] **Data Integrity**: Relationships and constraints properly enforced

---

## 📞 CALLKIT INTEGRATION CHECKLIST

### ✅ Call Directory Extension
- [ ] **Extension Target**: Separate Call Directory Extension target created
- [ ] **Info.plist**: Extension properly configured in Info.plist
- [ ] **Handler Implementation**: CXCallDirectoryProvider properly implemented
- [ ] **Data Access**: Extension can access shared blocked numbers data
- [ ] **Incremental Updates**: Support for incremental blocking updates

### ✅ Extension Lifecycle
- [ ] **Request Handling**: beginRequest(with:) properly implemented
- [ ] **Error Management**: Errors properly handled and reported
- [ ] **Performance**: Extension performs efficiently with large datasets
- [ ] **Data Sorting**: Phone numbers sorted for CallKit requirements
- [ ] **Extension Reloading**: App can trigger extension reload

```swift
// ✅ GOOD: CallKit extension implementation
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
```

### ✅ User Experience
- [ ] **Permission Requests**: User prompted to enable Call Directory
- [ ] **Settings Access**: Deep link to Settings app for CallKit configuration
- [ ] **Status Feedback**: App shows current CallKit extension status
- [ ] **Manual Refresh**: User can manually refresh blocked numbers

---

## 🔒 SECURITY & PRIVACY CHECKLIST

### ✅ Data Protection
- [ ] **Keychain Storage**: Sensitive data stored in Keychain
- [ ] **App Groups**: Proper App Group configuration for data sharing
- [ ] **Data Encryption**: Core Data store encryption if required
- [ ] **Background Access**: Data access properly secured in background
- [ ] **Privacy Manifest**: Privacy manifest file created (iOS 17+)

### ✅ Permissions Management
- [ ] **Contacts Access**: Proper NSContactsUsageDescription
- [ ] **CallKit Usage**: Appropriate CallKit permission explanations
- [ ] **Permission Flow**: Graceful permission request flow
- [ ] **Denied Permissions**: Proper handling of denied permissions
- [ ] **Settings Deep Link**: Direct users to Settings for permissions

### ✅ Network Security
- [ ] **HTTPS Only**: All network requests use HTTPS
- [ ] **Certificate Pinning**: SSL certificate pinning if applicable
- [ ] **Data Transmission**: Minimal data sent over network
- [ ] **API Security**: Proper API authentication and rate limiting

---

## 🧪 TESTING CHECKLIST

### ✅ Unit Testing
- [ ] **ViewModel Tests**: All ViewModels have comprehensive unit tests
- [ ] **Service Tests**: Data services and business logic tested
- [ ] **Mock Dependencies**: Proper mocking of external dependencies
- [ ] **Async Testing**: Async/await operations properly tested
- [ ] **Edge Cases**: Error conditions and edge cases covered

### ✅ UI Testing
- [ ] **Critical Flows**: Main user flows covered by UI tests
- [ ] **Accessibility Testing**: VoiceOver and accessibility tested
- [ ] **Device Testing**: Tested on multiple device sizes
- [ ] **Performance Testing**: App launch time and responsiveness tested
- [ ] **Memory Testing**: Memory leaks and retain cycles checked

### ✅ Integration Testing
- [ ] **CallKit Integration**: Call blocking functionality tested
- [ ] **Core Data**: Data persistence and migration tested
- [ ] **Extension Communication**: App-Extension data sharing tested
- [ ] **Background Tasks**: Background processing tested

---

## 🚀 PERFORMANCE CHECKLIST

### ✅ SwiftUI Performance
- [ ] **View Updates**: Unnecessary view updates minimized
- [ ] **@Published Optimization**: Only necessary properties are @Published
- [ ] **List Performance**: Large lists use proper lazy loading
- [ ] **Image Loading**: Async image loading implemented
- [ ] **Animation Performance**: Smooth animations without jank

### ✅ Memory Management
- [ ] **Retain Cycles**: [weak self] used in closures where needed
- [ ] **Large Data Sets**: Efficient handling of large blocked number lists
- [ ] **Background Tasks**: Proper cleanup of background tasks
- [ ] **Image Caching**: Efficient image caching strategy
- [ ] **Core Data**: Proper Core Data memory management

### ✅ Launch Performance
- [ ] **App Launch Time**: Cold launch under 3 seconds
- [ ] **Splash Screen**: Proper launch screen configuration
- [ ] **Initial Data Load**: Efficient initial data loading strategy
- [ ] **Extension Launch**: Call Directory Extension launches quickly

---

## 📱 DEVICE COMPATIBILITY CHECKLIST

### ✅ iOS Version Support
- [ ] **Minimum iOS**: Clear minimum iOS version defined
- [ ] **Feature Availability**: iOS version-specific features properly gated
- [ ] **Deployment Testing**: Tested on minimum supported iOS version
- [ ] **API Availability**: @available annotations used where needed

### ✅ Device Support
- [ ] **iPhone Support**: All supported iPhone models tested
- [ ] **iPad Support**: iPad-specific layouts if supported
- [ ] **Simulator Testing**: Comprehensive simulator testing
- [ ] **Physical Device**: Testing on physical devices
- [ ] **Different Screen Sizes**: UI tested on various screen sizes

---

## 🌍 LOCALIZATION CHECKLIST

### ✅ String Management
- [ ] **Localizable.strings**: All user-facing strings externalized
- [ ] **String Keys**: Descriptive string keys used
- [ ] **Pluralization**: Plural strings properly handled
- [ ] **Context**: String context provided for translators
- [ ] **String Length**: UI handles varying string lengths

### ✅ Cultural Adaptation
- [ ] **Date Formatting**: Locale-appropriate date formatting
- [ ] **Number Formatting**: Locale-appropriate number formatting
- [ ] **Phone Number Format**: International phone number support
- [ ] **Right-to-Left**: RTL language support if required

---

## 📋 PRE-SUBMISSION CHECKLIST

### ✅ App Store Guidelines
- [ ] **Content Guidelines**: App content follows App Store guidelines
- [ ] **Privacy Policy**: Privacy policy created and linked
- [ ] **App Description**: Clear, accurate App Store description
- [ ] **Screenshots**: High-quality screenshots for all device sizes
- [ ] **App Icon**: Proper app icon for all required sizes

### ✅ Technical Requirements
- [ ] **Archive Build**: Release archive builds successfully
- [ ] **No Debug Code**: Debug code and print statements removed
- [ ] **Performance**: App meets performance requirements
- [ ] **Memory Usage**: Memory usage within acceptable limits
- [ ] **Battery Usage**: Minimal battery impact

### ✅ Final Testing
- [ ] **Fresh Install**: App tested on fresh device install
- [ ] **Update Testing**: Update flow tested if applicable
- [ ] **Edge Cases**: All edge cases and error conditions tested
- [ ] **Accessibility**: Full accessibility audit completed
- [ ] **Security Review**: Security best practices verified

---

## 🔍 CODE REVIEW CHECKLIST

### ✅ Code Quality
- [ ] **Swift Style Guide**: Code follows Swift style guidelines
- [ ] **Naming Conventions**: Clear, descriptive naming throughout
- [ ] **Comments**: Complex logic properly documented
- [ ] **TODOs**: All TODO comments resolved or tracked
- [ ] **Dead Code**: Unused code removed

### ✅ Syntax Validation ⚠️ NEW
- [ ] **Escape Characters**: No literal `\n`, `\t` characters in Swift code
- [ ] **Line Breaks**: Proper line breaks instead of escape sequences
- [ ] **Auto-Format**: Code formatted with Xcode auto-format (⌃I)
- [ ] **Build Test**: Code builds without syntax errors
- [ ] **Character Encoding**: All text uses proper UTF-8 encoding

**Common Syntax Issues to Check:**
```swift
// ❌ AVOID: Literal escape characters
.padding(.horizontal)\n
}\n

// ✅ GOOD: Proper line breaks
.padding(.horizontal)
}
```

### ✅ Architecture Review
- [ ] **MVVM Compliance**: Proper MVVM pattern implementation
- [ ] **Dependency Management**: Clean dependency injection
- [ ] **Protocol Usage**: Appropriate use of protocols
- [ ] **Extension Organization**: Swift extensions properly organized

### ✅ Performance Review
- [ ] **Async Implementation**: Proper async/await usage
- [ ] **Main Thread**: UI updates on main thread only
- [ ] **Background Work**: Heavy work on background threads
- [ ] **Memory Efficiency**: Efficient memory usage patterns

---

## 📚 DOCUMENTATION REQUIREMENTS

### ✅ Code Documentation
- [ ] **API Documentation**: Public APIs documented with ///
- [ ] **Complex Logic**: Complex algorithms explained
- [ ] **TODO Management**: TODOs properly tracked
- [ ] **Architecture Notes**: Major architectural decisions documented

### ✅ Project Documentation
- [ ] **README**: Comprehensive README.md file
- [ ] **Setup Guide**: Clear project setup instructions
- [ ] **API Reference**: API reference documentation
- [ ] **Feature Documentation**: Feature implementation details

---

**📋 SUMMARY**: This checklist ensures iOS SwiftUI apps meet Apple's standards, perform well, and provide excellent user experience. Check off each item during development and code review.

**🔄 UPDATES**: This checklist should be updated as iOS and SwiftUI evolve with new versions and best practices.

## 🔧 TROUBLESHOOTING
For common issues and crashes:
- [iOS Xcode Crash Troubleshooting Guide](ios-xcode-crash-troubleshooting.md) - Solutions for project file corruption, ID collisions, and build issues