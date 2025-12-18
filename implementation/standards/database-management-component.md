# Database Management Component Implementation

[← Back to Implementation](../)

## ⚙️ JAVA IMPLEMENTATION

### DatabaseManagementHelper.java
```java
package com.yourapp.helpers;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;
import android.os.Environment;
import android.widget.Toast;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import kotlinx.coroutines.*;

public class DatabaseManagementHelper {
    private Context context;
    private DatabaseHelper dbHelper;
    private ActivityResultLauncher<String> importLauncher;
    
    public DatabaseManagementHelper(AppCompatActivity activity, DatabaseHelper dbHelper) {
        this.context = activity;
        this.dbHelper = dbHelper;
        
        // Register file picker launcher
        this.importLauncher = activity.registerForActivityResult(
            new ActivityResultContracts.GetContent(),
            this::handleImportFile
        );
    }
    
    /**
     * Export database with user confirmation
     */
    public void exportDatabase() {
        showExportConfirmationDialog();
    }
    
    /**
     * Import database with file picker
     */
    public void importDatabase() {
        importLauncher.launch("*/*");
    }
    
    private void showExportConfirmationDialog() {
        new AlertDialog.Builder(context)
            .setTitle(context.getString(R.string.export_confirm_title))
            .setMessage(context.getString(R.string.export_confirm_message))
            .setPositiveButton(context.getString(R.string.confirm), (dialog, which) -> {
                performDatabaseExport();
            })
            .setNegativeButton(context.getString(R.string.cancel), null)
            .show();
    }
    
    private void performDatabaseExport() {
        ProgressDialog progressDialog = ProgressDialog.show(context, null, 
            context.getString(R.string.export_progress), true);
        
        // Perform export in background
        new Thread(() -> {
            try {
                boolean success = exportDatabaseToFile();
                
                // Update UI on main thread
                ((AppCompatActivity) context).runOnUiThread(() -> {
                    progressDialog.dismiss();
                    if (success) {
                        showMessage(context.getString(R.string.export_success));
                    } else {
                        showMessage(context.getString(R.string.export_failed));
                    }
                });
                
            } catch (Exception e) {
                ((AppCompatActivity) context).runOnUiThread(() -> {
                    progressDialog.dismiss();
                    showMessage(context.getString(R.string.export_failed) + ": " + e.getMessage());
                });
            }
        }).start();
    }
    
    private boolean exportDatabaseToFile() throws IOException {
        // Create backup file with timestamp
        String timestamp = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.getDefault()).format(new Date());
        String fileName = "backup_" + timestamp + ".db";
        
        File downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
        File appDir = new File(downloadsDir, context.getString(R.string.app_name));
        if (!appDir.exists()) {
            appDir.mkdirs();
        }
        
        File backupFile = new File(appDir, fileName);
        File currentDB = new File(dbHelper.getDatabasePath());
        
        // Copy database file
        try (FileInputStream inStream = new FileInputStream(currentDB);
             FileOutputStream outStream = new FileOutputStream(backupFile)) {
            
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inStream.read(buffer)) > 0) {
                outStream.write(buffer, 0, length);
            }
            outStream.flush();
        }
        
        return backupFile.exists() && backupFile.length() > 0;
    }
    
    private void handleImportFile(Uri uri) {
        if (uri != null) {
            if (isValidBackupFile(uri)) {
                showImportConfirmationDialog(uri);
            } else {
                showMessage(context.getString(R.string.import_invalid_file));
            }
        }
    }
    
    private boolean isValidBackupFile(Uri uri) {
        try {
            InputStream inputStream = context.getContentResolver().openInputStream(uri);
            if (inputStream != null) {
                // Basic validation - check file size and header if needed
                byte[] buffer = new byte[16];
                int bytesRead = inputStream.read(buffer);
                inputStream.close();
                
                // SQLite files start with "SQLite format 3"
                String header = new String(buffer, 0, Math.min(bytesRead, 15));
                return header.startsWith("SQLite format 3");
            }
        } catch (Exception e) {
            return false;
        }
        return false;
    }
    
    private void showImportConfirmationDialog(Uri uri) {
        new AlertDialog.Builder(context)
            .setTitle(context.getString(R.string.import_confirm_title))
            .setMessage(context.getString(R.string.import_confirm_message))
            .setPositiveButton(context.getString(R.string.confirm), (dialog, which) -> {
                performDatabaseImport(uri);
            })
            .setNegativeButton(context.getString(R.string.cancel), null)
            .show();
    }
    
    private void performDatabaseImport(Uri uri) {
        ProgressDialog progressDialog = ProgressDialog.show(context, null,
            context.getString(R.string.import_progress), true);
        
        new Thread(() -> {
            try {
                boolean success = importDatabaseFromFile(uri);
                
                ((AppCompatActivity) context).runOnUiThread(() -> {
                    progressDialog.dismiss();
                    if (success) {
                        showMessage(context.getString(R.string.import_success));
                    } else {
                        showMessage(context.getString(R.string.import_failed));
                    }
                });
                
            } catch (Exception e) {
                ((AppCompatActivity) context).runOnUiThread(() -> {
                    progressDialog.dismiss();
                    showMessage(context.getString(R.string.import_failed) + ": " + e.getMessage());
                });
            }
        }).start();
    }
    
    private boolean importDatabaseFromFile(Uri uri) throws IOException {
        File currentDB = new File(dbHelper.getDatabasePath());
        File backupDB = new File(currentDB.getParent(), currentDB.getName() + ".backup");
        
        try {
            // Create backup of current database
            copyFile(currentDB, backupDB);
            
            // Import new database
            try (InputStream inputStream = context.getContentResolver().openInputStream(uri);
                 FileOutputStream outputStream = new FileOutputStream(currentDB)) {
                
                if (inputStream != null) {
                    byte[] buffer = new byte[1024];
                    int length;
                    while ((length = inputStream.read(buffer)) > 0) {
                        outputStream.write(buffer, 0, length);
                    }
                    outputStream.flush();
                }
            }
            
            // Verify imported database
            if (isValidDatabase(currentDB)) {
                // Delete backup file if import successful
                backupDB.delete();
                return true;
            } else {
                // Restore from backup if import failed
                copyFile(backupDB, currentDB);
                backupDB.delete();
                return false;
            }
            
        } catch (Exception e) {
            // Restore from backup on error
            if (backupDB.exists()) {
                copyFile(backupDB, currentDB);
                backupDB.delete();
            }
            throw e;
        }
    }
    
    private void copyFile(File src, File dst) throws IOException {
        try (FileInputStream inStream = new FileInputStream(src);
             FileOutputStream outStream = new FileOutputStream(dst)) {
            
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inStream.read(buffer)) > 0) {
                outStream.write(buffer, 0, length);
            }
            outStream.flush();
        }
    }
    
    private boolean isValidDatabase(File dbFile) {
        try {
            SQLiteDatabase db = SQLiteDatabase.openDatabase(
                dbFile.getAbsolutePath(), 
                null, 
                SQLiteDatabase.OPEN_READONLY
            );
            db.close();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    private void showMessage(String message) {
        Toast.makeText(context, message, Toast.LENGTH_LONG).show();
    }
}
```

