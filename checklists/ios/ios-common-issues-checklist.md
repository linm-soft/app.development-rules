# iOS Common Issues and Fixes Checklist

## Core Data Model Loading Issues

### Core Data Model Not Found ⚠️ NEW
**Problem**: "Failed to load model named DataModel" error on app launch
**Root Cause**: Missing .xccurrentversion file in .xcdatamodeld bundle

**Symptoms**:
- App crashes immediately on launch with Core Data error
- "DataModel.momd not found in bundle" in console
- Core Data stack fails to initialize

**Solution**:
1. **Create .xccurrentversion file**:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>_XCCurrentVersionName</key>
       <string>DataModel.xcdatamodel</string>
   </dict>
   </plist>
   ```

2. **Place in .xcdatamodeld directory**:
   ```
   DataModel.xcdatamodeld/
   ├── .xccurrentversion          ← ADD THIS FILE
   └── DataModel.xcdatamodel/
       └── contents
   ```

3. **Add error recovery to PersistenceController**:
   ```swift
   // Verify model exists and implement fallback
   guard let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
       print("ERROR: DataModel.momd not found in bundle")
       container = self.createContainerWithProgrammaticModel()
       return
   }
   ```

### Core Data Store Corruption ⚠️ NEW
**Problem**: "NSPersistentStoreIncompatibleVersionHashError" or store loading failures
**Solution**: Implement store recovery mechanism
```swift
private func attemptStoreRecovery() {
    guard let storeURL = container.persistentStoreDescriptions.first?.url else { return }
    
    do {
        try FileManager.default.removeItem(at: storeURL)
        try? FileManager.default.removeItem(at: storeURL.appendingPathExtension("sqlite-wal"))
        try? FileManager.default.removeItem(at: storeURL.appendingPathExtension("sqlite-shm"))
        
        // Retry loading
        container.loadPersistentStores { _, error in
            if error != nil {
                fatalError("Core Data recovery failed")
            }
        }
    } catch {
        fatalError("Failed to recover Core Data store")
    }
}
```

## SwiftUI Preview Crashes

### "SmartCallBlock may have crashed" in Previews ⚠️ NEW
**Problem**: SwiftUI Previews crash with PotentialCrashError
**Root Cause**: @StateObject initialization and Core Data access in preview environment

**Symptoms**:
- Preview crashes immediately when trying to display
- "PotentialCrashError" in Xcode preview
- Cannot see SwiftUI preview for any view

**Solutions**:

1. **Use @EnvironmentObject instead of @StateObject**:
   ```swift
   // ❌ CRASH RISK in previews
   @StateObject private var callBlockManager = CallBlockManager.shared
   
   // ✅ PREVIEW SAFE
   @EnvironmentObject private var callBlockManager: CallBlockManager
   ```

2. **Create preview-safe managers**:
   ```swift
   class CallBlockManager: ObservableObject {
       private var isPreviewMode: Bool {
           ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
       }
       
       static func forPreview() -> CallBlockManager {
           let manager = CallBlockManager()
           manager.blockedCallsCount = 5
           manager.extensionEnabled = true
           return manager
       }
   }
   ```

3. **Safe Preview implementation**:
   ```swift
   struct ContentView_Previews: PreviewProvider {
       static var previews: some View {
           let context = PersistenceController(inMemory: true).container.viewContext
           
           // Create sample data
           let blockedNumber = BlockedNumber(context: context)
           blockedNumber.phoneNumber = "+1234567890"
           try? context.save()
           
           return ContentView()
               .environment(\\.managedObjectContext, context)
               .environmentObject(CallBlockManager.forPreview())
       }
   }
   ```

4. **Prevent CallKit/UserDefaults access in previews**:
   ```swift
   func reloadCallDirectory() {
       guard !isPreviewMode else { return }
       CXCallDirectoryManager.sharedInstance.reloadExtension(...)
   }
   ```

## Text Encoding and Quote Issues

### Smart Quotes (Curly Quotes) ⚠️
**Problem**: Compilation errors due to smart quotes copied from rich text editors
**Symptoms**: 
- Swift compiler errors about unrecognized characters
- Text showing curly quotes `""` instead of straight quotes `""`

**Solution**:
```powershell
# Fix all Swift files in directory
Get-ChildItem "*.swift" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    $content = $content.Replace([char]8220, [char]34)  # " -> "
    $content = $content.Replace([char]8221, [char]34)  # " -> "
    $content = $content.Replace([char]8216, [char]39)  # ' -> '
    $content = $content.Replace([char]8217, [char]39)  # ' -> '
    Set-Content $_.FullName $content -Encoding UTF8
    Write-Host "Fixed: $($_.Name)"
}
```

### UTF-8 Encoding Issues ⚠️
**Problem**: Special characters display as malformed sequences
**Common Examples**:
- Bullet point `•` showing as `â€¢`
- Em dash `—` showing as `â€"`
- Other Unicode characters corrupted

