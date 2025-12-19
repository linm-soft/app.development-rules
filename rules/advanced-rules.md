# Advanced Rules (2.17-2.30)

> Advanced features and specialized standards

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "advanced-rules"...
```

**Purpose:** Let user know AI is referencing advanced rules.

---

## 2.17. Logging & Crash Handling System ⚠️ OPTIONAL

**📂 See:** [`implementation/comprehensive-logging-system.md`](../implementation/comprehensive-logging-system.md)

**Quick Reference:**
- **Centralized LogHelper** with single global toggle (replaces android.util.Log)
- **Crash logs always enabled** (no toggle) + All other logs toggleable via single switch
- **Smart categorization:** UI, Database, API, Pagination logging  
- **Production optimized:** Zero debug impact in release builds
- **View integration:** No additional config needed - views auto-respect global toggle

**Updated Toggle Behavior (Dec 2025):**
- **Single Toggle Controls:** All logs (debug, info, warning, error) except crashes
- **Crash logs:** ALWAYS enabled for debugging (no toggle)
- **View logs:** Automatically controlled by global toggle - no per-view config needed

⚠️ **User Confirmation Required:** Ask before applying logging system

---

## 2.18. Error Handling & Crash Prevention ⚠️ CRITICAL

**📂 See:** [`implementation/crash-handling-logging.md`](../implementation/crash-handling-logging.md)

**Quick Reference:**
- **Global ExceptionHandler** integrated with LogHelper crash logging
- **User-friendly error dialogs** with recovery options
- **Critical sections protection:** Database, Network, File I/O, Media
- **Automatic crash log creation** in Downloads folder

---

## 2.19. Menu Standards ⚠️ OPTIONAL

**📂 See:** [`implementation/menu-implementation.md`](../implementation/menu-implementation.md)

**Quick Reference:**
- **Total Menu Items:** Maximum 5 items per menu (UX best practice)
- **Bottom Navigation:** 5 items max (4 main + 1 "More"), `app:labelVisibilityMode="selected"`
- **App Bar Menu:** Standard settings/help/share patterns
- **Navigation Drawer:** Material Design compliance with standard sections
- Height: 70dp standard with 8dp padding
- Icon size: 24dp (Material Design)
- Custom background with rounded selection indicator
- Color selectors for proper state management
- Fragment container constraint to bottom navigation

⚠️ **User Confirmation Required:** Ask before applying menu standards

---

## 2.20. Dialog Implementation Standards ⚠️ CRITICAL  

**📂 See:** [`implementation/dialog-rules.md`](../implementation/dialog-rules.md)

**Quick Reference:**
- **NEVER use:** `AlertDialog.Builder` with `setTitle()`/`setMessage()`
- **ALWAYS use:** Custom layout with `dialog.setContentView()`
- **MANDATORY:** Call `DialogUtils.setDialogWidth()` after `dialog.show()`
- Padding: `@dimen/spacing_large` (20dp) for container
- Background: Corner radius with `@drawable/dialog_background`
- All text must use string resources (multi-language)

### ⚠️ MIGRATION TO COMMON DIALOG FRAMEWORK (Rule 2.16)

**DEVELOPER CONFIRMATION REQUIRED:**

Before implementing any new dialog or modifying existing dialogs, developer must confirm:

**✅ Checklist for Dialog Implementation:**
- [ ] **Check if Common Dialog Framework (Rule 2.16) can handle this use case**
- [ ] **If YES**: Use `CommonDialog.Builder()` instead of AlertDialog
- [ ] **If NO**: Document why custom implementation is needed
- [ ] **Migration**: Replace existing AlertDialog calls with CommonDialog
- [ ] **Testing**: Verify dialog behavior matches design requirements

**🔄 Dynamic Content Support:**
```java
// ✅ Dialog auto-resizes when content changes
CommonDialog dialog = new CommonDialog.Builder(context)
    .setTitle("Loading...")
    .setMessage("Step 1: Starting...")
    .build();
dialog.show();

