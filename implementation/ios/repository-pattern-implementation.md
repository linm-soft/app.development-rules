# iOS Repository Pattern Implementation Guide

> Detailed implementation guide for Repository pattern in iOS with Core Data

---

## 📋 Overview

The Repository pattern abstracts data access logic and provides a clean interface for data operations. It acts as a mediator between the business logic and data sources.

**Benefits:**
- Testability (can mock repository)
- Separation of concerns
- Easier to swap data sources
- Reusable across multiple views
- Cleaner view models

---

## 🏗️ Basic Repository Pattern

### Protocol-Based Approach

```swift
// MARK: - Protocol Definition
protocol BlockedNumberRepository {
    func fetchAll() -> [BlockedNumber]
    func fetchAllPublisher() -> AnyPublisher<[BlockedNumber], Never>
    func add(_ number: BlockedNumber) throws
    func update(_ number: BlockedNumber) throws
    func delete(_ number: BlockedNumber) throws
    func search(_ query: String) -> [BlockedNumber]
    func deleteAll() throws
}

// MARK: - Implementation with Core Data
class BlockedNumberRepositoryImpl: BlockedNumberRepository {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
    
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    // MARK: - Fetch Operations
    func fetchAll() -> [BlockedNumber] {
        let request = NSFetchRequest<BlockedNumber>(entityName: "BlockedNumber")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \BlockedNumber.dateAdded, ascending: false)
        ]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching blocked numbers: \(error)")
            return []
        }
    }
    
    func fetchAllPublisher() -> AnyPublisher<[BlockedNumber], Never> {
        // Using @FetchRequest in SwiftUI is more idiomatic,
        // but this example shows how to expose as publisher
        Future { promise in
            let numbers = self.fetchAll()
            promise(.success(numbers))
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Add Operation
    func add(_ number: BlockedNumber) throws {
        viewContext.insert(number)
        try save()
    }
    
    // MARK: - Update Operation
    func update(_ number: BlockedNumber) throws {
        // Core Data auto-tracks changes if object is in context
        try save()
    }
    
    // MARK: - Delete Operation
    func delete(_ number: BlockedNumber) throws {
        viewContext.delete(number)
        try save()
    }
    
    // MARK: - Search Operation
    func search(_ query: String) -> [BlockedNumber] {
        let request = NSFetchRequest<BlockedNumber>(entityName: "BlockedNumber")
        request.predicate = NSPredicate(
            format: "phoneNumber CONTAINS[cd] %@ OR reason CONTAINS[cd] %@",
            query, query
        )
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \BlockedNumber.dateAdded, ascending: false)
        ]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error searching: \(error)")
            return []
        }
    }
    
    // MARK: - Delete All Operation
    func deleteAll() throws {
        let request = NSFetchRequest<NSFetchRequestExpression>(entityName: "BlockedNumber")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try viewContext.execute(deleteRequest)
        try save()
    }
    
    // MARK: - Private Methods
    private func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
}
```

---

## 💻 Real-World Example: SmartCallBlock Repository

```swift
protocol CallHistoryRepository {
    func fetchAll() -> [CallHistory]
    func fetchBlocked() -> [CallHistory]
    func add(_ call: CallHistory) throws
    func delete(_ call: CallHistory) throws
    func deleteAll() throws
    func getStatistics() -> CallStatistics
}

class CallHistoryRepositoryImpl: CallHistoryRepository {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
    
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    // MARK: - Fetch All Calls
    func fetchAll() -> [CallHistory] {
        let request = NSFetchRequest<CallHistory>(entityName: "CallHistory")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CallHistory.callDate, ascending: false)
        ]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching call history: \(error)")
            return []
        }
    }
    
    // MARK: - Fetch Blocked Calls
    func fetchBlocked() -> [CallHistory] {
        let request = NSFetchRequest<CallHistory>(entityName: "CallHistory")
        request.predicate = NSPredicate(format: "wasBlocked == true")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CallHistory.callDate, ascending: false)
        ]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching blocked calls: \(error)")
            return []
        }
    }
    
    // MARK: - Add Call
    func add(_ call: CallHistory) throws {
        viewContext.insert(call)
        try save()
    }
    
    // MARK: - Delete Call
    func delete(_ call: CallHistory) throws {
        viewContext.delete(call)
        try save()
    }
    
    // MARK: - Delete All Calls
    func deleteAll() throws {
        let request = NSFetchRequest<NSFetchRequestExpression>(entityName: "CallHistory")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try viewContext.execute(deleteRequest)
        try save()
    }
    
    // MARK: - Statistics
    func getStatistics() -> CallStatistics {
        let allCalls = fetchAll()
        let blockedCalls = fetchBlocked()
        
        let totalDuration = allCalls.reduce(0) { $0 + $1.callDuration }
        
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayBlocked = blockedCalls.filter { call in
            guard let date = call.callDate else { return false }
            return date >= todayStart
        }
        
        return CallStatistics(
            totalCalls: allCalls.count,
            totalBlocked: blockedCalls.count,
            todayBlocked: todayBlocked.count,
            totalDuration: totalDuration
        )
    }
    
    private func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
}

struct CallStatistics {
    let totalCalls: Int
    let totalBlocked: Int
    let todayBlocked: Int
    let totalDuration: Int32
}
```

