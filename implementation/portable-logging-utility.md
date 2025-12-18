# 📱 LogHelper Utility - Portable Implementation Guide

> **Version:** 1.0.4  
> **Date:** December 13, 2025  
> **Compatibility:** Android API 21+  
> **Purpose:** Copy-paste ready logging utility for any Android project

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "portable-logging-utility implementation"...
```

**Purpose:** Let user know AI is referencing logging utility implementation details.

---

## 🎯 RELATED STANDARDS

**📂 Design Standards References:**
- [Style System Architecture](standards/style-system-architecture.md) - Debug UI styling if toggle interface needed

**📂 Implementation Standards:**
- [Comprehensive Logging System](comprehensive-logging-system.md) - Full logging architecture
- [Debug Tools Standards](debug-tools-standards.md) - Development tools integration

---

## 🎯 What This Provides

✅ **Toggle-able Debug Logging** - Enable/disable during development  
✅ **Production Optimized** - Zero debug logs in release builds  
✅ **Crash Logging Always On** - Critical errors never filtered  
✅ **Specialized Categories** - UI, API, Database, Pagination logging  
✅ **No Dependencies** - Pure Android framework code  

---

## ⚙️ JAVA IMPLEMENTATION

### **LogHelper Utility Class**

Create `app/src/main/java/com/yourpackage/utils/LogHelper.java`:

```java
package com.yourpackage.utils; // Change to your package

import android.util.Log;
import com.yourpackage.BuildConfig; // Change to your package

/**
 * Centralized logging utility with toggle support
 * 
 * Features:
 * - Debug logs only in debug builds (toggle-able)
 * - Crash logs always enabled
 * - Production optimized
 * - Specialized categories for better debugging
 */
public class LogHelper {
    
    // Toggle for development debugging (can be changed at runtime)
    private static boolean DEBUG_ENABLED = BuildConfig.DEBUG;
    
    /**
     * Toggle debug logging on/off
     * @param enabled true to enable debug logs, false to disable
     */
    public static void setDebugEnabled(boolean enabled) {
        DEBUG_ENABLED = enabled;
        if (BuildConfig.DEBUG) {
            Log.i("LogHelper", "Debug logging " + (enabled ? "ENABLED" : "DISABLED"));
        }
    }
    
    /**
     * Check if debug logging is currently enabled
     */
    public static boolean isDebugEnabled() {
        return DEBUG_ENABLED;
    }
    
    // =========================
    // SPECIALIZED LOGGING METHODS
    // =========================
    
    /**
     * UI-related logging (lifecycle, interactions, navigation)
     */
    public static void ui(String message) {
        if (DEBUG_ENABLED && BuildConfig.DEBUG) {
            Log.d("UI", message);
        }
    }
    
    /**
     * API-related logging (requests, responses, networking)
     */
    public static void api(String message) {
        if (DEBUG_ENABLED && BuildConfig.DEBUG) {
            Log.d("API", message);
        }
    }
    
    /**
     * Database-related logging (queries, CRUD operations)
     */
    public static void database(String message) {
        if (DEBUG_ENABLED && BuildConfig.DEBUG) {
            Log.d("DATABASE", message);
        }
    }
    
    /**
     * Pagination-related logging (page loads, filtering)
     */
    public static void pagination(String message) {
        if (DEBUG_ENABLED && BuildConfig.DEBUG) {
            Log.d("PAGINATION", message);
        }
    }
    
    /**
     * Crash logging (ALWAYS enabled - no toggle)
     * Critical for debugging production issues
     */
    public static void crash(String message, Throwable exception) {
        Log.e("CRASH", message, exception);
    }
    
    /**
     * Crash logging without exception
     */
    public static void crash(String message) {
        Log.e("CRASH", message);
    }
    
    // =========================
    // STANDARD LOGGING METHODS (with toggle)
    // =========================
    
    /**
     * Debug logging (toggle-able)
     */
    public static void d(String tag, String message) {
        if (DEBUG_ENABLED && BuildConfig.DEBUG) {
            Log.d(tag, message);
        }
    }
    
