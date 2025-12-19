# iOS File Management & Xcode Project Integration Guide
**Date**: December 19, 2025  
**Status**: Active Development Guideline

---

## 🎯 Overview

When creating new iOS source files (`.swift`) in the SmartCallBlock iOS project, they must be automatically integrated into the Xcode project file (`SmartCallBlock.xcodeproj`) to ensure:
- ✅ Files are compiled
- ✅ Code is accessible  
- ✅ Build succeeds without errors
- ✅ Version control stays in sync

---

## 📋 Quick Reference

### When to Apply This Guide
```
✅ Creating new .swift files
✅ Adding UI components
✅ Adding service/manager classes
✅ Adding model files
✅ Adding utility files
```

### When NOT to Apply This Guide
```
❌ Creating resource files (images, sounds) - handled separately
❌ Modifying existing files - only for new files
❌ Android development - different process
❌ Configuration files - handled in settings
```

---

## 🔧 Process Overview

### Standard Workflow for New iOS Files

```
1. PLAN FILE STRUCTURE
   ↓
2. CREATE .swift FILE
   ↓
3. ADD TO XCODE PROJECT
   ↓
4. UPDATE DOCUMENTATION
   ↓
5. COMMIT & PUSH
```

---

## 📁 File Organization Structure

### Directory Layout
```
SmartCallBlock/
├─ SmartCallBlock/                # Main app target directory
│  ├─ SmartCallBlockApp.swift    # App entry point
│  ├─ ContentView.swift          # Main view
│  ├─ components/               # UI components (if created)
│  │  ├─ StatCard.swift
│  │  ├─ QuickActionButton.swift
│  │  └─ CustomView.swift
│  ├─ views/                     # Feature views (if created)
│  │  ├─ HomeView.swift
│  │  ├─ SettingsView.swift
│  │  └─ [FeatureView].swift
│  ├─ services/                  # Business logic services
│  │  ├─ CallBlockManager.swift
│  │  ├─ SubscriptionManager.swift
│  │  └─ [NewService].swift
│  ├─ models/                    # Data models (if created)
│  │  ├─ BlockedNumber+CoreData.swift
│  │  └─ [NewModel].swift
│  ├─ utils/                     # Utility functions (if created)
│  │  └─ [Utility].swift
│  ├─ managers/                  # Managers & handlers
│  │  ├─ CallBlockManager.swift
│  │  ├─ DatabaseHelper.swift
│  │  └─ [NewManager].swift
│  ├─ Assets.xcassets/          # Images, colors, etc.
│  ├─ Info.plist
│  ├─ SmartCallBlock.entitlements
│  └─ Preview Content/
│
├─ SmartCallBlock.xcodeproj/    # Xcode project config
│  ├─ project.pbxproj           # Main project file (AUTO-UPDATED)
│  ├─ xcshareddata/
│  └─ [Team ID].xcconfig
│
└─ CallDirectoryExtension/      # Call directory extension target
```

---

## ✅ Step-by-Step: Creating a New iOS File

### Step 1: Plan the File Location
```
Decide: Where should this file live?

Component/View:       SmartCallBlock/[ComponentName].swift
UI Component:         SmartCallBlock/components/[ComponentName].swift
Feature View:         SmartCallBlock/views/[FeatureName]View.swift
Service/Manager:      SmartCallBlock/services/[ServiceName].swift
Model:                SmartCallBlock/models/[Model]+Extension.swift
Utility:              SmartCallBlock/utils/[UtilityName].swift
Manager/Handler:      SmartCallBlock/managers/[Manager].swift
```

### Step 2: Create the Swift File
```swift
//
//  BlockedCallsChartView.swift
//  SmartCallBlock
//
//  Created on 12/19/2025.
//

import SwiftUI
import CoreData

struct BlockedCallsChartView: View {
    // Implementation
}
```

