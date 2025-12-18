# Common Dialog Implementation Standards

[← Back to Implementation](../)

## 🚀 RECENT UPDATES (December 15, 2025)

### ✅ Fixed NullPointerException Issues
- **Issue**: `alertDialog.getContext()` called before `alertDialog` initialization
- **Solution**: Pass `Context` parameter to `setupContent()` and `setupButtons()` methods
- **Status**: RESOLVED ✅

### 🎯 Custom Layout Optimization
- **Issue**: Custom layouts had duplicate base container styling and buttons
- **Solution**: Direct custom layout usage as dialog view, skip base container completely
- **Benefits**: Cleaner UI, no duplicate styling, better performance
- **Status**: IMPLEMENTED ✅

### 🧹 Removed Duplicate Button Handling
- **Issue**: Custom layouts with own buttons + framework buttons = 2 sets of buttons
- **Solution**: Skip framework button setup when custom layout detected
- **Result**: Single button set, cleaner interface
- **Status**: FIXED ✅

### 🎨 Simplified Background System
- **Removed**: `dialog_container_bg.xml` drawable
- **Change**: Use system default background instead of custom styling
- **Result**: Cleaner, more native look
- **Status**: CLEANED UP ✅

## ⚙️ JAVA IMPLEMENTATION

### DialogType.java
```java
package com.callblocker.common.dialog;

/**
 * Enum định nghĩa các loại dialog trong app
 */
public enum DialogType {
    /**
     * Dialog xác nhận hành động (có 2 button: Yes/No hoặc Confirm/Cancel)
     */
    CONFIRM,
    
    /**
     * Dialog cảnh báo (thường có 1 button OK, màu vàng/cam)
     */
    WARNING,
    
    /**
     * Dialog báo lỗi (màu đỏ, có 1 button OK)
     */
    ERROR,
    
    /**
     * Dialog thông báo thành công (màu xanh lá, có 1 button OK)
     */
    SUCCESS,
    
    /**
     * Dialog hiển thị thông tin (màu xanh dương, có 1 button OK)
     */
    INFO,
    
    /**
     * Dialog loading/progress (không có button, tự đóng)
     */
    LOADING,
    
    /**
     * Dialog với layout tùy chỉnh hoàn toàn
     */
    CUSTOM
}
```

### DialogConfig.java
```java
package com.callblocker.common.dialog;

import androidx.annotation.LayoutRes;

/**
 * Configuration class cho CommonDialog
 * Chứa tất cả thông tin cần thiết để tạo một dialog
 */
public class DialogConfig {
    private String title;
    private String message;
    private DialogType type = DialogType.INFO;
    private ButtonConfig positiveButton;
    private ButtonConfig negativeButton;
    private @LayoutRes int customLayout = -1;
    private boolean cancelable = true;
    private boolean cancelOnTouchOutside = true;
    private int iconResId = -1;
    
    // Constructor
    public DialogConfig() {}
    
    // Getters
    public String getTitle() { return title; }
    public String getMessage() { return message; }
    public DialogType getType() { return type; }
    public ButtonConfig getPositiveButton() { return positiveButton; }
    public ButtonConfig getNegativeButton() { return negativeButton; }
    public int getCustomLayout() { return customLayout; }
    public boolean isCancelable() { return cancelable; }
    public boolean isCancelOnTouchOutside() { return cancelOnTouchOutside; }
    public int getIconResId() { return iconResId; }
    
    // Setters
    public void setTitle(String title) { this.title = title; }
    public void setMessage(String message) { this.message = message; }
    public void setType(DialogType type) { this.type = type; }
    public void setPositiveButton(ButtonConfig positiveButton) { this.positiveButton = positiveButton; }
    public void setNegativeButton(ButtonConfig negativeButton) { this.negativeButton = negativeButton; }
    public void setCustomLayout(@LayoutRes int customLayout) { this.customLayout = customLayout; }
    public void setCancelable(boolean cancelable) { this.cancelable = cancelable; }
    public void setCancelOnTouchOutside(boolean cancelOnTouchOutside) { this.cancelOnTouchOutside = cancelOnTouchOutside; }
    public void setIconResId(int iconResId) { this.iconResId = iconResId; }
    
    /**
     * Inner class để config button
     */
    public static class ButtonConfig {
        private String text;
        private OnClickListener listener;
        private int textColor = -1;
        private int backgroundColor = -1;
        
        public ButtonConfig(String text, OnClickListener listener) {
            this.text = text;
            this.listener = listener;
        }
        
        // Getters
        public String getText() { return text; }
        public OnClickListener getListener() { return listener; }
        public int getTextColor() { return textColor; }
        public int getBackgroundColor() { return backgroundColor; }
        
        // Setters
        public ButtonConfig setTextColor(int textColor) { 
            this.textColor = textColor; 
            return this;
        }
        public ButtonConfig setBackgroundColor(int backgroundColor) { 
            this.backgroundColor = backgroundColor; 
            return this;
        }
    }
    
    /**
     * Interface cho button click listener
     */
    public interface OnClickListener {
        void onClick(CommonDialog dialog, int which);
    }
}
```

