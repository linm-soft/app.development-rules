# iOS File Management - Quick Reference Card
**Date**: December 19, 2025

---

## 🚀 Quick Start: Adding New iOS File

### In 3 Steps

**Step 1: Create File**
```swift
// MyNewView.swift
import SwiftUI

struct MyNewView: View {
    var body: some View {
        Text("Hello")
    }
}
```

**Step 2: Add to Xcode**
- Open `SmartCallBlock.xcodeproj` in Xcode
- Right-click `SmartCallBlock` folder
- Select "Add Files to SmartCallBlock"
- Choose your `.swift` file
- ✅ Check "Copy items if needed"
- ✅ Check "Create groups"
- Click "Add"

**Step 3: Verify**
```bash
cd /Users/mac/Project/Source/Mobile/smart-call-block/IOS
xcodebuild -project SmartCallBlock.xcodeproj clean build
```

---

## 📁 File Location Cheat Sheet

```
📍 UI View/Screen
   → SmartCallBlock/[ViewName].swift
   Example: BlockedNumbersListView.swift

📍 UI Component
   → SmartCallBlock/components/[ComponentName].swift
   Example: components/StatCard.swift

📍 Service/Manager
   → SmartCallBlock/services/[ServiceName].swift
   Example: services/CallBlockManager.swift

📍 Data Model
   → SmartCallBlock/models/[ModelName]+Extension.swift
   Example: models/BlockedNumber+Extension.swift

📍 Utility Function
   → SmartCallBlock/utils/[UtilityName].swift
   Example: utils/DateFormatter.swift

📍 Manager/Handler
   → SmartCallBlock/managers/[ManagerName].swift
   Example: managers/SubscriptionManager.swift
```

---

## ✅ File Template Checklist

### Every New File Should Have

```swift
//
//  FileName.swift              // 👈 File name
//  SmartCallBlock              // 👈 Project name
//
//  Created on 12/19/2025.      // 👈 Creation date
//

import SwiftUI                  // 👈 Required imports
import CoreData

struct ViewName: View {         // 👈 Proper naming
    // Code here
}

#Preview {                      // 👈 SwiftUI preview
    ViewName()
}
```

---

## ⚙️ Common Build Issues & Fixes

### ❌ "File not found"
```bash
# Check file in project
grep -q "FileName.swift" SmartCallBlock.xcodeproj/project.pbxproj
# If not found: Add via Xcode GUI (see Step 2 above)
```

### ❌ "Module not found"
```bash
# Verify imports are correct
# Check: Is it Swift, not Objective-C?
# Solution: Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData/*
xcodebuild clean build
```

### ❌ Xcode Crash
```bash
# Reset Derived Data
rm -rf ~/Library/Developer/Xcode/DerivedData/SmartCallBlock*

# Restart Xcode
killall Xcode
open SmartCallBlock.xcodeproj
```

---

## 🔄 Automated Sync (Optional)

If creating files programmatically:

```bash
#!/bin/bash
# auto_add_ios_file.sh

FILE=$1
cp "$FILE" /Users/mac/Project/Source/Mobile/smart-call-block/IOS/SmartCallBlock/
cd /Users/mac/Project/Source/Mobile/smart-call-block/IOS
xcodebuild clean build
echo "✅ File added and verified!"
```

Usage:
```bash
./auto_add_ios_file.sh MyNewView.swift
```

---

## 📋 Verification Commands

```bash
# List all Swift files in project
find SmartCallBlock -name "*.swift" | sort

# Verify file in project.pbxproj
grep "BlockedCallsChartView.swift" SmartCallBlock.xcodeproj/project.pbxproj

# Count total Swift files
find SmartCallBlock -name "*.swift" | wc -l

# Build and test
xcodebuild -project SmartCallBlock.xcodeproj \
  -scheme SmartCallBlock \
  clean build
```

---

## 🎯 File Categories

| Type | Location | Example |
|------|----------|---------|
| **Main Views** | SmartCallBlock/ | ContentView.swift |
| **UI Components** | SmartCallBlock/components/ | StatCard.swift |
| **Feature Views** | SmartCallBlock/views/ | SettingsView.swift |
| **Services** | SmartCallBlock/services/ | CallBlockManager.swift |
| **Models** | SmartCallBlock/models/ | BlockedNumber+Properties.swift |
| **Utilities** | SmartCallBlock/utils/ | DateUtils.swift |
| **Managers** | SmartCallBlock/managers/ | SubscriptionManager.swift |

---

## 🔗 Full Documentation

For detailed information, see:
- **[ios-file-management-guide.md](ios-file-management-guide.md)** - Complete guide
- **[app-rules.md](app-rules.md)** - General app development rules
- **[ios-project-rules.md](platform-rules/ios-project-rules.md)** - iOS-specific rules

---

## 🆘 Need Help?

1. **Build failing?** → Check [ios-file-management-guide.md#troubleshooting](ios-file-management-guide.md#troubleshooting)
2. **Wrong folder?** → See [File Location Cheat Sheet](#file-location-cheat-sheet)
3. **Template help?** → Check [ios-file-management-guide.md#file-categories--templates](ios-file-management-guide.md#file-categories--templates)

---

**Reference Card** | December 19, 2025
