# Material Design 3 Migration Guide

> **🎯 Goal:** Migrate Android app from Material Design 2 to Material Design 3 (Material You)
> 
> **📱 Support:** Android 7.0+ (API 24+) with graceful degradation
> **🎨 Material You:** Full support for Android 12+ (API 31+), fallback theming for older versions

---

## 📋 Migration Overview

### Why Material Design 3?
- **🆕 Modern UI:** Latest Google design system (2021+)
- **🎨 Dynamic Colors:** Material You adapts to user's wallpaper (Android 12+)
- **🌗 Enhanced Theming:** Better dark mode and custom color schemes
- **📱 Device Compatibility:** Works on 99%+ of active Android devices (API 24+)

### Migration Path
```
Material Design 2 (material:1.9.0)
         ↓
Material Design 3 (material:1.11.0+)
```

### Device Support Matrix
| Android Version | API Level | Material You Support | Fallback |
|-----------------|-----------|---------------------|----------|
| Android 7.0-11  | 24-30    | ❌ No | ✅ Static MD3 colors |
| Android 12+     | 31+      | ✅ Yes | ✅ Dynamic colors |

---

## 🔍 Step 0: Custom Component Review & Comparison

> **⚠️ IMPORTANT:** Before migrating, review existing custom components and compare with MD3 equivalents
> **🎯 Goal:** Get user confirmation on which components to migrate vs keep custom

### 0.1 Detection Commands for Custom Components

**Find Custom Views/Components:**
```powershell
# Find custom View classes
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String "class.*extends.*View|class.*extends.*ViewGroup" | 
    Select-Object Path, LineNumber, Line

# Find custom XML components
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String "<([a-z]+\.)+[A-Z][a-zA-Z]*" | 
    Select-Object Path, LineNumber, Line

# Find custom drawables (may have MD3 equivalents)
Get-ChildItem -Path "app\src\main\res\drawable" -Filter "*.xml" -Recurse | 
    Select-String "shape|selector|layer-list" | 
    Select-Object Path, LineNumber, Line

# Find custom styles (may conflict with MD3)
Get-ChildItem -Path "app\src\main\res\values" -Filter "styles.xml" -Recurse | 
    Select-String "<style.*name=\"Widget\.|<style.*name=\"Base\." | 
    Select-Object Path, LineNumber, Line
```

### 0.2 Component Comparison Matrix

**Generate comparison table for user decision:**

| Custom Component | Location | MD3 Equivalent | Migration Benefit | Keep Custom? |
|------------------|----------|----------------|-------------------|---------------|
| `CustomButton.java` | `com.app.views` | `MaterialButton` | ✅ Better theming, accessibility | ❓ **User Decision** |
| `RoundedCardView.xml` | `drawable/` | `MaterialCardView` | ✅ Dynamic corners, elevation | ❓ **User Decision** |
| `CustomDialog.java` | `com.app.dialogs` | `Material3 Dialog` | ✅ Better animations, theming | ❓ **User Decision** |
| `GradientButton.xml` | `drawable/` | `MaterialButton` + themes | ✅ Consistent with system | ❓ **User Decision** |
| `CustomNavigationBar` | `com.app.navigation` | `BottomNavigationView` | ✅ Material You colors | ❓ **User Decision** |

### 0.3 User Confirmation Process

**Present findings to user with options:**

```
📋 Custom Component Review Results:

Found X custom components that have Material Design 3 equivalents:

1. CustomButton.java
   ├─ Current: Custom view with manual styling
   ├─ MD3 Alternative: MaterialButton with Theme.Material3
   ├─ Benefits: Auto theming, Material You support, accessibility
   └─ Migration effort: Low (replace XML + update Java references)

2. RoundedCardView.xml
   ├─ Current: Custom drawable with fixed corners
   ├─ MD3 Alternative: MaterialCardView with dynamic styling
   ├─ Benefits: Elevation animation, theme-aware colors
   └─ Migration effort: Medium (update layouts, test elevation)

3. CustomDialog.java
   ├─ Current: Custom dialog with hardcoded styling
   ├─ MD3 Alternative: Material3 Dialog with dynamic theming
   ├─ Benefits: Consistent animations, better accessibility
   └─ Migration effort: High (rewrite dialog logic)

Options:
├─ [A] Migrate ALL components to MD3 (recommended)
├─ [S] Selective migration (choose per component)
├─ [K] Keep ALL custom components (minimal MD3 adoption)
└─ [C] Cancel migration

Choice: ___
```

