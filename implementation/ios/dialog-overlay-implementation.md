# iOS Dialog/Overlay Implementation Guide

## Overview
Complete implementation patterns for iOS dialog and overlay system using SwiftUI with CoreData integration.

## DialogManager Singleton

```swift
import Foundation
import SwiftUI

// MARK: - Dialog Data Model
struct DialogConfig {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    let primaryAction: (() -> Void)?
    let secondaryAction: (() -> Void)?
    let dialogType: DialogType
    
    enum DialogType {
        case confirmation
        case success
        case error
        case warning
    }
}

// MARK: - DialogManager Observable Object
class DialogManager: ObservableObject {
    static let shared = DialogManager()
    
    @Published var isPresented = false
    @Published var currentDialog: DialogConfig?
    
    private init() {}
    
    func showConfirm(
        title: String,
        message: String,
        primaryTitle: String = "Confirm",
        secondaryTitle: String = "Cancel",
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        currentDialog = DialogConfig(
            title: title,
            message: message,
            primaryButtonTitle: primaryTitle,
            secondaryButtonTitle: secondaryTitle,
            primaryAction: onConfirm,
            secondaryAction: onCancel,
            dialogType: .confirmation
        )
        isPresented = true
    }
    
    func showSuccess(
        title: String = "Success",
        message: String,
        completion: @escaping () -> Void = {}
    ) {
        currentDialog = DialogConfig(
            title: title,
            message: message,
            primaryButtonTitle: "OK",
            secondaryButtonTitle: nil,
            primaryAction: completion,
            secondaryAction: nil,
            dialogType: .success
        )
        isPresented = true
    }
    
    func showError(
        title: String = "Error",
        message: String,
        completion: @escaping () -> Void = {}
    ) {
        currentDialog = DialogConfig(
            title: title,
            message: message,
            primaryButtonTitle: "OK",
            secondaryButtonTitle: nil,
            primaryAction: completion,
            secondaryAction: nil,
            dialogType: .error
        )
        isPresented = true
    }
    
    func dismiss() {
        isPresented = false
        // Small delay to allow animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.currentDialog = nil
        }
    }
}
```

## CommonDialogOverlay View

```swift
import SwiftUI

struct CommonDialogOverlay: View {
    @ObservedObject private var dialogManager = DialogManager.shared
    @State private var shouldClose = false
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            if dialogManager.isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dialogManager.dismiss()
                    }
            }
            
            // Dialog content
            if dialogManager.isPresented, let dialog = dialogManager.currentDialog {
                VStack(spacing: 16) {
                    // Title
                    Text(dialog.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Message
                    Text(dialog.message)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Divider()
                    
                    // Buttons
                    HStack(spacing: 12) {
                        // Secondary button (if exists)
                        if let secondaryTitle = dialog.secondaryButtonTitle {
                            Button(action: {
                                dialog.secondaryAction?()
                                dialogManager.dismiss()
                            }) {
                                Text(secondaryTitle)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        // Primary button
                        Button(action: {
                            dialog.primaryAction?()
                            dialogManager.dismiss()
                        }) {
                            Text(dialog.primaryButtonTitle)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundColor(.white)
                                .background(dialogTypeColor(dialog.dialogType))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(20)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 8)
                .padding(20)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private func dialogTypeColor(_ type: DialogConfig.DialogType) -> Color {
        switch type {
        case .confirmation:
            return .blue
        case .success:
            return .green
        case .error:
            return .red
        case .warning:
            return .orange
        }
    }
}
```

## Critical Rules

### 1. Never Use @StateObject for CommonDialogOverlay
❌ **Wrong:**
```swift
@StateObject private var dialogManager = DialogManager()
```

✅ **Correct:**
```swift
@ObservedObject private var dialogManager = DialogManager.shared
```

**Reason:** DialogManager is a singleton - we observe the shared instance, never own it.

### 2. Apply Overlay in Feature Views, Not App Root
❌ **Wrong:**
```swift
// SmartCallBlockApp.swift
var body: some Scene {
    WindowGroup {
        ContentView()
            .overlay(CommonDialogOverlay()) // ❌ Compilation error
    }
}
```

✅ **Correct:**
```swift
// BlockedNumbersListView.swift
var body: some View {
    VStack {
        // View content
    }
    .overlay(CommonDialogOverlay()) // ✅ Works
}
```

**Reason:** Swift compilation order prevents app root from seeing DialogManager/CommonDialogOverlay. Apply overlays in feature views where dialogs are actually shown.

### 3. Centralize Dismissal Through DialogManager
✅ **Correct Pattern:**
```swift
DialogManager.shared.showConfirm(
    title: "Delete Numbers?",
    message: "This action cannot be undone.",
    primaryTitle: "Delete",
    onConfirm: {
        // Perform action
        self.deleteNumbers()
    },
    onCancel: {
        // Optional: Handle cancel
    }
)

// All dismissals go through DialogManager.dismiss()
// triggered by overlay button tap
```

### 4. Wait for Dialog to Dismiss Before UI Updates
✅ **Correct Pattern:**
```swift
func deleteNumbers() {
    let idsToDelete = selectedNumbers.map { $0.id }
    
    DialogManager.shared.showConfirm(
        title: "Delete \(idsToDelete.count) number(s)?",
        message: "Blocked numbers will be permanently deleted.",
        primaryTitle: "Delete",
        onConfirm: {
            // DialogManager.dismiss() is called after this closure
            // Then show success dialog
            self.performDelete(idsToDelete)
            DialogManager.shared.showSuccess(
                message: "Numbers deleted successfully",
                completion: {
                    DispatchQueue.main.async {
                        self.selectedNumbers.removeAll()
                        self.showDeleteMenu = false
                    }
                }
            )
        }
    )
}
```

## Troubleshooting

### "cannot find 'DialogManager' in scope"
- **Cause:** Trying to reference DialogManager at app root
- **Solution:** Use `.overlay(CommonDialogOverlay())` in feature views instead

### Dialog doesn't appear
- **Cause 1:** Missing `.overlay(CommonDialogOverlay())` modifier
- **Solution:** Add overlay to the view that needs dialogs
- **Cause 2:** Wrong DialogManager instance
- **Solution:** Always use `DialogManager.shared`

### Dialog appears but buttons don't respond
- **Cause:** Using `@StateObject` with DialogManager
- **Solution:** Change to `@ObservedObject private var dialogManager = DialogManager.shared`

### Dialog doesn't dismiss
- **Cause:** Not calling `DialogManager.shared.dismiss()` in button actions
- **Solution:** CommonDialogOverlay buttons automatically call `dismiss()` after action