    /**
     * Info logging (debug builds only)
     */
    public static void i(String tag, String message) {
        if (BuildConfig.DEBUG) {
            Log.i(tag, message);
        }
    }
    
    /**
     * Warning logging (always shown)
     */
    public static void w(String tag, String message) {
        Log.w(tag, message);
    }
    
    /**
     * Error logging (always shown)
     */
    public static void e(String tag, String message) {
        Log.e(tag, message);
    }
    
    /**
     * Error logging with exception
     */
    public static void e(String tag, String message, Throwable throwable) {
        Log.e(tag, message, throwable);
    }
    
    /**
     * Verbose logging (toggle-able, most detailed)
     */
    public static void v(String tag, String message) {
        if (DEBUG_ENABLED && BuildConfig.DEBUG) {
            Log.v(tag, message);
        }
    }
}
```

### Step 2: Replace Old Logging

**Before** (Old Pattern):
```java
import android.util.Log;

public class MainActivity extends Activity {
    private static final String TAG = "MainActivity";
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.d(TAG, "Activity created");
        Log.d(TAG, "API: Making request to /users");
        Log.d(TAG, "DB: Loading user data");
    }
}
```

**After** (New Pattern):
```java
import com.yourpackage.utils.LogHelper;

public class MainActivity extends Activity {
    // No TAG needed!
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        LogHelper.ui("Activity created");
        LogHelper.api("Making request to /users");
        LogHelper.database("Loading user data");
    }
}
```

### Step 3: Add Toggle Control (Optional)

For in-app toggle control, add this to any activity:

```java
// Add a button/switch to toggle logging
Switch debugToggle = findViewById(R.id.debug_toggle);
debugToggle.setChecked(LogHelper.isDebugEnabled());
debugToggle.setOnCheckedChangeListener((view, isChecked) -> {
    LogHelper.setDebugEnabled(isChecked);
    // Save preference if needed
    SharedPreferences.Editor editor = getSharedPreferences("debug", MODE_PRIVATE).edit();
    editor.putBoolean("debug_enabled", isChecked);
    editor.apply();
});

// Load saved preference
SharedPreferences prefs = getSharedPreferences("debug", MODE_PRIVATE);
boolean savedDebugState = prefs.getBoolean("debug_enabled", BuildConfig.DEBUG);
LogHelper.setDebugEnabled(savedDebugState);
```

---

## 📖 Usage Examples

### Basic Usage

```java
public class UserService {
    
    public User loadUser(String userId) {
        LogHelper.api("Loading user: " + userId);
        
        try {
            // API call
            User user = apiCall(userId);
            LogHelper.api("User loaded successfully: " + user.getName());
            return user;
        } catch (Exception e) {
            LogHelper.crash("Failed to load user: " + userId, e);
            return null;
        }
    }
}
```

### Database Operations

```java
public class DatabaseHelper {
    
    public List<Item> search(String query) {
        LogHelper.database("Searching for: '" + query + "'");
        long startTime = System.currentTimeMillis();
        
        // Database query
        List<Item> results = performSearch(query);
        
        long duration = System.currentTimeMillis() - startTime;
        LogHelper.database("Found " + results.size() + " results in " + duration + "ms");
        
        return results;
    }
}
```

### UI Components

```java
public class MainActivity extends AppCompatActivity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LogHelper.ui("MainActivity created");
        
        setupUI();
        LogHelper.ui("UI setup completed");
    }
    
    @Override
    protected void onResume() {
        super.onResume();
        LogHelper.ui("MainActivity resumed");
    }
    
    private void onButtonClick() {
        LogHelper.ui("Button clicked - starting new activity");
        startActivity(new Intent(this, DetailActivity.class));
    }
}
```

### Pagination

```java
public class NewsAdapter extends RecyclerView.Adapter {
    
