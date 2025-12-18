# Error Handling & Crash Prevention

> **Status:** ⚠️ REQUIRED for all Android projects
> **Last Updated:** December 2024

---

## 📋 Overview

Error handling in Android requires a **two-level defense strategy**:

1. **Global Exception Handler** - Catches all unhandled exceptions (last resort)
2. **Local Try-Catch Blocks** - Handles specific errors gracefully (primary defense)

**Both levels are REQUIRED** - they serve different purposes and complement each other.

---

## 🎯 Core Principle: Defense in Depth + Null Safety

```
User Action
    ↓
Null Safety Validation (Level 3) ← **NEW: Proactive prevention**
    ↓
Local Try-Catch (Level 2) ← Primary defense
    ↓ (if error escapes)
Global Handler (Level 1) ← Safety net
    ↓ (if both fail)
System Crash Dialog ← What we want to avoid
```

**⚠️ INTEGRATION:** Null safety (Rule 2.29) must be applied BEFORE error handling patterns

---

## 🛡️ Level 1: Global Exception Handler (REQUIRED)

### Purpose
- **Last resort** safety net when local error handling fails
- Prevents "App has stopped" system dialog
- Shows user-friendly error dialog with recovery options
- Logs crash details for debugging

### Implementation Steps

#### Step 1: Create ExceptionHandler.java

**Location:** `app/src/main/java/com/yourapp/util/ExceptionHandler.java`

```java
package com.yourapp.util;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.os.Process;
import android.util.Log;
import android.widget.Toast;

import com.yourapp.R;
import com.yourapp.ui.main.MainActivity;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Global Exception Handler
 * Catches uncaught exceptions and handles gracefully without crashing the app
 * Shows error dialog and optionally restarts the app
 * 
 * @author Your Name
 */
public class ExceptionHandler implements Thread.UncaughtExceptionHandler {

    private static final String TAG = "ExceptionHandler";
    private static final boolean RESTART_ON_CRASH = true;

    private final Context context;
    private final Thread.UncaughtExceptionHandler defaultHandler;
    private Activity lastActivity = null;

    public ExceptionHandler(Context context) {
        this.context = context.getApplicationContext();
        this.defaultHandler = Thread.getDefaultUncaughtExceptionHandler();
    }

    public void setLastActivity(Activity activity) {
        this.lastActivity = activity;
    }

    @Override
    public void uncaughtException(Thread thread, Throwable ex) {
        try {
            Log.e(TAG, "Uncaught exception occurred!", ex);
            
            // Write crash log
            writeExceptionToFile(ex);
            
            // Show error to user on UI thread
            showErrorDialog(ex);
            
        } catch (Exception e) {
            Log.e(TAG, "Failed to handle exception.", e);
            // Last resort - call default handler
            if (defaultHandler != null) {
                defaultHandler.uncaughtException(thread, ex);
            }
        }
    }

    private void showErrorDialog(Throwable ex) {
        try {
            new Handler(Looper.getMainLooper()).post(() -> {
                try {
                    String errorMessage = getErrorMessage(ex);
                    
                    if (lastActivity != null && !lastActivity.isFinishing()) {
                        showAlertDialog(lastActivity, errorMessage);
                    } else {
                        Toast.makeText(context, 
                            context.getString(R.string.error_occurred) + "\n" + errorMessage, 
                            Toast.LENGTH_LONG).show();
                        
                        if (RESTART_ON_CRASH) {
                            new Handler(Looper.getMainLooper()).postDelayed(this::restartApp, 2000);
                        }
                    }
                } catch (Exception e) {
                    Log.e(TAG, "Error showing dialog", e);
                    Process.killProcess(Process.myPid());
                    System.exit(10);
                }
            });
            
            Thread.sleep(5000);
            
        } catch (InterruptedException e) {
            Log.e(TAG, "Thread interrupted", e);
        }
    }

    private void showAlertDialog(Activity activity, String errorMessage) {
        try {
            new AlertDialog.Builder(activity)
                .setTitle(R.string.error_title)
                .setMessage(context.getString(R.string.error_occurred) + "\n\n" + errorMessage)
                .setPositiveButton(R.string.restart_app, (dialog, which) -> restartApp())
                .setNegativeButton(R.string.close, (dialog, which) -> {
                    dialog.dismiss();
                    if (RESTART_ON_CRASH) {
                        Process.killProcess(Process.myPid());
                        System.exit(10);
                    }
                })
                .setCancelable(false)
                .show();
        } catch (Exception e) {
            Log.e(TAG, "Failed to show AlertDialog", e);
            restartApp();
        }
    }

    private String getErrorMessage(Throwable ex) {
        String message = ex.getMessage();
        if (message == null || message.isEmpty()) {
            message = ex.getClass().getSimpleName();
        }
        
        if (message.length() > 150) {
            message = message.substring(0, 150) + "...";
        }
        
        return message;
    }

    private void restartApp() {
        try {
            Intent intent = new Intent(context, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            context.startActivity(intent);
            
            Process.killProcess(Process.myPid());
            System.exit(10);
        } catch (Exception e) {
            Log.e(TAG, "Failed to restart app", e);
            Process.killProcess(Process.myPid());
            System.exit(10);
        }
    }

    private void writeExceptionToFile(Throwable ex) {
        try {
            StringWriter sw = new StringWriter();
            ex.printStackTrace(new PrintWriter(sw));
            String stackTrace = sw.toString();

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
            String logContent = "CRASH REPORT\n"
                    + "==============\n"
                    + "Timestamp: " + sdf.format(new Date()) + "\n"
                    + "\n--- STACK TRACE ---\n\n"
                    + stackTrace;

            // Generate unique filename with timestamp
            SimpleDateFormat filenameSdf = new SimpleDateFormat("yyyy-MM-dd_HHmmss", Locale.getDefault());
            String logFileName = "crash_log_" + filenameSdf.format(new Date()) + ".txt";

            Log.i(TAG, "Crash logged to: " + logFileName);
            // TODO: Write to file in Downloads/{appId}/ folder
        } catch (Exception e) {
            Log.e(TAG, "Error writing crash log", e);
        }
    }
}
```