### CommonDialog.java
```java
package com.callblocker.common.dialog;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.core.content.ContextCompat;

import com.callblocker.R;
import com.callblocker.utils.DialogUtils;

/**
 * Common Dialog Framework
 * Cung cấp interface thống nhất cho tất cả dialog trong app
 * Sử dụng Builder pattern để tạo dialog dễ dàng và type-safe
 */
public class CommonDialog {
    private AlertDialog alertDialog;
    private DialogConfig config;
    private View dialogView;
    
    // Views
    private TextView tvTitle;
    private TextView tvMessage;
    private ImageView ivIcon;
    private FrameLayout flCustomContent;
    private LinearLayout llButtonContainer;
    private Button btnPositive;
    private Button btnNegative;
    
    private CommonDialog(DialogConfig config) {
        this.config = config;
    }
    
    /**
     * Hiển thị dialog với dynamic content resizing
     */
    public void show() {
        if (alertDialog != null && !alertDialog.isShowing()) {
            alertDialog.show();
            
            // Setup dynamic resizing instead of just width
            if (alertDialog.getContext() instanceof Activity) {
                DialogUtils.setupDynamicResizing(alertDialog, (Activity) alertDialog.getContext());
            }
        }
    }
    
    /**
     * Update dialog content và trigger automatic resize
     * Sử dụng khi thay đổi content programmatically
     */
    public void updateContent() {
        if (alertDialog != null && alertDialog.isShowing()) {
            Context context = alertDialog.getContext();
            DialogUtils.updateContentAndResize(alertDialog, context);
        }
    }
    
    /**
     * Set new message and auto-resize dialog
     */
    public void setMessage(String message) {
        if (tvMessage != null) {
            tvMessage.setText(message);
            tvMessage.setVisibility(message != null && !message.isEmpty() ? View.VISIBLE : View.GONE);
            updateContent();
        }
    }
    
    /**
     * Set new title and auto-resize dialog
     */
    public void setTitle(String title) {
        if (tvTitle != null) {
            tvTitle.setText(title);
            tvTitle.setVisibility(title != null && !title.isEmpty() ? View.VISIBLE : View.GONE);
            updateContent();
        }
    }
    
    /**
     * Đóng dialog
     */
    public void dismiss() {
        if (alertDialog != null && alertDialog.isShowing()) {
            alertDialog.dismiss();
        }
    }
    
    /**
     * Kiểm tra dialog có đang hiển thị không
     */
    public boolean isShowing() {
        return alertDialog != null && alertDialog.isShowing();
    }
    
    /**
     * Lấy root view của dialog (để access custom views)
     */
    public View getDialogView() {
        return dialogView;
    }
    
    /**
     * Tìm view trong dialog
     */
    public <T extends View> T findViewById(int id) {
        return dialogView != null ? dialogView.findViewById(id) : null;
    }
    
    /**
     * Builder class để tạo CommonDialog
     */
    public static class Builder {
        private DialogConfig config = new DialogConfig();
        private Context context;
        
        public Builder(@NonNull Context context) {
            this.context = context;
        }
        
        /**
         * Set title cho dialog
         */
        public Builder setTitle(@NonNull String title) {
            config.setTitle(title);
            return this;
        }
        
        /**
         * Set message cho dialog
         */
        public Builder setMessage(@NonNull String message) {
            config.setMessage(message);
            return this;
        }
        
        /**
         * Set loại dialog (ảnh hưởng đến màu sắc và icon)
         */
        public Builder setType(@NonNull DialogType type) {
            config.setType(type);
            return this;
        }
        
        /**
         * Set positive button (OK, Confirm, Yes, etc.)
         */
        public Builder setPositiveButton(@NonNull String text, @Nullable DialogConfig.OnClickListener listener) {
            config.setPositiveButton(new DialogConfig.ButtonConfig(text, listener));
            return this;
        }
        
        /**
         * Set negative button (Cancel, No, etc.)
         */
        public Builder setNegativeButton(@NonNull String text, @Nullable DialogConfig.OnClickListener listener) {
            config.setNegativeButton(new DialogConfig.ButtonConfig(text, listener));
            return this;
        }
        
        /**
         * Set custom layout cho dialog content
         */
        public Builder setCustomView(@LayoutRes int layoutRes) {
            config.setCustomLayout(layoutRes);
            config.setType(DialogType.CUSTOM);
            return this;
        }
        
        /**
         * Set có thể cancel bằng back button không
         */
        public Builder setCancelable(boolean cancelable) {
            config.setCancelable(cancelable);
            return this;
        }
        
        /**
         * Set có thể cancel bằng touch outside không
         */
        public Builder setCancelOnTouchOutside(boolean cancel) {
            config.setCancelOnTouchOutside(cancel);
            return this;
        }
        
        /**
         * Set icon cho dialog
         */
        public Builder setIcon(int iconResId) {
            config.setIconResId(iconResId);
            return this;
        }
        
        /**
         * Build dialog từ config
         */
        public CommonDialog build() {
            CommonDialog dialog = new CommonDialog(config);
            dialog.createDialog(context);
            return dialog;
        }
    }
    
    /**
     * Tạo AlertDialog từ config
     * 
     * UPDATE 2025-12-15: Optimized for custom layouts
     * - Custom layouts use direct view inflation (no base container)
     * - Standard dialogs use base container with full framework
     * - Fixed NullPointerException issues with context handling
     */
    private void createDialog(Context context) {
        LayoutInflater inflater = LayoutInflater.from(context);
        
        // If using custom layout, use it directly as dialog view
        if (config.getCustomLayout() != -1) {
            dialogView = inflater.inflate(config.getCustomLayout(), null);
        } else {
            // Use base container for standard dialogs
            dialogView = inflater.inflate(R.layout.dialog_base_container, null);
            
            // Find views
            findViews();
            
            // Setup content
            setupContent(context);
            
            // Setup buttons  
            setupButtons(context);
        }
        
        // Create AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setView(dialogView);
        builder.setCancelable(config.isCancelable());
        
        alertDialog = builder.create();
        alertDialog.setCanceledOnTouchOutside(config.isCancelOnTouchOutside());
        
        // Handle cancel
        alertDialog.setOnCancelListener(dialogInterface -> {
            // Call negative button listener if exists
            if (config.getNegativeButton() != null && config.getNegativeButton().getListener() != null) {
                config.getNegativeButton().getListener().onClick(this, DialogInterface.BUTTON_NEGATIVE);
            }
        });
    }
    
    private void findViews() {
        tvMainTitle = dialogView.findViewById(R.id.tvDialogMainTitle);
        tvMainMessage = dialogView.findViewById(R.id.tvDialogMainMessage);
        ivMainIcon = dialogView.findViewById(R.id.ivDialogMainIcon);
        flCustomContainer = dialogView.findViewById(R.id.flDialogCustomContainer);
        llButtonContainer = dialogView.findViewById(R.id.llDialogButtonContainer);
    }
    
    private void setupContent() {
        // Title
        if (config.getTitle() != null && !config.getTitle().isEmpty()) {
            tvTitle.setText(config.getTitle());
            tvTitle.setVisibility(View.VISIBLE);
        } else {
            tvTitle.setVisibility(View.GONE);
        }
        
        // Message
        if (config.getMessage() != null && !config.getMessage().isEmpty()) {
            tvMessage.setText(config.getMessage());
            tvMessage.setVisibility(View.VISIBLE);
        } else {
            tvMessage.setVisibility(View.GONE);
        }
        
        // Icon
        setupIcon();
        
        // Custom content
        setupCustomContent();
    }
    
    private void setupIcon() {
        int iconRes = config.getIconResId();
        
        // Auto-set icon based on dialog type
        if (iconRes == -1) {
            switch (config.getType()) {
                case SUCCESS:
                    iconRes = R.drawable.ic_check_circle;
                    break;
                case WARNING:
                    iconRes = R.drawable.ic_warning;
                    break;
                case ERROR:
                    iconRes = R.drawable.ic_error;
                    break;
                case INFO:
                    iconRes = R.drawable.ic_info;
                    break;
                default:
                    iconRes = -1;
            }
        }
        
        if (iconRes != -1) {
            ivIcon.setImageResource(iconRes);
            ivIcon.setVisibility(View.VISIBLE);
        } else {
            ivIcon.setVisibility(View.GONE);
        }
    }
    
    private void setupCustomContent() {
        if (config.getCustomLayout() != -1) {
            LayoutInflater inflater = LayoutInflater.from(alertDialog.getContext());
            View customView = inflater.inflate(config.getCustomLayout(), flCustomContent, false);
            flCustomContent.addView(customView);
            flCustomContent.setVisibility(View.VISIBLE);
        } else {
            flCustomContent.setVisibility(View.GONE);
        }
    }
    
    /**
     * Setup buttons with context parameter
     * 
     * UPDATE 2025-12-15: Fixed NullPointerException and duplicate buttons
     * - Skip button setup completely for custom layouts
     * - Use context parameter instead of alertDialog.getContext()
     * - Custom layouts handle their own buttons
     */
    private void setupButtons(Context context) {
        // If using custom layout, completely skip button setup
        // Custom layout should handle its own buttons
        if (config.getCustomLayout() != -1) {
            // Make sure the framework button container is completely hidden
            if (llButtonContainer != null) {
                llButtonContainer.setVisibility(View.GONE);
                llButtonContainer.removeAllViews();
            }
            return;
        }
        
        // Normal button setup for non-custom layouts
        llButtonContainer.setVisibility(View.VISIBLE);
        llButtonContainer.removeAllViews();
        
        LayoutInflater inflater = LayoutInflater.from(context);
        
        // Negative button (Cancel)
        if (config.getNegativeButton() != null) {
            btnNegative = (Button) inflater.inflate(R.layout.dialog_btn_cancel, llButtonContainer, false);
            btnNegative.setText(config.getNegativeButton().getText());
            btnNegative.setOnClickListener(v -> {
                if (config.getNegativeButton().getListener() != null) {
                    config.getNegativeButton().getListener().onClick(this, DialogInterface.BUTTON_NEGATIVE);
                } else {
                    dismiss();
                }
            });
            llButtonContainer.addView(btnNegative);
        }
        
        // Positive button (OK, Confirm)
        if (config.getPositiveButton() != null) {
            btnPositive = (Button) inflater.inflate(R.layout.dialog_btn_confirm, llButtonContainer, false);
            btnPositive.setText(config.getPositiveButton().getText());
            
            // Set button style based on dialog type
            setupButtonStyle(btnPositive, config.getType());
            
            btnPositive.setOnClickListener(v -> {
                if (config.getPositiveButton().getListener() != null) {
                    config.getPositiveButton().getListener().onClick(this, DialogInterface.BUTTON_POSITIVE);
                } else {
                    dismiss();
                }
            });
            llButtonContainer.addView(btnPositive);
        }
        
        // If no buttons, add default OK button
        if (config.getPositiveButton() == null && config.getNegativeButton() == null) {
            btnPositive = (Button) inflater.inflate(R.layout.dialog_btn_confirm, llButtonContainer, false);
            btnPositive.setText(context.getString(R.string.ok));
            btnPositive.setOnClickListener(v -> dismiss());
            llButtonContainer.addView(btnPositive);
        }
    }
    
    private void setupButtonStyle(Button button, DialogType type) {
        Context context = button.getContext();
        
        switch (type) {
            case SUCCESS:
                button.setBackgroundTintList(ContextCompat.getColorStateList(context, R.color.success));
                break;
            case WARNING:
                button.setBackgroundTintList(ContextCompat.getColorStateList(context, R.color.warning));
                break;
            case ERROR:
                button.setBackgroundTintList(ContextCompat.getColorStateList(context, R.color.button_danger));
                break;
            case CONFIRM:
                button.setBackgroundTintList(ContextCompat.getColorStateList(context, R.color.button_danger));
                break;
            default:
                button.setBackgroundTintList(ContextCompat.getColorStateList(context, R.color.primary));
                break;
        }
    }
}
```

