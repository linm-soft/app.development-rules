# 🎨 Theme & Settings

[← Back to Implementation](../)

---

## ⚙️ JAVA IMPLEMENTATION

### **1. LocaleHelper Utility Class**

**File: `utils/LocaleHelper.java`**
```java
package com.yourapp.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import java.util.Locale;

public class LocaleHelper {
    private static final String PREF_NAME = "app_settings";
    private static final String KEY_LANGUAGE = "language";

    /**
     * Apply saved language to context
     */
    public static Context applyLanguage(Context context) {
        String language = getLanguage(context);
        return applyLanguage(context, language);
    }

    /**
     * Apply specific language to context
     */
    public static Context applyLanguage(Context context, String language) {
        Locale locale;
        
        if ("system".equals(language)) {
            // Use system default language
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                locale = Resources.getSystem().getConfiguration().getLocales().get(0);
            } else {
                locale = Resources.getSystem().getConfiguration().locale;
            }
        } else {
            // Use specific language
            locale = new Locale(language);
        }
        
        Locale.setDefault(locale);
        
        Configuration config = new Configuration(context.getResources().getConfiguration());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            config.setLocale(locale);
            return context.createConfigurationContext(config);
        } else {
            config.locale = locale;
            context.getResources().updateConfiguration(config, context.getResources().getDisplayMetrics());
            return context;
        }
    }

    /**
     * Get saved language preference
     */
    public static String getLanguage(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        return prefs.getString(KEY_LANGUAGE, "system");
    }

    /**
     * Save language preference
     */
    public static void setLanguage(Context context, String language) {
        SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(KEY_LANGUAGE, language).apply();
    }
}
```

### **2. Application Class Theme Management**

**File: `YourApp.java` (extends Application)**
```java
public class YourApp extends Application {
    private static final String PREF_NAME = "app_settings";
    private static final String KEY_THEME_MODE = "theme_mode";

    @Override
    public void onCreate() {
        super.onCreate();
        applyTheme();
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(LocaleHelper.applyLanguage(base));
    }

    private void applyTheme() {
        SharedPreferences prefs = getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        String themeMode = prefs.getString(KEY_THEME_MODE, "light");
        
        switch (themeMode) {
            case "light":
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                break;
            case "dark":
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                break;
            case "system":
            default:
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                break;
        }
    }
    
    public static void setThemeMode(Context context, String mode) {
        SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(KEY_THEME_MODE, mode).apply();
        
        switch (mode) {
            case "light":
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
                break;
            case "dark":
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
                break;
            case "system":
            default:
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
                break;
        }
    }
}
```

### **3. MainProfile Settings Implementation**

```java
private void setupAppSettingsSection(View view) {
    LinearLayout layoutThemeSelection = view.findViewById(R.id.layoutThemeSelection);
    LinearLayout layoutLanguageSelection = view.findViewById(R.id.layoutLanguageSelection);
    TextView tvCurrentTheme = view.findViewById(R.id.tvCurrentTheme);
    TextView tvCurrentLanguage = view.findViewById(R.id.tvCurrentLanguage);
    
    // Update current displays
    updateThemeDisplay(tvCurrentTheme);
    updateLanguageDisplay(tvCurrentLanguage);
    
    // Click listeners
    layoutThemeSelection.setOnClickListener(v -> showThemeSelectionDialog(tvCurrentTheme));
    layoutLanguageSelection.setOnClickListener(v -> showLanguageSelectionDialog(tvCurrentLanguage));
}

private void showThemeSelectionDialog(TextView tvCurrentTheme) {
    String[] themes = {
        getString(R.string.theme_light),
        getString(R.string.theme_dark),
        getString(R.string.theme_system)
    };
    String[] themeCodes = {"light", "dark", "system"};
    
    String currentTheme = YourApp.getThemeMode(getContext());
    int selectedIndex = 2; // Default to system
    for (int i = 0; i < themeCodes.length; i++) {
        if (themeCodes[i].equals(currentTheme)) {
            selectedIndex = i;
            break;
        }
    }
    
    new AlertDialog.Builder(requireContext())
        .setTitle(R.string.select_theme)
        .setSingleChoiceItems(themes, selectedIndex, (dialog, which) -> {
            YourApp.setThemeMode(getContext(), themeCodes[which]);
            updateThemeDisplay(tvCurrentTheme);
            dialog.dismiss();
        })
        .setNegativeButton(android.R.string.cancel, null)
        .show();
}
```

---

## 🎨 UI IMPLEMENTATION

## Required Files (CRITICAL)

| File | Path | Purpose |
|------|------|---------|
| `attrs.xml` | `values/attrs.xml` | Custom theme attributes |
| `styles_theme.xml` | `values/styles_theme.xml` | Light theme with NoActionBar |
| `styles_theme.xml` | `values-night/styles_theme.xml` | Dark theme |
| `colors_*.xml` | `values/` and `values-night/` | Colors for both modes |
| `dialog_background.xml` | `drawable/dialog_background.xml` | Dialog rounded corners |

## Theme-aware Colors

**❌ NEVER use:** `@color/background_dark`, `@color/card_background_dark` directly in layouts

**✅ ALWAYS use:** `@color/background_light`, `@color/card_background` - Android auto-switches

## CardView Rules (CRITICAL)

**ALWAYS set:**
```xml
<CardView
    app:cardBackgroundColor="@color/card_background" />
```

**NOT:**
- ❌ `android:backgroundTint`
- ❌ `@android:color/white`
- ❌ Missing `cardBackgroundColor` (will be white in dark mode!)

## Color Selector Files

**❌ WRONG:** Hardcoded hex in selectors
```xml
<item android:color="#09A3E3" android:state_checked="true" />
```

**✅ CORRECT:** Color resource references
```xml
<item android:color="@color/primary" android:state_checked="true" />
```

## Settings Implementation

- Dark Mode toggle: `AppCompatDelegate.setDefaultNightMode()`
- Language selector: Dialog with System/EN/VI options
- Store in SharedPreferences
- Apply in Application class `onCreate()`