#### Step 2: Register in Application Class

**Location:** `app/src/main/java/com/yourapp/YourApplication.java`

```java
package com.yourapp;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.yourapp.util.ExceptionHandler;

public class YourApplication extends Application {
    private ExceptionHandler exceptionHandler;
    
    @Override
    public void onCreate() {
        super.onCreate();
        
        // ⚠️ CRITICAL: Set up FIRST before any other initialization
        exceptionHandler = new ExceptionHandler(this);
        Thread.setDefaultUncaughtExceptionHandler(exceptionHandler);
        
        // Register activity lifecycle callbacks
        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
                exceptionHandler.setLastActivity(activity);
            }

            @Override
            public void onActivityStarted(@NonNull Activity activity) {
                exceptionHandler.setLastActivity(activity);
            }

            @Override
            public void onActivityResumed(@NonNull Activity activity) {
                exceptionHandler.setLastActivity(activity);
            }

            @Override
            public void onActivityPaused(@NonNull Activity activity) {}

            @Override
            public void onActivityStopped(@NonNull Activity activity) {}

            @Override
            public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {}

            @Override
            public void onActivityDestroyed(@NonNull Activity activity) {}
        });
        
        // Rest of initialization...
    }
}
```

#### Step 3: Register Application in AndroidManifest.xml

```xml
<application
    android:name=".YourApplication"
    android:icon="@mipmap/ic_launcher"
    android:label="@string/app_name">
    <!-- ... -->
</application>
```

#### Step 4: Add Required String Resources

**values/strings.xml:**
```xml
<!-- Error Handling -->
<string name="error_title">Oops! Something went wrong</string>
<string name="error_occurred">An error occurred</string>
<string name="restart_app">Restart App</string>
<string name="close">Close</string>
```

**values-vi/strings.xml:**
```xml
<!-- Error Handling -->
<string name="error_title">Rất tiếc! Đã xảy ra lỗi</string>
<string name="error_occurred">Đã xảy ra lỗi</string>
<string name="restart_app">Khởi động lại</string>
<string name="close">Đóng</string>
```