### DialogExamples.java (Usage Reference with Dynamic Content)
```java
package com.callblocker.common.dialog.examples;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.CheckBox;
import android.widget.LinearLayout;

import com.callblocker.common.dialog.CommonDialog;
import com.callblocker.common.dialog.DialogType;

/**
 * Ví dụ cách sử dụng Common Dialog Framework
 * Bao gồm dynamic content và auto-resize features
 */
public class DialogExamples {
    
    /**
     * Simple Confirmation Dialog
     */
    public static void showConfirmDialog(Context context, String title, String message, 
                                       Runnable onConfirm) {
        new CommonDialog.Builder(context)
            .setTitle(title)
            .setMessage(message)
            .setType(DialogType.CONFIRM)
            .setPositiveButton("Xác nhận", (dialog, which) -> {
                if (onConfirm != null) onConfirm.run();
                dialog.dismiss();
            })
            .setNegativeButton("Hủy", (dialog, which) -> dialog.dismiss())
            .build()
            .show();
    }
    
    /**
     * Success Dialog
     */
    public static void showSuccessDialog(Context context, String message) {
        new CommonDialog.Builder(context)
            .setTitle("Thành công")
            .setMessage(message)
            .setType(DialogType.SUCCESS)
            .setPositiveButton("OK", (dialog, which) -> dialog.dismiss())
            .build()
            .show();
    }
    
    /**
     * Error Dialog
     */
    public static void showErrorDialog(Context context, String message) {
        new CommonDialog.Builder(context)
            .setTitle("Lỗi")
            .setMessage(message)
            .setType(DialogType.ERROR)
            .setPositiveButton("OK", (dialog, which) -> dialog.dismiss())
            .setCancelable(true)
            .build()
            .show();
    }
    
    /**
     * Loading Dialog
     */
    public static CommonDialog showLoadingDialog(Context context, String message) {
        return new CommonDialog.Builder(context)
            .setMessage(message)
            .setType(DialogType.LOADING)
            .setCancelable(false)
            .setCancelOnTouchOutside(false)
            .build();
    }
}
```

