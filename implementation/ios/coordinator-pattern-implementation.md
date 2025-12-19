# iOS Coordinator Pattern Implementation Guide

> Detailed implementation guide for Coordinator pattern in iOS for navigation management

---

## 📋 Overview

The Coordinator pattern centralizes navigation logic and manages app flow. Instead of views pushing other views, a coordinator handles all navigation decisions.

**Benefits:**
- Centralized navigation logic
- Easier to test navigation flows
- Reusable coordinators
- Clear app architecture
- Handles deep linking easily

---

## 🏗️ Basic Coordinator Pattern

### Protocol Definition

```swift
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
```

### AppCoordinator Implementation

```swift
class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTabBar()
    }
    
    // MARK: - Navigation Methods
    private func showTabBar() {
        let tabCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}
```

### TabBarCoordinator

```swift
class TabBarCoordinator: NSObject, Coordinator, UITabBarControllerDelegate {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        
        // Create coordinators for each tab
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        let settingsCoordinator = SettingsCoordinator(navigationController: UINavigationController())
        let historyCoordinator = HistoryCoordinator(navigationController: UINavigationController())
        
        homeCoordinator.start()
        settingsCoordinator.start()
        historyCoordinator.start()
        
        childCoordinators = [homeCoordinator, settingsCoordinator, historyCoordinator]
        
        // Setup tab bar
        tabBarController.viewControllers = [
            homeCoordinator.navigationController,
            settingsCoordinator.navigationController,
            historyCoordinator.navigationController
        ]
        
        self.tabBarController = tabBarController
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
```

---

## 💻 Real-World Example: SmartCallBlock Navigation

### BlockedNumbersCoordinator

```swift
class BlockedNumbersCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let blockedNumbersViewController = BlockedNumbersListViewController()
        blockedNumbersViewController.coordinator = self
        navigationController.setViewControllers([blockedNumbersViewController], animated: false)
    }
    
    func showAddNumber() {
        let addNumberViewController = AddNumberViewController()
        addNumberViewController.coordinator = self
        navigationController.present(addNumberViewController, animated: true)
    }
    
    func showEditNumber(_ number: BlockedNumber) {
        let editViewController = EditNumberViewController(number: number)
        editViewController.coordinator = self
        navigationController.present(editViewController, animated: true)
    }
    
    func showDetails(for number: BlockedNumber) {
        let detailViewController = NumberDetailViewController(number: number)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
```

### In SwiftUI with NavigationStack

```swift
protocol SwiftUICoordinator {
    associatedtype Root: View
    
    @ViewBuilder var root: Root { get }
    func navigate(to destination: String)
}

class BlockedNumbersSwiftUICoordinator: ObservableObject, SwiftUICoordinator {
    @Published var navigationPath = NavigationPath()
    @Published var selectedNumber: BlockedNumber?
    @Published var showAddSheet = false
    
    @ViewBuilder
    var root: some View {
        NavigationStack(path: $navigationPath) {
            BlockedNumbersListView(coordinator: self)
                .navigationDestination(for: BlockedNumber.self) { number in
                    NumberDetailView(number: number, coordinator: self)
                }
        }
    }
    
    func navigate(to destination: String) {
        switch destination {
        case "add":
            showAddSheet = true
        case "back":
            navigationPath.removeLast()
        default:
            break
        }
    }
    
    func showDetails(for number: BlockedNumber) {
        navigationPath.append(number)
    }
    
    func dismiss() {
        navigationPath.removeLast()
    }
}
```

---

## 🎯 Usage in ViewControllers

### ViewController with Coordinator

```swift
class BlockedNumbersListViewController: UIViewController {
    weak var coordinator: BlockedNumbersCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
    }
    
    @objc
    private func addTapped() {
        coordinator?.showAddNumber()
    }
    
    func didSelectNumber(_ number: BlockedNumber) {
        coordinator?.showDetails(for: number)
    }
}
```

### SwiftUI View with Coordinator

```swift
struct BlockedNumbersListView: View {
    @ObservedObject var coordinator: BlockedNumbersSwiftUICoordinator
    @State private var numbers: [BlockedNumber] = []
    
    var body: some View {
        VStack {
            List(numbers, id: \.objectID) { number in
                NavigationLink(value: number) {
                    Text(number.phoneNumber ?? "Unknown")
                }
            }
            
            Toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { coordinator.showAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $coordinator.showAddSheet) {
            AddNumberView(isPresented: $coordinator.showAddSheet)
        }
    }
}
```

---

## 🌐 Deep Linking Support

### Deep Link Handling in Coordinator

```swift
class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTabBar()
    }
    
    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }
        
        switch components.host {
        case "blockedNumbers":
            handleBlockedNumbersDeepLink(components)
        case "settings":
            handleSettingsDeepLink(components)
        default:
            break
        }
    }
    
    private func handleBlockedNumbersDeepLink(_ components: URLComponents) {
        // Navigate to blocked numbers
        if let tabController = navigationController.viewControllers.first as? UITabBarController {
            tabController.selectedIndex = 0
        }
    }
    
    private func handleSettingsDeepLink(_ components: URLComponents) {
        // Navigate to settings
        if let tabController = navigationController.viewControllers.first as? UITabBarController {
            tabController.selectedIndex = 2
        }
    }
}

// Usage in SceneDelegate
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    for context in URLContexts {
        let url = context.url
        appCoordinator?.handleDeepLink(url)
    }
}
```

---

## 🧪 Testing Coordinators

### Mock Coordinator for Testing

```swift
class MockBlockedNumbersCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()
    
    var addNumberCalled = false
    var showDetailsCalled = false
    var selectedNumber: BlockedNumber?
    
    func start() {}
    
    func showAddNumber() {
        addNumberCalled = true
    }
    
    func showDetails(for number: BlockedNumber) {
        showDetailsCalled = true
        selectedNumber = number
    }
}

// Test Example
class BlockedNumbersViewControllerTests: XCTestCase {
    func testAddButtonTriggersCoordinator() {
        let coordinator = MockBlockedNumbersCoordinator()
        let viewController = BlockedNumbersListViewController()
        viewController.coordinator = coordinator
        
        viewController.addTapped()
        
        XCTAssertTrue(coordinator.addNumberCalled)
    }
}
```

---

## ⚠️ Memory Management

### Preventing Retain Cycles

```swift
class BlockedNumbersCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    func start() {
        let viewController = BlockedNumbersViewController()
        
        // Use weak reference to avoid retain cycle
        viewController.onAddTapped = { [weak self] in
            self?.showAddNumber()
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}
```

---

## 📚 Related Files

- **Pattern Overview**: [app-rules.md - Coordinator Pattern](../../app-rules.md#-coordinator-pattern-for-navigation)
- **Real Example**: [SmartCallBlock Architecture](../ios/smartcallblock-dialog-example.md)
- **Singleton Pattern**: [singleton-pattern-implementation.md](./singleton-pattern-implementation.md)

---

## ✅ Checklist for Coordinator Implementation

- [ ] Base Coordinator protocol defined
- [ ] AppCoordinator created for root navigation
- [ ] Child coordinators for feature screens
- [ ] ViewControllers/Views have weak coordinator reference
- [ ] No strong reference cycles
- [ ] Navigation methods clearly named
- [ ] Deep linking support implemented
- [ ] Unit tests with mock coordinators
- [ ] Error handling for navigation
- [ ] Memory managed properly (childCoordinators cleanup)
