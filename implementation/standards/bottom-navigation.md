# 📱 Bottom Navigation Implementation

> **Standard Bottom Navigation patterns for Android Native Java apps**

## 🔍 Essential Bottom Navigation Components

**Required Files Structure:**
```
res/
├── layout/
│   └── activity_main_new.xml           # Fragment container + bottom nav
├── menu/
│   └── bottom_nav_menu.xml            # Navigation menu items
├── drawable/
│   └── bottom_nav_item_background.xml  # Selected state background
└── color/
    └── bottom_nav_color.xml           # Icon/text color selector
```

## ✅ MANDATORY Implementation Rules

### 1. Layout Structure (activity_main_new.xml)

**Use ConstraintLayout for proper positioning:**
```xml
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <!-- Fragment Container -->
    <FrameLayout
        android:id="@+id/fragmentContainer"
        android:layout_width="0dp"
        android:layout_height="0dp"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintBottom_toTopOf="@+id/bottomNavigation"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

    <!-- Bottom Navigation -->
    <com.google.android.material.bottomnavigation.BottomNavigationView
        android:id="@+id/bottomNavigation"
        android:layout_width="0dp"
        android:layout_height="70dp"
        android:background="@color/background_white"
        android:elevation="8dp"
        app:labelVisibilityMode="selected"
        app:menu="@menu/bottom_nav_menu"
        app:itemIconTint="@color/bottom_nav_color"
        app:itemTextColor="@color/bottom_nav_color"
        app:itemBackground="@drawable/bottom_nav_item_background"
        app:itemRippleColor="@color/ripple_light"
        app:itemIconSize="24dp"
        app:itemPaddingTop="8dp"
        app:itemPaddingBottom="8dp"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

### 2. Menu Configuration (bottom_nav_menu.xml)

**Standard 4-tab navigation pattern:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <item
        android:id="@+id/nav_home"
        android:icon="@drawable/ic_home_selector"
        android:title="@string/nav_home" />
    
    <item
        android:id="@+id/nav_add_block"
        android:icon="@drawable/ic_add_selector"
        android:title="@string/nav_add_block" />
    
    <item
        android:id="@+id/nav_list"
        android:icon="@drawable/ic_list_selector"
        android:title="@string/nav_list" />
    
    <item
        android:id="@+id/nav_profile"
        android:icon="@drawable/ic_profile_selector"
        android:title="@string/nav_profile" />
</menu>
```

### 3. Item Background Selector (bottom_nav_item_background.xml)

**Rounded selection indicator pattern:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_checked="true">
        <shape android:shape="rectangle">
            <solid android:color="#E3F5FC" />
            <corners android:radius="12dp" />
        </shape>
    </item>
    <item>
        <shape android:shape="rectangle">
            <solid android:color="@android:color/transparent" />
        </shape>
    </item>
</selector>
```

### 4. Color Selector (bottom_nav_color.xml)

**Theme-aware color switching:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:color="@color/primary" android:state_checked="true" />
    <item android:color="@color/text_hint" />
</selector>
```

## 🚨 Critical Configuration Rules

### Label Visibility (MANDATORY)
- ✅ **ALWAYS use:** `app:labelVisibilityMode="selected"`
- ❌ **NEVER use:** `app:labelVisibilityMode="always"` (cluttered UI)
- ❌ **NEVER use:** `app:labelVisibilityMode="never"` (poor UX)

### Dimensions and Spacing
- **Height:** `70dp` (56dp minimum + 14dp padding)
- **Icon size:** `24dp` (Material Design standard)
- **Padding:** Top/Bottom `8dp` each
- **Elevation:** `8dp` for proper shadow

### Icon Requirements
- Each icon MUST be a drawable selector (e.g., `ic_home_selector.xml`)
- Icons change state based on `android:state_checked="true"`
- Different visual states for selected/unselected

## ⚙️ Java Implementation

**Fragment Navigation Pattern:**
```java
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_new);
        
        setupBottomNavigation();
    }
    
    private void setupBottomNavigation() {
        BottomNavigationView bottomNavigation = findViewById(R.id.bottomNavigation);
        bottomNavigation.setOnNavigationItemSelectedListener(item -> {
            Fragment selectedFragment = null;
            
            switch (item.getItemId()) {
                case R.id.nav_home:
                    selectedFragment = new HomeFragment();
                    break;
                case R.id.nav_feature:
                    selectedFragment = new FeatureFragment();
                    break;
                case R.id.nav_list:
                    selectedFragment = new ListFragment();
                    break;
                case R.id.nav_profile:
                    selectedFragment = new MainProfile();  // Standard across all apps
                    break;
            }
            
            if (selectedFragment != null) {
                getSupportFragmentManager()
                    .beginTransaction()
                    .replace(R.id.fragmentContainer, selectedFragment)
                    .commit();
            }
            
            return true;
        });
        
        // Set default fragment
        bottomNavigation.setSelectedItemId(R.id.nav_home);
    }
}
```

## 🎨 Design Standards

**Standard Colors:****
- **Selected background:** Light blue (`#E3F5FC`) with 12dp corners
- **Selected icon/text:** Primary color
- **Unselected icon/text:** Hint text color
- **Background:** Theme-aware white/dark
- **Ripple effect:** Light ripple color

**Typography:**
- Use string resources for all menu titles
- Follow multi-language support (EN + VI required)
- Font size automatically handled by Material Design

**Visual Feedback:**
- Rounded rectangle selection indicator
- Smooth color transitions between states
- Consistent icon sizing (24dp)
- Material ripple effects on touch

## 📋 Validation Checklist

Before implementing, verify:
- ✅ `labelVisibilityMode="selected"` present
- ✅ Menu file exists with 3+ navigation items
- ✅ Color selector file exists and referenced
- ✅ Item background drawable exists and referenced
- ✅ Height >= 70dp specified
- ✅ Elevation = 8dp for shadow
- ✅ All menu titles use string resources
- ✅ Icon selectors exist for all menu items
- ✅ Fragment navigation logic implemented
- ✅ Default fragment selected in onCreate()

## 🔍 Common Issues

**Problem:** Labels always showing
**Solution:** Check `app:labelVisibilityMode="selected"` is set

**Problem:** No visual feedback on selection
**Solution:** Verify `app:itemBackground` points to valid selector drawable

**Problem:** Icons not changing state
**Solution:** Ensure icon drawables are selectors with `state_checked="true"`

**Problem:** Fragment not switching
**Solution:** Verify `OnNavigationItemSelectedListener` implementation and fragment container ID

**Problem:** Bottom nav covering content
**Solution:** Use ConstraintLayout and properly constrain fragment container to `layout_constraintBottom_toTopOf="@+id/bottomNavigation"`
