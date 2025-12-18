# Smart Call Block - Cross-Platform Setup Guide

This project contains both iOS and Android implementations of a smart call blocking application with caller name detection.

## Quick Start

### iOS Development
```bash
cd smart-call-block/IOS
open SmartCallBlock.xcodeproj
```
**Requirements:** macOS with Xcode 15.4+

### Android Development  
```bash
cd smart-call-block/ANDROID
# Open this folder in Android Studio
```
**Requirements:** Android Studio Electric Eel+ with API 29+

## Documentation Structure

**📚 Setup Guides:**
- **iOS:** [`ios-setup-guide.md`](./ios-setup-guide.md) - Complete iOS Xcode setup
- **Android:** [`android-setup-guide.md`](./android-setup-guide.md) - Complete Android Studio setup

**📂 Project Rules & Best Practices:**
- **iOS Rules:** [`../../platform-rules/ios-project-rules.md`](../../platform-rules/ios-project-rules.md)
- **Android Rules:** [`../../platform-rules/android-project-rules.md`](../../platform-rules/android-project-rules.md)

## Key Features Implemented

### ✅ Cross-Platform Features
- **Caller Name Detection** - Looks up contact names for incoming calls
- **Multiple Blocking Types** - Exact number, prefix matching, name-based blocking
- **Call History** - Logs blocked calls with caller information
- **Settings Management** - Configure blocking preferences
- **Contact Integration** - Reads device contacts for name lookup

### ✅ Platform-Specific Features

#### iOS Features
- **CallKit Integration** - System-level call blocking
- **CallDirectory Extension** - Background call screening
- **SwiftUI Interface** - Modern iOS UI
- **Core Data Storage** - Local data persistence
- **Contact Framework** - Native contact access

#### Android Features  
- **CallScreeningService** - System call screening API
- **Call Overlay** - Custom caller ID display
- **Material Design 3** - Modern Android UI
- **SQLite Database** - Local data storage
- **ContactsContract** - Android contacts API

## Development Status

### ✅ Completed
- Caller name detection on both platforms
- Contact permission handling
- Name-based blocking with 3-level matching (exact/prefix/contains)
- Long text handling in UI (truncation)
- Call history logging with names
- Project setup and configuration files
- Development documentation

### ✅ Fixed Issues
- iOS project file corruption (reconstructed complete project.pbxproj)
- Missing contact permissions in iOS Info.plist
- Android overlay service caller name display
- Database schema for name storage
- UI text overflow handling

## Getting Started

1. **Choose Platform:**
   - For iOS: Follow [`ios-setup-guide.md`](./ios-setup-guide.md)
   - For Android: Follow [`android-setup-guide.md`](./android-setup-guide.md)

2. **Test on Device:**
   - Both platforms require physical devices for full call blocking testing
   - Simulators/emulators have limited call functionality

## Feature Comparison

| Feature | iOS | Android | Notes |
|---------|-----|---------|-------|
| Number Blocking | ✅ | ✅ | CallKit vs CallScreeningService |
| Name Detection | ✅ | ✅ | Contacts framework vs ContactsContract |
| Prefix Blocking | ✅ | ✅ | Both support wildcard matching |
| Name Blocking | ✅ | ✅ | 3-level matching on both platforms |
| Call History | ✅ | ✅ | Core Data vs SQLite |
| Caller ID Overlay | ➖ | ✅ | iOS uses system UI only |
| Background Extension | ✅ | ➖ | iOS CallDirectory extension |

## Architecture Notes

### iOS Architecture
- **Main App**: SwiftUI views + CallBlockManager
- **Extension**: CallDirectoryHandler for system integration
- **Storage**: Core Data with CallHistory entity
- **Permissions**: NSContactsUsageDescription in Info.plist

### Android Architecture  
- **Main App**: Activities with bottom navigation
- **Service**: CallScreeningService + CallOverlayService
- **Storage**: SQLite with DatabaseHelper
- **Permissions**: Runtime permission requests

## Testing Checklist

### Both Platforms
- [ ] Contact permission granted
- [ ] Add phone number to block list
- [ ] Receive test call from blocked number
- [ ] Verify call is blocked
- [ ] Check call appears in history with name
- [ ] Test name-based blocking
- [ ] Test prefix blocking

### iOS Specific
- [ ] CallDirectory extension enabled in Settings > Phone
- [ ] Core Data model loads correctly
- [ ] SwiftUI views display properly

### Android Specific  
- [ ] App set as default call screening app
- [ ] Overlay permission enabled
- [ ] Material Design theming works
- [ ] SQLite database operations work

## Development Guidelines

**🤖 AI Development:**
- Always reference platform-specific rules before coding
- Follow established project patterns and conventions
- Check existing documentation in project DOCS/ folders

**📋 Review Process:**
- Use platform-specific checklists for code reviews
- Validate cross-platform feature consistency
- Test on real devices before finalizing features