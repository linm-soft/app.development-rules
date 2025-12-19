# AI ASSISTANT DEVELOPMENT GUIDELINES

## 🎯 CORE MISSION
**MAINTAIN STRICT FILE ORGANIZATION & CONTENT SEPARATION**

## 📢 AI ANNOUNCEMENT PROTOCOL
**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**
```
AI assistance đang check "AI_GUIDELINES"...
```
**Purpose:** Let user know AI is reading guidelines for proper workflow execution.

## 📁 CENTRALIZED DOCUMENTATION STRUCTURE (December 17, 2025)

### 🎯 **Development Rules (This Location)**
- **Cross-platform guidelines** and development workflows
- **Build automation tools** and procedures
- **Migration guides** for package ID and project updates
- **Code standards** and quality assurance rules

### 📂 **Project Documentation (Each Project's DOCS/)**
Each project maintains centralized documentation:
- **`[project]/DOCS/`** - Complete project documentation
- **`[project]/DOCS/android/`** - Android platform docs
- **`[project]/DOCS/ios/`** - iOS platform docs
- **`[project]/DOCS/api/`** - API reference documentation

### 🔄 **Documentation Routing**
**For project-specific information:**
1. **Architecture & Design** → `[project]/DOCS/[platform]/architecture.md`
2. **Build Instructions** → `[project]/DOCS/[platform]/build-guide.md`
3. **Database Schema** → `[project]/DOCS/[platform]/database-schema.md`
4. **API Reference** → `[project]/DOCS/api/[platform]-api-reference.md`
5. **Project Status** → `[project]/DOCS/project-summary.md`

## 📋 DOCUMENTATION REVIEW & MIGRATION PROTOCOL

### 🔍 **Universal Structure Validation**
**⚠️ MANDATORY: AI must validate ALL documentation follows universal pattern**

#### **Required Documentation Structure Check**
```yaml
Project Documentation Validation:
  Required Files:
    - "[project]/DOCS/README.md" # Documentation index
    - "[project]/DOCS/project-summary.md" # Project overview
    - "[project]/DOCS/version-tracking.md" # Version management
    - "[project]/DOCS/feature-tracking.md" # Feature matrix
    - "[project]/DOCS/android/architecture.md" # Android architecture
    - "[project]/DOCS/android/build-guide.md" # Android build guide
    - "[project]/DOCS/android/database-schema.md" # Android database
    - "[project]/DOCS/android/setup-guide.md" # Android setup
    - "[project]/DOCS/android/monetization-system.md" # Android monetization
    - "[project]/DOCS/ios/architecture.md" # iOS architecture
    - "[project]/DOCS/ios/build-guide.md" # iOS build guide
    - "[project]/DOCS/ios/database-schema.md" # iOS database
    - "[project]/DOCS/ios/setup-guide.md" # iOS setup
    - "[project]/DOCS/ios/monetization-system.md" # iOS monetization
    - "[project]/DOCS/api/README.md" # API index
    - "[project]/DOCS/api/android-api-reference.md" # Android APIs
    - "[project]/DOCS/api/ios-api-reference.md" # iOS APIs
```

### 🚀 **Documentation Migration Support**
**When AI encounters non-standard documentation structure:**

#### **Step 1: Structure Assessment**
```bash
# AI should announce:
"🔍 Analyzing documentation structure..."
"📋 Checking compliance with universal standards..."
```

#### **Step 2: Migration Plan Generation**
```yaml
Migration Assessment:
  Missing Files: [list missing required files]
  Misplaced Content: [identify content in wrong locations]
  Outdated References: [find broken or outdated links]
  Structure Violations: [document structure issues]
```

#### **Step 3: Auto-Migration Execution**
**AI should automatically:**
1. **Create missing directories** (`DOCS/`, `android/`, `ios/`, `api/`)
2. **Generate missing files** using universal templates
3. **Move misplaced content** to correct locations
4. **Update all cross-references** to new structure
5. **Validate final structure** against universal pattern

### 📊 **Migration Validation Checklist**
```yaml
Post-Migration Validation:
  Directory Structure: ✅ # [project]/DOCS/[platform]/
  Required Files: ✅ # All 17 required files present
  Cross-References: ✅ # All internal links working
  Content Organization: ✅ # Content in correct files
  Naming Convention: ✅ # lowercase-with-hyphens
  Version Information: ✅ # Current version tracking
  API Documentation: ✅ # Complete API reference
```