### 0.4 Component-by-Component Confirmation

**If user chooses Selective (S):**

```powershell
# For each custom component found
foreach ($component in $customComponents) {
    Write-Host "\n=== $($component.Name) ==="
    Write-Host "Location: $($component.Path)"
    Write-Host "MD3 Alternative: $($component.MD3Alternative)"
    Write-Host "Migration Effort: $($component.Effort)"
    Write-Host "Benefits: $($component.Benefits)"
    
    $choice = Read-Host "Migrate this component? [Y/N/Skip]"
    $component.Migrate = $choice -eq "Y"
}
```

---

## 🚀 Step 1: Dependencies Migration

### 1.1 Update build.gradle (Module: app)

**Current (MD2):**
```gradle
dependencies {
    implementation 'com.google.android.material:material:1.9.0'
    // Other dependencies...
}
```

**Updated (MD3):**
```gradle
dependencies {
    implementation 'com.google.android.material:material:1.11.0'
    // Other dependencies...
}
```

**Verification Command:**
```powershell
# Check current Material version
Get-Content "app\build.gradle" | Select-String "material:"
```

### 1.2 Update compileSdk & targetSdk

**Recommended:**
```gradle
android {
    compileSdk 34
    targetSdk 34
    
    defaultConfig {
        minSdk 24  // Supports 99%+ devices
        // ...
    }
}
```

---

## 🎨 Step 2: Theme Migration

### 2.1 Create New Theme Files

**File Structure:**
```
app/src/main/res/values/
├── themes.xml           ← MD3 Light theme
├── themes.xml (night)   ← MD3 Dark theme
├── colors.xml           ← MD3 color system
└── attrs.xml            ← Custom attributes (existing)
```

### 2.2 Update themes.xml (Light Theme)

**Path:** `app/src/main/res/values/themes.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Material Design 3 Light Theme -->
    <style name="Base.Theme.AppName" parent="Theme.Material3.DayNight">
        <!-- Primary colors -->
        <item name="colorPrimary">@color/md_theme_light_primary</item>
        <item name="colorOnPrimary">@color/md_theme_light_onPrimary</item>
        <item name="colorPrimaryContainer">@color/md_theme_light_primaryContainer</item>
        <item name="colorOnPrimaryContainer">@color/md_theme_light_onPrimaryContainer</item>
        
        <!-- Secondary colors -->
        <item name="colorSecondary">@color/md_theme_light_secondary</item>
        <item name="colorOnSecondary">@color/md_theme_light_onSecondary</item>
        <item name="colorSecondaryContainer">@color/md_theme_light_secondaryContainer</item>
        <item name="colorOnSecondaryContainer">@color/md_theme_light_onSecondaryContainer</item>
        
        <!-- Tertiary colors -->
        <item name="colorTertiary">@color/md_theme_light_tertiary</item>
        <item name="colorOnTertiary">@color/md_theme_light_onTertiary</item>
        <item name="colorTertiaryContainer">@color/md_theme_light_tertiaryContainer</item>
        <item name="colorOnTertiaryContainer">@color/md_theme_light_onTertiaryContainer</item>
        
        <!-- Background colors -->
        <item name="android:colorBackground">@color/md_theme_light_background</item>
        <item name="colorOnBackground">@color/md_theme_light_onBackground</item>
        <item name="colorSurface">@color/md_theme_light_surface</item>
        <item name="colorOnSurface">@color/md_theme_light_onSurface</item>
        <item name="colorSurfaceVariant">@color/md_theme_light_surfaceVariant</item>
        <item name="colorOnSurfaceVariant">@color/md_theme_light_onSurfaceVariant</item>
        
        <!-- Error colors -->
        <item name="colorError">@color/md_theme_light_error</item>
        <item name="colorOnError">@color/md_theme_light_onError</item>
        <item name="colorErrorContainer">@color/md_theme_light_errorContainer</item>
        <item name="colorOnErrorContainer">@color/md_theme_light_onErrorContainer</item>
        
        <!-- Surface colors -->
        <item name="colorSurfaceInverse">@color/md_theme_light_inverseSurface</item>
        <item name="colorOnSurfaceInverse">@color/md_theme_light_inverseOnSurface</item>
        <item name="colorPrimaryInverse">@color/md_theme_light_inversePrimary</item>
        
        <!-- Status bar -->
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:windowLightStatusBar">true</item>
        
        <!-- Navigation bar -->
        <item name="android:navigationBarColor">@android:color/transparent</item>
        
        <!-- Custom attributes (keep existing) -->
        <item name="card_background">@color/md_theme_light_surface</item>
        <item name="text_primary">@color/md_theme_light_onSurface</item>
        <item name="text_secondary">@color/md_theme_light_onSurfaceVariant</item>
    </style>
    
    <!-- Application theme -->
    <style name="Theme.AppName" parent="Base.Theme.AppName" />
</resources>
```

