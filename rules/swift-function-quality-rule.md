# Swift Function Quality Rule

> Rule for preventing duplicate functions and ensuring clear parameter naming in Swift code

---

## 📋 RULE SCOPE
**Applies to**: All iOS Swift/SwiftUI projects  
**Purpose**: Ensure clean function definitions and clear parameter usage  
**Review Stage**: Code review, migration, and automated checks

---

## ⚠️ CRITICAL VIOLATIONS

### 1. Duplicate Function Declarations
**Rule**: No function shall be declared more than once in the same scope

**Violation Pattern**:
```swift
// ❌ CRITICAL ERROR
private func processData() {
    // First implementation
}

// Later in same file
private func processData() {  // DUPLICATE - MUST FIX
    // Second implementation
}
```

**Correct Pattern**:
```swift
// ✅ COMPLIANT
private func processData() {
    // Single implementation
}
```

### 2. Implicit Parameter Labels
**Rule**: Custom components must use explicit parameter labels

**Violation Pattern**:
```swift
// ❌ POOR READABILITY
CustomButton("Save", action: handleSave)
ComponentView("Title", data: itemData)
HelperFunction("Value", option: true)
```

**Correct Pattern**:
```swift
// ✅ CLEAR AND EXPLICIT
CustomButton(title: "Save", action: handleSave)
ComponentView(text: "Title", data: itemData)
HelperFunction(value: "Value", option: true)
```

### 3. SwiftUI Preview Crash Prevention
**Rule**: All SwiftUI Previews must be crash-safe and use preview-safe data

**Violation Pattern**:
```swift
// ❌ PREVIEW CRASH RISK
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

@StateObject private var callBlockManager = CallBlockManager.shared
```

**Correct Pattern**:
```swift
// ✅ PREVIEW-SAFE
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController(inMemory: true).container.viewContext
        
        // Create sample data
        let sampleEntity = SampleEntity(context: context)
        sampleEntity.name = "Test Data"
        try? context.save()
        
        return ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(CallBlockManager.forPreview())
    }
}

@EnvironmentObject private var callBlockManager: CallBlockManager
```

### 4. Core Data Model Safety
**Rule**: Core Data initialization must include error handling and recovery

**Violation Pattern**:
```swift
// ❌ NO ERROR RECOVERY
container.loadPersistentStores { _, error in
    if let error = error {
        fatalError("Core Data error: \(error)")
    }
}
```

**Correct Pattern**:
```swift
// ✅ ROBUST ERROR HANDLING
container.loadPersistentStores { storeDescription, error in
    if let error = error as NSError? {
        print("Core Data Error: \(error.localizedDescription)")
        print("Store URL: \(storeDescription.url?.absoluteString ?? "Unknown")")
        
        // Attempt recovery for non-memory stores
        if !inMemory {
            self.attemptStoreRecovery()
        } else {
            fatalError("Core Data error in memory store: \(error)")
        }
    }
}
```

---

## 🔍 AUTOMATED DETECTION

### PowerShell Detection Script
```powershell
# Swift Function Quality Checker
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
)

Write-Host "🔍 Swift Function Quality Check" -ForegroundColor Cyan

# Check for duplicate functions
Write-Host "`n1. Checking for duplicate functions..." -ForegroundColor Yellow
Get-ChildItem "$ProjectPath" -Filter "*.swift" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName
    $functions = $content | Where-Object { $_ -match "^\s*private func|^\s*func|^\s*internal func" }
    $functionNames = $functions | ForEach-Object { 
        ($_ -replace "^\s*", "") -replace "\{.*", "" -replace "\s+", " "
    }
    $duplicates = $functionNames | Group-Object | Where-Object { $_.Count -gt 1 }
    
    if ($duplicates) {
        Write-Host "❌ DUPLICATE FUNCTIONS in $($_.Name):" -ForegroundColor Red
        $duplicates | ForEach-Object {
            Write-Host "   - $($_.Name) (found $($_.Count) times)" -ForegroundColor Red
        }
    }
}

# Check for implicit parameters in custom components
Write-Host "`n2. Checking for implicit parameters..." -ForegroundColor Yellow
Get-ChildItem "$ProjectPath" -Filter "*.swift" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName
    $suspiciousLines = $content | Select-String -Pattern '\w+\("[^"]*",' | Where-Object {
        $_.Line -notmatch 'Text\(|Button\(|Label\(|Image\(|print\(|fatalError\(|precondition\('
    }
    
    if ($suspiciousLines) {
        Write-Host "⚠️  POTENTIAL IMPLICIT PARAMETERS in $($_.Name):" -ForegroundColor Yellow
        $suspiciousLines | ForEach-Object {
            Write-Host "   Line $($_.LineNumber): $($_.Line.Trim())" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n✅ Function quality check completed" -ForegroundColor Green
```

---

## 📝 REVIEW CHECKLIST

### Pre-Migration Review
- [ ] **Scan for duplicates**: Run detection script on source code
- [ ] **Identify implicit calls**: Review custom component usage
- [ ] **Document findings**: Log all violations for systematic fixing
- [ ] **Estimate effort**: Count violations for planning

### Migration Steps
1. **Fix duplicates first** - Remove or consolidate duplicate functions
2. **Update parameter calls** - Add explicit parameter labels  
3. **Verify compilation** - Ensure all changes build successfully
4. **Test functionality** - Confirm behavior unchanged

### Post-Migration Verification
- [ ] **Zero duplicates**: Re-run detection script for clean results
- [ ] **Explicit parameters**: All custom components use labeled parameters
- [ ] **Build success**: Project compiles without errors
- [ ] **Functionality intact**: All features work as expected

---

## 🎯 IMPLEMENTATION GUIDE

### For New Code
```swift
// ✅ GOOD: Write functions once, use explicit parameters
struct MyView: View {
    private func handleUserAction() {
        // Single implementation
        processUserData()
    }
    
    var body: some View {
        VStack {
            CustomButton(title: "Submit", action: handleUserAction)
            InfoComponent(text: "Status", value: currentStatus)
        }
    }
}
```

### For Legacy Code Migration
1. **Search & Replace Pattern**:
   ```
   Find: CustomComponent("
   Replace: CustomComponent(title: "
   ```

2. **Function Deduplication**:
   - Keep the most complete implementation
   - Remove empty or redundant versions
   - Merge logic if both have unique parts

### Team Guidelines
- **Code Review**: Always check for these patterns
- **IDE Setup**: Configure warnings for similar function signatures
- **Documentation**: Update function comments when consolidating
- **Testing**: Unit test all modified functions

---

## 🔧 TOOL INTEGRATION

### Xcode Integration
```bash
# Add as build phase script
cd "$SRCROOT"
powershell -File "scripts/swift-quality-check.ps1" -ProjectPath "."
```

### CI/CD Pipeline
```yaml
# GitHub Actions example
- name: Swift Function Quality Check
  run: |
    pwsh scripts/swift-quality-check.ps1 -ProjectPath ./ios/
```

### Pre-commit Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit
pwsh scripts/swift-quality-check.ps1 -ProjectPath ./
if [ $? -ne 0 ]; then
    echo "❌ Function quality issues found. Fix before committing."
    exit 1
fi
```

---

**Rule Owner**: iOS Development Team  
**Last Updated**: December 18, 2025  
**Next Review**: Monthly during code quality reviews