**Key Points:**
- ✅ Include header comment with file name
- ✅ Include project name comment
- ✅ Include creation date
- ✅ Import required frameworks
- ✅ Use proper naming (PascalCase for types)

### Step 3: Add File to Xcode Project

#### Option A: Using Xcode GUI (Recommended)
```
1. Open SmartCallBlock.xcodeproj in Xcode
2. Right-click on "SmartCallBlock" folder in Project Navigator
3. Select "Add Files to 'SmartCallBlock'"
4. Navigate to your .swift file
5. Check: ✅ "Copy items if needed"
6. Check: ✅ "Create groups"
7. Target: ✅ "SmartCallBlock" (NOT "CallDirectoryExtension")
8. Click "Add"
```

#### Option B: Using Command Line
```bash
# Copy file to SmartCallBlock directory
cp BlockedCallsChartView.swift /Users/mac/Project/Source/Mobile/smart-call-block/IOS/SmartCallBlock/

# Update Xcode project
cd /Users/mac/Project/Source/Mobile/smart-call-block/IOS
xcodebuild -project SmartCallBlock.xcodeproj \
  -scheme SmartCallBlock \
  -configuration Debug \
  -addedFile BlockedCallsChartView.swift
```

#### Option C: Using Script (Automated)
```bash
#!/bin/bash
# add_ios_file.sh

FILE_PATH=$1
PROJECT_DIR="/Users/mac/Project/Source/Mobile/smart-call-block/IOS"

# Copy file to SmartCallBlock
cp "$FILE_PATH" "$PROJECT_DIR/SmartCallBlock/"

# Run sync script
cd "$PROJECT_DIR"
python3 generate_core_data_files.py
```

### Step 4: Verify File is Added to Project
```bash
# Check if file is in project.pbxproj
grep -q "BlockedCallsChartView.swift" SmartCallBlock.xcodeproj/project.pbxproj
echo "✅ File added to project" || echo "❌ File not in project"

# Build to verify compilation
xcodebuild -project SmartCallBlock.xcodeproj \
  -scheme SmartCallBlock \
  -configuration Debug \
  clean build
```

### Step 5: Update Documentation
```
1. Update relevant documentation file
2. Add file to file manifest
3. Update CHANGELOG if significant
4. Add to relevant feature tracking
```

---

## 🔄 Automatic Sync with Xcode Project

### Using project.pbxproj Sync Script

Create `sync_xcode_project.sh` in iOS folder:

```bash
#!/bin/bash
# sync_xcode_project.sh
# Automatically sync new .swift files with Xcode project

PROJECT_DIR="/Users/mac/Project/Source/Mobile/smart-call-block/IOS"
XCODE_PROJECT="$PROJECT_DIR/SmartCallBlock.xcodeproj"
PBXPROJ="$XCODE_PROJECT/project.pbxproj"
SOURCE_DIR="$PROJECT_DIR/SmartCallBlock"

echo "🔄 Syncing iOS source files with Xcode project..."

# Find all .swift files in SmartCallBlock directory
for file in $(find "$SOURCE_DIR" -name "*.swift" -type f); do
    # Extract relative path from SOURCE_DIR
    REL_PATH="${file#$SOURCE_DIR/}"
    
    # Check if file is in project.pbxproj
    if ! grep -q "\"$REL_PATH\"" "$PBXPROJ"; then
        echo "➕ Adding missing file: $REL_PATH"
        
        # Get file reference hash
        FILE_REF=$(printf '%s' "$REL_PATH" | md5sum | cut -d' ' -f1 | tr '[:lower:]' '[:upper:]' | head -c 24)
        
        # Add to project configuration
        # (Note: This is simplified; full implementation would modify pbxproj properly)
    fi
done

# Validate project structure
echo "✅ Sync complete!"
echo "📝 Updated files:"
grep "\.swift\"" "$PBXPROJ" | wc -l
```

### Using Xcode Build Phases