### 2.3 Update themes.xml (Dark Theme)

**Path:** `app/src/main/res/values-night/themes.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Material Design 3 Dark Theme -->
    <style name="Base.Theme.AppName" parent="Theme.Material3.DayNight">
        <!-- Primary colors -->
        <item name="colorPrimary">@color/md_theme_dark_primary</item>
        <item name="colorOnPrimary">@color/md_theme_dark_onPrimary</item>
        <item name="colorPrimaryContainer">@color/md_theme_dark_primaryContainer</item>
        <item name="colorOnPrimaryContainer">@color/md_theme_dark_onPrimaryContainer</item>
        
        <!-- Secondary colors -->
        <item name="colorSecondary">@color/md_theme_dark_secondary</item>
        <item name="colorOnSecondary">@color/md_theme_dark_onSecondary</item>
        <item name="colorSecondaryContainer">@color/md_theme_dark_secondaryContainer</item>
        <item name="colorOnSecondaryContainer">@color/md_theme_dark_onSecondaryContainer</item>
        
        <!-- Tertiary colors -->
        <item name="colorTertiary">@color/md_theme_dark_tertiary</item>
        <item name="colorOnTertiary">@color/md_theme_dark_onTertiary</item>
        <item name="colorTertiaryContainer">@color/md_theme_dark_tertiaryContainer</item>
        <item name="colorOnTertiaryContainer">@color/md_theme_dark_onTertiaryContainer</item>
        
        <!-- Background colors -->
        <item name="android:colorBackground">@color/md_theme_dark_background</item>
        <item name="colorOnBackground">@color/md_theme_dark_onBackground</item>
        <item name="colorSurface">@color/md_theme_dark_surface</item>
        <item name="colorOnSurface">@color/md_theme_dark_onSurface</item>
        <item name="colorSurfaceVariant">@color/md_theme_dark_surfaceVariant</item>
        <item name="colorOnSurfaceVariant">@color/md_theme_dark_onSurfaceVariant</item>
        
        <!-- Error colors -->
        <item name="colorError">@color/md_theme_dark_error</item>
        <item name="colorOnError">@color/md_theme_dark_onError</item>
        <item name="colorErrorContainer">@color/md_theme_dark_errorContainer</item>
        <item name="colorOnErrorContainer">@color/md_theme_dark_onErrorContainer</item>
        
        <!-- Surface colors -->
        <item name="colorSurfaceInverse">@color/md_theme_dark_inverseSurface</item>
        <item name="colorOnSurfaceInverse">@color/md_theme_dark_inverseOnSurface</item>
        <item name="colorPrimaryInverse">@color/md_theme_dark_inversePrimary</item>
        
        <!-- Status bar -->
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:windowLightStatusBar">false</item>
        
        <!-- Navigation bar -->
        <item name="android:navigationBarColor">@android:color/transparent</item>
        
        <!-- Custom attributes (keep existing) -->
        <item name="card_background">@color/md_theme_dark_surface</item>
        <item name="text_primary">@color/md_theme_dark_onSurface</item>
        <item name="text_secondary">@color/md_theme_dark_onSurfaceVariant</item>
    </style>
</resources>
```