## 🎨 UI IMPLEMENTATION

### Suggested File Names (Descriptive & Clear)

#### Main Dialog Structure
```
dialog_base_container.xml  ← Main dialog structure (scrollable, icon, title, message, custom content area)
```

#### Button Templates
```
dialog_btn_confirm.xml     ← Primary action button (OK, Save, Delete, Confirm, etc.)
dialog_btn_cancel.xml      ← Secondary action button (Cancel, No, Back, etc.)
```

#### Alternative Naming (Framework Focused)
```
common_dialog_layout.xml   ← Main dialog layout
common_dialog_btn_primary.xml   ← Primary action button
common_dialog_btn_secondary.xml ← Secondary action button
```

### dialog_base_container.xml (Main Structure)
```xml
<?xml version="1.0" encoding="utf-8"?>
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:fillViewport="true">
    
    <LinearLayout
        style="@style/DialogContainer">
        
        <!-- Icon (optional) -->
        <ImageView
            android:id="@+id/ivDialogIcon"
            android:layout_width="48dp"
            android:layout_height="48dp"
            android:layout_gravity="center"
            android:layout_marginBottom="16dp"
            android:visibility="gone"
            android:contentDescription="@string/dialog_icon" />
        
        <!-- Title -->
        <TextView
            android:id="@+id/tvDialogTitle"
            style="@style/DialogTitle"
            android:visibility="gone"
            android:maxLines="3"
            android:ellipsize="end" />
        
        <!-- Message -->
        <TextView
            android:id="@+id/tvDialogMessage"
            style="@style/DialogMessage"
            android:visibility="gone"
            android:lineSpacingExtra="4dp"
            android:lineSpacingMultiplier="1.2" />
        
        <!-- Custom Content Container -->
        <FrameLayout
            android:id="@+id/flCustomContent"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:visibility="gone" />
    
    <!-- Button Container -->
    <LinearLayout
        android:id="@+id/llButtonContainer"
        style="@style/DialogButtonContainer" />
        
</LinearLayout>

</ScrollView>
```

