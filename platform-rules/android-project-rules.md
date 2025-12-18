# Android Project Rules & Best Practices

> Quy tắc chung cho tất cả Android Native Java projects. Dùng làm reference cho AI Assistant.

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "ANDROID_PROJECT_RULES"...
```

**Purpose:** Let user know AI is referencing main project rules.

**⚠️ CRITICAL: AI must ALWAYS read advanced-rules.md for CRITICAL rules**
- Rule 2.19 - Error Handling & Null Safety ⚠️ CRITICAL
- Rule 2.25 - Database Migration ⚠️ CRITICAL  
- Rule 2.29 - Null Safety Standards ⚠️ CRITICAL

---

## 🤖 AI GUIDELINES & DOCUMENTATION REFERENCES

**📂 Complete AI Instructions:** [`../ai-guidelines.md`](../ai-guidelines.md)
**📂 Workflow Commands:** [`../workflow-commands.md`](../workflow-commands.md)
**📂 Android UI Workflow:** [`android-ui-workflow.md`](./android-ui-workflow.md)

**📚 Universal Documentation Pattern:**
- **Android Architecture:** `[project]/DOCS/android/architecture.md`
- **Build Guide:** `[project]/DOCS/android/build-guide.md`
- **Database Schema:** `[project]/DOCS/android/database-schema.md`
- **API Reference:** `[project]/DOCS/api/android-api-reference.md`
- **Setup Guide:** `[project]/DOCS/android/setup-guide.md`

**Quick AI Reference:**
- Read category-specific rule files, not this master file
- Use checklists for reviews, implementation files for coding
- Reference project-specific DOCS/ for technical implementation details
- Apply these rules to ANY Android project  
- Always create TODO list before starting work
- Follow progress tracking protocols

### 📝 CRITICAL: Section Numbering Rules
- **NEVER create duplicate section numbers** (e.g., two 2.13 sections)
- **ALWAYS check existing numbering** before adding new sections
- **Sequential order required:** 2.1 → 2.2 → ... → 2.20 → 3 → 4
- **When adding new section:** Insert in proper numerical position and renumber subsequent sections

### 🤝 MANDATORY: User Confirmation for Optional Rules
**⚠️ Ask user before applying ANY ⚠️ OPTIONAL rule:**

**Example Confirmations:**
- "Detected Bottom Navigation. Apply Bottom Navigation Standards (2.18)? (y/n)"
- "Found FloatingActionButton. Apply FAB Positioning rules (2.13)? (y/n)"
- "No logging detected. Add Logging & Debugging setup (2.16)? (y/n)"

**Response Handling:**
- **YES:** Apply rule and include in compliance checks
- **NO:** Skip rule, don't mark as violation
- **Document choice:** Note user's decision in review

### 🎯 Rule Priority Classification
- **⚠️ CRITICAL:** Core functionality that ALL apps must have - will break app/cause crashes if not implemented
- **⚠️ REQUIRED:** Standard features most apps should have - user experience expectations
- **⚠️ OPTIONAL:** App-specific features - depends on design/requirements, ASK USER FIRST
- **No emoji:** Basic setup rules that always apply to any Android project

**When to use each:**
- **CRITICAL:** Apply automatically - Error Handling, Spacing, Dialog Standards, Null Safety
- **REQUIRED:** Apply to most apps - Multi-language, Theme, MainProfile, Permissions
- **OPTIONAL:** Ask user first - Bottom Navigation, FAB, Logging, Debug Tools

---

## 📋 Android Project Rules - Master Navigation

### 📂 Rule Categories

| Category | Rules Range | Primary Focus | File Link |
|----------|-------------|---------------|-----------|
| **Setup & Organization** | 2.1 - 2.9 | Project structure, naming, build configuration, app ID format | [rules/setup-rules.md](rules/setup-rules.md) |
| **UI & User Experience** | 2.10 - 2.18 | Interface standards, design patterns, user interaction | [rules/ui-ux-rules.md](rules/ui-ux-rules.md) |
| **Advanced Features** | 2.19 - 2.30 | Logging, error handling, debug tools, null safety | [rules/advanced-rules.md](rules/advanced-rules.md) |
| **Code Quality & Review** | 3.0 - 4.0 | Development checklist, detection commands | [rules/quality-rules.md](rules/quality-rules.md) |

### 🛠️ Implementation Resources

**📂 See:** [Implementation Guides](implementation/) - Comprehensive implementation details and patterns
**📂 See:** [Standards Collection](implementation/standards/) - Complete Java implementations and UI layouts
**📂 See:** [Build Validation](implementation/build-validation-procedures.md) - Build troubleshooting and prevention

### 🔗 Cross-References Between Categories

- **Setup** ↔ **Quality**: Project structure affects review commands
- **UI/UX** ↔ **Advanced**: Theme system connects to logging configuration  
- **Advanced** ↔ **Quality**: Error handling verification in development checklist
- **Build** ↔ **Quality**: Resource validation prevents compilation failures
- **All categories** ↔ **Quality**: Detection commands verify compliance across all rules

---

## 🚨 MANDATORY AI WORKFLOW

### When reviewing existing code:
```
1. Read rules/quality-rules.md first → Run ALL detection commands
2. Read rules/advanced-rules.md → Check CRITICAL rules (2.19, 2.25, 2.29) 
3. Check implementation/build-validation-procedures.md → Validate build health
4. Report ALL findings, including missed CRITICAL rules
```

### When build issues occur:
```
1. Read implementation/build-validation-procedures.md
2. Run diagnostic commands for specific error type
3. Apply appropriate solution procedures
4. Document resolution in review changes folder
```

### When implementing new features:
```
User: "implement MainProfile" → Read rules/ui-ux-rules.md (Rules 2.14-2.15)
User: "setup new project" → Read rules/setup-rules.md (Rules 2.1-2.8)  
User: "add logging system" → Read rules/advanced-rules.md (Rule 2.18)
```

### Task Type Navigation Guide

| Task Type | Which Section to Read | Purpose |
|-----------|----------------------|---------|
| **Review/Check existing code** | 👉 **[Quality Rules](rules/quality-rules.md)** | Detection commands and verification |
| **Implement new feature/code** | 👉 **Category-specific rules** | Implementation patterns and examples |
| **Understanding workflow** | 👉 **[AI Guidelines](../AI_GUIDELINES.md)** | Process and workflow instructions |

**Examples:**
```
User: "review app"              → AI: Read rules/quality-rules.md → Run detection commands → Report issues
User: "implement MainProfile"   → AI: Read rules/ui-ux-rules.md → Reference implementation/ → Use standards/ code
User: "tạo dialog confirm"      → AI: Read rules/ui-ux-rules.md (Rule 2.11) → implementation guide → standards code
User: "migrate AlertDialog"     → AI: Read implementation/common-dialog-framework.md → procedures/commondialog-migration.md → cleanup steps
User: "check hardcoded strings" → AI: Read rules/quality-rules.md → Run PowerShell command
```

**Why this matters:**
- ✅ **Faster reviews** - Quality rules are concise, focused on detection
- ✅ **Better implementation** - Proper separation: concepts → guides → code
- ✅ **No code mixing** - Clear boundary between guides and implementations
- ✅ **Correct workflow** - Review = verify, Implement = concepts + code

---

## 📋 Quick Rule Reference

### Setup & Organization (2.1-2.9)
- **2.1** App Profile - Developer info in build.gradle
- **2.2** Application ID Format - Standard `linm.soft.[appname]` format  
- **2.3** Project Structure - Standard Android structure
- **2.4** Gradle Configuration - Version management
- **2.5** Naming Conventions - File and resource naming
- **2.6** Build Setup - BUILD_TIME configuration
- **2.7** Java Code Organization - Class structure patterns
- **2.8** Resources Organization - Colors, dimensions, styles
- **2.9** File Splitting Rules - When and how to split files
- **2.5** Naming Conventions - Snake_case consistency
- **2.6** Version Management - Automated version handling  
- **2.7** Multi-language Support ⚠️ REQUIRED
- **2.8** Resource Organization - String/color management

### UI & User Experience (2.9-2.17)
- **2.9** Hex Colors Management - Color resource organization
- **2.10** Material Design 3 ⚠️ REQUIRED - Modern design system
- **2.11** Dialog Standards ⚠️ REQUIRED - Custom dialog layouts
- **2.12** Permissions ⚠️ REQUIRED - Proper permission handling
- **2.13** FAB Positioning ⚠️ OPTIONAL - Floating action button rules
- **2.14** Theme & Settings ⚠️ REQUIRED - Light/dark mode support
- **2.15** MainProfile ⚠️ REQUIRED - User profile fragment
- **2.16** Common Dialog Framework ⚠️ REQUIRED - 7 types, auto icons/theming
- **2.17** Android Icon Standards ⚠️ REQUIRED - Standardized icon library

### Advanced Features (2.18-2.29)
- **2.18** Logging System ⚠️ OPTIONAL - Single toggle controls all logs
- **2.19** Error Handling & Null Safety ⚠️ CRITICAL - Crash prevention, null checks
- **2.20** Menu Standards ⚠️ OPTIONAL - Navigation patterns
- **2.21** Dialog Implementation ⚠️ CRITICAL - Custom dialog rules
- **2.22** Spacing Standards ⚠️ CRITICAL - 4dp system, RTL support
- **2.23** Border Standards ⚠️ CRITICAL - Corner radius consistency  
- **2.24** Style Architecture ⚠️ CRITICAL - Style hierarchy patterns
- **2.25** Database Migration ⚠️ CRITICAL - Database versioning  
- **2.26** Documentation ⚠️ REQUIRED - Project documentation
- **2.27** Debug Tools ⚠️ OPTIONAL - Development activity standards
- **2.28** Database Management ⚠️ REQUIRED - Export/Import with user confirmation
- **2.29** Null Safety Standards ⚠️ CRITICAL - Mandatory null checks, auto-recovery patterns

### Code Quality & Review (3.0-4.0)
- **3.0** Code Review ⚠️ REQUIRED - Detection commands for compliance
- **4.0** AI Development Checklist - Quick verification tasks

---

## 🛠️ Adding New Rules - Template

**ANDROID_PROJECT_RULES.md Quick Reference Format:**
```markdown
- **X.XX** Rule Name ⚠️ PRIORITY - Brief 1-line description
```

**rules/[category]-rules.md Format:**
```markdown
## X.XX Rule Name ⚠️ PRIORITY