### 2.4 Create MD3 Color System

**Path:** `app/src/main/res/values/colors.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Material Design 3 Light Colors -->
    <color name="md_theme_light_primary">#1976D2</color>
    <color name="md_theme_light_onPrimary">#FFFFFF</color>
    <color name="md_theme_light_primaryContainer">#BBDEFB</color>
    <color name="md_theme_light_onPrimaryContainer">#0D47A1</color>
    
    <color name="md_theme_light_secondary">#FF5722</color>
    <color name="md_theme_light_onSecondary">#FFFFFF</color>
    <color name="md_theme_light_secondaryContainer">#FFCCBC</color>
    <color name="md_theme_light_onSecondaryContainer">#BF360C</color>
    
    <color name="md_theme_light_tertiary">#4CAF50</color>
    <color name="md_theme_light_onTertiary">#FFFFFF</color>
    <color name="md_theme_light_tertiaryContainer">#C8E6C9</color>
    <color name="md_theme_light_onTertiaryContainer">#1B5E20</color>
    
    <color name="md_theme_light_error">#F44336</color>
    <color name="md_theme_light_onError">#FFFFFF</color>
    <color name="md_theme_light_errorContainer">#FFCDD2</color>
    <color name="md_theme_light_onErrorContainer">#C62828</color>
    
    <color name="md_theme_light_background">#FAFAFA</color>
    <color name="md_theme_light_onBackground">#212121</color>
    <color name="md_theme_light_surface">#FFFFFF</color>
    <color name="md_theme_light_onSurface">#212121</color>
    <color name="md_theme_light_surfaceVariant">#F5F5F5</color>
    <color name="md_theme_light_onSurfaceVariant">#424242</color>
    
    <color name="md_theme_light_inverseSurface">#303030</color>
    <color name="md_theme_light_inverseOnSurface">#F5F5F5</color>
    <color name="md_theme_light_inversePrimary">#90CAF9</color>
    
    <!-- Material Design 3 Dark Colors -->
    <color name="md_theme_dark_primary">#90CAF9</color>
    <color name="md_theme_dark_onPrimary">#0D47A1</color>
    <color name="md_theme_dark_primaryContainer">#1565C0</color>
    <color name="md_theme_dark_onPrimaryContainer">#E3F2FD</color>
    
    <color name="md_theme_dark_secondary">#FFAB91</color>
    <color name="md_theme_dark_onSecondary">#BF360C</color>
    <color name="md_theme_dark_secondaryContainer">#E64A19</color>
    <color name="md_theme_dark_onSecondaryContainer">#FBE9E7</color>
    
    <color name="md_theme_dark_tertiary">#A5D6A7</color>
    <color name="md_theme_dark_onTertiary">#1B5E20</color>
    <color name="md_theme_dark_tertiaryContainer">#2E7D32</color>
    <color name="md_theme_dark_onTertiaryContainer">#E8F5E8</color>
    
    <color name="md_theme_dark_error">#EF5350</color>
    <color name="md_theme_dark_onError">#C62828</color>
    <color name="md_theme_dark_errorContainer">#D32F2F</color>
    <color name="md_theme_dark_onErrorContainer">#FFEBEE</color>
    
    <color name="md_theme_dark_background">#121212</color>
    <color name="md_theme_dark_onBackground">#E0E0E0</color>
    <color name="md_theme_dark_surface">#1E1E1E</color>
    <color name="md_theme_dark_onSurface">#E0E0E0</color>
    <color name="md_theme_dark_surfaceVariant">#2E2E2E</color>
    <color name="md_theme_dark_onSurfaceVariant">#BDBDBD</color>
    
    <color name="md_theme_dark_inverseSurface">#E0E0E0</color>
    <color name="md_theme_dark_inverseOnSurface">#2E2E2E</color>
    <color name="md_theme_dark_inversePrimary">#1976D2</color>
    
    <!-- Legacy colors (for backward compatibility) -->
    <color name="colorPrimary">@color/md_theme_light_primary</color>
    <color name="colorPrimaryDark">@color/md_theme_light_primaryContainer</color>
    <color name="colorAccent">@color/md_theme_light_secondary</color>
</resources>
```