---

## 🎯 Level 2: Local Try-Catch Blocks (PRIMARY DEFENSE)

### When to Use Try-Catch

**REQUIRED for these operations:**

| Operation Type | Risk | Example |
|----------------|------|---------|
| Database operations | SQL errors, database locked | SQLiteException |
| Network calls | Timeout, no internet | IOException, SocketException |
| File I/O | Permission denied, disk full | IOException, FileNotFoundException |
| JSON parsing | Malformed data | JSONException |
| Media playback | Codec issues, file corrupt | MediaPlayer exceptions |
| UI with external data | Null values, invalid URLs | NullPointerException, IllegalStateException |

### Critical Sections Requiring Try-Catch

#### 1. Database Operations (REQUIRED)

```java
private void initDatabase() {
    try {
        DatabaseHelper dbHelper = DatabaseHelper.getInstance(requireContext());
        if (dbHelper != null) {
            newsDb = new NewsDbHelper(dbHelper);
        }
        feedParser = new RssFeedParser(requireContext());
        audioPlayer = NewsAudioPlayer.getInstance(requireContext());
    } catch (SQLException e) {
        Log.e(TAG, "Database error", e);
        showError(getString(R.string.database_error));
    } catch (Exception e) {
        Log.e(TAG, "Failed to initialize services", e);
        showError(getString(R.string.error_occurred));
    }
}

private void loadData() {
    new Thread(() -> {
        try {
            List<Item> items = database.getAllItems();
            runOnUiThread(() -> adapter.setItems(items));
        } catch (SQLException e) {
            Log.e(TAG, "Failed to load data", e);
            runOnUiThread(() -> showError(getString(R.string.load_failed)));
        }
    }).start();
}
```

#### 2. Network Operations (REQUIRED)

```java
private void fetchNews() {
    try {
        feedParser.fetchAllFeeds(new FeedParseCallback() {
            @Override
            public void onSuccess(List<Article> articles) {
                updateUI(articles);
            }
            
            @Override
            public void onError(String error) {
                Log.e(TAG, "Network error: " + error);
                showError(getString(R.string.network_error));
            }
        });
    } catch (IOException e) {
        Log.e(TAG, "Network exception", e);
        showError(getString(R.string.network_error));
    } catch (Exception e) {
        Log.e(TAG, "Unexpected error during fetch", e);
        showError(getString(R.string.error_occurred));
    }
}
```

#### 3. File Operations (REQUIRED)

```java
private void exportData() {
    try {
        File exportFile = new File(getExternalFilesDir(null), "backup.json");
        FileOutputStream fos = new FileOutputStream(exportFile);
        fos.write(jsonData.getBytes());
        fos.close();
        
        Toast.makeText(this, R.string.export_success, Toast.LENGTH_SHORT).show();
    } catch (FileNotFoundException e) {
        Log.e(TAG, "File not found", e);
        showError(getString(R.string.file_error));
    } catch (IOException e) {
        Log.e(TAG, "Failed to write file", e);
        showError(getString(R.string.save_failed));
    }
}
```

#### 4. RecyclerView Adapter Binding (REQUIRED)

```java
@Override
public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
    try {
        NewsArticle article = articles.get(position);
        
        holder.textTitle.setText(article.getTitle());
        holder.textSource.setText(article.getSource());
        
        // Image loading with error handling
        if (article.getImageUrl() != null && !article.getImageUrl().isEmpty()) {
            Glide.with(context)
                .load(article.getImageUrl())
                .placeholder(R.drawable.ic_placeholder)
                .error(R.drawable.ic_error)
                .into(holder.imageArticle);
        } else {
            holder.imageArticle.setImageResource(R.drawable.ic_placeholder);
        }
    } catch (IndexOutOfBoundsException e) {
        Log.e(TAG, "Invalid position: " + position, e);
    } catch (Exception e) {
        Log.e(TAG, "Error binding view at position " + position, e);
    }
}
```

#### 5. Media Player Operations (REQUIRED)