**Solution**:
```swift
// Fix in code - replace malformed characters
Text("â€¢") // Wrong
Text("•")   // Correct

Text("â€"") // Wrong  
Text("—")   // Correct
```

## Swift Syntax Issues

### Literal Escape Characters ⚠️ NEW
**Problem**: Literal `\n`, `\t` characters in Swift code causing compilation errors
**Symptoms**:
- "Invalid component of Swift key path"
- "Consecutive statements on a line must be separated by ';'"
- "Cannot find 'n' in scope"

**Common Pattern**:
```swift
// ❌ BAD: Literal escape characters
.padding(.horizontal)\n
}\n

// ✅ GOOD: Actual line breaks  
.padding(.horizontal)
}
```

**Prevention**:
- Use Xcode auto-format (⌃I) after copying code
- Visual inspection for `\n`, `\t` patterns
- Build frequently to catch syntax errors early

### Solution Script:
```powershell
# Find and fix literal escape characters
Get-ChildItem "*.swift" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '\\n|\\t') {
        Write-Host "Found escape characters in: $($_.Name)"
        # Manual review required - auto-fix may break intentional strings
    }
}
```

## Swift Function Issues

### Duplicate Function Declarations ⚠️ NEW
**Problem**: Multiple definitions of the same function causing compilation errors
**Symptoms**:
- "Invalid redeclaration of 'functionName()'"
- Build fails with duplicate definition errors

**Common Pattern**:
```swift
// ❌ BAD: Duplicate functions
private func handleAction() {
    // First implementation
}

// Later in same file
private func handleAction() {
    // Duplicate implementation - REMOVE THIS
}
```

**Detection**:
```powershell
# Find potential duplicate functions
Get-ChildItem "*.swift" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName
    $functions = $content | Where-Object { $_ -match "^\s*private func|^\s*func" }
    $functionNames = $functions | ForEach-Object { ($_ -split '\s+')[1,2] -join ' ' }
    $duplicates = $functionNames | Group-Object | Where-Object { $_.Count -gt 1 }
    if ($duplicates) {
        Write-Host "Potential duplicates in $($_.Name): $($duplicates.Name -join ', ')"
    }
}
```

### Implicit Parameter Names ⚠️ NEW  
**Problem**: Missing parameter labels making code unclear
**Symptoms**: Code builds but is hard to read and maintain

**Pattern**:
```swift
// ❌ UNCLEAR: Implicit first parameter
CustomButton("Save", action: saveAction)
ComponentView("Title", parameter: value)

// ✅ GOOD: Explicit parameter labels  
CustomButton(title: "Save", action: saveAction)
ComponentView(title: "Title", parameter: value)
```

**Best Practices**:
- Always use explicit parameter labels for clarity
- Especially important for custom views and functions
- Makes code self-documenting and easier to understand

## App Icon Configuration

### Missing AppIcon Asset ⚠️
**Problem**: "None of the input catalogs contained a matching app icon set"
**Root Cause**: Icon files not properly organized in AppIcon.appiconset directory

**Solution**:
1. **Check icon file location**: Icons must be INSIDE AppIcon.appiconset folder
2. **Move icons to correct location**:
   ```powershell
   Move-Item "Assets.xcassets\Icon-*.png" "Assets.xcassets\AppIcon.appiconset\"
   ```
3. **Verify Contents.json references**:
   - All `"filename"` entries in Contents.json must match actual files
   - Icons must be physically present in AppIcon.appiconset directory

**Required File Structure**:
```
Assets.xcassets/
├── Contents.json                    # Root asset catalog metadata
└── AppIcon.appiconset/
    ├── Contents.json               # App icon configuration
    ├── Icon-20@2x.png             # All icon files here
    ├── Icon-20@3x.png
    ├── Icon-29@2x.png
    └── ... (all other icon sizes)
```

**Required Sizes**:
- iPhone: 20x20@2x, 20x20@3x, 29x29@2x, 29x29@3x, 40x40@2x, 40x40@3x, 60x60@2x, 60x60@3x
- iPad: 20x20@1x, 20x20@2x, 29x29@1x, 29x29@2x, 40x40@1x, 40x40@2x, 76x76@1x, 76x76@2x, 83.5x83.5@2x
- Marketing: 1024x1024@1x

