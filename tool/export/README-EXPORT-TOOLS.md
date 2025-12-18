# Export Tools for Cross-Platform Projects

Complete project export tool for Android, iOS, and cross-platform mobile app projects.

## 🎯 Purpose

This tool provides streamlined export functionality for mobile app workspaces, automatically generating clean source code packages ready for Android Studio or Xcode import. The tool creates a single ZIP file containing all necessary project files while excluding development artifacts.

## 📁 Tools Available

### **Interactive Export:**
- **export-project.bat** - Interactive batch script with auto-detection
- **export-full-project.ps1** - PowerShell export engine

## 🚀 Quick Start

### **Recommended Usage (Interactive):**
```batch
# Run interactive export tool
./export-project.bat
```

The batch script will:
- Auto-detect available projects
- Auto-select smart-call-block if found  
- Export both Android and iOS content
- Create single ZIP file in Source/Export/
- Offer to open the export folder

### **PowerShell Direct Usage:**
```powershell
# Export complete workspace
./export-full-project.ps1

# Custom configuration
./export-full-project.ps1 -Platform both -ProjectName "MyApp"
```

## ⚙️ Parameters

### **Available Options:**
```powershell
-Platform        # "android", "ios", "both" (default: "both")
-OutputPath      # Custom staging directory (default: Source/Export/temp_staging)
-ProjectName     # Project name for ZIP file (default: "SmartCallBlock")
-CreateZipFile   # Create ZIP files (default: $true)
-KeepFolders     # Keep staging folders (default: $false)
-IncludeTimestamp # Add timestamp to ZIP (default: $true)
-ShowVerbose     # Show detailed output (default: $false)
```

## 📋 Features

### **🔍 Auto-Detection:**
- **Project Detection**: Auto-detects smart-call-block project
- **Platform Detection**: Identifies Android and iOS components
- **Smart Filtering**: Excludes development files and build artifacts
- **Clean Export**: Creates production-ready source packages

### **🧹 Smart Cleanup:**
Automatically excludes:
- **Development**: `development-rules/`, `test-app/`, `Export/`
- **Build Artifacts**: `build/`, `generated/`, `intermediates/`, `outputs/`, `tmp/`
- **Android**: `.gradle/`, `*.apk`, `*.aab`, `local.properties`, `gradlew*`
- **iOS**: `DerivedData/`, `*.xcuserdata/`, `Pods/`, `Build/`
- **IDE Files**: `.vscode/`, `.idea/`, `.vs/`, `.ai-progress/`
- **Version Control**: `.git/`, `.github/`, `.gitignore`
- **System Files**: `.DS_Store`, `Thumbs.db`, `*.tmp`, `*.log`

### **📦 Single ZIP Output:**
- **One File**: Creates single `SmartCallBlock_Export_[timestamp].zip`
- **Clean Structure**: No intermediate folders, direct ZIP creation
- **Auto Cleanup**: Removes staging folders automatically
- **Ready to Import**: Optimized for Android Studio/Xcode

### **📝 Documentation:**
- **Export Info**: JSON file with export details and statistics
- **README**: Basic documentation included in ZIP
- **Statistics**: Shows files copied vs skipped

## 🛠️ Usage Workflow

### **Step-by-Step Process:**
1. **Run**: `./export-project.bat`
2. **Auto-Detection**: Script finds smart-call-block project
3. **Platform Detection**: Identifies Android + iOS = exports both
4. **File Processing**: Copies source files, excludes build artifacts  
5. **ZIP Creation**: Creates single ZIP file in Source/Export/
6. **Cleanup**: Removes staging folder
7. **Open**: Offers to open Export folder with ZIP file

### **Output Location:**
```
Source/Export/SmartCallBlock_Export_20241217_143000.zip
```

### **Import Instructions:**
- **Android Studio**: File → Import Project → Select ZIP
- **Xcode**: Extract ZIP → Open .xcodeproj file
```

## 🔧 Advanced Options

### **PowerShell Direct Usage:**
```powershell
# Basic export
./export-full-project.ps1

# Custom project name
./export-full-project.ps1 -ProjectName "MyCustomApp"

# Verbose output for debugging
./export-full-project.ps1 -ShowVerbose

# Keep staging folder (for inspection)
./export-full-project.ps1 -KeepFolders
```

## 🎯 Use Cases

### **Development Scenarios:**
- **Quick Export** → Run `export-project.bat` 
- **Android Studio Import** → Extract ZIP and import Android folder
- **Xcode Import** → Extract ZIP and open .xcodeproj file
- **Clean Source Distribution** → Single ZIP ready for sharing

### **Team Distribution:**
- **Client Delivery** → Clean source without development artifacts
- **Code Review** → Export for external review without build files
- **Backup** → Complete project backup in ZIP format
- **Onboarding** → Clean project structure for new team members

## 📊 Output Structure

### **Single ZIP Export:**
```
SmartCallBlock_Export_20241217_143000.zip
├── ANDROID/                 # Android project files
│   ├── build.gradle
│   ├── app/src/
│   └── settings.gradle
├── IOS/                     # iOS project files  
│   ├── SmartCallBlock.xcodeproj
│   ├── SmartCallBlock/
│   └── CallDirectoryExtension/
├── DOCs/                    # Documentation
│   ├── android/
│   ├── ios/
│   └── README.md
└── README.md                # Import instructions
```

## ⚡ Performance & Tips

### **Optimizations:**
- **Automatic cleanup** removes staging folders
- **Smart filtering** excludes ~90% of unnecessary files
- **Single ZIP** approach eliminates folder duplication
- **Fast compression** with optimal level

### **File Size Reduction:**
- Build artifacts excluded → ~80% smaller
- Development files excluded → cleaner structure
- Only source code and docs → production ready

## 🐛 Troubleshooting

### **Common Issues:**

**Export folder opens to wrong location:**
- Script automatically opens `Source/Export/` folder
- Contains the generated ZIP file

**ZIP file seems small:**
- This is expected - build artifacts are excluded  
- Only source code and documentation included
- Use `-ShowVerbose` to see what files are processed

**PowerShell execution errors:**
- Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Ensure you're in the correct directory

## 🔄 What's New

### **Latest Updates:**
- ✅ **Single ZIP Output** - No more multiple ZIP files
- ✅ **Auto Cleanup** - No leftover staging folders
- ✅ **Enhanced Filtering** - Better build artifact detection
- ✅ **Interactive Mode** - Smart project detection
- ✅ **Simplified Process** - One-click export

---

**💡 Quick Start**: Just run `./export-project.bat` and you're done!

**🎯 Result**: Single ZIP file ready for Android Studio/Xcode import!