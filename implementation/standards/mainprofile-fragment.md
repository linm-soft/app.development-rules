# 👤 MainProfile Fragment

## Overview

**REQUIRED for every app** - Profile/Settings screen with:
- User info (if login enabled)
- Permissions status + action buttons
- Package name + version info
- App settings (Language, Dark Mode)
- Developer info (About section)

## Key Components

**Permissions Section:**
- Check status: `ContextCompat.checkSelfPermission()` or special check
- Display: Name, Description, Status badge (Granted/Denied)
- Action: Button opens Settings if denied
- Refresh: `onResume()` → reload permissions

**Settings Section:**
- Dark Mode: Switch → SharedPreferences → `AppCompatDelegate.setDefaultNightMode()`
- Language: Dialog selector → SharedPreferences → `recreate()`

**About Section:**
- Developer: `Linh.BoDinh`
- Contact: `support@soft-linm.com` (clickable email intent)
- Website: `soft-linm.com` (clickable browser intent)
- Version: `BuildConfig.VERSION_NAME`
- Release date: `BuildConfig.BUILD_TIME` formatted

## Permission Synchronization Rule

**When adding new permission, MUST sync ALL 3 places:**
1. `AndroidManifest.xml` - Declare permission
2. `MainActivity.java` → `getPermissionTerms()` - Terms Dialog
3. `MainProfile.java` → `getAppPermissions()` - Permission Section

Missing any = incomplete implementation!

## Strings Required

- EN: `values/strings_profile.xml`
- VI: `values-vi/strings_profile.xml`

Must have strings for: permissions, settings, about section.
