# Build System Modules

> Tách file build-app.ps1 thành các module để dễ quản lý và maintain

## 📁 Cấu trúc Module

### `modules/build-utils.ps1`
- **Functions:** `Write-Info`, `Write-Success`, `Write-Error`, `Write-Warning`
- **Utilities:** `Convert-ToLinmSoftFormat`
- **Purpose:** Common utility functions

### `modules/build-functions.ps1`
- **Version Functions:** `Get-AndroidVersion`, `Get-iOSVersion`, `Update-AndroidVersion`, `Update-iOSVersion`
- **App ID Functions:** `Get-AndroidAppId`, `Get-iOSAppId`, `Update-AndroidAppId`, `Update-iOSAppId`
- **Purpose:** Core app configuration management

### `modules/app-detection.ps1`
- **Function:** `Find-Apps`
- **Purpose:** VS Code workspace detection and app scanning

### `modules/build-core.ps1`
- **Function:** `Build-App`
- **Purpose:** Main build logic for Android and iOS

## 🔄 Migration

### Old File (630 lines)
```
build-app.ps1          # Monolithic file
```

### New Structure (Modular)
```
build-app-new.ps1      # Main script (~200 lines)
modules/
├── build-utils.ps1    # Utilities (~20 lines)
├── build-functions.ps1 # Version/App ID functions (~150 lines)
├── app-detection.ps1   # Workspace detection (~100 lines)
└── build-core.ps1      # Build logic (~80 lines)
```

## ✅ Benefits

1. **Better Organization** - Each file has single responsibility
2. **Easier Maintenance** - Edit specific modules only
3. **Code Reusability** - Can import functions in other scripts
4. **Faster Loading** - Only load needed modules
5. **Better Testing** - Test individual modules separately

## 🚀 Usage

### Test New Version
```powershell
# Test the new modular version
.\build-app-new.ps1

# Compare with old version
.\build-app.ps1
```

### Replace Old Version
```powershell
# Backup old version
Move-Item build-app.ps1 build-app-old.ps1

# Use new version
Move-Item build-app-new.ps1 build-app.ps1
```

## 📝 Notes

- All functionality preserved
- Same command-line interface
- Same user experience
- Added module loading with verbose output
- Better error handling for missing modules