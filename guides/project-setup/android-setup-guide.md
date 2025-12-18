# Android Project Setup Guide

## Prerequisites
- Android Studio Electric Eel (2022.1.1) or later
- Android SDK API Level 29+ (Android 10.0)
- Gradle 8.0+

## Opening the Project
1. Open Android Studio
2. Select "Open an existing project"
3. Navigate to `smart-call-block/ANDROID` folder in your project directory
4. Click "OK" to open the project
5. Wait for Gradle sync to complete

## Project Structure
The project contains:
- **app module** (Main Android application)
  - MainActivity.java - Main activity with bottom navigation
  - CallBlockManager.java - Core blocking logic
  - DatabaseHelper.java - SQLite database with name blocking support
  - AddBlockedNumberActivity.java - Add blocked numbers
  - CallHistoryActivity.java - Call history with caller names
  - SettingsActivity.java - Settings and preferences
  - CallScreeningService.java - System call screening integration
  - CallOverlayService.java - Call overlay with caller name display
  - ContactHelper.java - Contact name lookup utility

## Key Features Implemented
- ✅ Caller name detection from contacts
- ✅ Multiple blocking methods (exact, prefix, name-based)
- ✅ Call screening service integration
- ✅ Overlay UI with caller name display
- ✅ SQLite database with 3-level name matching
- ✅ Contact permissions handling
- ✅ Call history logging with names

## Build Configuration
- **Minimum SDK:** API 29 (Android 10.0)
- **Target SDK:** API 33 (Android 13)
- **Compile SDK:** API 33
- **Java Version:** 1.8

## Required Permissions
```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.CALL_PHONE" />
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
<uses-permission android:name="android.permission.ANSWER_PHONE_CALLS" />
```

## Dependencies
- androidx.appcompat:appcompat:1.6.1
- com.google.android.material:material:1.8.0
- androidx.constraintlayout:constraintlayout:2.1.4
- androidx.lifecycle:lifecycle-extensions:2.2.0

## Build & Run
1. Sync project with Gradle
2. Connect Android device or start emulator
3. Click "Run" or press Ctrl+R
4. Grant required permissions when prompted

## Testing Call Blocking
1. Install app on device
2. Go to Settings > Apps > Default apps > Call screening app
3. Select "Call Blocker" as default call screening app
4. Add phone numbers to block list
5. Test with incoming calls

## Testing Overlay Feature
1. Go to Settings > Apps > Special access > Display over other apps
2. Enable permission for "Call Blocker"
3. Receive a call to see caller name overlay

## Database Schema
The app uses SQLite with these key tables:
- **blocked_numbers** - Stores blocked phone numbers and names
- **call_history** - Logs blocked calls with caller information
- **settings** - App configuration and preferences

## Troubleshooting
- **Gradle sync fails:** Check internet connection and Android Studio version
- **Call screening not working:** Verify app is set as default call screening app
- **Contacts not loading:** Check READ_CONTACTS permission is granted
- **Overlay not showing:** Enable "Display over other apps" permission
- **Build errors:** Clean project and rebuild (Build > Clean Project)

## Development Notes
- Use real Android device for testing call features
- Emulator may not fully support call screening APIs
- Test on different Android versions (API 29-33)
- Ensure proper permission handling for Android 11+

## Project Files
- `build.gradle` - Main build configuration
- `app/build.gradle` - App module build settings
- `app/src/main/AndroidManifest.xml` - App permissions and components
- `app/src/main/res/` - UI resources and layouts