### dialog_btn_confirm.xml (Primary Action Button)
```xml
<?xml version="1.0" encoding="utf-8"?>
<Button xmlns:android="http://schemas.android.com/apk/res/android"
    style="@style/DialogButton.Confirm"
    android:layout_width="wrap_content"
    android:layout_height="@dimen/button_height_small"
    android:text="OK"
    android:textColor="@android:color/white"
    android:background="@drawable/button_background"
    android:backgroundTint="@color/primary"
    android:paddingStart="@dimen/spacing_large"
    android:paddingEnd="@dimen/spacing_large" />
```

### dialog_btn_cancel.xml (Secondary Action Button)
```xml
<?xml version="1.0" encoding="utf-8"?>
<Button xmlns:android="http://schemas.android.com/apk/res/android"
    style="@style/DialogButton.Cancel"
    android:layout_width="wrap_content"
    android:layout_height="@dimen/button_height_small"
    android:text="CANCEL"
    android:textColor="@color/text_secondary"
    android:background="?android:attr/selectableItemBackground"
    android:paddingStart="16dp"
    android:paddingEnd="16dp"
    android:layout_marginEnd="8dp" />
```

## 📋 FILE NAMING COMPARISON

### ❌ Current Names (Less Clear)
```
dialog_common_base.xml      ← What is "common base"?
dialog_button_positive.xml  ← What action is "positive"?
dialog_button_negative.xml  ← What action is "negative"?
```

