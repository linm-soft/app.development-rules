# 💬 Dialog Implementation Rules

> **Based on smart-call-block app analysis**

## 🔍 Essential Dialog Components

**Required Files Pattern:**
```
res/
├── layout/
│   ├── dialog_confirm_block.xml       # Main confirmation dialog
│   ├── dialog_confirm_simple.xml      # Simple yes/no dialog
│   ├── dialog_info.xml               # Information display
│   └── dialog_permission_settings.xml # Settings redirect
├── drawable/
│   ├── dialog_background.xml         # Corner radius background
│   ├── dialog_container_bg.xml       # Container styling
│   └── dialog_warning_bg.xml         # Warning state background
└── drawable-night/
    ├── dialog_container_bg.xml       # Dark mode container
    └── dialog_warning_bg.xml         # Dark mode warning
```

## ❌ NEVER Use AlertDialog.Builder with setTitle/setMessage

**❌ WRONG Pattern:**
```java
// DO NOT USE THIS APPROACH
AlertDialog.Builder builder = new AlertDialog.Builder(context);
builder.setTitle("Confirm Action");
builder.setMessage("Are you sure?");
builder.setPositiveButton("Yes", null);
builder.setNegativeButton("No", null);
builder.show();
```

**Why this is wrong:**
- Cannot control styling consistently
- No support for custom backgrounds/corners
- Limited layout customization
- Breaks dark mode theming
- Inconsistent with Material Design 3

## ✅ ALWAYS Use Custom Layout Pattern

**✅ CORRECT Implementation from smart-call-block:**

### 1. Create Custom Dialog Layout

```xml
<!-- dialog_confirm_block.xml -->
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="vertical"
    android:padding="@dimen/spacing_large"
    android:background="@color/primary_light">

    <!-- Title -->
    <TextView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="@string/quick_block_title"
        android:textColor="@color/text_primary"
        android:textSize="@dimen/text_size_heading"
        android:textStyle="bold"
        android:layout_marginBottom="@dimen/spacing_small" />

    <!-- Content Display -->
    <TextView
        android:id="@+id/tvKey"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textColor="@color/primary"
        android:textSize="@dimen/text_size_large"
        android:textStyle="bold"
        android:background="@color/background_white"
        android:padding="@dimen/spacing_small"
        android:layout_marginBottom="@dimen/spacing_normal" />

    <!-- Input Section (if needed) -->
    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/block_title_label"
        android:textColor="@color/text_primary"
        android:textSize="@dimen/text_size_normal"
        android:textStyle="bold"
        android:layout_marginBottom="@dimen/spacing_tiny" />

    <EditText
        android:id="@+id/editBlockTitle"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="@string/block_title_hint"
        android:inputType="textPersonName"
        android:padding="@dimen/spacing_medium"
        android:background="@drawable/input_background"
        android:textColor="@color/input_text"
        android:textSize="@dimen/text_size_medium"
        android:layout_marginBottom="@dimen/spacing_normal" />

    <!-- Buttons Container -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:gravity="end">

        <Button
            android:id="@+id/btnCancel"
            android:layout_width="wrap_content"
            android:layout_height="@dimen/button_height"
            android:text="@string/btn_cancel"
            android:paddingStart="@dimen/spacing_normal"
            android:paddingEnd="@dimen/spacing_normal" />

        <Button
            android:id="@+id/btnConfirm"
            android:layout_width="wrap_content"
            android:layout_height="@dimen/button_height"
            android:text="@string/btn_confirm"
            android:paddingStart="@dimen/spacing_large"
            android:paddingEnd="@dimen/spacing_large" />

    </LinearLayout>

</LinearLayout>
```

### 2. Dialog Background Styling

```xml
<!-- dialog_background.xml -->
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="@color/card_background" />
    <corners android:radius="@dimen/card_corner_radius" />
</shape>
```

### 3. Java Implementation Pattern