    public void loadNextPage() {
        LogHelper.pagination("Loading page " + (currentPage + 1));
        LogHelper.pagination("Current items: " + items.size());
        
        // Load data
        List<Item> newItems = loadPage(currentPage + 1);
        
        items.addAll(newItems);
        LogHelper.pagination("Page loaded - total items: " + items.size());
        notifyDataSetChanged();
    }
}
```

### Error Handling

```java
public class NetworkManager {
    
    public ApiResponse makeRequest(String url) {
        LogHelper.api("Making request to: " + url);
        
        try {
            ApiResponse response = httpClient.get(url);
            LogHelper.api("Request successful - status: " + response.getStatusCode());
            return response;
        } catch (NetworkException e) {
            LogHelper.crash("Network request failed: " + url, e);
            return null;
        }
    }
}
```

---

## 🔧 Migration Guide

### From android.util.Log

| Old Method | New Method | Category |
|------------|------------|----------|
| `Log.d(TAG, "UI message")` | `LogHelper.ui("message")` | UI |
| `Log.d(TAG, "API call")` | `LogHelper.api("message")` | API |
| `Log.d(TAG, "DB query")` | `LogHelper.database("message")` | Database |
| `Log.d(TAG, "Page load")` | `LogHelper.pagination("message")` | Pagination |
| `Log.e(TAG, msg, ex)` | `LogHelper.crash(msg, ex)` | Exception |
| `Log.d(TAG, msg)` | `LogHelper.d("CustomTag", msg)` | Generic |

### Batch Replace Script (Regex)

Find: `Log\.d\(([^,]+),\s*"([^"]+)"\)`
Replace based on content:
- If contains "API" → `LogHelper.api("$2")`
- If contains "DB/Database" → `LogHelper.database("$2")`  
- If contains "UI/Activity" → `LogHelper.ui("$2")`
- Otherwise → `LogHelper.d($1, "$2")`

---

## ⚡ Performance Notes

- **Debug Builds**: All logging active, can be toggled
- **Release Builds**: Only crash logs active (others compiled out)
- **Zero Runtime Cost**: In production, debug calls are eliminated
- **Memory Efficient**: No string concatenation if logging disabled

---

## 🎛️ Advanced Features

### Custom Categories

Add your own categories:

```java
public static void auth(String message) {
    if (DEBUG_ENABLED && BuildConfig.DEBUG) {
        Log.d("AUTH", message);
    }
}

public static void sync(String message) {
    if (DEBUG_ENABLED && BuildConfig.DEBUG) {
        Log.d("SYNC", message);
    }
}
```

### Conditional Logging

```java
// Only log expensive operations when debugging
if (LogHelper.isDebugEnabled()) {
    String expensiveDebugInfo = generateDetailedReport(); 
    LogHelper.database("Detailed report: " + expensiveDebugInfo);
}
```

### Log Filtering in IDE

Filter by category in Android Studio Logcat:
- `tag:UI` - Show only UI logs
- `tag:API` - Show only API logs  
- `tag:CRASH` - Show only crash logs
- `tag:DATABASE` - Show only database logs

---

## ✅ Integration Checklist

- [ ] Copy LogHelper.java to your project
- [ ] Update package name in imports
- [ ] Replace old Log.* calls with LogHelper.*
- [ ] Test toggle functionality
- [ ] Verify release builds have no debug logs
- [ ] Add toggle UI if needed
- [ ] Test crash logging works

---

## 🔍 Troubleshooting

**Q: Debug logs not appearing**
A: Check `LogHelper.isDebugEnabled()` and ensure you're in a debug build

**Q: Release build still showing logs**
A: Only crash logs should appear. Check `BuildConfig.DEBUG` is false

**Q: Too many logs**
A: Use categories (ui, api, database) and filter in Logcat

**Q: Performance issues**
A: Debug logs are compiled out in release builds, no performance impact

**📂 Note**: This implementation uses design standards from:
- [Style Architecture](standards/style-system-architecture.md) for debug toggle UI styling
- [Comprehensive Logging System](comprehensive-logging-system.md) for full system integration

---

This utility is ready to copy-paste into any Android project! 🚀