## 🚀 CROSS-PLATFORM FEATURE IMPLEMENTATION PROTOCOL

### 🎯 **Feature Implementation Tracking**
**⚠️ MANDATORY: When implementing ANY new feature, AI must track both platforms**

#### **Step 1: Feature Planning & Tracking Initialization**
```yaml
Feature Implementation Plan:
  Feature Name: "[feature-name]"
  Implementation Date: "[date]"
  Target Platforms:
    - Android: ✅ Required
    - iOS: ✅ Required
  
  Progress Tracking:
    Planning Phase: [ ] Not Started / [⏳] In Progress / [✅] Complete
    Android Implementation: [ ] Not Started / [⏳] In Progress / [✅] Complete
    iOS Implementation: [ ] Not Started / [⏳] In Progress / [✅] Complete
    Cross-Platform Testing: [ ] Not Started / [⏳] In Progress / [✅] Complete
    Documentation Updates: [ ] Not Started / [⏳] In Progress / [✅] Complete
    
  Session Management:
    Session ID: "[unique-session-id]"
    Start Time: "[timestamp]"
    Last Checkpoint: "[checkpoint-name]"
    Resume Point: "[resume-instructions]"
```

#### **Step 2: Cross-Platform Parity Requirements**
```yaml
Platform Parity Checklist:
  Core Functionality:
    ✅ Android: [feature works as expected]
    ✅ iOS: [feature works as expected]
    ✅ Behavior Consistency: [same user experience]
  
  UI/UX Elements:
    ✅ Android: [Material Design 3 compliance]
    ✅ iOS: [SwiftUI/HIG compliance]
    ✅ Visual Consistency: [platform-appropriate but consistent]
  
  Data Layer:
    ✅ Android: [SQLite implementation]
    ✅ iOS: [Core Data implementation]
    ✅ Data Compatibility: [same data structure]
  
  API Integration:
    ✅ Android: [Java API implementation]
    ✅ iOS: [Swift API implementation]
    ✅ API Parity: [same functionality exposed]
```

### ⚡ **Session Management & Resume Capability**

#### **Checkpoint System**
**AI must create checkpoints at these stages:**

```yaml
Implementation Checkpoints:
  checkpoint_001_planning_complete:
    description: "Feature planning and architecture defined"
    android_status: "[status]"
    ios_status: "[status]"
    next_steps: "[specific next actions]"
    resume_point: "Begin Android implementation"
  
  checkpoint_002_android_core_complete:
    description: "Android core functionality implemented"
    android_status: "✅ Core Complete"
    ios_status: "[pending/in-progress]"
    next_steps: "[iOS core implementation]"
    resume_point: "Begin iOS implementation"
  
  checkpoint_003_ios_core_complete:
    description: "iOS core functionality implemented"
    android_status: "✅ Complete"
    ios_status: "✅ Core Complete"
    next_steps: "[UI implementation]"
    resume_point: "Begin cross-platform UI consistency"
  
  checkpoint_004_ui_complete:
    description: "UI implementation completed both platforms"
    android_status: "✅ Complete"
    ios_status: "✅ Complete"
    next_steps: "[testing and validation]"
    resume_point: "Begin cross-platform testing"
  
  checkpoint_005_implementation_complete:
    description: "Full implementation and testing complete"
    android_status: "✅ Complete & Tested"
    ios_status: "✅ Complete & Tested"
    next_steps: "[documentation updates]"
    resume_point: "Update documentation"
```

#### **Timeout & Rate Limit Recovery Protocol**

**When session is interrupted:**

```yaml
Resume Protocol:
  1. Session Recovery:
    - Read last checkpoint from feature tracking
    - Identify current implementation state
    - Determine exact resume point
    - Validate previous work completeness
  
  2. State Verification:
    - Check Android implementation status
    - Check iOS implementation status  
    - Verify cross-platform consistency
    - Identify any incomplete work
  
  3. Resume Execution:
    - Continue from exact checkpoint
    - Maintain cross-platform parity
    - Update progress tracking
    - Create new checkpoints as needed
  
  Resume Command Format:
    "Resume feature implementation: [feature-name]"
    "Last checkpoint: [checkpoint-name]" 
    "Session ID: [session-id]"
```

