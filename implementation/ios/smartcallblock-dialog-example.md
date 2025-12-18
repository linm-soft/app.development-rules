# SmartCallBlock Dialog Implementation Example

## Real-World Usage: Delete Blocked Numbers

### 1. BlockedNumbersListView - Apply Overlay

```swift
import SwiftUI
import CoreData

struct BlockedNumbersListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: BlockedNumber.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BlockedNumber.dateAdded, ascending: false)]
    ) var blockedNumbers: FetchedResults<BlockedNumber>
    
    @State private var selectedNumbers = Set<String>()
    @State private var showDeleteMenu = false
    
    var body: some View {
        VStack {
            List(selection: $selectedNumbers) {
                ForEach(blockedNumbers, id: \.id) { number in
                    HStack {
                        Text(number.phoneNumber ?? "Unknown")
                        Spacer()
                        if let reason = number.blockReason {
                            Text(reason)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Delete button
            if !selectedNumbers.isEmpty {
                Button(action: {
                    showDeleteMenu = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete \(selectedNumbers.count)")
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()
                }
            }
        }
        // ✅ CRITICAL: Apply overlay to show dialogs
        .overlay(CommonDialogOverlay())
        .navigationTitle("Blocked Numbers")
    }
    
    // MARK: - Delete Flow with Dialog
    func deleteNumbers() {
        let idsToDelete = Array(selectedNumbers)
        let count = idsToDelete.count
        
        // Step 1: Show confirmation dialog
        DialogManager.shared.showConfirm(
            title: "Delete \(count) Number\(count > 1 ? "s" : "")?",
            message: "Blocked numbers will be permanently deleted. This action cannot be undone.",
            primaryTitle: "Delete",
            secondaryTitle: "Cancel",
            onConfirm: {
                // Step 2: Perform delete (after dialog is dismissed)
                performDeleteAndShowResult(idsToDelete)
            },
            onCancel: {
                // User cancelled - dialog closes automatically
            }
        )
    }
    
    private func performDeleteAndShowResult(_ ids: [String]) {
        // Delete from Core Data
        for id in ids {
            if let numberToDelete = blockedNumbers.first(where: { $0.id == id }) {
                moc.delete(numberToDelete)
            }
        }
        
        do {
            try moc.save()
            
            // Step 3: Show success dialog
            DialogManager.shared.showSuccess(
                title: "Success",
                message: "\(ids.count) number(s) deleted successfully",
                completion: {
                    // Step 4: Clear UI state (after success dialog is dismissed)
                    DispatchQueue.main.async {
                        selectedNumbers.removeAll()
                        showDeleteMenu = false
                    }
                }
            )
        } catch {
            // Step 3 (Error): Show error dialog
            DialogManager.shared.showError(
                title: "Delete Failed",
                message: error.localizedDescription,
                completion: {
                    // Reset state but keep selection for retry
                }
            )
        }
    }
}
```

## Example 2: Edit Number with Validation Dialog

```swift
struct EditNumberView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var blockedNumber: BlockedNumber
    @State private var phoneNumber: String = ""
    @State private var blockReason: String = ""
    
    var body: some View {
        Form {
            Section("Phone Number") {
                TextField("Enter number", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }
            
            Section("Block Reason") {
                Picker("Reason", selection: $blockReason) {
                    Text("Spam").tag("Spam")
                    Text("Telemarketer").tag("Telemarketer")
                    Text("Personal").tag("Personal")
                }
            }
            
            Button("Save Changes") {
                validateAndSave()
            }
        }
        // ✅ Apply overlay for validation dialogs
        .overlay(CommonDialogOverlay())
        .navigationTitle("Edit Number")
    }
    
    func validateAndSave() {
        // Validation
        guard !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            DialogManager.shared.showError(
                title: "Validation Error",
                message: "Phone number cannot be empty"
            )
            return
        }
        
        // Check for duplicates
        if phoneNumber != blockedNumber.phoneNumber {
            // Could be duplicate check here
            DialogManager.shared.showWarning(
                title: "Warning",
                message: "This number is already blocked",
                completion: {
                    // Could allow override
                }
            )
            return
        }
        
        // Save to Core Data
        blockedNumber.phoneNumber = phoneNumber
        blockedNumber.blockReason = blockReason
        blockedNumber.dateModified = Date()
        
        do {
            try moc.save()
            
            DialogManager.shared.showSuccess(
                message: "Changes saved successfully",
                completion: {
                    dismiss()
                }
            )
        } catch {
            DialogManager.shared.showError(
                message: "Failed to save changes: \(error.localizedDescription)"
            )
        }
    }
}
```