```java
private void playAudio(NewsArticle article) {
    try {
        if (audioPlayer != null && article != null && article.getAudioUrl() != null) {
            audioPlayer.playArticle(article);
            updatePlayerUI(article);
        } else {
            throw new IllegalStateException("Invalid audio player state");
        }
    } catch (IllegalStateException e) {
        Log.e(TAG, "Player not ready", e);
        showError(getString(R.string.player_error));
    } catch (Exception e) {
        Log.e(TAG, "Failed to play article", e);
        showError(getString(R.string.playback_error));
    }
}
```

#### 6. Fragment Lifecycle Operations (REQUIRED)

```java
@Override
public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
    
    try {
        initViews(view);
        initDatabase();
        setupRecyclerView();
        loadArticles();
    } catch (IllegalStateException e) {
        Log.e(TAG, "Fragment not attached", e);
        if (getContext() != null) {
            Toast.makeText(getContext(), R.string.error_occurred, Toast.LENGTH_SHORT).show();
        }
    } catch (Exception e) {
        Log.e(TAG, "Failed to initialize fragment", e);
        if (isAdded() && getContext() != null) {
            showError(getString(R.string.error_occurred));
        }
    }
}
```

---

## 📊 Error Handling Strategy by Component

| Component | Primary Errors | Handling Strategy |
|-----------|---------------|-------------------|
| **Activity** | Lifecycle errors | Try-catch in onCreate/onResume |
| **Fragment** | Not attached, null context | Check isAdded() + try-catch |
| **RecyclerView Adapter** | IndexOutOfBounds, null data | Try-catch in onBindViewHolder |
| **Database Helper** | SQLiteException, locked DB | Try-catch + retry logic |
| **Network Service** | IOException, timeout | Try-catch + callback error |
| **File Manager** | FileNotFoundException, permissions | Try-catch + user prompt |
| **Media Player** | IllegalStateException | Try-catch + reset player |

---

## ✅ Best Practices

### DO:

1. **Log with Context**
```java
Log.e(TAG, "Failed to load article ID: " + articleId, exception);
```

2. **Use String Resources for User Messages**
```java
// ✅ Good
Toast.makeText(context, R.string.network_error, Toast.LENGTH_SHORT).show();

// ❌ Bad
Toast.makeText(context, exception.getMessage(), Toast.LENGTH_SHORT).show();
```

3. **Provide Recovery Options**
```java
private void showErrorWithRetry(String message) {
    new AlertDialog.Builder(this)
        .setTitle(R.string.error_title)
        .setMessage(message)
        .setPositiveButton(R.string.retry, (dialog, which) -> retryOperation())
        .setNegativeButton(R.string.cancel, null)
        .show();
}
```

4. **Null-Safe Operations**
```java
if (article != null && article.getTitle() != null) {
    textView.setText(article.getTitle());
} else {
    textView.setText(R.string.no_title);
}
```

5. **Validate Input Before Processing**
```java
public void setArticle(NewsArticle article) {
    if (article == null) {
        Log.w(TAG, "Attempted to set null article");
        return;
    }
    // Process article...
}
```

### DON'T:

1. **❌ Silent Failures**
```java
// ❌ Bad
try {
    doSomething();
} catch (Exception e) {
    // Silent failure - no log, no user feedback
}

// ✅ Good
try {
    doSomething();
} catch (Exception e) {
    Log.e(TAG, "Failed to do something", e);
    showError(getString(R.string.operation_failed));
}
```

2. **❌ Show Technical Errors to Users**
```java
// ❌ Bad - Cryptic message
Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();

// ✅ Good - User-friendly message
Toast.makeText(this, R.string.network_error, Toast.LENGTH_SHORT).show();
```

3. **❌ Catch Without Handling**
```java
// ❌ Bad - Catching too broad
try {
    riskyOperation();
} catch (Exception e) {
    // What can we do here? Too generic!
}

// ✅ Good - Specific catches
try {
    riskyOperation();
} catch (IOException e) {
    handleNetworkError(e);
} catch (JSONException e) {
    handleDataError(e);
}
```

---

## 🧪 Testing Error Handling

### Development Testing

