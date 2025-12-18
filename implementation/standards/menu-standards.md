# 📱 Menu Standards Implementation

> **Comprehensive menu patterns for Android Native Java apps**

## ⚠️ **CRITICAL RULE: Menu Item Limits**

### 🎯 **Maximum Items Per Menu Type:**
- **Bottom Navigation:** 4 items maximum (Material Design standard)
- **App Bar Menu:** 5 items maximum (3-4 recommended)
- **Navigation Drawer:** No strict limit, but group related items
- **Context Menu:** 5 items maximum (3-4 recommended)

### 📱 **UX Rationale:**
- **Cognitive Load:** Users can process max 5-7 items efficiently
- **Mobile Screen:** Limited space requires prioritization
- **Thumb Reach:** Bottom navigation items must be easily accessible
- **Material Design:** Google's guidelines recommend 3-5 main actions

**❌ BAD:** 6+ items in bottom navigation, 8+ items in options menu
**✅ GOOD:** 4 items in bottom nav, 3-4 primary actions in options menu

## 🚨 **Detection & User Confirmation Workflow**

### When AI Detects 5+ Menu Items:

**STEP 1: Detection Commands**
```bash
# Detect bottom navigation menus
find . -name "*.xml" -exec grep -l "BottomNavigationView\|bottom.*nav.*menu" {} \;

# Count menu items in files
grep -c "<item" res/menu/bottom_nav_menu.xml
grep -c "<item" res/menu/main_menu.xml
```

**STEP 2: User Confirmation Required**
When >5 items detected, AI MUST show this confirmation:

```
⚠️ MENU LIMIT EXCEEDED DETECTED

Found [X] menu items in [menu_name]:
1. [Item 1 name] - android:id="@+id/item1" 
2. [Item 2 name] - android:id="@+id/item2"
3. [Item 3 name] - android:id="@+id/item3"  
4. [Item 4 name] - android:id="@+id/item4"
5. [Item 5 name] - android:id="@+id/item5"
6. [Item 6 name] - android:id="@+id/item6"

🎯 RECOMMENDATION: Move items 5+ to "More" menu for better UX.

Which items should move to "More" menu?
□ Item 5: [name]
□ Item 6: [name]
□ Keep current structure (not recommended)

Please confirm your choice.
```

**STEP 3: Implementation After Confirmation**
Only proceed with "More" menu migration after user confirms which items to move.

### 🔄 **Handling Excess Items (More Than Limits):**

#### Bottom Navigation (>4 items) → Use "More" Tab
**Approach:** Use PopupMenu anchored to "More" navigation item for cleaner UX.

```xml
<!-- Main Bottom Navigation Menu (res/menu/bottom_navigation_menu.xml) -->
<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- First 4 priority items -->
    <item
        android:id="@+id/navigation_home"
        android:icon="@drawable/ic_home"
        android:title="@string/nav_home" />
    <item
        android:id="@+id/navigation_feature"
        android:icon="@drawable/ic_feature"
        android:title="@string/nav_feature" />
    <item
        android:id="@+id/navigation_list"
        android:icon="@drawable/ic_list"
        android:title="@string/nav_list" />
    <item
        android:id="@+id/navigation_profile"
        android:icon="@drawable/ic_person"
        android:title="@string/nav_profile" />

    <!-- The "More" item (Always last) -->
    <item
        android:id="@+id/navigation_more"
        android:icon="@drawable/ic_more_horiz"
        android:title="@string/nav_more" />
</menu>
```

```xml
<!-- Overflow Menu (res/menu/more_navigation_menu.xml) -->
<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <item
        android:id="@+id/navigation_settings"
        android:icon="@drawable/ic_settings"
        android:title="@string/nav_settings" />
    <item
        android:id="@+id/navigation_help"
        android:icon="@drawable/ic_help"
        android:title="@string/nav_help" />
</menu>
```