// Content updates trigger automatic resize
dialog.setMessage("Step 2: Processing large amount of data...");
dialog.setTitle("Processing Complete");
```

**⚡ Common Dialog Types Available:**
```java
// ✅ All types support dynamic content resizing:
DialogType.CONFIRM   // Delete, logout confirmations
DialogType.SUCCESS   // "Item saved successfully"  
DialogType.ERROR     // "Network error occurred"
DialogType.WARNING   // "This will delete all data"
DialogType.INFO      // "Permission required explanation"
DialogType.LOADING   // "Please wait..." with progress updates
DialogType.CUSTOM    // Forms, expandable content, complex layouts
```

**📱 Responsive Design Features:**
- **Auto-width**: Responsive width with configurable margins
- **Auto-height**: Dynamic height based on content (max 80% screen height)
- **Scrollable**: Long content automatically scrollable
- **Content updates**: Real-time resizing when text/views change
- **Screen rotation**: Auto-adjusts to orientation changes

**❌ Only use legacy AlertDialog when:**
- Common Dialog Framework doesn't support the specific use case
- Performance-critical scenarios requiring custom optimization
- Third-party library integration that requires AlertDialog

**🔄 Migration Priority:**
1. **New dialogs**: MUST use Common Dialog Framework
2. **Existing simple dialogs**: Migrate when touched/modified
3. **Complex existing dialogs**: Migrate during major refactoring only

**📋 Migration Process:**
- **Use checklist**: [`checklists/dialog-migration-checklist.md`](../checklists/dialog-migration-checklist.md)
- **Track progress**: Document each migration with reasoning
- **Team review**: Get approval for exceptions to framework usage

---

## 2.21. Spacing and Padding Standards ⚠️ CRITICAL

**📂 See:** [`implementation/android/spacing-padding-standards.md`](../implementation/android/spacing-padding-standards.md)

**Complete Spacing System:**
- **4dp increment system**: spacing_tiny(4) → spacing_xxlarge(32)
- **RTL support**: ALWAYS use `paddingStart`/`paddingEnd` (NOT left/right)
- **Component patterns**: Standard padding for buttons, dialogs, lists, cards
- **File organization**: dimens_spacing.xml, dimens_component.xml, dimens_text.xml
- **Zero tolerance**: NO hardcoded dp values, NO left/right attributes
- **Validation rules**: All spacing MUST be multiples of 4dp

⚠️ **User Confirmation Required:** Ask developer before implementing complete spacing system

**Quick Reference:**
- Container padding: `@dimen/spacing_normal` (16dp)
- Section gaps: `@dimen/spacing_large` (20dp) 
- List item gaps: `@dimen/spacing_tiny` (4dp)
- Dialog patterns: 20dp container, 16dp sections, 12dp inputs

---

## 2.22. Border & Shape Standards ⚠️ REQUIRED

**📂 See:** [`implementation/android/border-shape-standards.md`](../implementation/android/border-shape-standards.md)

**Complete Border System:**
- **Corner radius scale**: radius_small(4dp) → radius_xlarge(20dp) + radius_round(50dp)
- **Stroke width standards**: stroke_thin(0.5dp) → stroke_bold(3dp)
- **Component-specific**: button_corner_radius, card_corner_radius, input_corner_radius
- **Drawable patterns**: bg_component_variant.xml naming convention
- **State selectors**: Proper state management for interactive elements
- **Color integration**: Use semantic colors, NO hardcoded hex values

⚠️ **User Confirmation Required:** Ask developer before implementing border system

**Quick Reference:**
- Standard radius: `@dimen/radius_normal` (8dp)
- Standard stroke: `@dimen/stroke_normal` (1dp) 
- Naming: bg_button_primary.xml, bg_card_bordered.xml
- States: pressed, focused, disabled, selected

---

## 2.23. Style System Architecture ⚠️ REQUIRED

**📂 See:** [`implementation/android/style-system-architecture.md`](../implementation/android/style-system-architecture.md)

**Complete Style Hierarchy:**
- **File organization**: styles_shared.xml, styles_button.xml, styles_input.xml, etc.
- **Text hierarchy**: TextAppearance.Heading → Body → Caption with inheritance
- **Component styles**: Button variants (Primary, Secondary, Outline, Danger)
- **Container patterns**: Base containers, form layouts, list items
- **Dialog system**: Complete dialog component architecture
- **Consistent inheritance**: Proper parent-child relationships

⚠️ **User Confirmation Required:** Ask developer before implementing style architecture

**Quick Reference:**
- Text: `@style/TextAppearance.Body`, `.Heading`, `.Caption`
- Buttons: `@style/ButtonStyle.Primary`, `.Secondary`, `.Outline`
- Containers: `@style/Container.Screen`, `.Card`, `.Section`
- Forms: `@style/InputStyle`, `FormContainer`, `FormLabel`

---

## 2.24. Database Migration Rule ⚠️ CRITICAL

**📂 See:** [`implementation/database-migration-rule.md`](../implementation/database-migration-rule.md)

**Quick Reference:**
- **AUTO-TRIGGER:** When AI detects new columns in CREATE TABLE or ContentValues
- **NO user confirmation needed** - this is mandatory boilerplate
- **Always increment DATABASE_VERSION** by 1
- **Always add migration block** with try-catch and logging
- **Pattern:** `ALTER TABLE ADD COLUMN` with DEFAULT values

---

## 2.25. Database Documentation Standards ⚠️ OPTIONAL

**📂 See:** [`implementation/database-documentation.md`](../implementation/database-documentation.md)

**Quick Reference:**
- **Only for apps with SQLite/Room databases**
- **User Confirmation Required:** Ask before creating/updating docs
- **File location:** `docs/dev/DATABASE_SCHEMA.md`
- **Content:** Tables, indexes, relationships, query patterns

**When to ask user:**
```
"Detected database usage. Create/Update database documentation? (y/n)"
```

---

## 2.26. Project Documentation Standards ⚠️ REQUIRED

**📂 See:** [`implementation/project-documentation-standards.md`](../implementation/project-documentation-standards.md)

**Quick Reference:**
- **Folder structure:** `docs/dev/` với ui, api, database, common subfolders
- **Main file:** `docs/dev/project_summary.md` - centralized project status
- **Auto-update:** AI tự động review và update progress khi có changes
- **Module summaries:** `plan_summary.md` trong mỗi subfolder
- **AI Progress Tracking:** Project-specific `.ai-progress/` files (see [`.ai-progress/`](../.ai-progress/) - modular workflows, commands, templates)

**Required structure:**
```
docs/dev/
├── ui/plan_summary.md
├── api/, database/, common/
└── project_summary.md