### ✅ Recommended Names (Self-Explanatory)
```
dialog_base_container.xml   ← Clearly main container
dialog_btn_confirm.xml      ← Clearly primary action (OK, Save, Delete)  
dialog_btn_cancel.xml       ← Clearly secondary action (Cancel, No)
```

### 🎯 Alternative Framework Names
```
common_dialog_layout.xml         ← Framework prefix + purpose
common_dialog_btn_primary.xml    ← Framework prefix + button role
common_dialog_btn_secondary.xml  ← Framework prefix + button role
```

### 💡 Project-Specific Names
```
callblock_dialog_container.xml   ← Project-specific prefix
callblock_dialog_btn_action.xml  ← Action button
callblock_dialog_btn_cancel.xml  ← Cancel button
```
    android:layout_height="@dimen/button_height_small"
    android:text="OK"
    android:textColor="@android:color/white"
    android:background="@drawable/button_background"
    android:backgroundTint="@color/primary"
    android:paddingStart="@dimen/spacing_large"
    android:paddingEnd="@dimen/spacing_large" />
```

### dialog_button_negative.xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<Button xmlns:android="http://schemas.android.com/apk/res/android"
    style="@style/DialogButton.Cancel"
    android:layout_width="wrap_content"
    android:layout_height="@dimen/button_height_small"
    android:text="CANCEL"
    android:textColor="@color/text_secondary"
    android:background="?android:attr/selectableItemBackground"
    android:paddingStart="16dp"
    android:paddingEnd="16dp"
    android:layout_marginEnd="8dp" />
```

### Required Colors (colors.xml)
```xml
<!-- Common Dialog Colors -->
<color name="success">#4CAF50</color>
<color name="warning">#FF9800</color>
<color name="button_danger">#F44336</color>
<color name="dialog_background">@color/surface</color>
```

### Required Strings (strings.xml)
```xml
<!-- Common Dialog Strings -->
<string name="dialog_icon">Dialog icon</string>
<string name="confirm">Xác nhận</string>
<string name="cancel">Hủy</string>
<string name="ok">OK</string>
<string name="success_title">Thành công</string>
<string name="error_title">Lỗi</string>
<string name="warning_title">Cảnh báo</string>
<string name="info_title">Thông tin</string>
```

**📂 Note**: This implementation uses design standards from:
- Spacing & Padding Standards for consistent dialog margins
- Border & Shape Standards for dialog corner radius
- Style System Architecture for proper style inheritance

## 🔄 DYNAMIC CONTENT FEATURES

### Auto-Resize Functionality
The CommonDialog supports dynamic content updates that automatically trigger dialog resizing:

