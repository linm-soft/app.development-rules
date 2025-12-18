# Build System - Modular Architecture Documentation

## Overview
The Smart Call Block build system has been refactored from a monolithic 630-line script into a modular architecture for better maintainability, testing, and organization.

## Architecture

### Main Script: `build-app.ps1`
- **Size**: ~200 lines (vs 630 lines original)
- **Purpose**: Main entry point and workflow orchestration
- **Features**: Parameter handling, user interaction, workflow coordination

### Modules Structure

#### `modules/build-utils.ps1`
- **Purpose**: Common utility functions and logging
- **Functions**:
  - `Write-Info` - Info messages (Cyan)
  - `Write-Success` - Success messages (Green)  
  - `Write-Warning` - Warning messages (Yellow)
  - `Write-Error` - Error messages (Red)
  - `Convert-ToLinmSoftFormat` - App ID format conversion

#### `modules/build-functions.ps1`
- **Purpose**: Version and App ID management for Android/iOS
- **Functions**:
  - `Get-AndroidVersion` / `Update-AndroidVersion`
  - `Get-iOSVersion` / `Update-iOSVersion`
  - `Get-AndroidAppId` / `Update-AndroidAppId`
  - `Get-iOSAppId` / `Update-iOSAppId`

#### `modules/app-detection.ps1`
- **Purpose**: VS Code workspace detection and app scanning
- **Functions**:
  - `Find-Apps` - Intelligent workspace detection
- **Features**:
  - Multi-folder workspace support
  - Android/iOS app detection
  - Path resolution for development-rules structure

#### `modules/build-core.ps1`
- **Purpose**: Main build logic for Android and iOS
- **Functions**:
  - `Build-App` - Platform-specific build execution
- **Features**:
  - Android Gradle builds
  - iOS version update mode (Windows)
  - APK output management

## Key Improvements

### 🏗️ **Modularity**
- Single responsibility principle
- Easy to test individual components
- Clear separation of concerns

### 🔧 **Maintainability**
- Each module ~100 lines max
- Independent development/testing
- Easier debugging and fixes

### 📱 **Enhanced Features**
- Better workspace detection
- Multi-app selection support
- Improved error handling
- App ID format standardization

### 💼 **Development Workflow**
- Clean module loading with error handling
- Verbose logging for debugging
- Consistent function naming

## Usage Examples

### Basic Interactive Build
```powershell
.\build-app.ps1
```

### Quick Build Specific App
```powershell
.\build-app.ps1 -QuickBuild -AppName smart-call-block
```

### Build with Specific Version
```powershell
.\build-app.ps1 -Version v2.0.0 -AppName smart-call-block
```

### Help and Information
```powershell
.\build-app.ps1 -Help
.\build-app.ps1 -ShowVersion
```

## Module Dependencies

```
build-app.ps1
├── modules/build-utils.ps1      (No dependencies)
├── modules/build-functions.ps1  (Depends on: build-utils)
├── modules/app-detection.ps1    (Depends on: build-utils, build-functions)
└── modules/build-core.ps1       (Depends on: build-utils, build-functions)
```

## Workspace Detection Logic

The system intelligently detects VS Code multi-folder workspaces:

1. **Development-rules context**: Detects when running from development-rules and finds sibling app folders
2. **Path resolution**: Maps Android.App/smart-call-block and IOS.App/smart-call-block
3. **Fallback mode**: Single-folder workspace support
4. **App identification**: Automatic Android (build.gradle) and iOS (.xcodeproj) detection

## App ID Format Standard

All apps follow the `linm.soft.[appname]` format:
- **Android**: applicationId in build.gradle
- **iOS**: Bundle ID in Info.plist/pbxproj

## Migration Notes

### From Monolithic Script
- **Backup**: Original script saved as `build-app-original-backup.ps1`
- **Compatibility**: All original features preserved
- **Performance**: Improved startup time with modular loading

### Future Enhancements
- Module versioning system
- Configuration file support
- Extended platform support
- Automated testing framework

## Troubleshooting

### Module Loading Issues
```powershell
# Check module syntax
. ".\modules\build-utils.ps1"
```

### Unicode/Encoding Issues
- Modules use clean ASCII for compatibility
- Unicode characters removed for PowerShell compatibility

### Path Resolution Problems
- Verify VS Code workspace structure
- Check development-rules folder structure

## Version History

- **v5.0**: Modular architecture implementation
- **v4.x**: Monolithic script with all features
- **v3.x**: Basic build automation