---

## 🎯 Usage in Views & ViewModels

### In SwiftUI View

```swift
struct BlockedNumbersListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BlockedNumber.dateAdded, ascending: false)],
        animation: .default
    )
    private var blockedNumbers: FetchedResults<BlockedNumber>
    
    @State private var repository: BlockedNumberRepository = BlockedNumberRepositoryImpl()
    
    var body: some View {
        List {
            ForEach(blockedNumbers, id: \.objectID) { number in
                BlockedNumberRow(number: number)
            }
            .onDelete { offsets in
                deleteNumbers(at: offsets)
            }
        }
    }
    
    private func deleteNumbers(at offsets: IndexSet) {
        for index in offsets {
            let number = blockedNumbers[index]
            do {
                try repository.delete(number)
            } catch {
                print("Error deleting: \(error)")
            }
        }
    }
}
```

### In ViewModel Pattern

```swift
class BlockedNumbersViewModel: ObservableObject {
    @Published var blockedNumbers: [BlockedNumber] = []
    @Published var errorMessage: String?
    
    let repository: BlockedNumberRepository
    
    init(repository: BlockedNumberRepository = BlockedNumberRepositoryImpl()) {
        self.repository = repository
        loadNumbers()
    }
    
    func loadNumbers() {
        blockedNumbers = repository.fetchAll()
    }
    
    func deleteNumber(_ number: BlockedNumber) {
        do {
            try repository.delete(number)
            loadNumbers()
        } catch {
            errorMessage = "Failed to delete: \(error.localizedDescription)"
        }
    }
    
    func searchNumbers(_ query: String) -> [BlockedNumber] {
        repository.search(query)
    }
}
```

---

## 🧪 Testing with Mock Repository

### Mock Implementation

```swift
class MockBlockedNumberRepository: BlockedNumberRepository {
    var mockNumbers: [BlockedNumber] = []
    var shouldThrowError = false
    
    func fetchAll() -> [BlockedNumber] {
        mockNumbers
    }
    
    func fetchAllPublisher() -> AnyPublisher<[BlockedNumber], Never> {
        Just(mockNumbers).eraseToAnyPublisher()
    }
    
    func add(_ number: BlockedNumber) throws {
        if shouldThrowError {
            throw NSError(domain: "Mock", code: -1)
        }
        mockNumbers.append(number)
    }
    
    func update(_ number: BlockedNumber) throws {
        if shouldThrowError {
            throw NSError(domain: "Mock", code: -1)
        }
    }
    
    func delete(_ number: BlockedNumber) throws {
        if shouldThrowError {
            throw NSError(domain: "Mock", code: -1)
        }
        mockNumbers.removeAll { $0.objectID == number.objectID }
    }
    
    func search(_ query: String) -> [BlockedNumber] {
        mockNumbers.filter {
            ($0.phoneNumber?.contains(query) ?? false) ||
            ($0.reason?.contains(query) ?? false)
        }
    }
    
    func deleteAll() throws {
        mockNumbers.removeAll()
    }
}

// Usage in Tests
class BlockedNumbersViewModelTests: XCTestCase {
    func testDeleteNumber() {
        let mockRepo = MockBlockedNumberRepository()
        let viewModel = BlockedNumbersViewModel(repository: mockRepo)
        
        // Setup mock data
        let number = BlockedNumber(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        mockRepo.mockNumbers = [number]
        
        // Test delete
        viewModel.deleteNumber(number)
        
        XCTAssertTrue(mockRepo.mockNumbers.isEmpty)
    }
}
```

---

## ⚠️ Error Handling Patterns

### Comprehensive Error Handling

```swift
enum RepositoryError: Error {
    case fetchFailed(Error)
    case saveFailed(Error)
    case deleteFailed(Error)
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .fetchFailed(let error):
            return "Failed to fetch data: \(error.localizedDescription)"
        case .saveFailed(let error):
            return "Failed to save data: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Failed to delete data: \(error.localizedDescription)"
        case .invalidData:
            return "Invalid data format"
        }
    }
}

// Usage
func add(_ number: BlockedNumber) throws {
    do {
        viewContext.insert(number)
        try save()
    } catch {
        throw RepositoryError.saveFailed(error)
    }
}
```

---

## 📚 Related Files

- **Pattern Overview**: [app-rules.md - Repository Pattern](../../app-rules.md#-repository-pattern-for-data-access)
- **Real Example**: [SmartCallBlock Implementation](../ios/smartcallblock-dialog-example.md)
- **Singleton Pattern**: [singleton-pattern-implementation.md](./singleton-pattern-implementation.md)

---

## ✅ Checklist for Repository Implementation

- [ ] Protocol defines all data operations
- [ ] Implementation uses Core Data/Room
- [ ] Error handling with custom error types
- [ ] Mock repository for testing
- [ ] Proper context management
- [ ] Thread-safe operations
- [ ] Documentation for all methods
- [ ] Unit tests with mock repository
- [ ] Integration tests with real data
- [ ] Performance optimized (proper indexes, batch operations)