---

## 🔧 Step 3: Component Migration (Based on User Selection)

> **📋 This step executes based on user's component selection from Step 0**
> **✅ Only migrate components user confirmed in the comparison review**

### 3.0 Migration Execution Strategy

**For each component user selected to migrate:**

1. **Create backup** of original component
2. **Show before/after** code comparison  
3. **Apply migration** with user confirmation
4. **Test functionality** before proceeding to next
5. **Rollback option** if issues found

### 3.1 Bottom Navigation (Material Design 3)

**⚠️ Execute only if user selected to migrate navigation components**

**Update:** `app/src/main/res/menu/bottom_navigation_menu.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <item
        android:id="@+id/nav_home"
        android:icon="@drawable/ic_home"
        android:title="@string/nav_home" />
    
    <item
        android:id="@+id/nav_features"
        android:icon="@drawable/ic_features"
        android:title="@string/nav_features" />
    
    <!-- More items... -->
</menu>
```

**Update:** `app/src/main/res/layout/activity_main.xml`

```xml
<com.google.android.material.bottomnavigation.BottomNavigationView
    android:id="@+id/bottom_navigation"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_alignParentBottom="true"
    app:labelVisibilityMode="selected"
    app:menu="@menu/bottom_navigation_menu"
    app:itemIconTint="@drawable/bottom_navigation_color_selector"
    app:itemTextColor="@drawable/bottom_navigation_color_selector"
    app:itemBackground="@drawable/bottom_navigation_item_background"
    style="@style/Widget.Material3.BottomNavigationView" />
```

### 3.2 CardView Migration (User-Confirmed Components Only)

**⚠️ Execute only if user confirmed CardView migration in Step 0**

**Pre-Migration Backup:**
```powershell
# Create backup before migration
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Copy-Item "app\src\main\res\layout" "app\src\main\res\layout_backup_$timestamp" -Recurse
Write-Host "✅ Backup created: layout_backup_$timestamp"
```

**Show Before/After Comparison to User:**

```
📋 CardView Migration Preview:

📄 File: activity_main.xml (Line 25-35)

❌ BEFORE (Custom CardView):
<androidx.cardview.widget.CardView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:cardCornerRadius="12dp"           ← Fixed radius
    app:cardElevation="4dp"               ← Static elevation
    app:cardBackgroundColor="?attr/card_background">  ← Custom color
    
    <!-- Content -->
    
</androidx.cardview.widget.CardView>

✅ AFTER (Material Design 3):
<com.google.android.material.card.MaterialCardView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:cardCornerRadius="16dp"           ← MD3 radius
    app:cardElevation="2dp"               ← MD3 elevation
    app:cardBackgroundColor="?attr/colorSurface"    ← MD3 surface color
    app:strokeWidth="1dp"                 ← NEW: outline support
    app:strokeColor="?attr/colorOutline"  ← NEW: dynamic outline
    style="@style/Widget.Material3.CardView.Elevated">  ← NEW: MD3 styling
    
    <!-- Content -->
    
</com.google.android.material.card.MaterialCardView>

🎯 Benefits:
  ✅ Dynamic corner radius based on theme
  ✅ Material You elevation animation
  ✅ Automatic outline for accessibility
  ✅ Theme-aware surface colors
  ✅ Better contrast in dark mode

⚠️ Changes:
  📝 Import: Add com.google.android.material.card.MaterialCardView
  📝 Radius: 12dp → 16dp (MD3 standard)
  📝 Elevation: 4dp → 2dp (MD3 subtle elevation)
  📝 Background: Custom attr → colorSurface

Proceed with this migration? [Y/N/Skip]: ___
```

