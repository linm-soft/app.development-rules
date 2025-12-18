# Android Icon Standards (Rule 2.17)

> Standardized icon library and naming conventions for consistent cross-app usage

## 🎯 RELATED STANDARDS
**📂 Design Standards References:**
- [Dialog Icon Standards](dialog-icon-standards.md) - Dialog-specific icons (Rule 2.16)
- [Style System Architecture](standards/style-system-architecture.md) - Icon styling and theming
- [Border & Shape Standards](standards/border-shape-standards.md) - Icon corner radius and shapes

**📂 Implementation Standards:**
- [Android Icon Implementation](standards/android-icon-implementation.md) - Complete icon library with XML code

## ⚙️ OVERVIEW

Android Icon Standards provide unified icon library with consistent design, naming, and theming:
- **🎨 Standardized Library**: Complete set of common app icons
- **📝 Naming Convention**: Consistent ic_[category]_[purpose] pattern
- **🌙 Theme Support**: All icons work with light/dark modes
- **♻️ Cross-App Reusable**: Same icons across all Android projects
- **📱 Material Design 3**: Following latest design guidelines

## 🏗️ ICON CATEGORIES

### Navigation Icons
**Bottom Navigation & Menu:**
- `ic_home.xml` - Home/Dashboard
- `ic_list.xml` - Lists/Data
- `ic_profile.xml` - Profile/Settings
- `ic_add.xml` - Add/Create actions

**With Selection States:**
- `ic_home_selector.xml` - Home with selected state
- `ic_list_selector.xml` - List with selected state  
- `ic_profile_selector.xml` - Profile with selected state
- `ic_add_selector.xml` - Add button with pressed state

### Action Icons
**CRUD Operations:**
- `ic_add.xml` - Add/Create
- `ic_add_circle.xml` - Add with circle background
- `ic_add_white.xml` - Add icon (white variant)
- `ic_check.xml` - Confirm/Success actions
- `ic_copy.xml` - Copy/Duplicate actions

### UI Component Icons
**Information & Status:**
- `ic_info_outline.xml` - Information display
- `ic_shield_check.xml` - Security/Protection status
- `ic_chevron_right.xml` - Navigation arrows/Expand
- `ic_calendar.xml` - Date/Time selection
- `ic_language.xml` - Language/Localization

**Theme & Settings:**
- `ic_dark_mode.xml` - Dark mode toggle

### App-Specific Icons
**Call Blocker Features:**
- `ic_blocked_numbers.xml` - Blocked phone numbers
- `ic_blocked_prefixes.xml` - Blocked number prefixes

### Dialog Icons (from Rule 2.16)
**Standard Dialog Types:**
- `ic_dialog_success.xml` - ✓ Success confirmation
- `ic_dialog_error.xml` - ✗ Error notification
- `ic_dialog_warning.xml` - ⚠ Warning alerts
- `ic_dialog_info.xml` - ℹ Information display
- `ic_dialog_confirm.xml` - ❓ Confirmation prompts
- `ic_dialog_loading.xml` - ↻ Loading states
- `ic_dialog_loading_animated.xml` - ↻ Animated loading

## 🎨 ICON SPECIFICATIONS

### Design Standards
```xml
<!-- Standard icon template -->
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24"
    android:tint="?android:attr/colorPrimary">
    
    <path
        android:fillColor="@android:color/white"
        android:pathData="[Material Design path data]"/>
</vector>
```

### Naming Convention
```
Pattern: ic_[category]_[purpose]_[variant].xml

Categories:
- dialog_    → Dialog-specific icons
- nav_       → Navigation/Bottom nav icons  
- action_    → Action buttons (add, edit, delete)
- ui_        → UI components (arrows, info, etc.)
- app_       → App-specific functionality
- theme_     → Theme/settings related

Examples:
✅ ic_dialog_success.xml
✅ ic_nav_home.xml  
✅ ic_action_add.xml
✅ ic_ui_chevron_right.xml
✅ ic_app_blocked_numbers.xml
✅ ic_theme_dark_mode.xml
```

### Size & Format Standards
- **Size**: 24dp x 24dp (standard), 32dp for large actions
- **Format**: Vector XML (scalable, theme-aware)
- **Viewport**: 24x24 for consistent scaling
- **Tint**: Theme-aware using `?android:attr/colorPrimary` or specific colors

## 📁 ICON LIBRARY STRUCTURE

```
app/src/main/res/drawable/
├── Navigation Icons
│   ├── ic_home.xml, ic_home_selected.xml, ic_home_selector.xml
│   ├── ic_list.xml, ic_list_selected.xml, ic_list_selector.xml
│   └── ic_profile.xml, ic_profile_selected.xml, ic_profile_selector.xml
├── Action Icons  
│   ├── ic_add.xml, ic_add_circle.xml, ic_add_white.xml
│   ├── ic_check.xml, ic_copy.xml
│   └── ic_add_selector.xml (with pressed states)
├── Dialog Icons (Rule 2.16)
│   ├── ic_dialog_success.xml, ic_dialog_error.xml  
│   ├── ic_dialog_warning.xml, ic_dialog_info.xml
│   ├── ic_dialog_confirm.xml, ic_dialog_loading.xml
│   └── ic_dialog_loading_animated.xml
├── UI Component Icons
│   ├── ic_chevron_right.xml, ic_info_outline.xml
│   ├── ic_calendar.xml, ic_language.xml  
│   └── ic_shield_check.xml, ic_dark_mode.xml
└── App-Specific Icons
    ├── ic_blocked_numbers.xml
    └── ic_blocked_prefixes.xml
```

## ✅ IMPLEMENTATION CHECKLIST

### Icon Creation Standards
- [ ] Follow naming convention: `ic_[category]_[purpose]_[variant].xml`
- [ ] Use 24dp x 24dp size with 24x24 viewport
- [ ] Include proper tint attribute for theming
- [ ] Test in both light and dark modes
- [ ] Validate Material Design 3 compliance
- [ ] Ensure accessibility contrast ratios

### Cross-Project Usage
- [ ] All icons work without modification in any Android project
- [ ] No app-specific dependencies in icon files
- [ ] Consistent visual style across icon categories
- [ ] Documentation includes usage examples
- [ ] Resource organization follows standards

### Integration Requirements
- [ ] Icons referenced correctly in Java/Kotlin code
- [ ] Selector states created for interactive icons
- [ ] Color variants provided where needed
- [ ] Animation support for loading/progress icons
- [ ] Usage examples documented for each category

## 🚀 MIGRATION FROM EXISTING ICONS

### Copy Icon Library to New Project
1. **Copy all icon files** from reference project to new project `/drawable/` folder
2. **Update resource references** in layouts and Java code if needed
3. **Verify theming** works correctly in target project theme
4. **Test all selector states** for interactive icons
5. **Update documentation** to reflect project-specific customizations

### Benefits of Standardized Icons
- **Faster development**: No need to create/find icons for each project
- **Consistent UX**: Users see familiar icons across apps
- **Easy maintenance**: Update library once, applies to all projects
- **Professional appearance**: Cohesive design language
- **Accessibility**: Properly tested contrast and sizing

---

*For dialog-specific icons and auto-theming, see [Dialog Icon Standards](dialog-icon-standards.md) (Rule 2.16).*

*This icon standardization ensures consistent visual language across all Android Native Java projects.*