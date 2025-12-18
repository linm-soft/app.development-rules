# Checklist: Data Backup & Restore

This checklist ensures that the application implements a data backup and restore mechanism according to project standards.

## ✅ Verification Steps

| # | Check | Command / Verification Method | Expected Result |
|---|---|---|---|
| 1 | **Backup Strategy Defined** | Review the app's functionality. | Determine if the app requires Offline (file-based) or Online (cloud-based) backup. |
| 2 | **First Launch Prompt (Offline Mode)** | Perform a fresh install of the app. | A dialog must appear asking the user for consent to enable local data backups. |
| 3 | **User Choice is Saved** | After responding to the first-launch dialog, reinstall or clear data and launch again. | The dialog should not appear a second time. The choice should be respected. |
| 4 | **Manual Backup Option** | Navigate to the app's Settings screen. | A "Backup Data" or similar option must be available. |
| 5 | **Manual Restore Option** | Navigate to the app's Settings screen. | A "Restore Data" or similar option must be available. |
| 6 | **Backup Process (Offline)** | Use the "Backup Data" feature. | The app should use the Storage Access Framework (SAF) to let the user choose a location. A `.db` file should be successfully created at that location. |
| 7 | **Restore Process (Offline)** | Use the "Restore Data" feature. Select a previously created backup file. | The app should close, restore the data, and upon reopening, the restored data should be present and correct. |
| 8 | **Permission Handling** | Review `AndroidManifest.xml` and related code. | The app should use modern, scoped storage practices (SAF) and avoid requesting broad `WRITE_EXTERNAL_STORAGE` permissions if possible. |
| 9 | **Online Backup Flow (If applicable)** | Sign in, make changes, install on a new device, and sign in again. | Data should be automatically restored from the cloud. |
| 10 | **Database Version Check in Restore** | Check restore implementation code. | Must validate backup database version before restoring. Must handle version mismatch (upgrade/prevent downgrade). |
| 11 | **Migration Logic Present** | Check if `onUpgrade()` is implemented in DatabaseHelper. | If database schema changed, `onUpgrade()` must have migration logic for each version. |
| 12 | **Rollback Mechanism** | Check restore implementation code. | Must create backup of current DB before restore. Must rollback if restore/migration fails. |

## 🔍 Detection Commands

### Detect Database Version in DatabaseHelper

```powershell
Get-ChildItem -Path "app\src\main\java" -Filter "*DatabaseHelper.java" -Recurse | 
    Select-String 'DATABASE_VERSION\s*=\s*\d+' | 
    Select-Object -Property Path, LineNumber, Line
```

**Expected Result:**
- Shows current `DATABASE_VERSION` value
- AI should note this version and check if migration logic exists for all versions

### Detect Database Schema Changes (ALTER TABLE, CREATE TABLE)

```powershell
Get-ChildItem -Path "app\src\main\java" -Filter "*DatabaseHelper.java" -Recurse | 
    Select-String '(CREATE TABLE|ALTER TABLE|DROP TABLE|ADD COLUMN)' | 
    Select-Object -Property Path, LineNumber, Line
```

**Expected Result:**
- Shows all CREATE/ALTER statements
- AI should verify if recent changes need `DATABASE_VERSION` increment

### Detect onUpgrade Implementation

```powershell
Get-ChildItem -Path "app\src\main\java" -Filter "*DatabaseHelper.java" -Recurse | 
    Select-String 'onUpgrade\s*\(' -Context 0,20 | 
    Select-Object -Property Path, LineNumber, Line
```

**Expected Result:**
- Shows `onUpgrade()` method implementation
- AI should verify migration logic exists for version gaps

### Detect Version Check in Restore Code

```powershell
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String '(getVersion|DATABASE_VERSION)' -Context 2,2 | 
    Where-Object { $_.Line -match 'restore|backup|import' } |
    Select-Object -Property Path, LineNumber, Line
```

**Expected Result:**
- Shows if restore code checks database version
- ❌ **No matches** = Missing version validation (MUST FIX)
- ✅ **Has matches** = Version check exists (verify logic)

## 🚨 Critical Issues to Detect

| Issue | How to Detect | Fix Required |
|-------|---------------|--------------|
| **DATABASE_VERSION incremented but no onUpgrade logic** | Version changed in git diff but `onUpgrade()` unchanged | Add migration logic in `onUpgrade()` |
| **Schema changed but DATABASE_VERSION not incremented** | Found CREATE/ALTER TABLE but version same as before | Increment `DATABASE_VERSION` |
| **Restore code doesn't check version** | Restore method doesn't call `getVersion()` | Add version validation before restore |
| **No rollback mechanism** | Restore code doesn't backup current DB first | Add current DB backup + rollback on failure |
| **Missing migration path** | Version jumped (e.g., 5→7) but `onUpgrade()` only handles 5→6 | Add migration for 6→7 |

## 📋 Review Workflow

When reviewing database-related changes:

1. **Check git diff** for DatabaseHelper changes
2. **Run detection commands** above
3. **Verify migration logic**:
   - If schema changed → Version incremented?
   - If version incremented → Migration logic added?
   - If restore exists → Version check added?
4. **Test scenario**:
   - Create backup with old version
   - Update app to new version
   - Restore old backup → Should auto-migrate

## 📝 Review Notes

- For offline mode, using the Storage Access Framework (SAF) is strongly preferred over legacy storage permissions.
- The restore process is critical and potentially destructive. It must be handled carefully, including closing database connections before overwriting the file.
- Ensure the user is clearly informed about what is being backed up and where it is being stored.
- **Database version validation is CRITICAL** - restoring incompatible database versions can cause crashes or data corruption.