## Example 3: Settings Reset Confirmation

```swift
struct SettingsView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showResetMenu = false
    
    var body: some View {
        Form {
            Section("Database") {
                Button(role: .destructive, action: {
                    showResetMenu = true
                }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                        Text("Reset All Data")
                    }
                }
            }
        }
        .overlay(CommonDialogOverlay())
        .navigationTitle("Settings")
    }
    
    func resetAllData() {
        // Show warning dialog
        DialogManager.shared.showConfirm(
            title: "Reset All Data?",
            message: "All blocked numbers, call history, and settings will be permanently deleted. This cannot be undone.",
            primaryTitle: "Reset",
            secondaryTitle: "Cancel",
            onConfirm: {
                performReset()
            }
        )
    }
    
    private func performReset() {
        let fetchRequest = NSFetchRequest<NSFetchRequestExpression>(entityName: "BlockedNumber")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try moc.execute(deleteRequest)
            try moc.save()
            
            DialogManager.shared.showSuccess(
                message: "All data has been reset",
                completion: {
                    // Return to home
                }
            )
        } catch {
            DialogManager.shared.showError(
                message: "Reset failed: \(error.localizedDescription)"
            )
        }
    }
}
```

## Dialog Flow Patterns

### Pattern 1: Simple Confirmation → Delete → Success
```
User taps Delete
  ↓
showConfirm() → Dialog appears
  ↓
User taps "Delete" button
  ↓
Dialog dismisses automatically
  ↓
performDelete() executes
  ↓
showSuccess() → New dialog appears
  ↓
User taps "OK"
  ↓
Dialog dismisses, completion block runs
  ↓
UI updates (clear selection, hide menu, etc.)
```

### Pattern 2: Validation Error → User Fixes → Retry
```
User saves invalid input
  ↓
showError() → Dialog appears
  ↓
User reads error, taps "OK"
  ↓
Dialog dismisses
  ↓
User fixes input and retries
  ↓
Save succeeds
```

### Pattern 3: Destructive Action with Multiple Confirmations
```
User chooses destructive action (Reset All)
  ↓
showConfirm() with warning message
  ↓
User confirms they understand
  ↓
showSuccess() confirms completion
  ↓
Return to safe state
```

## Common Mistakes to Avoid

### ❌ Wrong: Not adding overlay
```swift
var body: some View {
    VStack { /* content */ }
    // Missing: .overlay(CommonDialogOverlay())
}
```

### ❌ Wrong: Updating UI before dialog completes
```swift
func delete() {
    DialogManager.shared.showConfirm(
        title: "Delete?",
        message: "Are you sure?",
        onConfirm: {
            performDelete()
        }
    )
    
    // ❌ This runs before dialog is dismissed
    selectedNumbers.removeAll()
}
```

### ✅ Correct: Use completion closures
```swift
func delete() {
    DialogManager.shared.showConfirm(
        title: "Delete?",
        message: "Are you sure?",
        onConfirm: {
            performDelete()
            // Dialog dismisses
            // Then show success
            DialogManager.shared.showSuccess(
                message: "Deleted",
                completion: {
                    // ✅ This runs after success dialog is dismissed
                    DispatchQueue.main.async {
                        selectedNumbers.removeAll()
                    }
                }
            )
        }
    )
}
```

## Testing Dialogs in Preview

```swift
#Preview {
    BlockedNumbersListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .onAppear {
            // Show dialog in preview
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                DialogManager.shared.showSuccess(message: "Preview Dialog")
            }
        }
}
```