### 🔄 **Feature Implementation Workflow**

#### **Phase 1: Cross-Platform Planning**
```yaml
Planning Requirements:
  Feature Specification:
    ✅ Core functionality defined
    ✅ Platform-specific adaptations identified
    ✅ Data model requirements specified
    ✅ UI/UX requirements documented
  
  Technical Architecture:
    ✅ Android implementation approach
    ✅ iOS implementation approach
    ✅ Shared data structures
    ✅ API design considerations
  
  Implementation Strategy:
    ✅ Development order (Android first/iOS first/parallel)
    ✅ Testing approach
    ✅ Integration points identified
    ✅ Documentation requirements
```

#### **Phase 2: Parallel Development Tracking**
```yaml
Development Status Matrix:
  Component | Android Status | iOS Status | Notes
  ------------------------------------------------------------------------------------------------
  Data Model     | [✅/⏳/❌]    | [✅/⏳/❌]  | [implementation notes]
  Core Logic     | [✅/⏳/❌]    | [✅/⏳/❌]  | [implementation notes]
  UI Components  | [✅/⏳/❌]    | [✅/⏳/❌]  | [implementation notes]
  API Integration| [✅/⏳/❌]    | [✅/⏳/❌]  | [implementation notes]
  Testing        | [✅/⏳/❌]    | [✅/⏳/❌]  | [implementation notes]
  Documentation  | [✅/⏳/❌]    | [✅/⏳/❌]  | [implementation notes]
```

#### **Phase 3: Quality Assurance & Validation**
```yaml
Cross-Platform Validation:
  Functional Testing:
    ✅ Android feature works correctly
    ✅ iOS feature works correctly
    ✅ Same functionality on both platforms
    ✅ Edge cases handled consistently
  
  Integration Testing:
    ✅ Data synchronization working
    ✅ API responses consistent
    ✅ Error handling uniform
    ✅ Performance acceptable on both platforms
  
  User Experience Validation:
    ✅ Platform-appropriate UI patterns
    ✅ Consistent user workflows
    ✅ Accessibility standards met
    ✅ Performance meets expectations
```

### 📝 **Progress Documentation Requirements**

#### **Feature Implementation Log**
```yaml
Implementation Log Entry:
  timestamp: "[ISO timestamp]"
  feature: "[feature name]"
  platform: "Android/iOS/Both"
  action: "[what was implemented]"
  status: "Started/In Progress/Complete/Blocked"
  next_steps: "[specific next actions]"
  challenges: "[any issues encountered]"
  notes: "[additional context]"
```

#### **Session Recovery Information**
```yaml
Session Recovery Data:
  session_metadata:
    session_id: "[unique identifier]"
    feature_name: "[feature being implemented]"
    start_time: "[session start]"
    last_activity: "[last action timestamp]"
  
  current_state:
    active_platform: "Android/iOS/Both"
    current_phase: "[planning/implementation/testing/documentation]"
    current_checkpoint: "[checkpoint identifier]"
    files_modified: "[list of modified files]"
  
  resume_instructions:
    next_action: "[specific next step]"
    context_needed: "[any context to restore]"
    verification_steps: "[validate current state]"
    continuation_plan: "[remaining implementation steps]"
```

## ⚠️ CRITICAL REQUIREMENTS

### 📝 Section Numbering Rules
- **NEVER create duplicate section numbers** (e.g., two 2.13 sections)
- **ALWAYS check existing numbering** before adding new sections
- **Sequential order required:** 2.1 → 2.2 → ... → 2.20 → 3 → 4
- **When adding new section:** Insert in proper numerical position and renumber subsequent sections

### 🏗️ Structure Requirements
- **Each section:** Must follow Quick Reference format
- **Links required:** All sections must link to implementation files
- **Consistency:** Use same format across all sections (see existing examples)
- **Emojis required:** ⚠️ for critical sections, 📂 for all "See:" links

