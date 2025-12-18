# Critical Changes Checklist

## Overview
This checklist covers changes that require user confirmation before proceeding, as they can have significant impact on app functionality or user experience.

## Detection Commands

### Database Schema Changes
```powershell
# Detect database schema changes
Get-ChildItem -Path "app\src\main\java" -Filter "*DatabaseHelper.java" -Recurse | 
    Select-String '(CREATE TABLE|ALTER TABLE|DROP TABLE|DATABASE_VERSION\s*=)' -Context 2,2
```

### Permission Changes  
```powershell
# Detect permission changes in manifest
git diff app/src/main/AndroidManifest.xml | Select-String 'uses-permission'
```

### Package Name Changes
```powershell
# Detect package name changes
git diff app/build.gradle | Select-String 'applicationId'
```

## Critical Changes Requiring Confirmation

| # | Change Type | Detection | Must Confirm With User | Why Critical |
|---|-------------|-----------|------------------------|--------------|
| 1 | **Database Version Increment** | Schema changed (CREATE/ALTER TABLE) | "Database schema changed. Need to increment DATABASE_VERSION from X to Y and add migration logic. Confirm?" | Breaks restore compatibility, requires migration |
| 2 | **Database Migration Logic** | DATABASE_VERSION incremented | "DATABASE_VERSION increased to X. Need to add migration logic in onUpgrade() from version Y to X. Confirm?" | Missing migration = data loss on upgrade |
| 3 | **Permission Addition/Removal** | AndroidManifest.xml permissions | "Adding/removing permission: [PERMISSION_NAME]. This affects user privacy and app store approval. Confirm?" | Privacy impact, app store review |
| 4 | **Package Name Change** | applicationId in build.gradle | "Package name changing from X to Y. This breaks app updates - users will see as new app. Confirm?" | Users lose data, breaks updates |

## User Confirmation Process

### 1. Detect Critical Change
When AI detects any critical change pattern:

```
Step 1: STOP all operations
Step 2: Show clear explanation of what changed
Step 3: Explain consequences
Step 4: Ask explicit user confirmation
```

### 2. User Response Handling

**If user says "yes":**
```
✅ Proceed with the change
✅ Implement required companion changes (migration logic, etc.)
✅ Add warnings in documentation
✅ Update version numbers as needed
```

**If user says "no":**
```
✅ Do NOT make the change
✅ Explain alternative approaches
✅ Ask what user wants to do instead
```

### 3. Required Follow-up Actions

For each confirmed critical change:

**Database Version Increment:**
- ✅ Increment DATABASE_VERSION constant
- ✅ Add migration logic in onUpgrade() method
- ✅ Test migration with sample data
- ✅ Document migration steps

**Permission Changes:**
- ✅ Update permission request flow in MainActivity
- ✅ Update MainProfile permission display
- ✅ Test permission denial scenarios
- ✅ Document privacy implications

**Package Name Changes:**
- ✅ Update all package references
- ✅ Update gradle configuration
- ✅ Test signing and build process
- ✅ Document breaking change impact

## Why This Matters

**Data Protection:**
- ✅ Prevents data loss (database changes)
- ✅ Prevents backup/restore failures (version mismatch)
- ✅ Ensures proper migration paths

**User Experience:**
- ✅ Prevents breaking app updates (package name)
- ✅ Maintains user trust (permission transparency)
- ✅ Avoids "new app" confusion

**Development Safety:**
- ✅ Gives user control over destructive operations
- ✅ Ensures proper migration logic is added
- ✅ Documents breaking changes

## Example Scenarios

### Scenario 1: Adding New Table
```
AI detects: CREATE TABLE new_feature_data
AI asks: "New table 'new_feature_data' detected. Need to increment DATABASE_VERSION from 3 to 4 and add migration logic. Confirm?"
User: "Yes"
AI actions:
1. Change DATABASE_VERSION = 3 to DATABASE_VERSION = 4
2. Add migration case in onUpgrade():
   case 3: db.execSQL("CREATE TABLE new_feature_data..."); break;
3. Test migration logic
```

### Scenario 2: Removing Permission
```
AI detects: Removed <uses-permission android:name="android.permission.CAMERA" />
AI asks: "Removing CAMERA permission. This will break camera features and affect app store description. Confirm?"
User: "No, keep camera functionality"
AI actions:
1. Do NOT remove permission
2. Explain camera usage requirements
3. Ask for alternative approach
```

### Scenario 3: Package Name Change
```
AI detects: applicationId changed from "com.example.oldapp" to "com.example.newapp"
AI asks: "Package name changing from com.example.oldapp to com.example.newapp. This breaks app updates - users will see as completely new app and lose all data. Confirm?"
User: "No, that's not what I want"
AI actions:
1. Revert package name change
2. Explain consequences of package name changes
3. Suggest alternative solutions (app rebranding without package change)
```

## Best Practices

**Always Ask First:**
- 🔴 Never make database version changes without user confirmation
- 🔴 Never change package names without explicit approval
- 🔴 Never add/remove sensitive permissions without discussion

**Provide Context:**
- ✅ Explain what the change does
- ✅ Explain why it's needed
- ✅ Explain potential consequences
- ✅ Offer alternatives when available

**Follow Through:**
- ✅ Implement ALL required companion changes
- ✅ Test critical paths after changes
- ✅ Document breaking changes
- ✅ Update version history

## iOS-Specific Critical Changes

**Project File Corruption:**
- Monitor for Xcode project file (.pbxproj) corruption
- Check for ID collisions and duplicate entries
- Validate project opens without crashes after changes
- See: [iOS Xcode Crash Troubleshooting](ios/ios-xcode-crash-troubleshooting.md)

**Common iOS Critical Points:**
- 🔴 Xcode project target dependencies
- 🔴 Bundle identifier changes
- 🔴 Code signing configurations
- 🔴 App extensions and entitlements