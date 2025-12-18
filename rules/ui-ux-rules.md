# UI/UX Rules (2.9-2.16)

> User interface and experience standards

---
## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "ui-ux-rules"...
```

**Purpose:** Let user know AI is referencing UI/UX rules.

---
## 2.9. Multi-language Support ⚠️ REQUIRED

**📂 See:** [`implementation/multi-language-support.md`](../implementation/multi-language-support.md)

**Quick Reference:**
- English (`values/`) + Vietnamese (`values-vi/`) required
- String names must match in both files
- NO hardcoded text in code or layouts
- Use `getString(R.string.xxx)` and `@string/xxx`

---

## 2.10. Material Design 3 Migration ⚠️ REQUIRED

**📂 See:** [`implementation/material-design-3-migration.md`](../implementation/material-design-3-migration.md)

**Quick Reference:**
- Upgrade from Material Design 2 to Material Design 3
- Update dependency: `material:1.9.0` → `material:1.11.0+`
- **REQUIRED:** Dynamic colors, improved theming, Material You support
- **Compatibility:** Android 7.0+ (API 24+), Material You for Android 12+ (API 31+)
- **Migration steps:** Dependencies → Themes → Components → Testing

---

## 2.11. Dialog Rules ⚠️ REQUIRED

**📂 See:** [`implementation/dialog-rules.md`](../implementation/dialog-rules.md)

**Quick Reference:**
- NEVER use AlertDialog.Builder with setTitle/setMessage
- ALWAYS use custom layout with `dialog.setContentView()`
- Call `DialogUtils.setDialogWidth()` after `dialog.show()`
- Use `@drawable/dialog_background` for styling

---

## 2.12. Permissions Handling ⚠️ REQUIRED

**📂 See:** [`implementation/permissions-handling.md`](../implementation/permissions-handling.md)

**Complete Permission System Standard:**
- **Progressive request flow**: Regular → Special → Roles  
- **Visual status display**: Green checkmarks vs Red X in profile
- **Educational dialogs**: Explain WHY permissions needed
- **Auto-refresh**: Update on `onResume()` from Settings
- **Click-to-settings**: Direct access to permission controls
- **Version-aware**: Handle Android API differences properly

**Key Components:**
```java
PermissionInfo[] permissions = {
    new PermissionInfo("Phone State", "Detect incoming calls", 
        Manifest.permission.READ_PHONE_STATE, false),
    new PermissionInfo("Display Over Apps", "Show block button", 
        "overlay", true) // Special permission
};
```

⚠️ **User Confirmation Required:** Ask developer before implementing complete permission system standard

**Quick Reference:**
- Display permissions status in MainProfile with visual indicators
- Sync 3 places: Manifest, MainActivity request, MainProfile display  
- Refresh on `onResume()` (user can change in Settings)
- Request button visible only when permissions missing
- Expandable section with individual permission details

---

## 2.17. Enhanced Load More & Pagination ⚠️ REQUIRED

**📂 See:** [`implementation/enhanced-load-more-implementation.md`](../implementation/enhanced-load-more-implementation.md)

**Complete Load More System:**
- **Multiple trigger points**: 70% threshold + near-bottom detection + dynamic threshold
- **Throttling & debouncing**: Prevent duplicate calls and rapid scroll events
- **Smooth animations**: Card insertion with slide + fade + scale effects  
- **Performance optimization**: Stable IDs, optimized RecyclerView configuration
- **Virtual scrolling integration**: Works seamlessly with VirtualScrollHelper

**Key Features:**
- ✅ **Responsive triggers**: Load more at 70% instead of waiting for bottom
- ✅ **Lag-free animations**: Staggered for small batches, batch for large datasets
- ✅ **Throttle protection**: 1-second minimum between load more calls
- ✅ **Scroll debouncing**: 100ms debounce for rapid scroll events
- ✅ **Performance optimized**: No memory overhead, minimal CPU impact

---

## 2.18. App Settings (Theme & Language) ⚠️ REQUIRED

**📂 See:** [`implementation/app-settings-theme-language.md`](../implementation/app-settings-theme-language.md)

**Complete App Settings System:**
- **Theme switching**: Light / Dark / System Default with instant application
- **Language switching**: English / Vietnamese / System Default  
- **LocaleHelper utility**: Handle locale changes with context override
- **Application class**: Theme management with SharedPreferences
- **Profile integration**: Settings section with selection dialogs
- **Persistent storage**: Preferences saved across app restarts

**Key Components:**
```java
// LocaleHelper for language management
public static Context applyLanguage(Context context) {
    String language = getLanguage(context);
    return applyLanguage(context, language);
}