{project}/.ai-progress/          # Project-specific AI tracking
├── {app_name}_main_progress.md
├── {app_name}_context.md
└── sessions/
```

---

## 2.27. Database Management Standards ⚠️ REQUIRED

**📂 See:** [`implementation/database-management-implementation.md`](../implementation/database-management-implementation.md)

**Quick Reference:**
- **Export Database:** User confirmation dialog before export with progress indicator
- **Import Database:** File validation, overwrite warning, and confirmation flow
- **Consistent UI:** Card-based layout with title, description, and action buttons
- **Error Handling:** Validation, storage permissions, and user feedback
- **Standard Layout:** Reusable section template for export/import functionality

**Key Features:**
- **User Confirmation:** Required for both export and import operations
- **Progress Feedback:** Show progress dialogs for long-running operations
- **File Validation:** Verify backup file integrity before import
- **Storage Info:** Optional section showing backup file location

⚠️ **User Confirmation Required:** Ask before applying database management standards

---

## 2.28. API & Network Standards ⚠️ OPTIONAL

**📂 See:** [`implementation/api-network-standards.md`](../implementation/api-network-standards.md)

**Quick Reference:**
- **HTTP Client:** Retrofit + OkHttp with centralized configuration
- **API Error Handling:** Standardized response parsing with user-friendly messages
- **Authentication:** Secure token management with automatic refresh
- **Network Security:** Certificate pinning, request/response validation
- **Offline Support:** Response caching and offline-first patterns

⚠️ **User Confirmation Required:** Ask before applying API integration standards

---

## 2.29. Null Safety Standards ⚠️ CRITICAL

**📂 See:** [`implementation/null-safety-standards.md`](../implementation/null-safety-standards.md)

**Quick Reference:**
- **Mandatory null checks** for all external dependencies (ExoPlayer, database, context)
- **Auto-recovery patterns** - components reinitialize when null detected
- **Graceful degradation** - user-friendly errors instead of crashes
- **Input validation** - comprehensive checks for method parameters
- **Prevention focus** - proactive coding patterns to eliminate NullPointerExceptions

**Critical Implementation:**
```java
// ✅ MANDATORY Pattern
if (player == null) {
    LogHelper.e(TAG, "Player null, reinitializing...");
    initializePlayer();
    if (player == null) {
        handleGracefulFailure();
        return;
    }
}
```

⚠️ **User Confirmation Required:** Ask before applying null safety patterns to existing code

---

## 2.30. Debug Tools & Development Activity Standards ⚠️ OPTIONAL

**📂 See:** [`implementation/debug-tools-standards.md`](../implementation/debug-tools-standards.md)

**Quick Reference:**
- **Reduced compliance** for debug/development activities (log viewers, crash handlers)
- **Allowed exceptions:** Hardcoded strings, English-only, basic UI for dev tools
- **Required standards:** Material Design 3 components, layout structure, color references
- **Standardized templates:** Use proven implementations (activity_log_viewer.xml from daily-speak)
- **Debug tool patterns:** Files with `debug`, `log`, `crash`, `test` keywords

⚠️ **User Confirmation Required:** Ask before applying reduced standards OR template replacement

**Confirmation Messages:**
```
"Detected debug/development tool: [filename]. Apply reduced standards for dev tools? (y/n)"
"Found basic/incomplete log viewer. Replace with standardized template from daily-speak? (y/n)"
```

---
**📚 Related Rules:**
- [Setup Rules](./setup-rules.md) - 2.1-2.8
- [UI/UX Rules](./ui-ux-rules.md) - 2.9-2.15
- [Quality Rules](./quality-rules.md) - 3.0-4.0