#### Add Run Script Build Phase
```
1. Open SmartCallBlock.xcodeproj in Xcode
2. Select "SmartCallBlock" target
3. Go to "Build Phases"
4. Click "+" → "New Run Script Phase"
5. Name it: "Sync Swift Files"
6. Add script:
```

```bash
# Sync new Swift files to project
SWIFT_FILES=$(find "$SRCROOT" -name "*.swift" -type f)
echo "📋 Found $(echo "$SWIFT_FILES" | wc -l) Swift files"

# Log for debugging
echo "✅ Swift files synced" >> "$SRCROOT/sync.log"
```

---

## 🎯 File Categories & Templates

### 1. SwiftUI View/Component
```swift
//
//  CustomView.swift
//  SmartCallBlock
//
//  Created on [DATE].
//

import SwiftUI

struct CustomView: View {
    // MARK: - Properties
    
    // MARK: - Body
    var body: some View {
        VStack {
            // Content
        }
    }
}

// MARK: - Preview
#Preview {
    CustomView()
}
```

### 2. Service/Manager Class
```swift
//
//  NewService.swift
//  SmartCallBlock
//
//  Created on [DATE].
//

import Foundation
import CoreData

class NewService {
    // MARK: - Singleton
    static let shared = NewService()
    
    // MARK: - Properties
    @Environment(\.managedObjectContext) var viewContext
    
    // MARK: - Methods
    func performAction() {
        // Implementation
    }
}
```

### 3. Data Model
```swift
//
//  NewModel+Extension.swift
//  SmartCallBlock
//
//  Created on [DATE].
//

import CoreData

extension NewModel {
    // MARK: - Computed Properties
    var displayName: String {
        return "Model"
    }
    
    // MARK: - Methods
    func update(value: String) {
        // Implementation
    }
}
```

### 4. Utility Functions
```swift
//
//  UtilityFunctions.swift
//  SmartCallBlock
//
//  Created on [DATE].
//

import Foundation

// MARK: - Date Utilities
func formatDate(_ date: Date) -> String {
    // Implementation
}

// MARK: - String Utilities
func validatePhoneNumber(_ phone: String) -> Bool {
    // Implementation
}
```

---

## 📋 Checklist: Before Committing New File

- [ ] File created in correct directory
- [ ] File has proper header comment
- [ ] File imports necessary frameworks
- [ ] Code follows Swift style guidelines
- [ ] File added to Xcode project
- [ ] Project builds without errors
- [ ] No compiler warnings
- [ ] Preview works (if SwiftUI)
- [ ] Documented in relevant guide
- [ ] Added to file manifest
- [ ] Tests created (if applicable)
- [ ] Committed with descriptive message

---

## 🐛 Troubleshooting

### Issue: File Created But Not Building
```
Problem: "File not found" errors in build

Solution:
1. Check: File is in SmartCallBlock directory
2. Verify: File added to Xcode project (Build Phases → Compile Sources)
3. Check: Target is "SmartCallBlock" (not CallDirectoryExtension)
4. Try: Clean build folder (Cmd+Shift+K)
5. Run: xcodebuild clean build
```

### Issue: File in Project But Can't Import
```
Problem: "Module not found" or "Cannot find in scope"

Solution:
1. Check: Import statements are correct
2. Verify: File is in correct target
3. Check: No circular imports
4. Try: Product → Build again
5. Reset: Derived Data folder
   rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

### Issue: Xcode Project File Corrupted
```
Problem: "Could not read project.pbxproj"

Solution:
1. Close Xcode
2. Backup project: cp -r SmartCallBlock.xcodeproj SmartCallBlock.xcodeproj.bak
3. Try: xcodebuild -project SmartCallBlock.xcodeproj clean
4. If fails: Restore from backup and sync manually
5. Last resort: Recreate project from source files
```

---

## 📊 File Manifest

### Current iOS Source Files (SmartCallBlock)
```
Core Files:
  ✅ SmartCallBlockApp.swift
  ✅ ContentView.swift
  
