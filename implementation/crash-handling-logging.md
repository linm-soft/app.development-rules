# 🛡️ Crash Handling & Error Recovery

> **Status:** ⚠️ CRITICAL - Required for all Android projects
> **Last Updated:** December 13, 2025
> **Integration:** Works with LogHelper system for unified logging

---

## 📋 Overview

Crash handling system providing:
1. **Global ExceptionHandler** - Catches unhandled exceptions
2. **User-friendly error dialogs** - Recovery options instead of "App has stopped"
3. **Automatic crash logging** - Integration with LogHelper.crash()
4. **App restart mechanism** - Graceful recovery from crashes

---

## 🎯 Architecture

```
Exception Occurs
    ↓
ExceptionHandler.uncaughtException()
    ↓
LogHelper.crash() → Save to file
    ↓
Show user-friendly dialog
    ↓
User chooses: [Restart] or [Close]
    ↓
Recovery action executed
```

---

## 🔧 Implementation

### Step 1: Enhanced ExceptionHandler.java

**Location:** `app/src/main/java/com/yourapp/util/ExceptionHandler.java`

```java
package com.yourapp.util;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.provider.MediaStore;
import android.widget.Toast;

import com.yourapp.R;
import com.yourapp.ui.main.MainActivity;
import com.yourapp.utils.LogHelper;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Global exception handler integrated with LogHelper
 * Provides crash logging and user recovery options
 */
public class ExceptionHandler implements Thread.UncaughtExceptionHandler {
    private final Context context;
    private final Thread.UncaughtExceptionHandler defaultHandler;
    private Activity lastActivity;
    
    public ExceptionHandler(Context context) {
        this.context = context;
        this.defaultHandler = Thread.getDefaultUncaughtExceptionHandler();
    }
    
    public void setLastActivity(Activity activity) {
        this.lastActivity = activity;
    }
    
    @Override
    public void uncaughtException(Thread thread, Throwable ex) {
        try {
            // Log crash using LogHelper (always enabled for crashes)
            LogHelper.crash("Uncaught exception in thread: " + thread.getName(), ex);
            
            // Save crash details to file
            saveLogFile(formatCrashLog(ex));
            
            // Show user-friendly dialog if possible
            if (lastActivity != null && !lastActivity.isFinishing()) {
                showCrashDialog(lastActivity, ex);
                return;
            }
            
        } catch (Exception e) {
            LogHelper.crash("Failed to handle exception gracefully", e);
        }
        
        // Fallback to default handler
        defaultHandler.uncaughtException(thread, ex);
    }
    
    private void showCrashDialog(Activity activity, Throwable ex) {
        try {
            new Handler(Looper.getMainLooper()).post(() -> {
                try {
                    AlertDialog dialog = new AlertDialog.Builder(activity)
                        .setTitle("Oops! Something went wrong")
                        .setMessage("The app encountered an unexpected error. Would you like to restart the app or close it?")
                        .setPositiveButton("Restart App", (d, which) -> {
                            d.dismiss();
                            restartApp();
                        })
                        .setNegativeButton("Close App", (d, which) -> {
                            d.dismiss();
                            Process.killProcess(Process.myPid());
                        })
                        .setCancelable(false)
                        .create();
                    
                    dialog.show();
                    
                    // Auto-close after 10 seconds if user doesn't respond
                    new Handler().postDelayed(() -> {
                        if (dialog.isShowing()) {
                            dialog.dismiss();
                            restartApp();
                        }
                    }, 10000);
                    
                } catch (Exception e) {
                    LogHelper.e(TAG, "Error showing dialog", e);
                    restartApp();
                }
            });
            
            // Wait for user interaction
            try {
                Thread.sleep(15000); // Give time for user dialog
            } catch (InterruptedException e) {
                LogHelper.e(TAG, "Thread interrupted", e);
            }
            
        } catch (Exception e) {
            LogHelper.e(TAG, "Failed to show AlertDialog", e);
            defaultHandler.uncaughtException(Thread.currentThread(), ex);
        }
    }
    
    private void restartApp() {
        try {
            Intent intent = new Intent(context, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            context.startActivity(intent);
            
            // Kill current process
            android.os.Process.killProcess(android.os.Process.myPid());
            
        } catch (Exception e) {
            LogHelper.crash(TAG, "Failed to restart app", e);
            Process.killProcess(Process.myPid());
        }
    }
    
    private String formatCrashLog(Throwable ex) {
        StringBuilder log = new StringBuilder();
        
        // Header
        log.append("=== CRASH REPORT ===\\n");
        log.append("Time: ").append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(new Date())).append("\\n");
        log.append("App: ").append(context.getPackageName()).append("\\n");
        log.append("Android: ").append(Build.VERSION.RELEASE).append(" (API ").append(Build.VERSION.SDK_INT).append(")\\n");
        log.append("Device: ").append(Build.MANUFACTURER).append(" ").append(Build.MODEL).append("\\n");
        log.append("\\n");
        
        // Exception details
        log.append("Exception Type: ").append(ex.getClass().getSimpleName()).append("\\n");
        log.append("Message: ").append(ex.getMessage()).append("\\n");
        log.append("\\n");
        
        // Stack trace
        log.append("Stack Trace:\\n");
        for (StackTraceElement element : ex.getStackTrace()) {
            log.append("  at ").append(element.toString()).append("\\n");
        }
        
        // Caused by (if any)
        Throwable cause = ex.getCause();
        while (cause != null) {
            log.append("\\nCaused by: ").append(cause.getClass().getSimpleName());
            if (cause.getMessage() != null) {
                log.append(": ").append(cause.getMessage());
            }
            log.append("\\n");
            for (StackTraceElement element : cause.getStackTrace()) {
                log.append("  at ").append(element.toString()).append("\\n");
            }
            cause = cause.getCause();
        }
        
        return log.toString();
    }
    
    private void saveLogFile(String content) {
        try {
            String timestamp = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.getDefault()).format(new Date());
            String appId = context.getPackageName().replace(".", "_");
            String fileName = "crash_log_" + timestamp + ".txt";
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Android 10+ - Use MediaStore
                ContentValues values = new ContentValues();
                values.put(MediaStore.Downloads.DISPLAY_NAME, fileName);
                values.put(MediaStore.Downloads.MIME_TYPE, "text/plain");
                values.put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS + "/" + appId);
                
                Uri uri = context.getContentResolver().insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values);
                if (uri != null) {
                    try (OutputStream outputStream = context.getContentResolver().openOutputStream(uri)) {
                        if (outputStream != null) {
                            outputStream.write(content.getBytes());
                            LogHelper.crash("Crash log saved to Downloads/" + appId + " using MediaStore", null);
                        }
                    }
                }
            } else {
                // Android 9 and below - Direct file access
                File downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
                File appDir = new File(downloadsDir, appId);
                if (!appDir.exists()) {
                    appDir.mkdirs();
                }
                
                File logFile = new File(appDir, fileName);
                try (FileOutputStream fos = new FileOutputStream(logFile)) {
                    fos.write(content.getBytes());
                    LogHelper.crash("Crash log saved to: " + logFile.getAbsolutePath(), null);
                }
            }
        } catch (IOException e) {
            LogHelper.crash("Failed to save crash log file", e);
        }
    }
    
    private void restartApp() {
        try {
            Intent intent = new Intent(context, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
            Process.killProcess(Process.myPid());
        } catch (Exception e) {
            LogHelper.crash("Failed to restart app", e);
            Process.killProcess(Process.myPid());
        }
    }
}
```

