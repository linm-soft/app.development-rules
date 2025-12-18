# Permissions Handling Implementation (Rule 2.12)

> Complete permission system pattern based on smart-call-block app analysis

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "permissions-handling implementation"...
```

**Purpose:** Let user know AI is referencing permissions implementation details.

---

## 🎯 RELATED STANDARDS

**📂 Design Standards References:**
- [Spacing & Padding Standards](standards/spacing-padding-standards.md) - Dialog padding and section spacing
- [Border & Shape Standards](standards/border-shape-standards.md) - Permission status indicators and dialog shapes
- [Style System Architecture](standards/style-system-architecture.md) - Dialog styles, button styles, text appearance

**📂 Implementation Standards:**
- [App Profile](standards/app-profile.md) - Where permissions status is displayed
- [Permissions Implementation](standards/permissions-implementation.md) - Complete UI + Java implementation

---

## 🎯 PERMISSION SYSTEM STANDARD

### **1. MANIFEST DECLARATION STRATEGY**

**Pattern for AndroidManifest.xml:**
```xml
<!-- Core permissions - always required -->
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.ANSWER_PHONE_CALLS" />
<uses-permission android:name="android.permission.READ_CONTACTS" />

<!-- Optional/Enhanced features -->
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />

<!-- Version-specific permissions -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
    android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
    android:maxSdkVersion="28" />

<!-- Special roles -->
<uses-permission android:name="android.permission.BIND_SCREENING_SERVICE" />
```

**Key Principles:**
- **Group by necessity**: Core vs Optional vs Version-specific
- **Use maxSdkVersion**: For deprecated permissions
- **Comment clearly**: Why each permission is needed

---

### **2. PERMISSION REQUEST FLOW**

**Progressive Request Strategy:**
1. **Regular permissions** → Group request with rationale
2. **Overlay permission** → Educational dialog + Settings redirect  
3. **Special roles** → System role request dialog

**📂 Complete Implementation:** [Permissions Implementation Standards](standards/permissions-implementation.md)
- Full MainActivity permission flow
- PermissionInfo data model
- MainProfile permissions section UI + Java
- Educational dialogs with proper styling
- Permission status checking logic

---

## ⚙️ JAVA IMPLEMENTATION

**📂 Complete Implementation:** [Permissions Implementation Standards](standards/permissions-implementation.md)

This file contains comprehensive implementation including:
- MainActivity permission request flow
- PermissionInfo data model class
- MainProfile permissions section implementation
- Permission status checking logic
- Educational dialog implementations
- UI layouts with proper styling

### **3. PROFILE SECTION IMPLEMENTATION**

**A. Permission Status Display:**

**Visual Pattern:**
- ✅ **Green checkbox**: Permission granted
- ❌ **Red X**: Permission denied
- **Summary count**: "4/5 permissions granted"  
- **Request button**: Visible only when missing permissions

**Implementation in MainProfile.java:**
```java
private void updatePermissionsDisplay() {
    PermissionInfo[] permissions = {
        new PermissionInfo("Phone State", "Detect incoming calls", 
            Manifest.permission.READ_PHONE_STATE, false),
        new PermissionInfo("Contacts", "Allow contact calls", 
            Manifest.permission.READ_CONTACTS, false), 
        new PermissionInfo("Answer Calls", "End blocked calls",
            Manifest.permission.ANSWER_PHONE_CALLS, false),
        new PermissionInfo("Display Over Apps", "Show block button",
            "overlay", true),
        new PermissionInfo("Call Screening", "Screen incoming calls",
            "call_screening", true)
    };

    permissionsContainer.removeAllViews();
    int grantedCount = 0;
    int totalCount = permissions.length;
    boolean allGranted = true;

    for (PermissionInfo permInfo : permissions) {
        View itemView = getLayoutInflater().inflate(R.layout.item_permission, null);
        
        TextView tvName = itemView.findViewById(R.id.tvPermissionName);
        TextView tvDescription = itemView.findViewById(R.id.tvPermissionDescription);
        ImageView ivStatus = itemView.findViewById(R.id.ivPermissionStatus);
        
        tvName.setText(permInfo.name);
        tvDescription.setText(permInfo.description);
        
        boolean isGranted = checkPermission(permInfo.permission, permInfo.isSpecial);
        
        if (isGranted) {
            ivStatus.setImageResource(android.R.drawable.checkbox_on_background);
            ivStatus.setColorFilter(Color.parseColor("#4CAF50")); // Green
            grantedCount++;
        } else {
            ivStatus.setImageResource(android.R.drawable.checkbox_off_background);
            ivStatus.setColorFilter(Color.parseColor("#F44336")); // Red
            allGranted = false;
        }
        
        // Clickable to open settings
        itemView.setOnClickListener(v -> openPermissionSettings(permInfo));
        
        permissionsContainer.addView(itemView);
    }
    
    // Update summary
    tvPermissionsSummary.setText(String.format(getString(R.string.permissions_summary), 
        grantedCount, totalCount));
    
    // Update UI colors
    if (allGranted) {
        tvPermissionsSummary.setTextColor(Color.parseColor("#4CAF50")); // Green
    } else {
        tvPermissionsSummary.setTextColor(Color.parseColor("#F44336")); // Red  
    }
    
    // Show/hide request button
    btnRequestPermissions.setVisibility(allGranted ? View.GONE : View.VISIBLE);
}