```java
// In debug builds, test error scenarios
if (BuildConfig.DEBUG) {
    // Test global handler
    // throw new RuntimeException("Test crash");
    
    // Test local handler
    // simulateNetworkError();
    
    // Test database error
    // corruptDatabase();
}
```

### Testing Checklist

- [ ] Test with airplane mode (network errors)
- [ ] Test with full storage (file I/O errors)
- [ ] Test with corrupted database file
- [ ] Test with null/invalid data from API
- [ ] Test fragment detachment scenarios
- [ ] Test media player with invalid URLs
- [ ] Force crash to test global handler
- [ ] Verify error messages in all languages

---

## 📋 Review Checklist

When reviewing code for error handling:

- [ ] **Global Handler**
  - [ ] ExceptionHandler.java created
  - [ ] Registered in Application class
  - [ ] ActivityLifecycleCallbacks implemented
  - [ ] String resources added (EN + other languages)

- [ ] **Local Try-Catch**
  - [ ] All database operations wrapped
  - [ ] All network operations handled
  - [ ] All file I/O operations protected
  - [ ] All media player operations safe
  - [ ] All RecyclerView binding protected
  - [ ] All fragment lifecycle safe

- [ ] **Error Messages**
  - [ ] Using string resources (not hardcoded)
  - [ ] User-friendly (not technical)
  - [ ] Multilingual support
  - [ ] Actionable (tell user what to do)

- [ ] **Logging**
  - [ ] All exceptions logged with context
  - [ ] Using appropriate log levels (E, W, I, D)
  - [ ] TAG constants used consistently
  - [ ] No sensitive data logged

- [ ] **Recovery**
  - [ ] Users have retry options where applicable
  - [ ] App doesn't lock up on error
  - [ ] Data loss minimized
  - [ ] Graceful degradation implemented

---

## 🎯 Advanced Pattern: Custom Exception Hierarchy (RECOMMENDED)

### Architecture: Child Classes → Root Handler

**Concept:** Child classes throw custom exceptions, Root decides how to handle (show user or just log)

### Benefits
- ✅ **Separation of Concerns** - Business logic doesn't know about UI
- ✅ **Centralized Control** - Root decides severity and user impact
- ✅ **User-Friendly Messages** - Exceptions carry context for UI
- ✅ **Flexible Handling** - Can change display strategy without touching business logic
- ✅ **Better Testing** - Mock exceptions easily

### Implementation

#### Step 1: Create Custom Exception Hierarchy

**Location:** `app/src/main/java/com/yourapp/exception/`

```java
// Base exception
public abstract class AppException extends Exception {
    private final ErrorSeverity severity;
    private final int messageResId;
    private final boolean shouldShowToUser;
    
    public enum ErrorSeverity {
        LOW,      // Just log, don't show user
        MEDIUM,   // Show toast
        HIGH,     // Show dialog
        CRITICAL  // Show dialog + restart
    }
    
    public AppException(String message, ErrorSeverity severity, int messageResId, boolean shouldShowToUser) {
        super(message);
        this.severity = severity;
        this.messageResId = messageResId;
        this.shouldShowToUser = shouldShowToUser;
    }
    
    public AppException(String message, Throwable cause, ErrorSeverity severity, int messageResId, boolean shouldShowToUser) {
        super(message, cause);
        this.severity = severity;
        this.messageResId = messageResId;
        this.shouldShowToUser = shouldShowToUser;
    }
    
    public ErrorSeverity getSeverity() { return severity; }
    public int getMessageResId() { return messageResId; }
    public boolean shouldShowToUser() { return shouldShowToUser; }
}
```

#### Step 2: Create Specific Exception Types

