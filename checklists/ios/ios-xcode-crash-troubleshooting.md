# iOS Xcode Crash Troubleshooting Guide

## Common Xcode Crash Issues and Solutions

### 1. SwiftUI Preview Crashes ("may have crashed" error)

#### Symptoms:
- SwiftUI Preview shows "AppName may have crashed"
- PotentialCrashError in preview process
- Preview process terminates unexpectedly
- Cannot see any SwiftUI preview content

#### Root Causes:
- **@StateObject in child views**: Using @StateObject for shared services causes preview crashes
- **Core Data access**: Accessing shared Core Data context in preview environment
- **CallKit/UserDefaults**: System services not available in preview process
- **Infinite view updates**: Computed properties triggering endless update cycles

#### Solution Steps:

1. **Replace @StateObject with @EnvironmentObject**
   ```swift
   // ❌ CRASH RISK
   @StateObject private var manager = CallBlockManager.shared
   
   // ✅ PREVIEW SAFE
   @EnvironmentObject private var manager: CallBlockManager
   ```

2. **Create Preview-Safe Services**
   ```swift
   class CallBlockManager: ObservableObject {
       private var isPreviewMode: Bool {
           ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
       }
       
       static func forPreview() -> CallBlockManager {
           let manager = CallBlockManager()
           manager.extensionEnabled = true
           return manager
       }
       
       func checkExtensionStatus() {
           guard !isPreviewMode else { 
               extensionEnabled = true
               return 
           }
           // Real implementation
       }
   }
   ```

3. **Safe Preview Implementation**
   ```swift
   struct ContentView_Previews: PreviewProvider {
       static var previews: some View {
           let context = PersistenceController(inMemory: true).container.viewContext
           
           return ContentView()
               .environment(\\.managedObjectContext, context)
               .environmentObject(CallBlockManager.forPreview())
       }
   }
   ```

4. **Clean Preview Caches**
   ```powershell
   # Clear all preview caches
   xcrun simctl --set previews delete all
   
   # Clear derived data
   Remove-Item -Recurse -Force "~/Library/Developer/Xcode/DerivedData/*" -ErrorAction SilentlyContinue
   
   # Restart Xcode
   killall Xcode
   ```

### 2. Project File Corruption (`project.pbxproj` damaged)

#### Symptoms:
- Xcode crashes with `EXC_CRASH (SIGABRT)` exception
- Error: `NSInvalidArgumentException: unrecognized selector sent to instance`
- Crash occurs during workspace/scheme loading
- Error mentions `PBXTargetDependency` or target dependency issues

#### Root Causes:
- **ID Collision**: Same UUID used for different objects (PBXTargetDependency and PBXContainerItemProxy)
- **Duplicate Entries**: Duplicate build file entries in PBXBuildFile section
- **Corrupted References**: Broken or circular references between project objects
- **Merge Conflicts**: Git merge conflicts in .pbxproj file not properly resolved

#### Solution Steps:

1. **Immediate Backup**
   ```powershell
   cd "project.xcodeproj"
   Copy-Item "project.pbxproj" "project.pbxproj.backup"
   ```

2. **Check for ID Collisions**
   - Look for duplicate UUIDs in different object sections
   - Especially between `PBXContainerItemProxy` and `PBXTargetDependency`

3. **Fix ID Collisions**
   - Generate new UUID for conflicting objects
   - Update all references to use the new UUID
   - Ensure `targetProxy` in `PBXTargetDependency` references correct `PBXContainerItemProxy`

4. **Remove Duplicate Entries**
   - Check `PBXBuildFile` section for duplicate source file entries
   - Remove duplicates while preserving one correct entry

5. **Clean User Data**
   ```powershell
   Remove-Item -Recurse -Force "xcuserdata" -ErrorAction SilentlyContinue
   Remove-Item -Recurse -Force "project.xcworkspace/xcuserdata" -ErrorAction SilentlyContinue
   ```

6. **Validate Fix**
   - Open project in Xcode
   - Verify all targets build successfully
   - Check scheme configurations

#### Prevention:
- Always commit working `.pbxproj` files before major changes
- Use Xcode's built-in merge tools for resolving conflicts
- Avoid manual editing of `.pbxproj` files when possible
- Regular backups of working project configurations

#### Example Fix - ID Collision:

**Problem:**
```
7B4F1C542C1B912400123456 /* PBXContainerItemProxy */ = { ... };
7B4F1C542C1B912400123456 /* PBXTargetDependency */ = {
    targetProxy = 7B4F1C542C1B912400123456 /* PBXContainerItemProxy */;
};
```

**Solution:**
```
7B4F1C542C1B912400123456 /* PBXContainerItemProxy */ = { ... };
7B4F1C552C1B912500123456 /* PBXTargetDependency */ = {
    targetProxy = 7B4F1C542C1B912400123456 /* PBXContainerItemProxy */;
};
```

### 2. Scheme Configuration Issues

#### Symptoms:
- Crash during scheme unarchiving
- Build configuration problems
- Target dependency resolution failures

#### Solutions:
- Reset scheme to default configuration
- Recreate schemes from scratch if necessary
- Verify target build order and dependencies

### 3. File Path Issues

#### Symptoms:
- Missing file references
- Path resolution errors

#### Solutions:
- Update file paths in project navigator
- Remove and re-add problematic files
- Check relative vs absolute path configurations

## Best Practices for iOS Project Maintenance

1. **Regular Validation**
   - Test project opens without issues after major changes
   - Validate all build configurations (Debug/Release)
   - Check both device and simulator builds

2. **Version Control Hygiene**
   - Commit `.pbxproj` changes in separate commits when possible
   - Use descriptive commit messages for project structure changes
   - Review `.pbxproj` diffs carefully before committing

3. **Team Coordination**
   - Coordinate project structure changes across team
   - Document any custom build settings or configurations
   - Share troubleshooting solutions with team members

4. **Backup Strategy**
   - Maintain working backups of project files
   - Document known-good project configurations
   - Keep copies of important scheme configurations

## Related Documentation
- [iOS SwiftUI Development Checklist](ios-swiftui-development-checklist.md)
- [iOS CallKit Integration Checklist](ios-callkit-integration-checklist.md)
- [Critical Changes Checklist](../critical-changes-checklist.md)

---
*Last Updated: December 18, 2025*
*Related to: SmartCallBlock iOS Project Crash Fix*