**Java Implementation for "More" tab:**
```java
private void setupBottomNavigation() {
    bottomNavigation.setOnItemSelectedListener(item -> {
        int itemId = item.getItemId();
        
        // Handle "More" click
        if (itemId == R.id.navigation_more) {
            showMoreMenu();
            return false; // Return false to prevent selecting "More" tab visually
        }
        
        // Handle normal tabs
        Fragment fragment = getFragmentForItem(itemId);
        return loadFragment(fragment);
    });
}

private void showMoreMenu() {
    // Find the view for the "More" menu item to anchor the popup
    View view = bottomNavigation.findViewById(R.id.navigation_more);
    
    PopupMenu popup = new PopupMenu(this, view);
    popup.getMenuInflater().inflate(R.menu.more_navigation_menu, popup.getMenu());
    
    popup.setOnMenuItemClickListener(item -> {
        // Handle clicks on items inside the popup
        Fragment fragment = getFragmentForItem(item.getItemId());
        return loadFragment(fragment);
    });
    
    popup.show();
}

private Fragment getFragmentForItem(int itemId) {
    if (itemId == R.id.navigation_home) {
        return new HomeFragment();
    } else if (itemId == R.id.navigation_feature) {
        return new FeatureFragment();
    } else if (itemId == R.id.navigation_list) {
        return new ListFragment();
    } else if (itemId == R.id.navigation_profile) {
        return new ProfileFragment();
    }
    // Overflow items
    else if (itemId == R.id.navigation_settings) {
        startActivity(new Intent(this, SettingsActivity.class));
        return null; // No fragment for Activities
    } else if (itemId == R.id.navigation_help) {
        startActivity(new Intent(this, HelpActivity.class));
        return null;
    }
    return null;
}
```

**✅ Benefits of PopupMenu approach:**
- **Cleaner UX:** No full-screen overlay, contextually anchored
- **Standard pattern:** Users familiar with popup menus
- **Less code:** No custom layouts needed
- **Better performance:** Lighter than BottomSheetDialog
- **Material Design:** Built-in theming and animations
```

#### App Bar Menu (>5 items) → Use Overflow Menu
```xml
<!-- Options menu with proper showAsAction -->
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">
    
    <!-- Primary actions (visible) -->
    <item
        android:id="@+id/action_search"
        android:icon="@drawable/ic_search"
        android:title="@string/action_search"
        app:showAsAction="ifRoom" />
        
    <item
        android:id="@+id/action_share"
        android:icon="@drawable/ic_share"
        android:title="@string/action_share"
        app:showAsAction="ifRoom" />
    
    <!-- Secondary actions (overflow) -->
    <item
        android:id="@+id/action_settings"
        android:title="@string/action_settings"
        app:showAsAction="never" />
        
    <item
        android:id="@+id/action_help"
        android:title="@string/action_help"
        app:showAsAction="never" />
        
    <item
        android:id="@+id/action_about"
        android:title="@string/action_about"
        app:showAsAction="never" />
</menu>
```

---

## 🔄 Standard Menu Types

### 1. Top App Bar Menu (Options Menu)

**Activity Implementation:**
```java
@Override
public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.main_menu, menu);
    return true;
}

@Override
public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
        case R.id.action_settings:
            // Standard settings intent
            startActivity(new Intent(this, SettingsActivity.class));
            return true;
        case R.id.action_help:
            // Standard help dialog
            showHelpDialog();
            return true;
        case R.id.action_share:
            // Standard share functionality
            shareApp();
            return true;
        default:
            return super.onOptionsItemSelected(item);
    }
}
```

**Menu XML (res/menu/main_menu.xml):**
```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">
    
    <item
        android:id="@+id/action_settings"
        android:title="@string/menu_settings"
        android:icon="@drawable/ic_settings"
        app:showAsAction="never" />
    
    <item
        android:id="@+id/action_help"
        android:title="@string/menu_help"
        android:icon="@drawable/ic_help"
        app:showAsAction="never" />
    
    <item
        android:id="@+id/action_share"
        android:title="@string/menu_share"
        android:icon="@drawable/ic_share"
        app:showAsAction="ifRoom" />
