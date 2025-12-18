# 📝 Logging & Debugging

## Two-Tier System

1. **Android Logcat** - Development logs (always enabled)
2. **Database Logs** - User-facing logs (can be toggled)

## Logcat Guidelines

**Tag Naming:** `private static final String TAG = "ClassName";`

**Log Levels:**
- `Log.d()` - Debug flow, method calls
- `Log.i()` - Important state changes
- `Log.w()` - Recoverable errors
- `Log.e()` - Errors needing attention

**When to Log:**
- Method entry/exit
- State changes
- User actions
- Success/failure operations
- Caught exceptions with stack trace

## Database Logs

**Enable/Disable:**
```java
// DatabaseHelper
public void setLogEnabled(boolean enabled) {
    prefs.edit().putBoolean(KEY_LOG_ENABLED, enabled).apply();
}

public void logBlockedCall(...) {
    if (!isLogEnabled()) return; // Skip if disabled
    // Insert to database...
}
```

**UI Control:**
- Toggle switch in Profile
- Load/save from SharedPreferences
- Show status to user

## Best Practices

- ❌ **NEVER log** sensitive data (full phone numbers, passwords)
- ✅ Mask sensitive info: `012****789`
- ✅ Use meaningful messages
- ✅ Include exception details: `e.getMessage()` + `printStackTrace()`
- ✅ Strip debug logs in production (ProGuard or `if (BuildConfig.DEBUG)`)

## Optional: LogViewerActivity

✅ **IMPLEMENTED** - In-app log viewer for debugging (debug builds only):

### Features:
- **Real-time display**: Show crash logs from Downloads/{package_name}/
- **Auto-refresh**: Updates every 5 seconds automatically
- **Monospace font**: Better readability for stacktraces
- **Multiple logs**: Shows last 5 crash logs
- **Share functionality**: Export logs via email/messaging
- **Clear logs**: Delete all logs with confirmation dialog
- **Modern UI**: Material Design 3 styling

### Access Methods:
1. **Profile tab**: Long press developer name "Linh.BoDinh" → Opens LogViewerActivity directly
2. **Simplified access**: No need to tap version multiple times, works in both debug and release builds

### Implementation Status:
- ✅ LogViewerActivity created with full functionality
- ✅ DebugTestActivity for crash testing
- ✅ Integration with ExceptionHandler
- ✅ UI layouts with Material Design 3
- ✅ AndroidManifest registration
- ✅ Simplified access in MainProfile (long press developer name)
- ✅ APK built and ready for testing

### File Locations:
```
/ui/debug/LogViewerActivity.java     - Main log viewer
/ui/debug/DebugTestActivity.java     - Crash testing utility  
/res/layout/activity_log_viewer.xml  - Log viewer UI
/res/layout/activity_debug_test.xml  - Debug test UI
```

### Test Instructions:
1. Build debug APK: `.\build-apk.bat`
2. Profile → Long press "Linh.BoDinh" (developer name) → LogViewerActivity opens directly
3. View any generated logs or crash reports in the app