```java
// Database exceptions
public class DatabaseException extends AppException {
    public DatabaseException(String message, Throwable cause) {
        super(message, cause, ErrorSeverity.MEDIUM, R.string.database_error, true);
    }
}

// Network exceptions
public class NetworkException extends AppException {
    public NetworkException(String message, Throwable cause) {
        super(message, cause, ErrorSeverity.MEDIUM, R.string.network_error, true);
    }
}

// Business logic exceptions (user-friendly)
public class InvalidOperationException extends AppException {
    public InvalidOperationException(String message) {
        super(message, ErrorSeverity.MEDIUM, R.string.invalid_operation, true);
    }
}

// Data validation exceptions
public class DataValidationException extends AppException {
    private final int customMessageResId;
    
    public DataValidationException(String message, int customMessageResId) {
        super(message, ErrorSeverity.LOW, customMessageResId, true);
        this.customMessageResId = customMessageResId;
    }
    
    @Override
    public int getMessageResId() {
        return customMessageResId; // Use specific message
    }
}

// Silent exceptions (just log, don't show)
public class CacheException extends AppException {
    public CacheException(String message, Throwable cause) {
        super(message, cause, ErrorSeverity.LOW, 0, false); // Don't show to user
    }
}
```

#### Step 3: Child Classes Throw Custom Exceptions

```java
// NewsDbHelper.java
public class NewsDbHelper {
    private static final String TAG = "NewsDbHelper";
    
    public List<NewsArticle> getAllArticles() throws DatabaseException {
        try {
            SQLiteDatabase db = dbHelper.getReadableDatabase();
            Cursor cursor = db.query("articles", null, null, null, null, null, null);
            
            List<NewsArticle> articles = new ArrayList<>();
            while (cursor.moveToNext()) {
                articles.add(parseArticle(cursor));
            }
            cursor.close();
            return articles;
            
        } catch (SQLException e) {
            Log.e(TAG, "Failed to query articles", e);
            throw new DatabaseException("Failed to load articles from database", e);
        }
    }
    
    public void insertArticle(NewsArticle article) throws DatabaseException, DataValidationException {
        // Validate first
        if (article == null || article.getTitle() == null) {
            throw new DataValidationException("Invalid article data", R.string.invalid_article);
        }
        
        try {
            SQLiteDatabase db = dbHelper.getWritableDatabase();
            ContentValues values = new ContentValues();
            values.put("title", article.getTitle());
            // ... more values
            
            long id = db.insert("articles", null, values);
            if (id == -1) {
                throw new DatabaseException("Failed to insert article", null);
            }
        } catch (SQLException e) {
            Log.e(TAG, "Insert failed", e);
            throw new DatabaseException("Failed to save article", e);
        }
    }
}

// RssFeedParser.java
public class RssFeedParser {
    private static final String TAG = "RssFeedParser";
    
    public List<NewsArticle> parseFeed(String feedUrl) throws NetworkException {
        try {
            URL url = new URL(feedUrl);
            SyndFeedInput input = new SyndFeedInput();
            SyndFeed feed = input.build(new XmlReader(url));
            
            return convertToArticles(feed);
            
        } catch (IOException e) {
            Log.e(TAG, "Network error fetching feed: " + feedUrl, e);
            throw new NetworkException("Failed to fetch news feed", e);
        } catch (Exception e) {
            Log.e(TAG, "Unexpected error parsing feed", e);
            throw new NetworkException("Failed to parse feed data", e);
        }
    }
}

// NewsAudioPlayer.java
public class NewsAudioPlayer {
    private static final String TAG = "NewsAudioPlayer";
    
    public void playArticle(NewsArticle article) throws InvalidOperationException {
        if (article == null || article.getAudioUrl() == null) {
            throw new InvalidOperationException("Cannot play article without audio URL");
        }
        
        if (player == null) {
            throw new InvalidOperationException("Audio player not initialized");
        }
        
        try {
            MediaItem mediaItem = MediaItem.fromUri(Uri.parse(article.getAudioUrl()));
            player.setMediaItem(mediaItem);
            player.prepare();
            player.play();
        } catch (Exception e) {
            Log.e(TAG, "Failed to play audio", e);
            throw new InvalidOperationException("Failed to play audio");
        }
    }
}
```

#### Step 4: Root Handler (Fragment/Activity) Decides What to Show

