# Common Dialog Framework Implementation (Rule 2.16)

> Unified dialog system for consistent UX across Android projects

## 🎯 RELATED STANDARDS
**📂 Design Standards References:**
- [Spacing & Padding Standards](standards/spacing-padding-standards.md) - Dialog margin and padding consistency
- [Border & Shape Standards](standards/border-shape-standards.md) - Dialog corner radius and backgrounds
- [Style System Architecture](standards/style-system-architecture.md) - Dialog style hierarchy
- [Dialog Icon Standards](dialog-icon-standards.md) - ⭐ **NEW** Standardized icons and auto-theming system

**📂 Implementation Standards:**
- [Common Dialog Implementation](standards/common-dialog-implementation.md) - Complete Java + XML implementation

## ⚙️ OVERVIEW

Common Dialog Framework provides unified API with **auto-icons and theming** for all dialog types:
- **🎨 Auto Icons**: Each dialog type has standardized Material Design icon (SUCCESS=✓, ERROR=✗, etc.)
- **🌙 Auto Theming**: Colors follow Material Design 3 with light/dark mode support
- **📏 Dynamic Resizing**: Content automatically adjusts dialog size
- **🔒 Type Safety**: Builder pattern with enum-based configuration 
- **♻️ Cross-App Reusable**: Same implementation pattern for all Android projects

## 🏗️ ARCHITECTURE

```
CommonDialogFramework/
├── DialogType.java           # Enum: CONFIRM, SUCCESS, ERROR, WARNING, INFO, LOADING, CUSTOM
├── DialogConfig.java         # Configuration data class
├── CommonDialog.java         # Main dialog class with Builder pattern
├── examples/
│   └── DialogExamples.java   # Usage examples for reference
└── layouts/
    ├── dialog_common_base.xml    # Base template
    ├── dialog_button_positive.xml # Positive button template  
    └── dialog_button_negative.xml # Negative button template
```

## 📋 DIALOG TYPES

### CONFIRM - Confirmation Actions
- **Use**: Delete, logout, destructive actions
- **Style**: Positive button red (danger color)
- **Example**: "Bạn có chắc chắn muốn xóa item này?"

### SUCCESS - Action Completed 
- **Use**: Operation successful notification
- **Style**: Positive button green, success icon
- **Example**: "Đã thêm số vào danh sách chặn"

### ERROR - Error Messages
- **Use**: Error occurred during operation  
- **Style**: Positive button red, error icon
- **Example**: "Không thể kết nối đến server"

### WARNING - Dangerous Action Warning
- **Use**: Warning before potentially harmful operation
- **Style**: Positive button orange/yellow, warning icon
- **Example**: "Hành động này sẽ xóa tất cả dữ liệu"

### INFO - Information Display
- **Use**: General information for user
- **Style**: Positive button blue, info icon  
- **Example**: "Ứng dụng cần quyền truy cập danh bạ"

### LOADING - Progress Indication
- **Use**: Long-running operations
- **Style**: No buttons, not cancelable
- **Example**: "Đang xử lý..." (with progress indicator)

### CUSTOM - Custom Layout
- **Use**: Complex forms, special UI requirements
- **Style**: Custom content + standard button container
- **Example**: Quick Block dialog with checkboxes

## 🚀 USAGE EXAMPLES

### Simple Confirmation
```java
new CommonDialog.Builder(context)
    .setTitle("Xác nhận xóa")
    .setMessage("Bạn có chắc chắn muốn xóa item này?")
    .setType(DialogType.CONFIRM)
    .setPositiveButton("Xóa", (dialog, which) -> {
        deleteItem();
        dialog.dismiss();
    })
    .setNegativeButton("Hủy", (dialog, which) -> dialog.dismiss())
    .build()
    .show();
```

### Success Notification
```java
new CommonDialog.Builder(context)
    .setTitle("Thành công")
    .setMessage("Đã thêm số vào danh sách chặn")
    .setType(DialogType.SUCCESS)
    .setPositiveButton("OK", (dialog, which) -> dialog.dismiss())
    .build()
    .show();
```

### Custom Dialog with Form
```java
CommonDialog dialog = new CommonDialog.Builder(context)
    .setType(DialogType.CUSTOM)
    .setCustomView(R.layout.dialog_quick_block_content)
    .setPositiveButton("Chặn", this::handleQuickBlock)
    .setNegativeButton("Hủy", null)
    .build();
    
// Access custom views
EditText editText = dialog.findViewById(R.id.editText);
CheckBox checkBox = dialog.findViewById(R.id.checkBox);

dialog.show();
```

## 📂 COMPLETE IMPLEMENTATION

**📂 Complete Implementation:** [Common Dialog Implementation](standards/common-dialog-implementation.md)

This file contains comprehensive implementation including:
- Complete Java class implementations (DialogType, DialogConfig, CommonDialog)
- UI layout examples with proper styling
- Integration steps and usage patterns
- Required string resources and drawables

**📂 Note**: This implementation uses design standards from:
- Spacing & Padding Standards for consistent margins
- Border & Shape Standards for dialog backgrounds
- Style System Architecture for theme integration

## ✅ IMPLEMENTATION CHECKLIST

### 🏗️ Core Framework
- [ ] Copy `DialogType.java` to `common.dialog` package
- [ ] Copy `DialogConfig.java` to `common.dialog` package  
- [ ] Copy `CommonDialog.java` to `common.dialog` package
- [ ] Copy `DialogExamples.java` for reference patterns

### 🎨 Layout Resources
- [ ] Add `dialog_common_base.xml` layout template
- [ ] Add `dialog_button_positive.xml` button template
- [ ] Add `dialog_button_negative.xml` button template
- [ ] Verify `styles_dialog.xml` exists with proper styles

### 🎯 Integration
- [ ] Add required colors: `success`, `warning`, `button_danger`
- [ ] Add dialog icons: `ic_check_circle`, `ic_warning`, `ic_error`, `ic_info`
- [ ] Add string resources for dialog labels
- [ ] Test with existing `DialogUtils.setDialogWidth()` integration

### 🔄 Migration (Optional)
- [ ] Identify existing AlertDialog usages  
- [ ] Replace with CommonDialog calls
- [ ] Remove old dialog layouts (after testing)
- [ ] Update code reviews to check CommonDialog usage

**📖 For comprehensive migration procedures: [CommonDialog Migration Procedures](../procedures/commondialog-migration.md)**

### 🧪 Testing
- [ ] Test all 7 dialog types render correctly
- [ ] Test custom layouts work with framework
- [ ] Test button actions and dismissal behavior
- [ ] Test theme compatibility (light/dark mode)
- [ ] Test dialog width with DialogUtils integration

### 📚 Documentation
- [ ] Copy usage guide to project documentation
- [ ] Update team coding standards
- [ ] Add examples to developer onboarding
- [ ] Document migration strategy for existing dialogs

## 🔗 CROSS-PROJECT USAGE

This framework is designed to be **cross-project reusable**. To use in other Android apps:

1. **Copy core files** to new project's `common.dialog` package
2. **Copy layout templates** to new project's `res/layout/`
3. **Adapt colors and strings** to match new project's theme
4. **Follow same usage patterns** for consistent UX

**Benefits for multiple projects:**
- Same dialog UX across all apps
- Reduced development time
- Easier maintenance and updates
- Team familiarity with common patterns

---

**Related Rules:**
- **Rule 2.11**: Dialog Standards (superseded by Common Dialog Framework)
- **Rule 2.10**: Material Design 3 (dialog styling follows MD3 principles)
- **Rule 2.14**: Theme & Settings (dialogs auto-respect app theme)