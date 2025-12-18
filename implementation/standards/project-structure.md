# 📁 Project Structure

[← Back to Implementation](../)

---

## Standard Layout

```
app-name/
├── app/
│   ├── build.gradle                 # App-level dependencies
│   ├── proguard-rules.pro           # ProGuard config
│   └── src/main/
│       ├── AndroidManifest.xml      # App manifest
│       ├── java/com/appname/        # Java source code
│       └── res/                     # Resources
├── docs/                            # Documentation
│   └── dev/                         # Development guides
├── gradle/                          # Gradle wrapper
├── build.gradle                     # Project-level build
├── settings.gradle                  # Project settings
└── local.properties                 # Local SDK path
```

## Java Source Structure

```
app/src/main/java/com/appname/
│
├── 📱 Activities (root folder)
│   ├── MainActivity.java            # Main entry point
│   ├── SettingsActivity.java        # Full-screen settings
│   └── [Feature]Activity.java       # Feature-specific screens
│
├── 🧩 Fragments (root folder) ⚠️ REQUIRED
│   ├── MainHome.java                # Home/Dashboard
│   ├── MainProfile.java             # ⭐ REQUIRED - Profile/Settings/About screen
│   └── Main[Feature].java           # Feature-specific
│
├── 📊 Models (root or models/)
│   ├── User.java                    # User model
│   └── [Entity].java                # Data models
│
├── 🔌 Adapters (root or adapters/)
│   ├── [Entity]Adapter.java         # RecyclerView adapters
│   └── [Entity]ListAdapter.java     # List adapters
│
├── 🛠️ Services (root folder)
│   ├── [Feature]Service.java        # Background services
│   └── [Feature]Receiver.java       # Broadcast receivers
│
├── 💾 Database (root folder)
│   └── DatabaseHelper.java          # SQLite helper
│
├── 🔧 Utils (utils/)
│   ├── DialogUtils.java             # Dialog utilities
│   ├── DateUtils.java               # Date formatting
│   └── [Feature]Utils.java          # Feature utilities
│
└── 📦 Helpers (root folder)
    ├── [Feature]Helper.java         # Feature helpers
    └── NotificationHelper.java      # Notification management
```

## Resources Structure

```
res/
├── drawable/                        # Vector drawables, shapes
│   ├── ic_*.xml                     # Icons (24dp)
│   ├── bg_*.xml                     # Backgrounds
│   └── selector_*.xml               # State selectors
│
├── layout/                          # Layout files
│   ├── activity_*.xml               # Activity layouts
│   ├── main_*.xml                   # Fragment layouts (main tabs)
│   ├── dialog_*.xml                 # Dialog layouts
│   ├── item_*.xml                   # List item layouts
│   └── view_*.xml                   # Custom view layouts
│
├── mipmap-*/                        # App icons
│
├── values/                          # Default resources
│   ├── colors.xml                   # Color definitions
│   ├── dimens.xml                   # Dimensions
│   ├── strings.xml                  # Strings
│   ├── styles.xml                   # Styles
│   └── themes.xml                   # App themes
│
└── values-vi/                       # Vietnamese translations
    └── strings.xml
```
