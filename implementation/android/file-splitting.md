# 📂 File Splitting Rules

## AI Workflow: LUÔN SPLIT để Clean Architecture

**LUÔN split resources theo category** - không phụ thuộc vào số lượng items.

**Nguyên tắc: 1 file = 1 purpose**

| Resource | Split thành | Luôn tách |
|----------|-------------|-----------|
| `colors.xml` | `colors_brand.xml`, `colors_text.xml`, `colors_ui.xml` | ✅ |
| `dimens.xml` | `dimens_text.xml`, `dimens_spacing.xml`, `dimens_component.xml` | ✅ |
| `strings.xml` | `strings_[feature].xml` theo màn hình/feature | ✅ |
| `styles.xml` | `styles_shared.xml`, `styles_button.xml`, `styles_dialog.xml` | ✅ |

## Layout Sections

**Khi layout > 200 lines hoặc có nhiều sections:** Tách thành `[name]_section_[part].xml` và dùng `<include>`

**Naming Pattern:**

| Layout Type | Section Pattern | Example |
|-------------|-----------------|---------|
| Fragment | `[fragment_name]_section_[name].xml` | `main_profile_section_header.xml` |
| Activity | `[activity_name]_section_[name].xml` | `activity_settings_section_toolbar.xml` |
| Dialog | `[dialog_name]_section_[name].xml` | `dialog_alarm_section_time_picker.xml` |

## Custom Header Pattern

**Theme:** Use `Theme.MaterialComponents.Light.NoActionBar`

**Custom Header Layout:** 56dp height, back button + title + optional actions

## When to Split

| Case | Action |
|------|--------|
| Code duplicate ≥ 2 nơi | Extract to Utils class |
| Layout used ≥ 2 nơi | Create shared layout with `<include>` |
| File > 300 lines | Split to helper classes |
| Constants > 10 | Extract to Constants class |