**Standard dialog creation from smart-call-block:**
```java
private void showConfirmDialog(String blockKey, String blockTitle, String blockType, String labels, String note) {
    if (getActivity() == null) return;
    
    // Inflate custom layout
    View dialogView = getLayoutInflater().inflate(R.layout.dialog_confirm_prefix, null);
    
    // Find views
    TextView tvConfirmPrefixNumber = dialogView.findViewById(R.id.tvConfirmPrefixNumber);
    Button btnCancelPrefix = dialogView.findViewById(R.id.btnCancelPrefix);
    Button btnConfirmPrefix = dialogView.findViewById(R.id.btnConfirmPrefix);
    
    // Set data
    tvConfirmPrefixNumber.setText(blockKey);
    
    // Create dialog with custom layout
    AlertDialog dialog = new AlertDialog.Builder(requireActivity())
        .setView(dialogView)
        .setCancelable(false)  // Prevent outside touch dismiss
        .create();
    
    // Handle events
    btnCancelPrefix.setOnClickListener(v -> dialog.dismiss());
    
    btnConfirmPrefix.setOnClickListener(v -> {
        dialog.dismiss();
        // Execute action
        addNumber(blockKey, blockTitle, blockType, labels, note);
    });
    
    // Show dialog
    dialog.show();
    
    // CRITICAL: Set dialog width after show
    DialogUtils.setDialogWidth(dialog, this);
}
```

## 🚨 MANDATORY Dialog Rules from smart-call-block

### 1. DialogUtils.setDialogWidth() - REQUIRED

**ALWAYS call after dialog.show():**
```java
dialog.show();
DialogUtils.setDialogWidth(dialog, this);  // Fragment context
// or
DialogUtils.setDialogWidth(dialog, activity);  // Activity context
```

### 2. Consistent Padding Pattern

**From smart-call-block analysis:**
```xml
<!-- Root Dialog Container -->
<LinearLayout
    android:padding="@dimen/spacing_large">     <!-- 20dp -->

<!-- Standard Button Padding -->
<Button
    android:paddingStart="@dimen/spacing_normal"  <!-- 16dp -->
    android:paddingEnd="@dimen/spacing_normal" />

<!-- Action Button Padding -->
<Button
    android:paddingStart="@dimen/spacing_large"   <!-- 20dp -->
    android:paddingEnd="@dimen/spacing_large" />

<!-- Input Field Padding -->
<EditText
    android:padding="@dimen/spacing_medium" />    <!-- 12dp -->
```

### 3. Proper Event Handling

**Always prevent memory leaks and handle null contexts:**
```java
private void showDialog() {
    // Check context availability
    if (getActivity() == null) return;
    
    // ... create dialog ...
    
    // Handle cancel properly
    btnCancel.setOnClickListener(v -> {
        if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
        }
    });
    
    // Handle confirm with action
    btnConfirm.setOnClickListener(v -> {
        if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
        }
        // Execute business logic
        performAction();
    });
}
```

## 🎨 Dialog Design Standards from smart-call-block

### Colors and Themes
- **Root background:** `@color/primary_light` or `@color/card_background`
- **Title text:** `@color/text_primary` with bold style
- **Content text:** `@color/primary` for emphasis, `@color/text_primary` for normal
- **Input backgrounds:** `@drawable/input_background` with theme support
- **Buttons:** Follow app theme colors with proper contrast

### Typography
- **Title:** `@dimen/text_size_heading` with bold weight
- **Content:** `@dimen/text_size_large` or `@dimen/text_size_medium`
- **Input text:** `@dimen/text_size_medium`
- **All text must use string resources** (multi-language support)

### Layout Structure
- **Root:** LinearLayout with vertical orientation
- **Buttons:** Horizontal LinearLayout at bottom, right-aligned (`android:gravity="end"`)
- **Spacing:** Consistent use of dimens resources
- **Background:** Corner radius from `@dimen/card_corner_radius`

## 📋 Dialog Types from smart-call-block Analysis

### 1. Confirmation Dialogs
**File pattern:** `dialog_confirm_*.xml`
**Purpose:** User action confirmation
**Components:** Title, content display, Cancel + Confirm buttons
**Example:** Confirm phone number blocking

### 2. Info Dialogs
**File pattern:** `dialog_info.xml`
**Purpose:** Information display
**Components:** Title, message, OK button only
**Example:** Feature explanations, status updates

### 3. Permission Dialogs
**File pattern:** `dialog_permission_settings.xml`
**Purpose:** Redirect to Android settings
**Components:** Explanation, Cancel + Settings buttons
**Example:** Request overlay permissions

### 4. Simple Dialogs
**File pattern:** `dialog_confirm_simple.xml`
**Purpose:** Yes/No questions
**Components:** Question, No + Yes buttons
**Example:** Delete confirmations

## 🔍 Validation Checklist

Before implementing dialog:
- ✅ Custom layout created (no AlertDialog setTitle/setMessage)
- ✅ `DialogUtils.setDialogWidth()` called after `show()`
- ✅ Dialog background has corner radius styling
- ✅ All text uses string resources (multi-language)
- ✅ Proper padding with dimens resources
- ✅ Event handlers check for null context
- ✅ Buttons properly aligned (end gravity)
- ✅ Input fields use proper input types
- ✅ Dark mode backgrounds exist (drawable-night/)