```java
// MainNews.java (Fragment)
public class MainNews extends Fragment {
    private static final String TAG = "MainNews";
    
    private void loadArticles() {
        new Thread(() -> {
            try {
                // Child class may throw exception
                List<NewsArticle> articles = newsDb.getAllArticles();
                
                requireActivity().runOnUiThread(() -> {
                    adapter.updateArticles(articles);
                    showEmptyState(articles.isEmpty());
                });
                
            } catch (DatabaseException e) {
                // Root decides how to handle
                handleException(e);
            }
        }).start();
    }
    
    private void refreshFeeds() {
        new Thread(() -> {
            try {
                // Multiple operations that can throw
                List<AudioFeed> feeds = newsDb.getActiveFeeds();
                
                for (AudioFeed feed : feeds) {
                    try {
                        List<NewsArticle> articles = feedParser.parseFeed(feed.getRssUrl());
                        for (NewsArticle article : articles) {
                            newsDb.insertArticle(article);
                        }
                    } catch (NetworkException e) {
                        // Network error - inform user but continue with other feeds
                        handleException(e);
                    } catch (DataValidationException e) {
                        // Invalid data - just log, don't bother user
                        handleException(e);
                    }
                }
                
                requireActivity().runOnUiThread(this::loadArticles);
                
            } catch (DatabaseException e) {
                // Critical database error - must inform user
                handleException(e);
            }
        }).start();
    }
    
    private void playArticle(NewsArticle article) {
        try {
            audioPlayer.playArticle(article);
            updatePlayerUI(article);
            
        } catch (InvalidOperationException e) {
            // User tried invalid operation - inform them
            handleException(e);
        }
    }
    
    /**
     * Centralized exception handler - Decides what to show user
     */
    private void handleException(AppException exception) {
        if (!isAdded() || getActivity() == null) return;
        
        // Always log
        Log.e(TAG, "Exception occurred: " + exception.getMessage(), exception);
        
        // Decide if user should see this
        if (!exception.shouldShowToUser()) {
            // Silent error - just logged
            return;
        }
        
        requireActivity().runOnUiThread(() -> {
            switch (exception.getSeverity()) {
                case LOW:
                    // Don't show anything - already logged
                    break;
                    
                case MEDIUM:
                    // Show toast
                    if (exception.getMessageResId() != 0) {
                        Toast.makeText(getContext(), exception.getMessageResId(), Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(getContext(), R.string.error_occurred, Toast.LENGTH_SHORT).show();
                    }
                    break;
                    
                case HIGH:
                    // Show dialog with retry option
                    showErrorDialog(exception);
                    break;
                    
                case CRITICAL:
                    // Show dialog and restart
                    showCriticalErrorDialog(exception);
                    break;
            }
        });
    }
    
    private void showErrorDialog(AppException exception) {
        new AlertDialog.Builder(requireContext())
            .setTitle(R.string.error_title)
            .setMessage(exception.getMessageResId())
            .setPositiveButton(R.string.retry, (dialog, which) -> {
                // Retry the operation based on exception type
                if (exception instanceof NetworkException) {
                    refreshFeeds();
                } else if (exception instanceof DatabaseException) {
                    loadArticles();
                }
            })
            .setNegativeButton(R.string.cancel, null)
            .show();
    }
    
    private void showCriticalErrorDialog(AppException exception) {
        new AlertDialog.Builder(requireContext())
            .setTitle(R.string.critical_error_title)
            .setMessage(exception.getMessageResId())
            .setPositiveButton(R.string.restart_app, (dialog, which) -> {
                Intent intent = new Intent(getContext(), MainActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(intent);
                requireActivity().finish();
            })
            .setCancelable(false)
            .show();
    }
}
```

#### Step 5: Application-Level Handler for Uncaught Exceptions

```java
// ExceptionHandler.java (Updated)
public class ExceptionHandler implements Thread.UncaughtExceptionHandler {
    
    @Override
    public void uncaughtException(Thread thread, Throwable ex) {
        try {
            Log.e(TAG, "Uncaught exception", ex);
            writeExceptionToFile(ex);
            
            // Check if it's our custom exception
            if (ex instanceof AppException) {
                AppException appEx = (AppException) ex;
                
                // Even uncaught, respect severity
                if (!appEx.shouldShowToUser()) {
                    // Silent error - just logged, exit gracefully
                    Process.killProcess(Process.myPid());
                    System.exit(0);
                    return;
                }
                
                // Show appropriate dialog based on severity
                showErrorDialog(appEx);
            } else {
                // Unknown exception - show generic error
                showGenericErrorDialog(ex);
            }
            
        } catch (Exception e) {
            Log.e(TAG, "Failed to handle exception", e);
            if (defaultHandler != null) {
                defaultHandler.uncaughtException(thread, ex);
            }
        }
    }
}
```

