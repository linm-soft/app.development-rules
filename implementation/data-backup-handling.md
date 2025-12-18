# Data Backup & Restore Handling

This document provides the standard guidelines for implementing data backup and restore functionality in Android applications. Offering a backup solution is critical for user data retention and a positive user experience when switching devices or reinstalling the app.

## 1. Backup Modes

Two primary modes of backup should be considered, depending on the application's nature.

### 1.1. Offline Backup (File-based)

- **Description:** This mode involves saving the application's database file to a location on the device's external storage. It's simple, doesn't require an internet connection, and gives the user direct control over their data file.
- **Best for:** Apps that work entirely offline and do not have a user authentication system.

### 1.2. Online Backup (Cloud-based)

- **Description:** This mode involves syncing user data to a cloud service, typically associated with their user account (e.g., Google Drive, Firebase).
- **Best for:** Apps with user accounts, cross-device data synchronization needs, and a more seamless, automated backup experience.

---

## 2. Implementation Guide: Offline Backup

This is the required standard for apps that handle user data without an online account system.

### Step 1: Prompting the User

- **Requirement:** On the first launch after installation, the application **MUST** display a dialog to ask the user if they wish to enable local backups.
- **Dialog Content:**
    - **Title:** "Enable Data Backup?"
    - **Message:** "Would you like to automatically back up your application data (progress, settings, etc.) to your device's storage? You can restore this data if you reinstall the app."
    - **Buttons:** "Enable", "Later".

**Example Dialog Flow:**
1.  User opens the app for the first time.
2.  Check a `SharedPreferences` flag (e.g., `isFirstLaunch`).
3.  If it's the first launch, show the backup consent dialog.
4.  Save the user's choice in `SharedPreferences`.

### Step 2: Performing the Backup

- **Trigger:** The backup can be triggered manually from a "Settings" screen or automatically after significant data changes.
- **Mechanism:**
    1.  Get the path to the app's internal database file (e.g., `/data/data/com.your.package/databases/yourapp.db`).
    2.  Use Android's **Storage Access Framework (SAF)** to let the user choose a destination folder (e.g., in `Downloads`) and grant write permission. This is the modern, recommended approach that doesn't require broad storage permissions.
    3.  Copy the `.db` file to the chosen location. It's good practice to include a timestamp in the backup filename (e.g., `yourapp_backup_20251212_1530.db`).

**Code Snippet (Conceptual - Backup):**
```java
// In your Activity/Fragment, to trigger the backup file creation
private void requestBackup() {
    Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
    intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.setType("application/octet-stream"); // Or a custom MIME type
    intent.putExtra(Intent.EXTRA_TITLE, "yourapp_backup_" + System.currentTimeMillis() + ".db");
    
    // Start the file picker
    backupLauncher.launch(intent); 
}

// Handle the result from the file picker
ActivityResultLauncher<Intent> backupLauncher = registerForActivityResult(
    new ActivityResultContracts.StartActivityForResult(),
    result -> {
        if (result.getResultCode() == Activity.RESULT_OK && result.getData() != null) {
            Uri uri = result.getData().getData();
            // Now you have the URI, you can write the database file to it.
            performDatabaseFileCopy(uri);
        }
    });
```

### Step 3: Performing the Restore

- **Trigger:** Manually from a "Settings" screen.
- **Mechanism:**
    1.  Use the **Storage Access Framework (SAF)** to let the user pick an existing backup file (`.db`).
    2.  **Crucially:** Before restoring, close the current database connection (`DatabaseHelper.close()`).
    3.  Copy the selected backup file, overwriting the app's internal database file.
    4.  Restart the application or re-initialize the database connection to load the restored data.

**Code Snippet (Conceptual - Restore):**
```java
// In your Activity/Fragment, to trigger the restore file selection
private void requestRestore() {
    Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
    intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.setType("*/*"); // Allow user to select the .db file
    
    restoreLauncher.launch(intent);
}

// Handle the result
ActivityResultLauncher<Intent> restoreLauncher = registerForActivityResult(
    new ActivityResultContracts.StartActivityForResult(),
    result -> {
        if (result.getResultCode() == Activity.RESULT_OK && result.getData() != null) {
            Uri uri = result.getData().getData();
            // Close DB, copy file, and restart app
            performDatabaseRestore(uri);
        }
    });
```

### Step 4: Database Version Validation & Migration

⚠️ **CRITICAL:** When restoring a database file, the backup file may have a **different database version** than the current app version. This must be handled properly to avoid crashes or data corruption.

**Requirement:**
1. **Before restore:** Check the database version of the backup file
2. **If versions differ:** Run migration logic to upgrade/downgrade schema
3. **After restore:** Validate data integrity
4. **If migration fails:** Rollback and inform user

**Implementation Steps:**

#### 4.1. Get Database Version from Backup File

