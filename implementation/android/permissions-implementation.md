# 🔐 Permissions Implementation Standards

[← Back to Implementation](../)

---

## ⚙️ JAVA IMPLEMENTATION

### **1. Permission Request Flow in MainActivity**

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    // ... setup code
    checkPermissions();           // Regular permissions first
    checkOverlayPermission();     // Special permissions second
    requestCallScreeningRole();   // Android roles last
}

private void checkPermissions() {
    String[] permissions = {
        Manifest.permission.READ_PHONE_STATE,
        Manifest.permission.READ_CONTACTS,
        Manifest.permission.ANSWER_PHONE_CALLS
    };
    
    boolean allGranted = true;
    for (String permission : permissions) {
        if (ContextCompat.checkSelfPermission(this, permission) 
            != PackageManager.PERMISSION_GRANTED) {
            allGranted = false;
            break;
        }
    }
    
    if (!allGranted) {
        ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE);
    }
}

@Override
public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, 
        @NonNull int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    
    if (requestCode == PERMISSION_REQUEST_CODE) {
        // Handle regular permission results
        // Show educational dialog if denied
    }
}
```

### **2. PermissionInfo Data Model**

```java
public class PermissionInfo {
    private String name;
    private String description;
    private String permission;
    private boolean isGranted;
    
    public PermissionInfo(String name, String description, String permission) {
        this.name = name;
        this.description = description;
        this.permission = permission;
        this.isGranted = false;
    }
    
    // Getters and setters
    public String getName() { return name; }
    public String getDescription() { return description; }
    public String getPermission() { return permission; }
    public boolean isGranted() { return isGranted; }
    public void setGranted(boolean granted) { isGranted = granted; }
}
```

### **3. MainProfile Permissions Section**

```java
private List<PermissionInfo> getAppPermissions() {
    List<PermissionInfo> permissions = new ArrayList<>();
    
    // Phone permission (if used)
    permissions.add(new PermissionInfo(
        getString(R.string.permission_phone_name),
        getString(R.string.permission_phone_desc),
        Manifest.permission.READ_PHONE_STATE
    ));
    
    // Contacts permission (if used)
    permissions.add(new PermissionInfo(
        getString(R.string.permission_contacts_name),
        getString(R.string.permission_contacts_desc),
        Manifest.permission.READ_CONTACTS
    ));
    
    // Call logs permission (if used)
    permissions.add(new PermissionInfo(
        getString(R.string.permission_call_log_name),
        getString(R.string.permission_call_log_desc),
        Manifest.permission.READ_CALL_LOG
    ));
    
    // Special permissions (if used)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        permissions.add(new PermissionInfo(
            getString(R.string.permission_overlay_name),
            getString(R.string.permission_overlay_desc),
            "SYSTEM_ALERT_WINDOW"
        ));
    }
    
    return permissions;
}

private void checkPermissionStatus() {
    List<PermissionInfo> permissions = getAppPermissions();
    int grantedCount = 0;
    
    for (PermissionInfo permInfo : permissions) {
        boolean granted = false;
        
        if ("SYSTEM_ALERT_WINDOW".equals(permInfo.getPermission())) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                granted = Settings.canDrawOverlays(getContext());
            }
        } else {
            granted = ContextCompat.checkSelfPermission(getContext(), 
                permInfo.getPermission()) == PackageManager.PERMISSION_GRANTED;
        }
        
        permInfo.setGranted(granted);
        if (granted) grantedCount++;
    }
    
    // Update UI based on permission status
    updatePermissionDisplay(permissions, grantedCount);
}

private void onPermissionItemClick(PermissionInfo permInfo) {
    if (permInfo.isGranted()) {
        // Already granted - show info or go to settings
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.parse("package:" + getContext().getPackageName()));
        startActivity(intent);
    } else {
        // Not granted - show explanation and request
        if ("SYSTEM_ALERT_WINDOW".equals(permInfo.getPermission())) {
            // Handle overlay permission
            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + getContext().getPackageName()));
            startActivity(intent);
        } else if ("call_screening".equals(permInfo.getPermission())) {
            // Show role request dialog
            requestCallScreeningRole();
        } else {
            // Open app settings
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.setData(Uri.parse("package:" + getContext().getPackageName()));
            startActivity(intent);
        }
    }
}
```

---

## 🎨 UI IMPLEMENTATION

### **Permission Status Layout**

```xml
<!-- Permission Item Layout -->
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal"
    android:padding="@dimen/spacing_normal">

    <!-- Status Icon -->
    <ImageView
        android:id="@+id/ivPermissionStatus"
        android:layout_width="24dp"
        android:layout_height="24dp"
        android:src="@drawable/ic_check_circle"
        android:tint="@color/success"
        android:layout_gravity="center_vertical" />

    <!-- Permission Info -->
    <LinearLayout
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:orientation="vertical"
        android:layout_marginStart="@dimen/spacing_medium">

        <TextView
            android:id="@+id/tvPermissionName"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            style="@style/TextAppearance.Body.Bold" />

        <TextView
            android:id="@+id/tvPermissionDescription"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            style="@style/TextAppearance.Caption"
            android:textColor="@color/text_hint"
            android:layout_marginTop="@dimen/spacing_tiny" />
    </LinearLayout>

    <!-- Action Button -->
    <Button
        android:id="@+id/btnPermissionAction"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/grant"
        style="@style/Widget.Button.Small" />

</LinearLayout>
```

### **Permission Summary Section**

```xml
<!-- Permission Summary -->
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal"
    android:padding="@dimen/spacing_normal">

    <TextView
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1"
        android:text="@string/permissions"
        style="@style/TextAppearance.Heading" />

    <TextView
        android:id="@+id/tvPermissionCount"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="3/4"
        style="@style/TextAppearance.Body"
        android:textColor="@color/success"
        android:layout_marginStart="@dimen/spacing_small" />

</LinearLayout>
```

### **Educational Dialog Layout**

```xml
<!-- dialog_permission_explanation.xml -->
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="vertical"
    style="@style/DialogContainer">

    <TextView
        android:id="@+id/tvDialogTitle"
        style="@style/DialogTitle"
        android:text="@string/permission_required" />

    <TextView
        android:id="@+id/tvDialogMessage"
        style="@style/DialogMessage"
        android:text="@string/permission_explanation" />

    <LinearLayout
        android:id="@+id/layoutHighlight"
        style="@style/DialogHighlightBox"
        android:layout_marginVertical="@dimen/spacing_medium">

        <TextView
            android:id="@+id/tvHighlightText"
            style="@style/DialogHighlightText"
            android:text="@string/permission_feature_benefit" />
    </LinearLayout>

    <TextView
        android:id="@+id/tvWarning"
        style="@style/DialogWarning"
        android:text="@string/permission_denial_consequence" />

    <LinearLayout
        style="@style/DialogButtonContainer">

        <Button
            android:id="@+id/btnCancel"
            style="@style/DialogButton.Neutral"
            android:text="@string/cancel" />

        <Button
            android:id="@+id/btnGrant"
            style="@style/DialogButton.Positive"
            android:text="@string/grant_permission" />
    </LinearLayout>

</LinearLayout>
```

**📂 Note**: This implementation uses design standards from:
- [Spacing Standards](spacing-padding-standards.md) for dialog and section padding
- [Style Architecture](style-system-architecture.md) for dialog styles, button styles, and text appearance
- [Border Standards](border-shape-standards.md) for permission status indicators