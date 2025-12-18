# App Settings Implementation (Theme & Language)

> Complete app settings system for theme and language preferences

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "app-settings implementation"...
```

**Purpose:** Let user know AI is referencing app settings implementation details.

---

## 🎯 RELATED STANDARDS

**📂 Design Standards References:**
- [Spacing & Padding Standards](standards/spacing-padding-standards.md) - UI spacing for settings sections
- [Border & Shape Standards](standards/border-shape-standards.md) - Dialog and button shapes  
- [Style System Architecture](standards/style-system-architecture.md) - Button and dialog styles

**📂 Implementation Standards:**
- [Theme Settings](standards/theme-settings.md) - Complete theme and language implementation with UI + Java code

---

## 🎯 APP SETTINGS STANDARD

### **1. COMPONENTS REQUIRED**

**Core Components:**
- **LocaleHelper.java** - Language management utility (see standards)
- **Application class** - Theme management (see standards)
- **MainProfile section** - Settings UI in profile (see standards)
- **SharedPreferences** - Store user preferences
- **Dialog selectors** - Theme and Language selection

**Key Features:**
- **Theme switching**: Light / Dark / System Default
- **Language switching**: English / Vietnamese / System Default
- **Persistent storage**: Preferences saved across app restarts
- **Immediate application**: Changes apply instantly
- **System integration**: Respect system settings when selected

### **2. IMPLEMENTATION REFERENCE**

**📂 Complete Implementation:** [Theme Settings Standards](standards/theme-settings.md)
- Full LocaleHelper.java utility class
- Application class with theme management
- MainProfile settings UI implementation
- Selection dialogs with proper styling
- Required string resources and icons

### **3. INTEGRATION STEPS**

1. **Copy utility classes** from standards
2. **Update Application class** with theme management
3. **Add settings section** to MainProfile
4. **Include required string resources**
5. **Add necessary icons**
6. **Register Application class** in AndroidManifest.xml

**📂 Note**: This implementation uses design standards from:
- [Spacing Standards](standards/spacing-padding-standards.md) for settings section spacing
- [Style Architecture](standards/style-system-architecture.md) for dialog and selection styling
- [Theme Settings](standards/theme-settings.md) for complete implementation details

---

## ✅ IMPLEMENTATION CHECKLIST

**Core Files:**
- [ ] LocaleHelper.java utility class (from standards)
- [ ] Application class with theme management (from standards)
- [ ] MainProfile settings section (from standards)
- [ ] Settings layout files (from standards)

**Functionality:**
- [ ] Theme switching (Light/Dark/System)
- [ ] Language switching (English/Vietnamese/System) 
- [ ] Persistent storage with SharedPreferences
- [ ] Immediate UI updates after selection
- [ ] Activity recreation for language changes

**UI Components:**
- [ ] Settings section in profile with icons (from standards)
- [ ] Current value display under each setting (from standards)
- [ ] Selection dialogs with radio buttons (from standards)
- [ ] Clickable settings items with ripple effect (from standards)
    }

---

## ⚙️ JAVA IMPLEMENTATION

**📂 Complete Implementation:** [Theme Settings Standards](standards/theme-settings.md)

This file contains comprehensive Java implementation including:
- LocaleHelper utility class with all methods
- Application class with theme management
- MainProfile settings UI implementation  
- Dialog selection implementations
- String resources and layout examples

**📂 Note**: This implementation uses design standards from:
- [Spacing Standards](standards/spacing-padding-standards.md) for settings section spacing
- [Style Architecture](standards/style-system-architecture.md) for dialog and selection styling
- [Theme Settings](standards/theme-settings.md) for complete implementation details

---

## ✅ IMPLEMENTATION CHECKLIST

### **MainProfile Settings Section Implementation**

```java
public class MainProfile extends Fragment {
    private TextView tvCurrentTheme, tvCurrentLanguage;
    
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_main_profile, container, false);
        
        // Initialize views
        tvCurrentTheme = view.findViewById(R.id.tvCurrentTheme);
        tvCurrentLanguage = view.findViewById(R.id.tvCurrentLanguage);
        
        // Setup settings clicks
        setupSettingsClicks(view);
        
        // Update current values
        updateSettingsDisplay();
        
        return view;
    }
    
    private void setupSettingsClicks(View view) {
        // Theme selection click
        view.findViewById(R.id.layoutThemeSelection).setOnClickListener(v -> showThemeDialog());
        
        // Language selection click
        view.findViewById(R.id.layoutLanguageSelection).setOnClickListener(v -> showLanguageDialog());
    }
    
    private void showThemeDialog() {
        String[] themes = {
            getString(R.string.theme_light),
            getString(R.string.theme_dark), 
            getString(R.string.theme_system)
        };
        
        int currentSelection = getCurrentThemeIndex();
        
        new AlertDialog.Builder(requireContext())
            .setTitle(R.string.select_theme)
            .setSingleChoiceItems(themes, currentSelection, (dialog, which) -> {
                applyTheme(which);
                updateSettingsDisplay();
                dialog.dismiss();
            })
            .setNegativeButton(R.string.cancel, null)
            .show();
    }
}
```

**📂 Note**: This implementation uses design standards from:
- [Spacing Standards](standards/spacing-padding-standards.md) for layout spacing
- [Style Architecture](standards/style-system-architecture.md) for dialog and button styles

---

## ✅ IMPLEMENTATION CHECKLIST

**Core Files:**
- [ ] LocaleHelper.java utility class
- [ ] Application class with theme management
- [ ] MainProfile settings section
- [ ] Settings layout files

**Functionality:**
- [ ] Theme switching (Light/Dark/System)
- [ ] Language switching (English/Vietnamese/System) 
- [ ] Persistent storage with SharedPreferences
- [ ] Immediate UI updates after selection
- [ ] Activity recreation for language changes

**UI Components:**
- [ ] Settings section in profile with icons
- [ ] Current value display under each setting
- [ ] Selection dialogs with radio buttons
- [ ] Clickable settings items with ripple effect

**String Resources:**
- [ ] English strings (values/strings_settings.xml)
- [ ] Vietnamese strings (values-vi/strings_settings.xml)
- [ ] Consistent naming pattern

**Integration:**
- [ ] attachBaseContext in all Activities
- [ ] Application class registered in manifest
- [ ] Theme applied on app startup
- [ ] Language applied on app startup

This standard ensures consistent app settings experience across all Android applications!