### Usage in Activity/Fragment
```java
public class MainActivity extends AppCompatActivity {
    private DatabaseManagementHelper dbManager;
    private Button btnExportDatabase, btnImportDatabase;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Initialize database management helper
        DatabaseHelper dbHelper = new DatabaseHelper(this);
        dbManager = new DatabaseManagementHelper(this, dbHelper);
        
        // Setup UI
        setupDatabaseManagementSection();
    }
    
    private void setupDatabaseManagementSection() {
        btnExportDatabase = findViewById(R.id.btnExportDatabase);
        btnImportDatabase = findViewById(R.id.btnImportDatabase);
        
        btnExportDatabase.setOnClickListener(v -> dbManager.exportDatabase());
        btnImportDatabase.setOnClickListener(v -> dbManager.importDatabase());
    }
}
```

## 🎨 UI IMPLEMENTATION

### section_database_management.xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.cardview.widget.CardView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    style="@style/Card"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_marginBottom="@dimen/spacing_normal">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="@dimen/spacing_normal">

        <!-- Section Title -->
        <TextView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="@string/data_management_title"
            android:textColor="@color/text_primary"
            android:textSize="@dimen/text_size_large"
            android:textStyle="bold"
            android:layout_marginBottom="@dimen/spacing_normal" />

        <!-- Export Database -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:gravity="center_vertical"
            android:layout_marginBottom="@dimen/spacing_medium">

            <LinearLayout
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:orientation="vertical">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/export_database_title"
                    android:textColor="@color/text_primary"
                    android:textSize="@dimen/text_size_medium"
                    android:textStyle="bold" />

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/export_database_desc"
                    android:textColor="@color/text_secondary"
                    android:textSize="@dimen/text_size_small"
                    android:layout_marginTop="@dimen/spacing_tiny" />
            </LinearLayout>

            <Button
                android:id="@+id/btnExportDatabase"
                android:layout_width="wrap_content"
                android:layout_height="@dimen/button_height_small"
                android:text="@string/export_button"
                android:textColor="@android:color/white"
                android:background="@drawable/button_background"
                android:backgroundTint="@color/primary"
                android:textSize="@dimen/text_size_small"
                android:paddingStart="@dimen/spacing_normal"
                android:paddingEnd="@dimen/spacing_normal" />
        </LinearLayout>

        <!-- Import Database -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:gravity="center_vertical"
            android:layout_marginBottom="@dimen/spacing_medium">

            <LinearLayout
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:orientation="vertical">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/import_database_title"
                    android:textColor="@color/text_primary"
                    android:textSize="@dimen/text_size_medium"
                    android:textStyle="bold" />

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/import_database_desc"
                    android:textColor="@color/text_secondary"
                    android:textSize="@dimen/text_size_small"
                    android:layout_marginTop="@dimen/spacing_tiny" />
            </LinearLayout>

            <Button
                android:id="@+id/btnImportDatabase"
                android:layout_width="wrap_content"
                android:layout_height="@dimen/button_height_small"
                android:text="@string/import_button"
                android:textColor="@android:color/white"
                android:background="@drawable/button_background"
                android:backgroundTint="@color/primary"
                android:textSize="@dimen/text_size_small"
                android:paddingStart="@dimen/spacing_normal"
                android:paddingEnd="@dimen/spacing_normal" />
        </LinearLayout>

        <!-- Storage Info -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:background="@color/background_light"
            android:padding="@dimen/spacing_medium"
            android:layout_marginTop="@dimen/spacing_medium"
            android:gravity="center_vertical">
            
            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="ℹ️"
                android:textSize="16sp"
                android:layout_marginEnd="@dimen/spacing_small" />
            
            <TextView
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:text="@string/storage_info"
                android:textColor="@color/text_secondary"
                android:textSize="@dimen/text_size_small"
                android:lineSpacingExtra="2dp" />
        </LinearLayout>

    </LinearLayout>

