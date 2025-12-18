# iOS Project Setup Guide

## Prerequisites
- macOS system with Xcode installed
- Xcode 15.4 or later

## Opening the Project
1. Navigate to the `smart-call-block/IOS` folder in your project directory
2. Double-click on `SmartCallBlock.xcodeproj` to open in Xcode
3. Wait for Xcode to index the project files

## Project Structure
The project contains:
- **SmartCallBlock** (Main app target)
  - SmartCallBlockApp.swift - App entry point
  - ContentView.swift - Main UI
  - CallBlockManager.swift - Core blocking logic with contact name detection
  - AddNumberView.swift - Add blocked numbers UI
  - SettingsView.swift - Settings screen
  - CallHistoryView.swift - Call history with caller names
  - StatisticsView.swift - Statistics view
  - DataModel.xcdatamodeld - Core Data model
  - Info.plist - App configuration with contacts permission

- **CallDirectoryExtension** (Extension target)
  - CallDirectoryHandler.swift - System call blocking integration

## Key Features Implemented
- ✅ Caller name detection from contacts
- ✅ Multiple blocking types (exact number, prefix, name-based)
- ✅ Contact permission handling
- ✅ Call history with caller names
- ✅ Long name text truncation in UI
- ✅ Core Data storage for blocked calls

## Build Requirements
- iOS 14.0+ deployment target
- Swift 5.0
- CallKit framework access
- Contacts framework for name detection

## Build Configuration
The project includes both Debug and Release configurations with:
- Code signing set to Automatic
- Bundle identifier: com.smartcallblock.ios
- Extension identifier: com.smartcallblock.ios.CallDirectoryExtension

## Testing
1. Build and run on iOS device (required for CallKit functionality)
2. Go to Settings > Phone > Call Blocking & Identification
3. Enable "SmartCallBlock" toggle
4. Test blocking functionality with added numbers

## Troubleshooting
- If project won't open: Ensure you're using macOS with Xcode
- If build fails: Check code signing and provisioning profiles
- If CallKit not working: Verify app is enabled in Phone settings
- If contacts not working: Check contacts permission in app settings

## Development Notes
- Use iOS Simulator for UI development
- Use real device for CallKit and contacts testing
- CallDirectory extension requires special entitlements for App Store distribution