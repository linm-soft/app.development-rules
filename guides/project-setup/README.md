# Project Setup Documentation Index

This directory contains comprehensive setup guides for the Smart Call Block project.

## Available Guides

### 📱 Platform-Specific Setup
- **[iOS Setup Guide](./ios-setup-guide.md)** - Complete Xcode project setup
- **[Android Setup Guide](./android-setup-guide.md)** - Complete Android Studio setup  

### 🔄 Cross-Platform Setup
- **[Cross-Platform Setup](./cross-platform-setup.md)** - Overview of both platforms

## Quick Reference

### iOS Development
- **Requirements:** macOS with Xcode 15.4+
- **Project Path:** `smart-call-block/IOS/SmartCallBlock.xcodeproj`
- **Key Features:** CallKit, SwiftUI, Core Data, CallDirectory Extension

### Android Development  
- **Requirements:** Android Studio Electric Eel+, API 29+
- **Project Path:** `smart-call-block/ANDROID/`
- **Key Features:** CallScreeningService, Material Design 3, SQLite, Call Overlay

## Development Rules

For coding standards and best practices, see:
- **iOS Rules:** [`../../platform-rules/ios-project-rules.md`](../../platform-rules/ios-project-rules.md)
- **Android Rules:** [`../../platform-rules/android-project-rules.md`](../../platform-rules/android-project-rules.md)

## Project Features

### ✅ Implemented Features
- Caller name detection from contacts
- Multiple blocking types (exact, prefix, name-based)
- Call history with caller names
- Cross-platform UI (SwiftUI + Material Design)
- Contact permission handling

### 🔧 Testing Requirements  
- Both platforms require physical devices for full call blocking testing
- iOS requires CallDirectory extension enabled in Settings
- Android requires call screening app permission