```java
private int getBackupDatabaseVersion(Uri backupFileUri) {
    SQLiteDatabase tempDb = null;
    try {
        // Copy backup to temp location
        File tempFile = new File(getCacheDir(), "temp_backup.db");
        copyUriToFile(backupFileUri, tempFile);
        
        // Open in read-only mode
        tempDb = SQLiteDatabase.openDatabase(
            tempFile.getAbsolutePath(),
            null,
            SQLiteDatabase.OPEN_READONLY
        );
        
        int version = tempDb.getVersion();
        return version;
        
    } catch (Exception e) {
        Log.e(TAG, "Failed to read backup version", e);
        return -1;
    } finally {
        if (tempDb != null) tempDb.close();
    }
}
```

#### 4.2. Migration Logic

```java
private boolean performDatabaseRestore(Uri backupFileUri) {
    int backupVersion = getBackupDatabaseVersion(backupFileUri);
    int currentVersion = DatabaseHelper.DATABASE_VERSION;
    
    if (backupVersion == -1) {
        showError("Invalid backup file");
        return false;
    }
    
    if (backupVersion > currentVersion) {
        // Backup is from newer version - cannot restore
        showError("Backup is from a newer version of the app. Please update the app first.");
        return false;
    }
    
    // Close current database
    DatabaseHelper.getInstance(this).close();
    
    // Backup current database (in case restore fails)
    File currentDb = getDatabasePath(DatabaseHelper.DATABASE_NAME);
    File backupCurrent = new File(currentDb.getAbsolutePath() + ".rollback");
    copyFile(currentDb, backupCurrent);
    
    try {
        // Copy backup file to database location
        copyUriToFile(backupFileUri, currentDb);
        
        if (backupVersion < currentVersion) {
            // Run migration from backupVersion to currentVersion
            migrateDatabaseFromVersion(backupVersion, currentVersion);
        }
        
        // Validate restored database
        if (!validateRestoredDatabase()) {
            throw new Exception("Database validation failed");
        }
        
        // Success - delete rollback file
        backupCurrent.delete();
        
        // Restart app to reload database
        restartApp();
        return true;
        
    } catch (Exception e) {
        Log.e(TAG, "Restore failed, rolling back", e);
        
        // Rollback: restore original database
        copyFile(backupCurrent, currentDb);
        backupCurrent.delete();
        
        showError("Restore failed: " + e.getMessage());
        return false;
    }
}
```

#### 4.3. Migration Between Versions

```java
private void migrateDatabaseFromVersion(int oldVersion, int newVersion) {
    SQLiteDatabase db = SQLiteDatabase.openDatabase(
        getDatabasePath(DatabaseHelper.DATABASE_NAME).getAbsolutePath(),
        null,
        SQLiteDatabase.OPEN_READWRITE
    );
    
    try {
        // Call the same migration logic as SQLiteOpenHelper
        DatabaseHelper.performMigration(db, oldVersion, newVersion);
        
        // Update version
        db.setVersion(newVersion);
        
    } finally {
        db.close();
    }
}
```

#### 4.4. Database Validation

```java
private boolean validateRestoredDatabase() {
    SQLiteDatabase db = null;
    try {
        db = DatabaseHelper.getInstance(this).getReadableDatabase();
        
        // Check if required tables exist
        Cursor cursor = db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table'", 
            null
        );
        
        List<String> tables = new ArrayList<>();
        while (cursor.moveToNext()) {
            tables.add(cursor.getString(0));
        }
        cursor.close();
        
        // Verify required tables
        String[] requiredTables = {"users", "settings", "data"}; // Replace with your tables
        for (String requiredTable : requiredTables) {
            if (!tables.contains(requiredTable)) {
                Log.e(TAG, "Missing table: " + requiredTable);
                return false;
            }
        }
        
        // Check data integrity (optional)
        // Run test queries to ensure data is readable
        
        return true;
        
    } catch (Exception e) {
        Log.e(TAG, "Database validation failed", e);
        return false;
    } finally {
        if (db != null) db.close();
    }
}
```

#### 4.5. User-Facing Flow

**Before Restore:**
```
Dialog Title: "Restore Data"
Message: "Backup file version: 5
         Current app version: 7
         
         The backup will be upgraded automatically.
         Your current data will be replaced.
         
         Continue?"
Buttons: "Restore", "Cancel"
```

**During Restore:**
```
Progress Dialog: "Restoring data..."
- Validating backup file
- Migrating database schema
- Verifying data integrity
```

**After Restore (Success):**
```
Dialog: "Restore completed successfully. 
         The app will now restart."
Button: "OK" → Restart app
```

**After Restore (Failure):**
```
Dialog: "Restore failed: [error message]
         Your data has not been changed."
Button: "OK"
```

---

## 3. Implementation Guide: Online Backup (Recommended for apps with accounts)

- **Service:** Google Drive API or Firebase (Firestore/Realtime Database) are recommended.
- **Authentication:** The user must be signed in with their Google Account.
- **Data Sync:** Instead of file copying, data is typically synced record by record or as a JSON object.
- **Auto-Backup:** Android's built-in Auto Backup for Apps can be a simpler alternative for key-value data (`SharedPreferences`) and files, but for structured `SQLite` data, a more robust solution like the Google Drive API is better.

**Considerations:**
- **Data Merging:** Handle conflicts if data has changed on both the device and the cloud.
- **Cost:** Cloud storage and operations may have associated costs.
- **Privacy:** Be transparent with the user about what data is being stored online.