private boolean checkPermission(String permission, boolean isSpecial) {
    if (getContext() == null) return false;
    
    if (isSpecial) {
        if (permission.equals("overlay")) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                return Settings.canDrawOverlays(getContext());
            }
            return true;
        } else if (permission.equals("call_screening")) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                RoleManager roleManager = getContext().getSystemService(RoleManager.class);
                return roleManager != null && roleManager.isRoleHeld(RoleManager.ROLE_CALL_SCREENING);
            }
            return true;
        }
    } else {
        return ContextCompat.checkSelfPermission(getContext(), permission) 
            == PackageManager.PERMISSION_GRANTED;
    }
    
    return false;
}
```

**B. Data Model:**
```java
private static class PermissionInfo {
    String name;
    String description;
    String permission;
    boolean isSpecial; // For overlay, call screening, etc.
    
    PermissionInfo(String name, String description, String permission, boolean isSpecial) {
        this.name = name;
        this.description = description;
        this.permission = permission;
        this.isSpecial = isSpecial;
    }
}
```

---

### **4. UI LAYOUTS**

**A. Permission Item Layout (item_permission.xml):**
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal"
    android:background="?attr/selectableItemBackground"
    android:padding="@dimen/spacing_normal"
    android:gravity="center_vertical">

    <!-- Permission Info -->
    <LinearLayout
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:orientation="vertical">

        <TextView
            android:id="@+id/tvPermissionName"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textColor="@color/text_primary"
            android:textSize="15sp"
            android:textStyle="bold" />

        <TextView
            android:id="@+id/tvPermissionDescription"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:textColor="@color/text_secondary"
            android:textSize="13sp"
            android:layout_marginTop="4dp" />
    </LinearLayout>

    <!-- Status Icon -->
    <ImageView
        android:id="@+id/ivPermissionStatus"
        android:layout_width="24dp"
        android:layout_height="24dp"
        android:layout_marginStart="16dp"
        android:contentDescription="@string/permission_status" />
</LinearLayout>
```

**B. Profile Permissions Section (main_profile_permissions_section.xml):**
```xml
<androidx.cardview.widget.CardView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:cardCornerRadius="@dimen/card_corner_radius"
    app:cardElevation="@dimen/card_elevation"
    app:cardBackgroundColor="@color/card_background">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="@dimen/spacing_normal">

        <!-- Header with expand/collapse -->
        <LinearLayout
            android:id="@+id/permissionsHeader"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:gravity="center_vertical"
            android:clickable="true"
            android:background="?attr/selectableItemBackground">

            <TextView
                android:layout_width="0dp"
                android:layout_weight="1"
                android:text="@string/permissions_status"
                android:textAppearance="@style/TextAppearance.Body.Bold" />

            <TextView
                android:id="@+id/tvPermissionsSummary"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="@string/permissions_summary_placeholder"
                android:textSize="12sp" />

            <ImageView
                android:id="@+id/ivExpandCollapse"
                android:layout_width="24dp"
                android:layout_height="24dp"
                android:src="@drawable/ic_expand_more"
                android:layout_marginStart="8dp" />
        </LinearLayout>

        <!-- Permissions List Container -->
        <LinearLayout
            android:id="@+id/permissionsContainer"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical"
            android:visibility="gone" />

        <!-- Request Button -->
        <Button
            android:id="@+id/btnRequestPermissions"
            style="@style/ButtonStyle.Primary"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:layout_marginTop="@dimen/spacing_small"
            android:text="@string/request_all_permissions"
            android:visibility="gone" />

    </LinearLayout>
</androidx.cardview.widget.CardView>
```

---

### **5. PERMISSION DIALOGS**

**A. Educational Dialog for Special Permissions:**

**Layout (dialog_permission_overlay.xml):**
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    style="@style/DialogContainer">

    <TextView
        style="@style/DialogTitle"
        android:text="@string/permission_overlay_title_dialog" />

    <TextView
        style="@style/DialogMessage"
        android:text="@string/permission_overlay_message_dialog" />

    <LinearLayout
        style="@style/DialogHighlightBox"
        android:background="@drawable/dialog_highlight_box_bg">

        <TextView
            style="@style/DialogHighlightText"
            android:text="@string/permission_overlay_feature"
            android:textSize="16sp"
            android:gravity="center" />
    </LinearLayout>

    <TextView
        style="@style/DialogWarning"
        android:text="@string/permission_overlay_hint" />

    <LinearLayout
        style="@style/DialogButtonContainer">

        <Button
            android:id="@+id/btnSkipOverlay"
            style="@style/DialogButton.Cancel"
            android:text="@string/skip_caps" />

        <Button
            android:id="@+id/btnGrantOverlay"
            style="@style/DialogButton.Confirm"
            android:text="@string/grant_permission_caps" />
    </LinearLayout>