**Contents.json Template**:
```json
{
  "images": [
    {
      "size": "20x20",
      "idiom": "iphone", 
      "filename": "Icon-20@2x.png",
      "scale": "2x"
    },
    // ... (add all required sizes)
  ],
  "info": {
    "version": 1,
    "author": "xcode"
  }
}
```

## Core Data Issues

### Cannot Find Type in Scope ⚠️
**Problem**: Core Data entities not found during compilation
**Symptoms**:
- "Cannot find type 'BlockedNumber' in scope"
- "Cannot find type 'CallHistory' in scope"
- "Invalid component of Swift key path"

**Root Cause**: Conflict between manual Core Data class files and automatic code generation

**Solution**:
1. **Check .xcdatamodel file**: Open DataModel.xcdatamodeld/DataModel.xcdatamodel/contents
2. **Fix codeGenerationType**: Change from `codeGenerationType="class"` to `codeGenerationType="category"`
3. **Manual fix for .xcdatamodel**:
   ```xml
   <entity name="BlockedNumber" representedClassName="BlockedNumber" syncable="YES" codeGenerationType="category">
   <entity name="CallHistory" representedClassName="CallHistory" syncable="YES" codeGenerationType="category">
   ```
4. **Alternative in Xcode**: Set "Codegen" to "Category/Extension" (not "Class Definition")
5. Clean build folder (⇧⌘K)
6. Rebuild project (⌘B)

**Why Category/Extension?**: When you have manual Core Data class files (BlockedNumber+CoreDataClass.swift), use Category/Extension to avoid conflicts.

## Pre-Commit Checklist

### Before Committing iOS Code ✅

- [ ] **Text Encoding Check**: No smart quotes or malformed UTF-8 characters
- [ ] **Asset Validation**: All required AppIcon sizes present in AppIcon.appiconset folder
- [ ] **Core Data**: Entity Codegen set to "Category/Extension" when using manual class files
- [ ] **Build Success**: Clean build completes without errors
- [ ] **Extension Setup**: Call Directory Extension properly configured
- [ ] **Team ID**: Development team set correctly
- [ ] **Asset Organization**: Icons in AppIcon.appiconset, not loose in Assets.xcassets
- [ ] **Cache Clear Test**: Project builds successfully after clean derived data

### 🔄 Troubleshooting Escalation

**Level 1**: Standard fixes (Core Data config, asset organization)
**Level 2**: Clean build folder and derived data
**Level 3**: Complete Xcode restart
**Level 4**: Switch Core Data generation method (manual ↔ auto)

**When to escalate**:
- Errors persist after standard fixes → Level 2
- Cache cleaning doesn't work → Level 3  
- Still failing after restart → Level 4

### Quick Validation Commands
```bash
# Check for smart quotes
grep -r "[""'']" *.swift

# Validate AppIcon structure
ls Assets.xcassets/AppIcon.appiconset/Icon-*.png

# Check Core Data configuration  
grep -r "codeGenerationType" *.xcdatamodel/contents

# Build test
xcodebuild clean build -scheme SmartCallBlock
```

## Emergency Recovery

### If Xcode Won't Open Project
1. **Backup project.pbxproj**
2. **Check for ID collisions** in project file
3. **Clean derived data**: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
4. **Reset user data**: `rm -rf *.xcodeproj/xcuserdata`
5. **Validate project structure**

### Character Encoding Recovery
```powershell
# Emergency fix for all text files
Get-ChildItem -Recurse "*.swift", "*.json", "*.plist" | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
    # Fix common encoding issues
    $content = $content.Replace("â€¢", "•")
    $content = $content.Replace("â€"", "—") 
    $content = $content.Replace(""", '"')
    $content = $content.Replace(""", '"')
    [System.IO.File]::WriteAllText($_.FullName, $content, [System.Text.Encoding]::UTF8)
}
```

## Prevention

### Editor Settings
**Xcode Preferences**:
- Text Editing → Use straight quotes for new documents
- File encoding: UTF-8

**VS Code Settings**:
```json
{
  "editor.autoClosingQuotes": "never",
  "editor.smartSelect.selectLeadingAndTrailingWhitespace": false
}
```

### Git Hooks
**Pre-commit hook** to prevent smart quotes:
```bash
#!/bin/bash
# Check for smart quotes before commit
if grep -r "[""'']" *.swift; then
    echo "Error: Smart quotes found in Swift files"
    echo "Run quote fixing script before committing"
    exit 1
fi
```