# 🃏 LogHelper - Quick Reference Card

> **Copy-paste ready for any Android project**

## ⚡ 30-Second Setup

1. **Copy LogHelper.java** → `app/src/main/java/com/yourpackage/utils/`
2. **Change package name** → `package com.yourpackage.utils;`
3. **Import and use** → `import com.yourpackage.utils.LogHelper;`

## 📝 Common Usage Patterns

```java
// UI Events
LogHelper.ui("Activity started");
LogHelper.ui("Button clicked");
LogHelper.ui("Fragment loaded");

// API Calls  
LogHelper.api("GET /users - requesting data");
LogHelper.api("POST /login - response: " + response.code());

// Database
LogHelper.database("SELECT * FROM users WHERE active=1");
LogHelper.database("Inserted 5 new records");

// Pagination
LogHelper.pagination("Loading page 2");
LogHelper.pagination("Total items: " + items.size());

// Crashes (ALWAYS logged)
LogHelper.crash("Critical error in payment", exception);
```

## 🎛️ Toggle Control

```java
// Check status
boolean isEnabled = LogHelper.isDebugEnabled();

// Toggle on/off
LogHelper.setDebugEnabled(true);   // Enable debugging
LogHelper.setDebugEnabled(false);  // Disable debugging

// Save preference
SharedPreferences prefs = getSharedPreferences("debug", MODE_PRIVATE);
prefs.edit().putBoolean("debug_enabled", enabled).apply();
```

## 🔄 Migration Cheat Sheet

| Old | New |
|-----|-----|
| `Log.d(TAG, "msg")` | `LogHelper.ui("msg")` or `LogHelper.d(TAG, "msg")` |
| `Log.e(TAG, msg, ex)` | `LogHelper.crash(msg, ex)` |
| `Log.i(TAG, "msg")` | `LogHelper.i(TAG, "msg")` |

## 🎯 Log Categories

- **`LogHelper.ui()`** - User interface, activities, fragments
- **`LogHelper.api()`** - Network requests, responses  
- **`LogHelper.database()`** - SQL queries, CRUD operations
- **`LogHelper.pagination()`** - Page loading, data fetching
- **`LogHelper.crash()`** - Exceptions, critical errors (always on)

## 🔍 Logcat Filtering

Filter by category in Android Studio:
```
tag:UI         - UI logs only
tag:API        - API logs only  
tag:DATABASE   - Database logs only
tag:CRASH      - Crash logs only
```

## ⚡ Performance

✅ **Debug Builds**: All logs active (toggle-able)  
✅ **Release Builds**: Only crash logs (others compiled out)  
✅ **Zero Cost**: No performance impact in production  

## 🚀 Ready to Use!

Just copy the LogHelper.java file and start logging! 📱