Brief 2-3 line description with key points.

**📂 See:** [`implementation/rule-name-implementation.md`](../implementation/rule-name-implementation.md)
```

**⚠️ CRITICAL:** Never put Java code in rules/ files - always reference implementation/ and standards/

---

## 🔍 Critical Updates (Dec 2025)

**Logging System:** Single toggle behavior, crash logs always enabled, view integration
**Null Safety Standards (Rule 2.29):** Mandatory null checks, auto-recovery patterns, prevention focus

---

## 📖 Important Note for Users

> **💡 Best Practice:** Trước khi yêu cầu review, hãy mở file review trước để xem AI đang làm gì:
> 
> **Các file cần mở:**
> - `docs/review/review-baseline.md` - Xem rules nào đã PASS ổn định
> - `docs/review/changes/review-YYYY-MM-DD.md` - Xem review session gần nhất
> - `.ai-progress/{app_id}_progress.md` - Xem progress tracking (nếu có)
> 
> **Lợi ích:**
> - ✅ Thấy được AI đang follow process hay không
> - ✅ Thấy được TODO tasks và progress
> - ✅ Thấy được comparison tables (Previous vs Current)
> - ✅ Thấy được issues đã fix và chưa fix
> - ✅ Có thể scroll theo realtime khi AI đang update

### 📋 Logging System Usage for All Projects

**🔍 Key Features (Updated Dec 2025):**
- **Single Toggle:** Controls ALL logs (debug, info, warning, error) except crashes
- **Crash logs:** Always enabled - never affected by toggle 
- **View Integration:** No config needed - views auto-respect global toggle
- **Cross-Project:** Same implementation pattern for all Android apps

**🎯 Usage Examples:**
```
User: "add logging to new app"  ➜ AI applies Rule 2.18 with single toggle behavior
User: "disable all logs"       ➜ User toggles OFF in LogViewer (crash logs still work)
User: "why still logging?"     ➜ Check if using crash() method (always enabled)
```

**📁 Files to Copy to New Projects:**
- `LogHelper.java` - Core logging with single toggle
- `DebugSettings.java` - Toggle control interface  
- `LogViewerActivity.java` - In-app log viewer
- `ExceptionHandler.java` - Crash handling integration

**⚡ No Additional Setup Required:**
- Views automatically follow global toggle
- No per-component configuration needed
- Works consistently across all app components

---

### 2.24 XML Layout Namespace Declarations ⚠️ CRITICAL

**Rule:** All XML namespace declarations MUST be at root element only.

**❌ NEVER declare namespaces in child elements:**
```xml
<ScrollView xmlns:android="...">
    <CardView 
        xmlns:app="http://schemas.android.com/apk/res-auto"  <!-- ❌ WRONG -->
        android:layout_width="match_parent">
