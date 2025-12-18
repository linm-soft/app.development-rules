# ✅ AI Development Checklist

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "ai-development-checklist"...
```

**Purpose:** Let user know AI is referencing development checklist.

---

## Quick Reference for Common Tasks

### Feature Implementation Workflow

- [ ] Create TODO list and track progress
- [ ] Implement feature with proper code structure
- [ ] Test compilation and functionality
- [ ] **Sync to documentation** - Update relevant docs:
  - [ ] Add to `docs/logs/CHANGELOG.md` with version and description
  - [ ] Update `docs/dev/project_summary.md` if architecture changes
  - [ ] Document API/interface changes in `docs/api/`
  - [ ] Add implementation notes to `docs/dev/ui/` or relevant section
- [ ] Mark feature as completed in progress tracking

### Creating Activity/Fragment

- [ ] Class name: `[Feature]Activity.java` / `Main[Feature].java`
- [ ] Layout file: `activity_[feature].xml` / `main_[feature].xml`
- [ ] Register in `AndroidManifest.xml`
- [ ] Add strings to **BOTH**: `values/strings.xml` AND `values-vi/strings.xml`
- [ ] Follow class structure order

### Creating Dialog

- [ ] Create layout: `dialog_[action].xml`
- [ ] NO AlertDialog.Builder with setTitle/setMessage
- [ ] Inflate with `dialog.setContentView()`
- [ ] Call `DialogUtils.setDialogWidth()` after `dialog.show()`
- [ ] Add strings to both language files

### Adding Resource

- [ ] Color name: Semantic (`text_primary`, not `blue`)
- [ ] Dimension name: By type (`spacing_normal`, `text_size_large`)
- [ ] String name: By context (`alarm_title`, `dialog_confirm`)
- [ ] Style name: By component (`Button.Primary`, `Text.Title`)

### Multi-language Strings ⚠️ CRITICAL

- [ ] Add to `values/strings.xml` (English)
- [ ] Add to `values-vi/strings.xml` (Vietnamese)
- [ ] **String names MUST match** in both files
- [ ] Use snake_case: `alarm_title` not `alarmTitle`
- [ ] Prefix by feature: `alarm_`, `dialog_`, `settings_`
- [ ] Order: `[subject]_[action]` (e.g., `topic_selected` not `selected_topic`)
- [ ] NO hardcoded text in Java/layouts
- [ ] Use `getString(R.string.xxx)` in code
- [ ] Use `@string/xxx` in layouts

### Theme/Dark Mode ⚠️ CRITICAL

- [ ] NO hardcoded dark colors (`@color/xxx_dark`)
- [ ] Use theme-aware colors (`@color/background_light`, `@color/card_background`)
- [ ] Screen backgrounds: `@color/background_light`
- [ ] CardView: `app:cardBackgroundColor="@color/card_background"`
- [ ] Text colors: `@color/text_primary`, `@color/text_secondary`
- [ ] Test both Light and Dark modes

### CardView Rules ⚠️ CRITICAL

- [ ] **REQUIRED:** `app:cardBackgroundColor="@color/card_background"`
- [ ] NO `android:backgroundTint`
- [ ] NO hardcoded `@android:color/white`
- [ ] If using style, ensure it has `cardBackgroundColor`
- [ ] Test both modes

### Color Selector Files ⚠️ CRITICAL

- [ ] NO hardcoded hex colors (`#RRGGBB`)
- [ ] ALWAYS use references (`@color/xxx`)
- [ ] Check colors exist in `values-night/`
- [ ] Files to check: `bottom_nav_color.xml`, `tab_text_color.xml`, etc.
- [ ] Test both modes

### New Project Setup - Theme

- [ ] Create `values/attrs.xml` with custom attributes
- [ ] Create `values/styles_theme.xml` with `Theme.MaterialComponents.Light.NoActionBar`
- [ ] Create `values-night/styles_theme.xml` with `Theme.MaterialComponents.NoActionBar`
- [ ] Ensure `colors_brand.xml` has `primary` AND `primary_dark`
- [ ] Create `drawable/dialog_background.xml`
- [ ] Create color files in both `values/` and `values-night/`
- [ ] Card style must have `cardBackgroundColor`

### New Project - Required Screens ⚠️ MANDATORY

- [ ] **MainProfile.java** - Profile/Settings screen (REQUIRED)
- [ ] User info (if login enabled)
- [ ] Permissions section with status + action buttons
- [ ] Package name + version info
- [ ] App settings:
  - [ ] Language selector (System/EN/VI)
  - [ ] Dark Mode toggle
- [ ] Developer info (About):
  - [ ] Developer: `Linh.BoDinh`
  - [ ] Contact: `support@soft-linm.com`
  - [ ] Website: `soft-linm.com` (clickable)
  - [ ] Version: `BuildConfig.VERSION_NAME`
  - [ ] Release date: `BuildConfig.BUILD_TIME`

### Permission Synchronization ⚠️ CRITICAL

When adding new permission, sync **ALL 3 PLACES:**

- [ ] `AndroidManifest.xml` - Declare permission
- [ ] `MainActivity.java` → `getPermissionTerms()` - Terms dialog
- [ ] `MainProfile.java` → `getAppPermissions()` - Permission section

**Missing any = incomplete!**

### Code Changes

- [ ] Check code duplicate → extract to Utils
- [ ] Check layout duplicate → create include layout
- [ ] Update comments if complex logic
- [ ] Keep consistent naming with existing code

### Model Field Changes

- [ ] Add field + getter/setter
- [ ] Update constructor if needed
- [ ] Update Database: add column, update version, migration
- [ ] Update CRUD methods in DatabaseHelper

### File Splitting

**ALWAYS split for clean architecture:**

- [ ] Read file → identify groups/prefixes
- [ ] Create new files by category:
  - colors → `colors_brand.xml`, `colors_text.xml`, `colors_ui.xml`
  - dimens → `dimens_text.xml`, `dimens_spacing.xml`
  - strings → `strings_[feature].xml`
  - styles → `styles_shared.xml`, `styles_button.xml`
- [ ] Move items to appropriate files
- [ ] Keep misc/common in original file
- [ ] Build verify
- [ ] Update `values-vi/` if strings

### Data Refresh Pattern (Bottom Navigation)

- [ ] Flag tracking in MainActivity: `boolean needsListRefresh`
- [ ] Public method: `markDataChanged()`
- [ ] Call after insert/update/delete
- [ ] Refresh in `onResume()` of list fragment
- [ ] Adapter update method: `updateData(List<T>)`
- [ ] Empty state handling

## When to Ask User

- Unsure which files are legacy/deprecated
- Project structure differs from standard
- Can't find existing Utils class
- Need to create many new files for large feature
- Unclear requirements or conflicting patterns

## Detection Commands (Run Before Submit)

See: [`code-review-detection.md`](./code-review-detection.md)