## 🔍 Common Issues and Solutions

**Problem:** Dialog looks different in dark mode
**Solution:** Create matching drawables in `drawable-night/` folder

**Problem:** Dialog too narrow on tablets
**Solution:** Ensure `DialogUtils.setDialogWidth()` is called

**Problem:** Memory leak warnings
**Solution:** Check `getActivity() == null` before creating dialogs in fragments

**Problem:** Text cut off or overlapping
**Solution:** Use proper spacing with `@dimen/spacing_*` resources

**Problem:** Buttons not responding
**Solution:** Verify button IDs match between layout and Java code

**Problem:** Dialog shows title bar
**Solution:** Use custom layout only, never mix with `setTitle()`
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="@string/dialog_confirm_delete_message"
        android:textSize="@dimen/text_size_normal"
        android:textColor="@color/text_secondary"
        android:layout_marginBottom="@dimen/spacing_large" />

    <!-- Buttons -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:gravity="end">

        <Button
            android:id="@+id/btnCancel"
            style="@style/Widget.Button.Secondary"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="@string/cancel"
            android:layout_marginEnd="@dimen/spacing_small" />

        <Button
            android:id="@+id/btnDelete"
            style="@style/Widget.Button.Danger"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="@string/delete" />
    </LinearLayout>
</LinearLayout>
```

### 2. Create Dialog in Java

```java
public class ConfirmDeleteDialog {
    
    public static void show(Context context, String itemName, 
                          OnConfirmListener listener) {
        
        Dialog dialog = new Dialog(context);
        dialog.setContentView(R.layout.dialog_confirm_delete);
        
        // Set width
        dialog.show();
        DialogUtils.setDialogWidth(dialog);
        
        // Setup views
        TextView tvMessage = dialog.findViewById(R.id.tvMessage);
        tvMessage.setText(context.getString(
            R.string.dialog_confirm_delete_message, itemName));
        
        // Cancel button
        dialog.findViewById(R.id.btnCancel)
            .setOnClickListener(v -> dialog.dismiss());
        
        // Delete button
        dialog.findViewById(R.id.btnDelete)
            .setOnClickListener(v -> {
                listener.onConfirm();
                dialog.dismiss();
            });
    }
    
    public interface OnConfirmListener {
        void onConfirm();
    }
}
```

### 3. DialogUtils Helper

```java
public class DialogUtils {
    
    public static void setDialogWidth(Dialog dialog) {
        Window window = dialog.getWindow();
        if (window != null) {
            WindowManager.LayoutParams params = window.getAttributes();
            DisplayMetrics metrics = 
                dialog.getContext().getResources().getDisplayMetrics();
            
            // Set to 85% of screen width
            params.width = (int) (metrics.widthPixels * 0.85);
            window.setAttributes(params);
        }
    }
}
```

### 4. Dialog Background Drawable

```xml
<!-- drawable/dialog_background.xml -->
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="@color/card_background" />
    <corners android:radius="12dp" />
</shape>
```

## Dialog Pattern Checklist

When creating a dialog:

- [ ] Create custom layout file: `dialog_[action].xml`
- [ ] Use `Dialog dialog = new Dialog(context)`
- [ ] Set content: `dialog.setContentView(R.layout.dialog_xxx)`
- [ ] Call `dialog.show()` FIRST
- [ ] Then call `DialogUtils.setDialogWidth(dialog)`
- [ ] Setup button click listeners
- [ ] Add strings to both `values/` and `values-vi/`
- [ ] Use `@drawable/dialog_background` for consistent styling
- [ ] Test in both Light and Dark mode

## Common Dialog Types

| Dialog Purpose | Layout Name | Buttons |
|---------------|-------------|---------|
| Confirm delete | `dialog_confirm_delete.xml` | Cancel, Delete |
| Info/Notice | `dialog_info.xml` | OK |
| Input | `dialog_input.xml` | Cancel, Save |
| Selection | `dialog_select.xml` | Cancel, items list |
| Terms/Privacy | `dialog_terms.xml` | Decline, Accept |

## Why DialogUtils.setDialogWidth()?

**Default dialog behavior:**
- Too narrow on tablets
- Too wide on small phones
- Not responsive

**With DialogUtils:**
- Consistent 85% screen width
- Responsive across devices
- Professional appearance
- Easy to adjust globally