```java
// Create dialog that can be updated
CommonDialog dialog = new CommonDialog.Builder(context)
    .setTitle("Processing...")
    .setMessage("Please wait...")
    .build();
dialog.show();

// Update content dynamically (dialog will auto-resize)
dialog.setTitle("Almost Done...");
dialog.setMessage("Finishing up the process...");
```

## 📋 CUSTOM LAYOUT BEST PRACTICES (Updated 2025-12-15)

### ✅ DO - Custom Layout Guidelines

#### 1. Use DialogContainer Style
```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    style="@style/DialogContainer">
    <!-- Your custom content here -->
</LinearLayout>
```

#### 2. Handle Your Own Buttons
```xml
<!-- In your custom layout -->
<LinearLayout style="@style/DialogButtonContainer">
    <Button
        android:id="@+id/btnCancel"
        style="@style/DialogButton.Cancel" />
    <Button
        android:id="@+id/btnConfirm"  
        style="@style/DialogButton.Confirm" />
</LinearLayout>
```

#### 3. Set Up Button Listeners in Code
```java
CommonDialog dialog = new CommonDialog.Builder(context)
    .setCustomView(R.layout.dialog_my_custom)
    .build();

// Find and set up your custom buttons
Button btnCancel = dialog.findViewById(R.id.btnCancel);
Button btnConfirm = dialog.findViewById(R.id.btnConfirm);

btnCancel.setOnClickListener(v -> dialog.dismiss());
btnConfirm.setOnClickListener(v -> {
    // Handle confirm action
    dialog.dismiss();
});

dialog.show();
```

### ❌ DON'T - Avoid These Mistakes

#### 1. Don't Mix Framework and Custom Buttons
```java
// ❌ BAD - Will create duplicate buttons
new CommonDialog.Builder(context)
    .setCustomView(R.layout.dialog_with_buttons)  // Has own buttons
    .setPositiveButton("OK", listener)            // Framework button
    .setNegativeButton("Cancel", listener)        // Framework button
    .build();
```

#### 2. Don't Use Base Container for Custom Layouts
```java
// ❌ BAD - Will create double styling
// Custom layout is now used directly, no base container needed
```

#### 3. Don't Forget Required String Resources
```xml
<!-- Required in strings.xml -->
<string name="dialog_icon">Dialog icon</string>
```

### 🎯 Framework vs Custom Layout Decision Tree

```
Need standard confirmation? ➜ Use Framework (setPositiveButton/setNegativeButton)
Need complex form/UI?      ➜ Use Custom Layout (setCustomView)
Need special styling?      ➜ Use Custom Layout with own styles
Need input fields?         ➜ Use Custom Layout
Need standard success/error? ➜ Use Framework with DialogType
```

### Auto-Resizing Capabilities
- **Responsive Width**: Automatically adjusts to screen size (max 90% width)
- **Dynamic Height**: Expands/contracts based on content (max 80% screen height)  
- **Scrollable Content**: Long content automatically scrollable
- **Real-time Updates**: Dialog resizes when content changes programmatically

### Usage Examples

#### Dynamic Loading Dialog
```java
// Show initial loading message
CommonDialog dialog = new CommonDialog.Builder(context)
    .setTitle("Processing...")
    .setMessage("Step 1: Initializing...")
    .setType(DialogType.LOADING)
    .build();
dialog.show();

// Update content during process (dialog auto-resizes)
dialog.setMessage("Step 2: Processing large amount of data...\n\nThis may take a moment.");
dialog.setTitle("Almost Done");
```

#### Expandable Custom Dialog
```java
// Dialog with expandable sections
CommonDialog dialog = new CommonDialog.Builder(context)
    .setType(DialogType.CUSTOM)
    .setCustomView(R.layout.expandable_form)
    .build();
    
CheckBox expandBox = dialog.findViewById(R.id.showAdvanced);
LinearLayout advancedSection = dialog.findViewById(R.id.advancedSection);

expandBox.setOnCheckedChangeListener((v, isChecked) -> {
    advancedSection.setVisibility(isChecked ? View.VISIBLE : View.GONE);
    // Dialog automatically resizes to accommodate content
});
```

### Performance Notes
- **ViewTreeObserver**: Used for detecting content changes
- **Debounced Resizing**: Prevents excessive layout calculations
- **Memory Efficient**: Listeners cleaned up when dialog dismissed
- **Smooth Animations**: Content changes trigger smooth resize transitions