### 🎯 Section Priority Classification
- **⚠️ CRITICAL:** Core functionality that ALL apps must have (Error Handling, Dialog Standards, Spacing)
- **⚠️ REQUIRED:** Standard features most apps should have (Multi-language, Theme, MainProfile)
- **⚠️ OPTIONAL:** App-specific features (Bottom Navigation, FAB, Logging) - use only if app needs them
- **No emoji:** Basic setup rules that always apply (Project Structure, Naming, etc.)

### 📱 iOS Development Standards ⚠️ CRITICAL

#### **SwiftUI Preview Safety**
- **⚠️ MANDATORY**: Use @EnvironmentObject instead of @StateObject for shared services
- **⚠️ MANDATORY**: Create .forPreview() factory methods for all ObservableObject services  
- **⚠️ MANDATORY**: Use in-memory Core Data contexts in previews
- **⚠️ MANDATORY**: Guard system API calls with preview mode detection

```swift
// ✅ COMPLIANT: Preview-safe service pattern
class CallBlockManager: ObservableObject {
    private var isPreviewMode: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static func forPreview() -> CallBlockManager {
        let manager = CallBlockManager()
        manager.extensionEnabled = true
        return manager
    }
}

// ✅ COMPLIANT: Safe preview implementation
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController(inMemory: true).container.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(CallBlockManager.forPreview())
    }
}
```

#### **Core Data Model Requirements**
- **⚠️ MANDATORY**: Include .xccurrentversion file in .xcdatamodeld bundles
- **⚠️ MANDATORY**: Implement bundle verification and error recovery
- **⚠️ MANDATORY**: Provide programmatic model fallback
- **⚠️ MANDATORY**: Use detailed error logging for debugging

```swift
// ✅ COMPLIANT: Robust Core Data initialization
guard let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd") else {
    print("ERROR: DataModel.momd not found in bundle")
    container = self.createContainerWithProgrammaticModel()
    return
}

container.loadPersistentStores { storeDescription, error in
    if let error = error as NSError? {
        print("Core Data Error: \(error.localizedDescription)")
        if !inMemory {
            self.attemptStoreRecovery()
        }
    }
}
```

**📂 Complete Guide:** [iOS SwiftUI Development Checklist](checklists/ios/ios-swiftui-development-checklist.md)  
**📂 Troubleshooting:** [iOS Common Issues Checklist](checklists/ios/ios-common-issues-checklist.md)

---

## 📋 MODULAR GUIDELINES STRUCTURE

This document serves as the central navigation hub for all AI assistant guidelines and standards.

### 📋 Core Guideline Modules

#### 🗂️ File Organization Standards
**📂 Complete Guide:** [File Organization Guidelines](guides/file-organization-guidelines.md)
- File hierarchy rules (platform-rules/android-project-rules → rules/ → implementation/ → standards/)
- Content separation enforcement (NO Java code in implementation/)
- Link patterns and navigation structure
- Violation detection and prevention

#### ✅ Validation & Compliance
**📂 Complete Guide:** [Validation Procedures](guides/validation-procedures.md)  
- Structure validation checklists
- Violation detection and reporting
- Review procedures and compliance scoring
- Performance metrics and optimization targets

#### 🎨 UI Resource Management  
**📂 Complete Guide:** [UI Resource Workflow](guides/ui-resource-workflow.md)
- Resource creation and naming standards
- Material Design 3 integration
- Theme management and accessibility
- Resource monitoring and maintenance

#### 🤖 AI Assistant Behavior
**📂 Complete Guide:** [AI Assistant Guidelines](guides/ai-assistant-guidelines.md)
- Core principles and response patterns
- Workflow enforcement standards
- User interaction protocols
- Quality assurance requirements

## 🚨 ZERO TOLERANCE POLICIES