// Application class for theme management  
public static void setThemeMode(Context context, String mode) {
    // Apply theme instantly with AppCompatDelegate
}
```

⚠️ **User Confirmation Required:** Ask developer before implementing complete app settings system

**Quick Reference:**
- Settings section in MainProfile with theme + language options
- Selection dialogs with radio buttons for user choice
- Immediate UI updates after selection
- Activity recreation for language changes
- Icons: ic_dark_mode, ic_language, ic_chevron_right

---

## 2.14. FAB Button Positioning ⚠️ OPTIONAL

**📂 See:** [`implementation/fab-button-positioning.md`](../implementation/fab-button-positioning.md)

**Quick Reference:**
- **Minimum margin bottom:** `80dp` when Bottom Navigation exists
- **With additional bottom components:** Calculate total margin (80dp + component height)
- **ALWAYS use:** `layout_gravity="bottom|end"` inside `CoordinatorLayout`
- **RecyclerView:** Must have `paddingBottom="80dp"` + `clipToPadding="false"`

⚠️ **User Confirmation Required:** Ask before applying FAB rules

---

## 2.15. Theme & Color System ⚠️ REQUIRED

**📂 See:** [`implementation/theme-settings.md`](../implementation/theme-settings.md)

**Quick Reference:**
- **REQUIRED:** `attrs.xml`, `styles_theme.xml` (light + dark)
- CardView: **MUST set** `app:cardBackgroundColor="@color/card_background"`
- Never use `_dark` suffix directly in layouts

---

## 2.15. MainProfile Fragment ⚠️ REQUIRED

**📂 See:** [`implementation/mainprofile-fragment.md`](../implementation/mainprofile-fragment.md)

**Quick Reference:**
- **REQUIRED** in every app
- Permissions + App Settings + About sections
- Sync 3 places: Manifest, MainActivity terms, MainProfile permissions

---

## 2.16. Common Dialog Framework ⚠️ REQUIRED

Unified dialog system with standardized icons, auto-theming, and consistent UX across all apps. Replaces individual AlertDialog implementations with type-safe Builder pattern.

**📂 See:** [`implementation/common-dialog-framework.md`](../implementation/common-dialog-framework.md)

**Quick Reference:**
- **Builder pattern**: `new CommonDialog.Builder(context).setType(DialogType.SUCCESS).show()`
- **7 Dialog Types**: CONFIRM, SUCCESS, ERROR, WARNING, INFO, LOADING, CUSTOM  
- **Auto icons**: Each type has standardized Material Design icon (success=check, error=X, etc.)
- **Auto theming**: Colors follow Material Design 3 theme (light/dark mode support)
- **Dynamic resizing**: Content automatically adjusts dialog size
- **Cross-app reusable**: Same implementation pattern for all Android projects

**Standard Icons:**
- **SUCCESS**: ✓ Check circle (green)
- **ERROR**: ✗ X circle (red)
- **WARNING**: ⚠ Triangle (orange)
- **INFO/CONFIRM**: ℹ Circle (blue)
- **LOADING**: ↻ Animated refresh (blue)
- **CUSTOM**: No auto icon (fully customizable)

---

## 2.17. Android Icon Standards ⚠️ REQUIRED

Standardized icon library with consistent design, naming conventions, and cross-app reusability. Provides complete set of common app icons following Material Design 3 guidelines.

**📂 See:** [`implementation/android-icon-standards.md`](../implementation/android-icon-standards.md)

**Quick Reference:**
- **Complete Icon Library**: Navigation, action, dialog, UI component, and app-specific icons
- **Naming Convention**: `ic_[category]_[purpose]_[variant].xml` pattern
- **Material Design 3**: 24dp vector icons with theme-aware tinting
- **Cross-Project Reuse**: Same icon files work in any Android project
- **Categories**: Dialog (from Rule 2.16), navigation, actions, UI components, app-specific
- **Auto-theming**: Light/dark mode support with proper contrast

**Standard Categories:**
- **Navigation**: ic_home.xml, ic_list.xml, ic_profile.xml (with selector states)
- **Actions**: ic_add.xml, ic_check.xml, ic_copy.xml
- **Dialog**: ic_dialog_success/error/warning/info/confirm/loading.xml (Rule 2.16)
- **UI Components**: ic_chevron_right.xml, ic_info_outline.xml, ic_calendar.xml
- **Theme**: ic_dark_mode.xml for theme switching
- **App-Specific**: ic_blocked_numbers.xml, ic_shield_check.xml

---
**📚 Related Rules:**
- [Setup Rules](./setup-rules.md) - 2.1-2.8
- [Advanced Rules](./advanced-rules.md) - 2.18-2.28
- [Quality Rules](./quality-rules.md) - 3.0-4.0