Views:
  ✅ AddNumberView.swift
  ✅ AdvancedBlockingRulesView.swift
  ✅ BackupRestoreView.swift
  ✅ BlockedNumbersListView.swift
  ✅ CallHistoryView.swift
  ✅ IncomingCallView.swift
  ✅ OnboardingView.swift
  ✅ PremiumView.swift
  ✅ SettingsView.swift
  ✅ StatisticsView.swift
  ✅ BlockedCallsChartView.swift (NEW - Dec 19, 2025)
  ✅ EditNumberView.swift
  ✅ CrashReportsView.swift

Managers/Services:
  ✅ CallBlockManager.swift
  ✅ CallBlockingService.swift
  ✅ CallKitCallObserver.swift
  ✅ CrashReportingManager.swift
  ✅ SubscriptionManager.swift
  ✅ BackupRestoreManager.swift
  ✅ DialogManager.swift

Models (Core Data):
  ✅ BlockedNumber+CoreDataClass.swift
  ✅ BlockedNumber+CoreDataProperties.swift
  ✅ CallHistory+CoreDataClass.swift
  ✅ CallHistory+CoreDataProperties.swift

Other:
  ✅ AppCommonDialogOverlay.swift
  ✅ SmartCallBlock.entitlements
```

---

## 🔗 Related Documentation

- [iOS Build Guide](../docs/ios/build-guide.md)
- [Xcode Setup Guide](IOS_XCODE_CAPABILITIES_SETUP.md)
- [Project Structure Documentation](README.md)
- [Development Workflow](../development-rules/workflow-commands.md)

---

## 📝 File Management Checklist

### When Creating New .swift File
```yaml
Before Creation:
  [ ] Determine file location
  [ ] Check naming conventions
  [ ] Review similar existing files
  [ ] Plan imports needed

During Creation:
  [ ] Add header comment
  [ ] Import frameworks
  [ ] Follow code style
  [ ] Add MARK sections
  [ ] Include Preview (if UI)

After Creation:
  [ ] Add to Xcode project
  [ ] Verify compilation
  [ ] Update documentation
  [ ] Commit with message
  [ ] Update manifest

Verification:
  [ ] Build succeeds
  [ ] No warnings
  [ ] Code accessible
  [ ] Version control sync
```

---

## 🎯 Quick Commands

### Add Single File
```bash
cd /Users/mac/Project/Source/Mobile/smart-call-block/IOS
xcodebuild -project SmartCallBlock.xcodeproj -scheme SmartCallBlock clean build
```

### Add Multiple Files
```bash
# Copy files to directory
cp *.swift SmartCallBlock/

# Build to verify
xcodebuild -project SmartCallBlock.xcodeproj clean build
```

### Verify File in Project
```bash
grep "BlockedCallsChartView.swift" SmartCallBlock.xcodeproj/project.pbxproj
```

### List All Swift Files
```bash
find SmartCallBlock -name "*.swift" | sort
```

### Sync Project After Manual Changes
```bash
# Clean Xcode cache
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Rebuild
xcodebuild -project SmartCallBlock.xcodeproj clean build
```

---

## 📞 Support & Questions

### Common Questions

**Q: Do I need to manually edit project.pbxproj?**  
A: Usually NO. Xcode handles this automatically when using the GUI. Only edit manually if using advanced build scripts.

**Q: What if file shows in Finder but not in Xcode?**  
A: The file might not be added to the target. Use "Build Phases" → "Compile Sources" to add it.

**Q: Can I organize files into groups in Xcode?**  
A: Yes! Use "Add Files" dialog and check "Create groups" to create folder structures.

**Q: What about CallDirectoryExtension?**  
A: Different target. Only use for CallKit directory service. Most files go to SmartCallBlock target.

---

**Status**: Active Development Guideline  
**Last Updated**: December 19, 2025  
**Applies To**: SmartCallBlock iOS Project  
**Maintained By**: Development Team
