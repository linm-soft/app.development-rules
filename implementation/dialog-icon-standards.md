# Common Dialog Framework - Icon Standards

> Chuẩn hóa icons cho Common Dialog Framework (Rule 2.16)

## 🎯 ICON STANDARDIZATION

### Standard Dialog Icons

| Dialog Type | Icon File | Description | Color Theme |
|-------------|-----------|-------------|-------------|
| **SUCCESS** | `ic_dialog_success.xml` | ✓ Check circle | Green (`@color/colorSuccess`) |
| **ERROR** | `ic_dialog_error.xml` | ✗ X circle | Red (`@color/colorError`) |
| **WARNING** | `ic_dialog_warning.xml` | ⚠ Triangle | Orange (`@color/colorWarning`) |
| **INFO** | `ic_dialog_info.xml` | ℹ Info circle | Blue (`@color/colorInfo`) |
| **CONFIRM** | `ic_dialog_confirm.xml` | ❓ Question circle | Blue (`@color/colorConfirm`) |
| **LOADING** | `ic_dialog_loading_animated.xml` | ↻ Animated refresh | Blue (animated) |
| **CUSTOM** | User-defined | Any custom icon | User-defined |

### Auto Icon Behavior

**✅ Automatic Icon Assignment:**
```java
// Icon tự động theo DialogType
new CommonDialog.Builder(context)
    .setType(DialogType.SUCCESS)  // ← Auto sử dụng ic_dialog_success.xml
    .show();
```

**🔧 Custom Icon Override:**
```java
// Override icon mặc định
new CommonDialog.Builder(context)
    .setType(DialogType.SUCCESS)
    .setIcon(R.drawable.my_custom_icon)  // ← Override auto icon
    .show();
```

## 🎨 ICON SPECIFICATIONS

### Design Standards
- **Size**: 24dp x 24dp vector drawables
- **Style**: Material Design 3 icons
- **Tint**: Dynamic color based on theme (`?android:attr/colorPrimary` or specific color)
- **Format**: Vector XML (scalable, theme-aware)

### Color Theming
```xml
<!-- Auto color theming -->
android:tint="@color/colorSuccess"    <!-- SUCCESS dialogs -->
android:tint="@color/colorError"      <!-- ERROR dialogs -->
android:tint="@color/colorWarning"    <!-- WARNING dialogs -->
android:tint="@color/colorInfo"       <!-- INFO/CONFIRM dialogs -->
```

### Animation Support
- **LOADING type**: Uses animated vector drawable
- **Other types**: Static icons
- **Smooth transitions**: Icons fade in with dialog appearance

## 📁 FILE STRUCTURE

```
app/src/main/res/
├── drawable/
│   ├── ic_dialog_success.xml          ← SUCCESS icon (check)
│   ├── ic_dialog_error.xml            ← ERROR icon (X)
│   ├── ic_dialog_warning.xml          ← WARNING icon (triangle)
│   ├── ic_dialog_info.xml             ← INFO icon (circle)
│   ├── ic_dialog_confirm.xml          ← CONFIRM icon (question)
│   ├── ic_dialog_loading.xml          ← LOADING static icon
│   └── ic_dialog_loading_animated.xml ← LOADING animated icon
├── values/
│   └── colors_ui.xml                  ← Dialog colors
└── values-night/
    └── colors_ui.xml                  ← Dark mode colors
```

## ⚙️ IMPLEMENTATION DETAILS

### DialogType Enhancement
```java
public enum DialogType {
    SUCCESS(R.drawable.ic_dialog_success),
    ERROR(R.drawable.ic_dialog_error),
    WARNING(R.drawable.ic_dialog_warning),
    INFO(R.drawable.ic_dialog_info),
    CONFIRM(R.drawable.ic_dialog_confirm),
    LOADING(R.drawable.ic_dialog_loading_animated),
    CUSTOM(0); // No default icon
    
    public int getIconResId() { return iconResId; }
    public boolean hasDefaultIcon() { return iconResId != 0; }
}
```

### Automatic Icon Setup
```java
private void setupIcon() {
    int iconRes = config.getIconResId();
    
    // Auto-set icon based on dialog type if not explicitly set
    if (iconRes == -1 && config.getType().hasDefaultIcon()) {
        iconRes = config.getType().getIconResId();
    }
    
    if (iconRes != -1) {
        ivMainIcon.setImageResource(iconRes);
        ivMainIcon.setVisibility(View.VISIBLE);
    } else {
        ivMainIcon.setVisibility(View.GONE);
    }
}
```

## 🔧 USAGE EXAMPLES

### Standard Usage (Auto Icons)
```java
// SUCCESS dialog - Auto green check icon
DialogExamples.showSuccessDialog(context);

// ERROR dialog - Auto red X icon  
DialogExamples.showErrorDialog(context);

// WARNING dialog - Auto orange triangle icon
DialogExamples.showWarningDialog(context);
```

### Custom Icon Override
```java
// Use custom icon instead of auto icon
new CommonDialog.Builder(context)
    .setType(DialogType.SUCCESS)
    .setIcon(R.drawable.my_custom_success_icon)
    .show();
```

### No Icon (Hide Icon)
```java
// CUSTOM type with no icon
new CommonDialog.Builder(context)
    .setType(DialogType.CUSTOM)
    // Don't set icon - icon will be hidden
    .show();
```

## ✅ BENEFITS

### For Developers
- **Zero setup**: Icons automatically assigned based on dialog type
- **Consistent UX**: Same icon for same purpose across all apps
- **Easy customization**: Simple override when needed
- **Theme aware**: Icons follow light/dark theme automatically

### For Users  
- **Visual consistency**: Same icons mean same things across apps
- **Instant recognition**: Familiar Material Design icons
- **Accessibility**: High contrast, clear visual indicators
- **Professional look**: Standardized, polished appearance

### For Cross-App Usage
- **Copy & paste**: Same icon files work in any Android project
- **No dependencies**: Self-contained icon resources
- **Scalable**: Vector drawables work on all screen densities
- **Future-proof**: Easy to update all apps by updating icon standards

## 🔍 MIGRATION FROM OLD DIALOGS

### Replace Old AlertDialog
```java
// OLD: Manual AlertDialog with inconsistent icons
AlertDialog.Builder builder = new AlertDialog.Builder(context);
builder.setIcon(R.drawable.some_random_icon);
builder.setMessage("Success!");
builder.show();

// NEW: CommonDialog with auto icon
new CommonDialog.Builder(context)
    .setType(DialogType.SUCCESS)  // Auto icon + color
    .setMessage("Success!")
    .show();
```

### Benefits of Migration
- **Reduced code**: No manual icon management
- **Consistency**: Same success = same green check icon
- **Theme support**: Icons automatically follow dark mode
- **Maintenance**: Update one place, affects all dialogs

---

*This icon standardization is part of Rule 2.16 - Common Dialog Framework. For full implementation details, see [`common-dialog-framework.md`](common-dialog-framework.md).*