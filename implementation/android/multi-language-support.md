# 🌍 Multi-language Support

## REQUIRED for ALL Apps

**Every app MUST support at minimum:**
- English (default - `values/`)
- Vietnamese (`values-vi/`)

## File Structure

```
res/
├── values/
│   ├── strings.xml              # English (default)
│   ├── strings_alarm.xml        # Feature-specific English
│   └── strings_profile.xml
│
└── values-vi/
    ├── strings.xml              # Vietnamese translations
    ├── strings_alarm.xml        # Feature-specific Vietnamese
    └── strings_profile.xml
```

## Rules

### 1. String Naming Convention

**Pattern:** `[feature]_[element]_[descriptor]`

| Good ✅ | Bad ❌ | Reason |
|---------|--------|--------|
| `alarm_title` | `alarmTitle` | Use snake_case, not camelCase |
| `dialog_confirm` | `confirm_dialog` | Subject first, then action |
| `settings_dark_mode` | `dark_mode` | Always prefix with feature |
| `profile_version` | `version` | Avoid generic names |

### 2. String Synchronization

**CRITICAL: Both files MUST have identical string names!**

```xml
<!-- values/strings.xml (English) -->
<string name="alarm_title">Alarm Title</string>
<string name="alarm_time">Alarm Time</string>

<!-- values-vi/strings.xml (Vietnamese) -->
<string name="alarm_title">Tiêu đề báo thức</string>
<string name="alarm_time">Thời gian báo thức</string>
```

**If names mismatch → Build error!**

### 3. No Hardcoded Strings

**❌ WRONG:**
```java
tvTitle.setText("Alarm Title");
Toast.makeText(this, "Saved successfully", LENGTH_SHORT).show();
```

```xml
<TextView
    android:text="Settings"
    ... />
```

**✅ CORRECT:**
```java
tvTitle.setText(R.string.alarm_title);
Toast.makeText(this, R.string.saved_successfully, LENGTH_SHORT).show();
```

```xml
<TextView
    android:text="@string/settings_title"
    ... />
```

### 4. Technical Terms

**Some terms can stay English in both languages:**
- Vibration patterns: "Short, Medium, Long"
- Technical settings: "USB Debugging"
- Brand names: "Android", "Google"

### 5. Checklist for AI

When adding/modifying strings:

- [ ] Add to `values/strings.xml` (English)
- [ ] Add to `values-vi/strings.xml` (Vietnamese)
- [ ] Ensure string names are **IDENTICAL**
- [ ] Use snake_case naming
- [ ] Prefix with feature name
- [ ] Subject before action in name
- [ ] No hardcoded text in Java/Kotlin
- [ ] No hardcoded text in XML layouts
- [ ] Test both languages in app

## Language Selector Implementation

**In Profile/Settings:**

```java
String[] languages = {"System Default", "English", "Tiếng Việt"};
String[] languageCodes = {"", "en", "vi"};

// Show dialog
AlertDialog.Builder builder = new AlertDialog.Builder(context);
builder.setItems(languages, (dialog, which) -> {
    String code = languageCodes[which];
    
    // Save preference
    prefs.edit().putString(KEY_LANGUAGE, code).apply();
    
    // Apply language
    applyLanguage(code);
    
    // Recreate activity
    getActivity().recreate();
});
```

**In Application.onCreate():**

```java
public class MyApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        
        String lang = prefs.getString(KEY_LANGUAGE, "");
        if (!lang.isEmpty()) {
            Locale locale = new Locale(lang);
            Locale.setDefault(locale);
            
            Configuration config = getResources().getConfiguration();
            config.setLocale(locale);
            getResources().updateConfiguration(config, 
                getResources().getDisplayMetrics());
        }
    }
}
```