### 🔴 CRITICAL VIOLATIONS (AUTO-REJECT)
1. **Java code in implementation/*.md files** - NO EXCEPTIONS
2. **Missing standards references** in implementation files  
3. **Broken navigation links** between hierarchy levels
4. **Duplicate content** across multiple files
5. **Inconsistent file naming** conventions

## 🔄 MANDATORY WORKFLOW PATTERNS

### Rule Creation Process
1. **Create quick reference** in appropriate rules/*.md file (NO Java code)
2. **Create implementation guide** in implementation/ with concepts only
3. **Create complete standards file** in implementation/android/ with ALL code
4. **Validate separation**: Implementation = concepts, Standards = code
5. **Update navigation links** across all affected files

### Content Placement Rules
- **rules/*.md**: Quick reference with links (max 3-4 lines per section)
- **implementation/*.md**: High-level concepts and workflows (NO Java code)
- **implementation/android/*.md**: Complete Java implementations (ALL code)
- **guides/*.md**: Detailed processes and comprehensive guidelines

## 🔍 AUTO-DETECTION RULES

```javascript
// Critical violation detection
IF (file_path.includes("implementation/") && content.includes("```java")) {
  ERROR: "Java code detected in implementation file!"
  ACTION: "Move all Java code to standards/ file"
  FIX: "Replace with reference to standards file"
}

IF (creating_new_rule && has_java_implementation) {
  WORKFLOW: "Create empty implementation guide → Create standards file → Add references"
  NEVER: "Put Java code directly in implementation file"
}
```

## 📋 QUICK VALIDATION CHECKLIST

Before any file creation or modification:
- [ ] **Java Code Location**: All code in standards/ files only?
- [ ] **Implementation Purity**: implementation/*.md contains NO code blocks?
- [ ] **Standards References**: All implementation files reference standards counterparts?
- [ ] **Navigation Links**: Proper hierarchy navigation maintained?
- [ ] **Content Separation**: Clear distinction between concepts vs implementations?

## 🎯 AI RESPONSE STANDARDS

### Primary Objectives
1. **ENFORCE** file organization hierarchy strictly
2. **PREVENT** Java code placement violations
3. **VALIDATE** proper link structure automatically  
4. **MAINTAIN** content separation standards
5. **GUIDE** compliant workflow practices

### Immediate Actions Required
- **When Java code found in implementation/**: Move to standards/, replace with reference
- **When creating new rules**: Follow mandatory 3-file structure (rules → implementation → standards)
- **When links are broken**: Fix navigation and validate all related files
- **When content duplicated**: Consolidate and establish single source of truth

## 🚨 MANDATORY STANDARDS FOR ALL ANDROID APPS

### Rule 2.29 - Null Safety Standards ⚠️ CRITICAL
**Apply AUTOMATICALLY when implementing ANY Android features:**

**🔴 MANDATORY Patterns:**
```java
// External dependencies (ExoPlayer, Database, Context)
if (component == null) {
    LogHelper.e(TAG, "Component null, reinitializing...");
    initializeComponent();
    if (component == null) {
        handleGracefulFailure();
        return;
    }
}
```

---

## 🔄 AI CONTEXT INDEPENDENCE

⚠️ **CRITICAL: AI MUST be stateless and history-independent**

Khi user trigger review workflow, AI PHẢI:

**✅ DO (Luôn làm):**
- Generate ONE timestamp at session start: `$timestamp = Get-Date -Format 'yyyy-MM-dd-HHmm'`
- REUSE same timestamp for ALL files in that session (prevent duplicates)
- Read review files (`docs/review/`) - Đây là source of truth
- Read progress files (`.ai-progress/`) - Current state tracking
- Read project files directly - Check actual code state
- Trust documentation over chat history
- Generate fresh TODO list based on current files

**❌ DON'T (Không làm):**
- Rely on chat history to know what was done before
- Assume issues still exist based on previous chat
- Skip reading review files because "I remember"
- Use cached knowledge from earlier in conversation
- Assume progress based on what user said earlier
- Generate multiple timestamps in same session (causes duplicate files)
- Guess or hardcode timestamps (e.g., "1000") - ALWAYS use `Get-Date` command
- Use incorrect file prefixes (Must use `issue-` not `issues-`)

**Why this matters:**
1. ✅ **Portable sessions** - User có thể copy project, mở chat mới, vẫn work
2. ✅ **Team collaboration** - Developer A làm xong, Developer B continue
3. ✅ **History independence** - Không cần scroll chat cũ để hiểu context
4. ✅ **Fresh start** - Mỗi review session là independent, không bị bias
5. ✅ **File-based truth** - Files are source of truth, not conversation

## 🔧 TERMINAL COMMAND GUIDELINES

**When using `run_in_terminal` tool:**
1. **Keep `explanation` parameter CONCISE (1-2 words max)**
   - ✅ GOOD: "Check strings", "Build verification"
   - ❌ BAD: "Checking for hardcoded strings in layout files using PowerShell..."

## 🤝 USER CONFIRMATION FOR OPTIONAL RULES

**⚠️ MANDATORY: Ask user before applying ANY optional rule**

**Process for Optional Rules:**
1. **Detect optional rule needed** (Bottom Navigation, FAB, Logging, etc.)
2. **STOP and ask user:** "This app uses [feature]. Apply [Rule Name] standards? (y/n)"
3. **Wait for confirmation** before proceeding
4. **Skip if user says no** - don't mark as compliance issue

**Example Confirmation Messages:**
```
"Detected Bottom Navigation in activity_main.xml. Apply Bottom Navigation Standards (section 2.18)? (y/n)"

"Found FloatingActionButton in layout. Apply FAB Button Positioning rules (section 2.13)? (y/n)"

"No logging system detected. Add Logging & Debugging setup (section 2.16)? (y/n)"
```

**User Response Handling:**
- **If YES:** Apply the optional rule and include in compliance check
- **If NO:** Skip rule entirely, don't mark as non-compliant
- **Document choice:** Note in review that user chose to skip optional rule

## 🤖 AI SESSION MANAGEMENT

**⚠️ CRITICAL: Read ai-progress guidelines for all AI implementation work**

**📂 Guidelines:** [`.ai-progress/ai-progress-tracking-quick.md`](./.ai-progress/ai-progress-tracking-quick.md) (ESSENTIAL)
**📚 Modular Reference:** [`.ai-progress/`](./.ai-progress/) - workflows/, commands/, templates/

**Project Structure:**
```
development-rules/.ai-progress/         # 📋 TEMPLATES & HOW-TO
current-project/.ai-progress/          # 🎯 ACTUAL TRACKING FILES
current-project/.ai-completed/         # 🏛️ COMPLETED FEATURES (shared)
```

**Before Starting Work:**
1. **Read guidelines:** `.ai-progress/ai-progress-tracking-quick.md` for essential workflow
2. **⚠️ Long chat history:** Use new chat protocol if >50 messages
3. **Check project context:** Confirm which app you're working on
4. **Review completed features:** Check `.ai-completed/` folder for historical context
5. **Look for existing:** `{project}/.ai-progress/` files for session continuity
6. **⚠️ Model Change Protocol:** If resuming/switching AI models, review progress files first

**During Implementation:**
- **Update progress:** Keep `.ai-progress/` files current
- **Save state regularly:** Prepare for potential rate limits
- **Document context:** File changes, current step, dependencies
- **Maintain consistency:** Follow established patterns from progress files

**Rate Limit Protocol:**
- **Immediate save:** Complete session state to `.ai-progress/{app}_context.md`
- **New session:** Read context file first, resume from exact checkpoint
- **Validate state:** Verify no external changes before continuing

## 📚 USAGE WORKFLOW

| Task Type | Which Section to Read | Purpose |
|-----------|----------------------|---------|
| **Review/Check existing code** | 👉 **[Quality Rules](rules/quality-rules.md)** | Quick verification points |
| **Implement new feature/code** | 👉 **Category-specific rules** | Concepts then standards/ |
| **Understanding workflow** | 👉 **[AI Guidelines](guides/ai-assistant-guidelines.md)** | Process and workflows |

## 📊 COMPLIANCE MONITORING

### Success Metrics
- **Zero violations** in file organization structure
- **100% compliance** with content separation rules
- **Working navigation** across all hierarchy levels
- **Complete standards coverage** for all implementations
- **Consistent enforcement** of naming conventions

### 📖 Important Note for Users

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
> 
> **Cách mở:**
> 1. Mở VS Code Explorer (Ctrl+Shift+E)
> 2. Navigate đến folder `docs/review/`
> 3. Mở file `review-baseline.md` và file mới nhất trong `changes/`
> 4. Split editor (Ctrl+\\) để xem cả 2 files cùng lúc
> 5. Khi AI update, VS Code sẽ auto-reload và bạn thấy changes realtime

---

**🔥 MISSION CRITICAL: Perfect file organization compliance. Zero tolerance for structural violations.**

*Last updated: December 13, 2025*