**Apply Migration (if user confirms):**
```xml
<!-- Migrated CardView -->
<com.google.android.material.card.MaterialCardView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:cardCornerRadius="16dp"
    app:cardElevation="2dp"
    app:cardBackgroundColor="?attr/colorSurface"
    app:strokeWidth="1dp"
    app:strokeColor="?attr/colorOutline"
    style="@style/Widget.Material3.CardView.Elevated">
    
    <!-- Content unchanged -->
    
</com.google.android.material.card.MaterialCardView>
```

**Post-Migration Test:**
```powershell
# Test build after CardView migration
.\gradlew assembleDebug
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ CardView migration successful"
} else {
    Write-Host "❌ Build failed. Rolling back CardView changes..."
    # Rollback logic here
}
```

### 3.3 Button Migration (Custom → Material Design 3)

**⚠️ Execute only if user confirmed Button migration in Step 0**

**Common Custom Button Patterns Found:**

**A. Custom Button Class Migration:**

```
📋 Custom Button Migration Preview:

📄 File: CustomButton.java + button_custom.xml

❌ BEFORE (Custom Button):
// CustomButton.java
public class CustomButton extends AppCompatButton {
    public CustomButton(Context context) {
        super(context);
        setBackground(ContextCompat.getDrawable(context, R.drawable.button_gradient));
        setTextColor(Color.WHITE);
        setPadding(32, 16, 32, 16);
    }
}

// button_gradient.xml
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <gradient
        android:startColor="#FF6200EE"
        android:endColor="#FF3700B3" />
    <corners android:radius="8dp" />
</shape>

✅ AFTER (MaterialButton):
<!-- Layout XML -->
<com.google.android.material.button.MaterialButton
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="@string/button_text"
    style="@style/Widget.Material3.Button"
    app:backgroundTint="?attr/colorPrimary" />

// No custom Java class needed!
// Styling handled by Material3 themes

🎯 Benefits:
  ✅ Automatic Material You color adaptation
  ✅ Built-in ripple effects
  ✅ Accessibility improvements (touch target, contrast)
  ✅ Consistent with system design language
  ✅ No custom code maintenance

⚠️ Changes:
  📝 Remove: CustomButton.java class (48 lines)
  📝 Remove: button_gradient.xml drawable
  📝 Update: Replace <com.app.CustomButton> in layouts
  📝 Colors: Will adapt to user's Material You theme

Proceed with Button migration? [Y/N/Skip]: ___
```

**B. Migration Execution (if confirmed):**

**Step 1 - Replace in layouts:**
```xml
<!-- OLD -->
<com.app.views.CustomButton
    android:id="@+id/btn_action"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="@string/action_button" />

<!-- NEW -->
<com.google.android.material.button.MaterialButton
    android:id="@+id/btn_action"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="@string/action_button"
    style="@style/Widget.Material3.Button" />
```

**Step 2 - Update Java references:**
```java
// OLD
CustomButton actionButton = findViewById(R.id.btn_action);

// NEW  
MaterialButton actionButton = findViewById(R.id.btn_action);
// Import: com.google.android.material.button.MaterialButton
```

**Step 3 - Remove custom files:**
```powershell
# After successful migration
Remove-Item "app\src\main\java\com\app\views\CustomButton.java"
Remove-Item "app\src\main\res\drawable\button_gradient.xml"
Write-Host "✅ Cleaned up custom button files"
```

**Material3 Button Styles Available:**
```xml
<!-- Filled Button (Primary) -->
<com.google.android.material.button.MaterialButton
    style="@style/Widget.Material3.Button" />

<!-- Outlined Button (Secondary) -->
<com.google.android.material.button.MaterialButton
    style="@style/Widget.Material3.Button.OutlinedButton" />

<!-- Text Button (Tertiary) -->
<com.google.android.material.button.MaterialButton
    style="@style/Widget.Material3.Button.TextButton" />

<!-- Tonal Button (New in MD3) -->
<com.google.android.material.button.MaterialButton
    style="@style/Widget.Material3.Button.TonalButton" />
```