---

## 📱 Integration with LogHelper System

### Key Integration Points:

1. **Always Log Crashes**: `LogHelper.crash()` calls are never affected by debug toggle
2. **Unified Format**: Crash logs follow same format as other LogHelper categories
3. **File Storage**: Crashes are saved both via LogHelper and ExceptionHandler
4. **UI Access**: Crash logs visible in LogViewerActivity alongside other logs

### Usage Examples:

**In any component**:
```java
try {
    // Risky operation
} catch (Exception e) {
    LogHelper.crash("Operation failed in ComponentName", e);
    // Handle gracefully
}
```

**In ExceptionHandler**:
```java
LogHelper.crash("Uncaught exception in thread: " + thread.getName(), ex);
```

---

## 📱 Application Integration

### Step 1: Application Class Setup

**File**: `DailySpeakApplication.java`
```java
import com.yourpackage.util.ExceptionHandler;

public class YourApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        // Initialize the exception handler
        Thread.setDefaultUncaughtExceptionHandler(new ExceptionHandler(this));
    }
}
```java
package com.yourapp;

import android.app.Application;
import com.yourapp.util.ExceptionHandler;
import com.yourapp.utils.DebugSettings;

public class DailySpeakApplication extends Application {
    private ExceptionHandler exceptionHandler;

    @Override
    public void onCreate() {
        super.onCreate();
        
        // Initialize crash handling
        exceptionHandler = new ExceptionHandler(this);
        Thread.setDefaultUncaughtExceptionHandler(exceptionHandler);
        
        // Load debug settings for LogHelper toggle
        DebugSettings.loadDebugSettings(this);
    }
    
    // Call this from each activity's onCreate
    public void setLastActivity(Activity activity) {
        if (exceptionHandler != null) {
            exceptionHandler.setLastActivity(activity);
        }
    }
}
```

### Step 2: Activity Integration

**In each Activity's onCreate()**:
```java
public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Register with exception handler for user-friendly dialogs
        DailySpeakApplication app = (DailySpeakApplication) getApplication();
        app.setLastActivity(this);
        
        // Rest of activity setup
    }
}
```

---

## 📋 Manifest Configuration

**File**: `AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourapp">

    <!-- Required for crash log saving on Android 9 and below -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
        android:maxSdkVersion="28" />

    <application
        android:name=".DailySpeakApplication"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme">
        
        <!-- Activities here -->
        
    </application>

</manifest>
```

---

## ✅ Testing & Validation

### Test Crash Recovery:

```java
// Add this to any activity for testing
Button crashButton = findViewById(R.id.crash_test_button);
crashButton.setOnClickListener(v -> {
    throw new RuntimeException("Test crash - checking recovery system");
});
```

**Expected behavior**:
1. Exception thrown → ExceptionHandler catches it
2. Crash logged via `LogHelper.crash()` 
3. File saved to Downloads folder
4. User sees friendly dialog with restart/close options
5. App recovers gracefully instead of "App has stopped"

---

## 🔍 Log Viewing

Crash logs are accessible through:

1. **LogViewerActivity**: Integrated view with toggle for crash/app logs
2. **File System**: Downloads/[package_name]/crash_log_*.txt files  
3. **LogHelper Integration**: Same format as other log categories

This provides a complete crash handling solution integrated with the LogHelper toggle system!