</LinearLayout>
```

**Implementation:**
```java
private void showOverlayPermissionDialog() {
    View dialogView = getLayoutInflater().inflate(R.layout.dialog_permission_overlay, null);
    Button btnSkipOverlay = dialogView.findViewById(R.id.btnSkipOverlay);
    Button btnGrantOverlay = dialogView.findViewById(R.id.btnGrantOverlay);
    
    AlertDialog dialog = new AlertDialog.Builder(this)
        .setView(dialogView)
        .setCancelable(false)
        .create();
    
    btnSkipOverlay.setOnClickListener(v -> dialog.dismiss());
    
    btnGrantOverlay.setOnClickListener(v -> {
        Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:" + getPackageName()));
        startActivityForResult(intent, OVERLAY_PERMISSION_REQUEST_CODE);
        dialog.dismiss();
    });
    
    dialog.show();
}
```

---

### **6. STRING RESOURCES**

**Pattern for strings_permission.xml:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Section -->
    <string name="permissions_status">Permissions Status</string>
    <string name="request_all_permissions">Request All Permissions</string>
    <string name="permissions_summary">%1$d/%2$d permissions granted</string>
    
    <!-- Core permissions -->
    <string name="perm_phone_state">Phone State</string>
    <string name="perm_phone_state_desc">Required to detect incoming calls and identify caller numbers</string>
    
    <string name="perm_contacts">Contacts</string>
    <string name="perm_contacts_desc">Required to allow calls from your contacts while blocking others</string>
    
    <string name="perm_answer_calls">Answer Phone Calls</string>
    <string name="perm_answer_calls_desc">Required to automatically end blocked calls</string>
    
    <!-- Special permissions -->
    <string name="perm_overlay">Display Over Apps</string>
    <string name="perm_overlay_desc">Required to show block button when receiving spam calls</string>
    
    <string name="perm_call_screening">Call Screening Role</string>
    <string name="perm_call_screening_desc">Required to screen and block incoming calls automatically</string>
    
    <!-- Dialog content -->
    <string name="permission_overlay_title_dialog">Display Over Other Apps</string>
    <string name="permission_overlay_message_dialog">This permission allows the app to show a block button when you receive spam calls.</string>
    <string name="permission_overlay_feature">Show Block Button During Calls</string>
    <string name="permission_overlay_hint">You can skip this permission if you don\'t want the overlay feature.</string>
</resources>
```

---

### **7. REFRESH STRATEGY**

**Auto-refresh on profile resume:**
```java
@Override
public void onResume() {
    super.onResume();
    // Refresh permissions display when user returns from Settings
    updatePermissionsDisplay();
}
```

**Manual refresh from settings:**
```java
private void openPermissionSettings(PermissionInfo permInfo) {
    if (permInfo.isSpecial) {
        if (permInfo.permission.equals("overlay")) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + getContext().getPackageName()));
            startActivity(intent);
        } else if (permInfo.permission.equals("call_screening")) {
            // Show role request dialog
            requestCallScreeningRole();
        }
    } else {
        // Open app settings
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.parse("package:" + getContext().getPackageName()));
        startActivity(intent);
    }
}
```

**📂 Note**: This implementation uses design standards from:
- [Spacing Standards](standards/spacing-padding-standards.md) for dialog and section padding
- [Style Architecture](standards/style-system-architecture.md) for dialog styles, button styles, and text appearance
- [Border Standards](standards/border-shape-standards.md) for permission status indicators

---

## ✅ IMPLEMENTATION CHECKLIST

**Manifest:**
- [ ] Group permissions by type (core/optional/version-specific)
- [ ] Add maxSdkVersion for deprecated permissions
- [ ] Comment each permission clearly

**Request Flow:**
- [ ] Check permissions on app launch
- [ ] Group request regular permissions
- [ ] Handle special permissions with educational dialogs
- [ ] Progressive flow: Regular → Special → Roles

**Profile Display:**
- [ ] Visual status indicators (checkmarks/X)
- [ ] Permission count summary with colors
- [ ] Clickable items to open settings
- [ ] Request button visibility logic
- [ ] Expandable/collapsible section

**User Education:**
- [ ] Clear permission names
- [ ] Feature-focused descriptions (why needed)
- [ ] Educational dialogs for special permissions
- [ ] Skip options for optional permissions

**Code Organization:**
- [ ] PermissionInfo data model
- [ ] Centralized permission checking logic
- [ ] Refresh on onResume()
- [ ] Proper dialog handling

**Resources:**
- [ ] strings_permission.xml with all permission strings
- [ ] Multi-language support (Vietnamese + English)
- [ ] Consistent naming pattern

This standard ensures consistent permission handling across all Android apps while providing excellent user experience and maintainable code structure.