### Usage Patterns

#### Pattern 1: Chain Operations with Different Error Handling

```java
private void performComplexOperation() {
    new Thread(() -> {
        try {
            // Step 1: Network (critical - must inform user)
            List<NewsArticle> articles = feedParser.parseFeed(feedUrl);
            
            try {
                // Step 2: Save to DB (important but not critical)
                for (NewsArticle article : articles) {
                    try {
                        newsDb.insertArticle(article);
                    } catch (DataValidationException e) {
                        // Invalid data - skip this article, continue with others
                        handleException(e); // Just logs
                    }
                }
            } catch (DatabaseException e) {
                // DB error - notify user but show network results
                handleException(e); // Shows toast
            }
            
            // Update UI with what we have
            requireActivity().runOnUiThread(() -> updateUI(articles));
            
        } catch (NetworkException e) {
            // Network failed - critical, must inform user
            handleException(e); // Shows dialog with retry
        }
    }).start();
}
```

#### Pattern 2: Validation with User-Friendly Messages

```java
public void saveUserProfile(UserProfile profile) throws DataValidationException {
    if (profile.getName() == null || profile.getName().trim().isEmpty()) {
        throw new DataValidationException(
            "Name is required", 
            R.string.error_name_required // Specific message for user
        );
    }
    
    if (profile.getEmail() != null && !isValidEmail(profile.getEmail())) {
        throw new DataValidationException(
            "Invalid email format", 
            R.string.error_email_invalid
        );
    }
    
    // ... save logic
}
```

### String Resources for Custom Exceptions

```xml
<!-- values/strings.xml -->
<string name="database_error">Cannot access data. Please try again.</string>
<string name="network_error">Connection error. Check your internet.</string>
<string name="invalid_operation">This action cannot be completed.</string>
<string name="invalid_article">Invalid article data.</string>
<string name="error_name_required">Please enter your name.</string>
<string name="error_email_invalid">Please enter a valid email address.</string>
<string name="critical_error_title">Critical Error</string>
```

### Comparison: Traditional vs Custom Exception Hierarchy

| Aspect | Traditional Try-Catch | Custom Exception Hierarchy |
|--------|----------------------|---------------------------|
| Error Messages | Generic or hardcoded | User-friendly string resources |
| Control | Scattered across codebase | Centralized in root handler |
| Severity | Not specified | Clear (LOW/MEDIUM/HIGH/CRITICAL) |
| User Impact | Inconsistent handling | Consistent UX decisions |
| Testing | Hard to mock | Easy to mock exceptions |
| Maintainability | Change many files | Change one handler |
| Separation | Business + UI mixed | Clean separation |

---

## 📝 Summary

**Three-Level Defense Strategy (RECOMMENDED):**

1. **Custom Exception Hierarchy** - Child classes throw typed exceptions
   - Business logic throws specific exceptions
   - Exceptions carry severity and user message
   - Root decides show/hide based on context

2. **Root Exception Handler (Fragment/Activity)** - Centralized decision maker
   - Catches typed exceptions from children
   - Decides severity: log only vs show user
   - Shows appropriate UI: toast vs dialog vs restart
   - Provides recovery options (retry, cancel)

3. **Global Handler (Application)** - Last resort for uncaught
   - Catches anything that escaped
   - Respects exception severity even when uncaught
   - Shows error dialog + restart option

**Benefits:**
- ✅ **User-Friendly** - Clear, contextual error messages
- ✅ **Maintainable** - Centralized error handling logic
- ✅ **Flexible** - Easy to change severity/display strategy
- ✅ **Testable** - Mock exceptions in unit tests
- ✅ **Professional** - Industry-standard architecture

---

*Last updated: December 2024*