```

**✅ CORRECT - All namespaces at root:**
```xml
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent">
    
    <CardView 
        android:layout_width="match_parent"
        app:cardElevation="8dp">  <!-- ✅ Can use app: prefix -->
```

**🎯 Detection Command:**
```powershell
grep -n "^\s*<[^>]*\n[^>]*xmlns:" app/src/main/res/layout/*.xml
```

**📋 Common Violations:**
- `CardView` with `xmlns:app` declaration
- `ConstraintLayout` with namespace in middle of file  
- Include tags with duplicate namespace declarations
- Fragment tags with their own namespace declarations

**🔧 Quick Fix Pattern:**
1. Move ALL `xmlns:*` to root element (line 2-3)
2. Remove duplicate namespace declarations from child elements
3. Verify `app:*`, `tools:*` attributes still work correctly

**⚠️ Why Critical:**
- Causes XML parsing errors in Android Studio
- Build failures with namespace conflicts
- IDE confusion with attribute suggestions
- Hard to debug - error messages unclear

---

### 2.25 Export Pattern Exclude Rules ⚠️ CRITICAL

**Rule:** Export exclude patterns must be specific to avoid excluding valid project files.

**❌ NEVER use overly broad patterns:**
```powershell
# These exclude valid files like main_profile_debug_section.xml
"*debug*"        # Excludes ANY file with "debug" in name
"*build*"        # Excludes BuildConfig.java, build_utils.xml
"*release*"      # Excludes release_notes.md, version_release.xml
"*.log*"         # Excludes dialog.xml, catalog.xml
```

**✅ CORRECT - Target specific folders/extensions:**
```powershell
# Only exclude build artifacts in specific folders
"*/debug/*"              # Debug build folders only
"*/debug\\*"            
"*/build/*"              # Build folders only  
"*/build\\*"
"*/generated/*"          # Generated folders only
"*/release/*"            # Release build folders only
"*.log"                  # Actual log files only
"*.logs"
```

**🎯 Detection Command:**
```powershell
# Check current exclude patterns
Select-String -Pattern '\"\*[^/\\]*\*\"' export-full-project.ps1
```

**📋 Pattern Guidelines:**
- Use `*/folder/*` for folder-specific exclusions
- Use `*.extension` for exact file extensions
- Avoid `*word*` patterns for common words
- Test patterns against actual project structure
- Document why each pattern is needed

**🔧 Common Valid Files to Protect:**
- `*debug_section.xml` - Layout components
- `*build_config.xml` - Configuration files  
- `*generated_values.xml` - Resource files
- `dialog*.xml` - Dialog layouts
- `*release_notes.md` - Documentation

---

### 2.26 App ID Migration Validation ⚠️ CRITICAL

**Rule:** After App ID changes, validate ALL package references are updated.

**❌ Common missed references during migration:**
```xml
<!-- Layout files with custom views -->
<com.oldpackage.CustomView />  <!-- Often forgotten -->

<!-- AndroidManifest components -->  
<service android:name="com.oldpackage.Service" />
```

**✅ REQUIRED validation steps:**
```powershell
# 1. Check layout files for package references
grep -r "com\.[old-package]\." app/src/main/res/layout/

# 2. Check Java/Kotlin imports  
grep -r "import com\.[old-package]\." app/src/main/java/

# 3. Check AndroidManifest
grep -r "com\.[old-package]" app/src/main/AndroidManifest.xml

# 4. Clean build validation
./gradlew clean assembleDebug
```

**🎯 Detection Pattern:**
```powershell
# Find any remaining old package references
grep -r "com\.callblocker\." app/src/
```

**📋 Critical Files to Check:**
- Layout XML files with custom views
- Java/Kotlin import statements  
- AndroidManifest.xml service/receiver declarations
- Proguard rules (if any)
- String resources with class names

**⚠️ Why Critical:**
- Causes "class not found" runtime errors
- Custom views fail to inflate
- Build succeeds but app crashes
- Hard to debug - error appears at runtime

**🔧 Quick Fix Pattern:**
1. Clean build folder: `Remove-Item -Recurse -Force app\build`
2. Search and replace old package references
3. Validate with clean build: `.\gradlew clean assembleDebug`

---

*For detailed implementation guides, see individual rule category files above.*

*Last updated: December 18, 2025*