---

## ⚗️ Step 4: Dynamic Colors (Material You)

### 4.1 Enable Dynamic Colors (Android 12+)

**Add to MainActivity.java:**

```java
public class MainActivity extends AppCompatActivity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Apply dynamic colors if supported (Android 12+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            DynamicColors.applyToActivityIfAvailable(this);
        }
        
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Rest of initialization...
    }
}
```

**Import required:**
```java
import com.google.android.material.color.DynamicColors;
import android.os.Build;
```

### 4.2 Graceful Degradation for Older Devices

**Theme Selection Logic:**

```java
public class ThemeUtils {
    
    public static void applyTheme(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12+: Use Material You dynamic colors
            DynamicColors.applyToActivityIfAvailable((Activity) context);
        } else {
            // Android 7-11: Use static MD3 colors
            // Theme already applied via themes.xml
            Log.d("ThemeUtils", "Using static Material Design 3 colors");
        }
    }
}
```

---

## 🔄 Step 4: Migration Rollback & Recovery

> **🛡️ Safety First:** Always provide rollback options for component migrations
> **📋 Track:** Keep detailed log of what was changed for easy reversal

### 4.1 Rollback Procedures

**If any component migration fails:**

```powershell
# Automatic rollback script
$timestamp = "20241212-143000"  # From Step 3 backup

# Restore layouts
if (Test-Path "app\src\main\res\layout_backup_$timestamp") {
    Remove-Item "app\src\main\res\layout" -Recurse -Force
    Rename-Item "app\src\main\res\layout_backup_$timestamp" "layout"
    Write-Host "✅ Layouts restored from backup"
}

# Restore Java files (if backed up)
if (Test-Path "app\src\main\java_backup_$timestamp") {
    Remove-Item "app\src\main\java" -Recurse -Force  
    Rename-Item "app\src\main\java_backup_$timestamp" "java"
    Write-Host "✅ Java files restored from backup"
}

# Clean build
.\gradlew clean assembleDebug
Write-Host "✅ Rollback complete. App restored to pre-migration state."
```

### 4.2 Component Migration Log

**Track all changes for accountability:**

```markdown
# Component Migration Log - [Date]

## User Selections
| Component | Decision | Reason |
|-----------|----------|--------|
| CustomButton | ✅ Migrate | Better theming support |
| RoundedCardView | ❌ Keep | Complex custom animations |
| CustomDialog | ✅ Migrate | MD3 accessibility features |

## Executed Migrations
| Component | Status | Files Modified | Issues |
|-----------|--------|----------------|---------|
| CustomButton | ✅ Success | 3 layouts, 2 Java files | None |
| CustomDialog | ⚠️ Partial | 1 Java file | Styling issue - fixed |

## Rollback Information
| Backup | Location | Created |
|--------|----------|----------|
| Layouts | `layout_backup_20241212-143000` | 14:30 |
| Java | `java_backup_20241212-143000` | 14:30 |

## Final Status
✅ 2/2 selected components migrated successfully
✅ Build passes
✅ Manual testing completed
```

### 4.3 Testing Each Component After Migration

**Incremental testing approach:**

```powershell
# Test after each component migration
function Test-ComponentMigration {
    param([string]$ComponentName)
    
    Write-Host "\n=== Testing $ComponentName Migration ==="
    
    # Build test
    .\gradlew assembleDebug
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Build failed after $ComponentName migration"
        return $false
    }
    
    # Layout inflation test (if possible)
    # Manual test prompt
    Write-Host "✅ Build successful"
    Write-Host "📱 Please test $ComponentName functionality manually:"
    Write-Host "   1. Does the component appear correctly?"
    Write-Host "   2. Does interaction work (click, scroll, etc.)?"
    Write-Host "   3. Does theming look correct in light/dark mode?"
    
    $testResult = Read-Host "Component working correctly? [Y/N]"
    return $testResult -eq "Y"
}

# Usage
$buttonMigrationOK = Test-ComponentMigration "MaterialButton"
if (-not $buttonMigrationOK) {
    Write-Host "⚠️ Rolling back MaterialButton migration..."
    # Execute rollback
}
```