</androidx.cardview.widget.CardView>
```

## 📝 REQUIRED STRING RESOURCES

### strings.xml
```xml
<resources>
    <!-- Data Management Section -->
    <string name="data_management_title">Data Management</string>
    
    <!-- Export Database -->
    <string name="export_database_title">Export Database</string>
    <string name="export_database_desc">Backup your data to external storage</string>
    <string name="export_button">EXPORT</string>
    <string name="export_confirm_title">Export Database</string>
    <string name="export_confirm_message">This will create a backup file containing all your data. The backup will be saved to Downloads folder. Continue?</string>
    <string name="export_success">Database exported successfully to Downloads folder</string>
    <string name="export_failed">Failed to export database</string>
    <string name="export_progress">Exporting database...</string>
    
    <!-- Import Database -->
    <string name="import_database_title">Import Database</string>
    <string name="import_database_desc">Restore data from backup file</string>
    <string name="import_button">IMPORT</string>
    <string name="import_confirm_title">Import Database</string>
    <string name="import_confirm_message">This will replace ALL current data with backup data. This action cannot be undone. Make sure you have a backup of your current data before proceeding. Continue?</string>
    <string name="import_success">Database imported successfully</string>
    <string name="import_failed">Failed to import database</string>
    <string name="import_invalid_file">Invalid backup file. Please select a valid database backup file.</string>
    <string name="import_progress">Importing database...</string>
    
    <!-- Storage Info -->
    <string name="storage_info">Backup files are saved to Downloads/[AppName]/ folder and can be accessed from any file manager.</string>
    
    <!-- Common -->
    <string name="cancel">Cancel</string>
    <string name="confirm">Confirm</string>
    <string name="ok">OK</string>
</resources>
```

## 🔧 REQUIRED PERMISSIONS

### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
    android:maxSdkVersion="28" />
```

**📂 Note**: This implementation uses design standards from [Spacing Standards](../standards/spacing-padding-standards.md), [Border Standards](../standards/border-shape-standards.md), and [Style System](../standards/style-system-architecture.md)