</menu>
```

### 2. Navigation Drawer Menu

**Layout (activity_main.xml):**
```xml
<androidx.drawerlayout.widget.DrawerLayout
    android:id="@+id/drawer_layout"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:fitsSystemWindows="true">

    <!-- Main content -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical">
        
        <!-- Toolbar -->
        <androidx.appcompat.widget.Toolbar
            android:id="@+id/toolbar"
            android:layout_width="match_parent"
            android:layout_height="?attr/actionBarSize"
            android:background="?attr/colorPrimary"
            app:titleTextColor="@android:color/white" />
        
        <!-- Fragment container -->
        <FrameLayout
            android:id="@+id/fragment_container"
            android:layout_width="match_parent"
            android:layout_height="match_parent" />
    </LinearLayout>

    <!-- Navigation drawer -->
    <com.google.android.material.navigation.NavigationView
        android:id="@+id/nav_view"
        android:layout_width="wrap_content"
        android:layout_height="match_parent"
        android:layout_gravity="start"
        android:fitsSystemWindows="true"
        app:menu="@menu/nav_drawer_menu"
        app:headerLayout="@layout/nav_header" />

</androidx.drawerlayout.widget.DrawerLayout>
```

**Java Implementation:**
```java
public class MainActivity extends AppCompatActivity 
    implements NavigationView.OnNavigationItemSelectedListener {

    private DrawerLayout drawerLayout;
    private ActionBarDrawerToggle toggle;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Setup drawer
        drawerLayout = findViewById(R.id.drawer_layout);
        NavigationView navigationView = findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        
        // Setup toggle
        toggle = new ActionBarDrawerToggle(
            this, drawerLayout, toolbar,
            R.string.navigation_drawer_open,
            R.string.navigation_drawer_close
        );
        drawerLayout.addDrawerListener(toggle);
    }
    
    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
        Fragment selectedFragment = null;
        
        switch (item.getItemId()) {
            case R.id.nav_home:
                selectedFragment = new HomeFragment();
                break;
            case R.id.nav_feature:
                selectedFragment = new FeatureFragment();
                break;
            case R.id.nav_settings:
                startActivity(new Intent(this, SettingsActivity.class));
                break;
            case R.id.nav_about:
                showAboutDialog();
                break;
        }
        
        if (selectedFragment != null) {
            getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.fragment_container, selectedFragment)
                .commit();
        }
        
        drawerLayout.closeDrawer(GravityCompat.START);
        return true;
    }
}
```

### 3. Context Menu (Long Press)

**Fragment/Activity Implementation:**
```java
@Override
public void onCreateContextMenu(ContextMenu menu, View v, 
    ContextMenu.ContextMenuInfo menuInfo) {
    super.onCreateContextMenu(menu, v, menuInfo);
    getMenuInflater().inflate(R.menu.context_menu, menu);
}

@Override
public boolean onContextItemSelected(MenuItem item) {
    AdapterView.AdapterContextMenuInfo info = 
        (AdapterView.AdapterContextMenuInfo) item.getMenuInfo();
    
    switch (item.getItemId()) {
        case R.id.context_edit:
            editItem(info.position);
            return true;
        case R.id.context_delete:
            deleteItem(info.position);
            return true;
        case R.id.context_share:
            shareItem(info.position);
            return true;
        default:
            return super.onContextItemSelected(item);
    }
}
```

## 🎯 Standard Menu Resources

**String Resources (res/values/strings.xml):**
```xml
<!-- Menu strings -->
<string name="menu_settings">Settings</string>
<string name="menu_help">Help</string>
<string name="menu_share">Share</string>
<string name="menu_edit">Edit</string>
<string name="menu_delete">Delete</string>
<string name="menu_about">About</string>

<!-- Navigation strings -->
<string name="navigation_drawer_open">Open navigation</string>
<string name="navigation_drawer_close">Close navigation</string>
```

**Standard Menu Icons:**
- ic_settings (24dp)
- ic_help (24dp)
- ic_share (24dp)
- ic_edit (24dp)
- ic_delete (24dp)
- ic_menu (24dp)

## 📋 Implementation Checklist

### Required Files:
- [ ] res/menu/main_menu.xml
- [ ] res/menu/nav_drawer_menu.xml (if using drawer)
- [ ] res/menu/context_menu.xml (if using context menu)
- [ ] Standard menu icons in res/drawable/

### Required Methods:
- [ ] onCreateOptionsMenu()
- [ ] onOptionsItemSelected()
- [ ] Standard menu handlers (settings, help, share)

### Optional Features:
- [ ] Navigation drawer implementation
- [ ] Context menu for list items
- [ ] Custom menu animations
- [ ] Dynamic menu items