---

## ✅ Step 5: Testing & Verification

### 5.1 Build Test

```powershell
# Clean and build project
.\gradlew clean assembleDebug

# Check for Material Design 3 usage
Get-Content "app\build.gradle" | Select-String "material:1.11"
```

### 5.2 Visual Testing Checklist

**Test on Different Android Versions:**

| Test Case | Android 7-11 (API 24-30) | Android 12+ (API 31+) |
|-----------|---------------------------|------------------------|
| **App Launch** | ✅ Static MD3 colors | ✅ Dynamic colors from wallpaper |
| **Light Mode** | ✅ Static light theme | ✅ Material You light theme |
| **Dark Mode** | ✅ Static dark theme | ✅ Material You dark theme |
| **Button Styles** | ✅ MD3 button styles | ✅ MD3 with dynamic colors |
| **Card Components** | ✅ MD3 card elevation | ✅ MD3 with surface colors |
| **Navigation** | ✅ MD3 navigation bar | ✅ MD3 with system colors |

### 5.3 Manual Test Steps

1. **Install on device with Android 12+:**
   - Change wallpaper → App colors should adapt
   - Toggle light/dark mode → Smooth transitions

2. **Install on device with Android 7-11:**
   - Colors remain consistent (static)
   - All components render correctly
   - No crashes or missing themes

---

## 🐛 Troubleshooting

### Issue 1: Build Errors After Migration

**Problem:** Compilation fails with theme attribute errors

**Solution:**
```powershell
# Clean build cache
.\gradlew clean

# Update all Material components in layouts
# Replace 'app:theme' with 'style="@style/Widget.Material3.*"'
```

### Issue 2: Colors Not Applying on Older Devices

**Problem:** MD3 colors not showing on Android 7-11

**Solution:**
- Verify `colors.xml` has all `md_theme_light_*` and `md_theme_dark_*` colors
- Check themes.xml references correct color names
- Ensure no `@android:color/system_*` references (Android 12+ only)

### Issue 3: Dynamic Colors Not Working

**Problem:** Material You colors not adapting to wallpaper

**Solution:**
```java
// Check if device supports dynamic colors
if (DynamicColors.isDynamicColorAvailable()) {
    DynamicColors.applyToActivityIfAvailable(this);
} else {
    Log.d("MainActivity", "Dynamic colors not available on this device");
}
```

---

## 📊 Migration Verification Commands

### Check Material Version
```powershell
Get-Content "app\build.gradle" | Select-String "material:"
```

### Find MD2 Remnants (Should be zero)
```powershell
# Check for old MD2 parent themes
Get-ChildItem -Path "app\src\main\res\values" -Filter "*.xml" -Recurse | 
    Select-String "Theme.MaterialComponents" | 
    Select-Object Path, LineNumber, Line
```

### Verify MD3 Implementation
```powershell
# Check for MD3 themes
Get-ChildItem -Path "app\src\main\res\values" -Filter "themes.xml" -Recurse | 
    Select-String "Theme.Material3" | 
    Select-Object Path, LineNumber, Line
```

---

## 📈 Benefits After Migration

| Aspect | Material Design 2 | Material Design 3 |
|--------|------------------|-------------------|
| **Design Language** | 2018 guidelines | 2021+ guidelines |
| **Dynamic Colors** | ❌ Static only | ✅ Material You (Android 12+) |
| **Accessibility** | ✅ Good | ✅ Enhanced |
| **Performance** | ✅ Good | ✅ Optimized |
| **Component Variety** | ✅ Standard set | ✅ Expanded set |
| **Cross-platform** | ❌ Android only | ✅ Android + Web + Flutter |

---

## 🔗 Additional Resources

- **Material Design 3 Official Guide:** https://m3.material.io/
- **Android Developer Guide:** https://developer.android.com/develop/ui/views/theming/material3
- **Migration Codelab:** https://developer.android.com/codelabs/material-theming

---

*Last updated: December 2024*
*Next review: When Material Design 4 is released*