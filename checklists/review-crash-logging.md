# Checklist: Crash Handling & Logging

This checklist ensures that the application has a proper crash handling and logging mechanism in place.

## ✅ Verification Steps

| # | Check | Command / Verification Method | Expected Result |
|---|---|---|---|
| 1 | **`ExceptionHandler` Exists** | Check for the existence of `util/ExceptionHandler.java`. | File should exist and implement `Thread.UncaughtExceptionHandler`. |
| 2 | **Initialized in Application** | Open `YourApplication.java` and check the `onCreate` method. | `Thread.setDefaultUncaughtExceptionHandler(new ExceptionHandler(this));` must be present. |
| 3 | **Manifest: Application Name** | Open `AndroidManifest.xml`. | The `android:name` attribute in the `<application>` tag must point to the custom `Application` class (e.g., `.YourApplication`). |
| 4 | **Manifest: Storage Permission** | Open `AndroidManifest.xml`. | `<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28" />` must be present for compatibility with Android 9 and below. |

## 📝 Review Notes

- The primary goal is to ensure that any unhandled exception is caught and logged to a file in the public `Downloads` directory.
- This allows for debugging without needing a direct `logcat` connection, which is critical for testing on non-developer devices or for analyzing crashes reported by users.
