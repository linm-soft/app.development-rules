# Workflow Commands & User Interactions

> Chi tiết workflows, commands và patterns cho AI Assistant interactions

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "WORKFLOW_COMMANDS"...
```

**Purpose:** Let user know AI is referencing workflow command guidelines.

---

## 🎨 UI/Asset Resource Workflows

**📂 Platform-Specific UI/Asset workflow guidelines:**
- **Android**: [`platform-rules/android-project-rules.md`](./platform-rules/android-project-rules.md)
- **iOS**: [`platform-rules/ios-project-rules.md`](./platform-rules/ios-project-rules.md)

**📚 Universal Documentation Pattern:**
- **Android Architecture:** `[project]/DOCS/android/architecture.md`
- **iOS Architecture:** `[project]/DOCS/ios/architecture.md`
- **API Documentation:** `[project]/DOCS/api/README.md`
- **Cross-Platform:** `[project]/DOCS/cross-platform/README.md`

**Quick Reference for AI:**
- **Auto-detect platform**: Android (XML, drawable, Java/Kotlin) or iOS (xcassets, Swift, SwiftUI) or Both
- **Confirmation format**: Show resource list → Ask Yes/No/Custom
- **Cross-platform implementation**: Feature → Android implementation → iOS implementation → Documentation
- **Implementation**: Copy resources → Implement classes → Create examples → Document
- **Documentation**: Update project docs in centralized DOCS/ structure
- **Apply to any project**: Use universal patterns for all apps

---

## 💬 Recommended User Commands (for AI to recognize)

Khi user muốn trigger review workflow, recommend các commands sau:

| User Command | AI Response | TODO Created? |
|--------------|-------------|---------------|
| `review` (alone) | Show VS Code Quick Pick menu with all rules, let user select from dropdown | ❌ NO (just showing menu) |
| `review app` | Full compliance review | ✅ YES |
| `review all` | Full re-review with comparison | ✅ YES |
| `check compliance` | Check against all rules | ✅ YES |
| `review rule file` / `review this rule` / `review rule` | **ALWAYS ask first (never assume):** "Bạn muốn review file rules như thế nào? (structure/completeness/clarity/examples/formatting/consistency/etc.)" | ❌ NO (clarification only) |
| `add rule vào file` / `add rule` / `add this rule to file` | Check chat history for context, if unclear → ask user "Bạn muốn add rule hay phần gì vào?" | ⚠️ Depends on complexity |
| `add rule [number] [name] [priority]` | **MUST ask confirmation first:** Show preview + confirm priority | ✅ YES |
| `create standards [feature]` | Create standards file with UI + Java implementation | ✅ YES |
| `add complete rule [number] [name] [priority]` | **MUST ask confirmation first:** Show preview + confirm all components | ✅ YES |
| `create implementation [name]` | Create implementation guide referencing standards | ⚠️ If multi-step |
| `update structure [file]` | Update file to new standard template | ⚠️ If multi-step |
| `review [rule name]` | Review specific rule only | ⚠️ If multi-step |
| `fix [issue]` | Fix specific issue | ⚠️ If multi-step |
| `implement [feature]` | Implement new feature | ✅ YES |
| `check code quality` | Run quality checks | ✅ YES |

**Example user commands AI should recognize:**
- ✅ "review app theo project rules"
- ✅ "review android theo ANDROID_PROJECT_RULES"
- ✅ "review ios theo IOS_PROJECT_RULES" 
- ✅ "check compliance với rules"
- ✅ "review all và compare với baseline"
- ✅ "review hardcoded strings"
- ✅ "check xem có issue gì không"
- ✅ "implement MainProfile fragment" (Android)
- ✅ "implement ProfileView swift" (iOS)
- ✅ "add rule 2.26 data-validation CRITICAL"
- ✅ "create standards theme-management"
- ✅ "add complete rule 2.27 error-handling REQUIRED"
- ✅ "create implementation dialog-system referencing dialog-standards.md"
- ✅ "update structure menu-implementation to new standard"
- ✅ "implement cross-platform feature user-preferences"

**What AI should do when seeing these commands:**

| Command Pattern | AI Action | Behavior |
|-----------------|-----------|----------|
| `review app` / `check compliance` | Smart review | Skip baseline rules, check only pending/new rules |
| `review all` / `full review` / `re-review` | Full re-review | Check ALL rules, compare with previous, show improvements |
| `review [specific rule]` | Targeted review | Check only that specific rule |
| `fix [issue]` | Fix only | Fix specific issue, no full review |

---

## ⚠️ FIRST RESPONSE - AI MUST Announce Review Mode

Khi user trigger bất kỳ review command nào, AI PHẢI respond ngay:

```
📋 Tôi đang sử dụng file "[PROJECT_PLATFORM]_RULES.md" review với mode:
   • User Command: [command user vừa gõ]
   • AI Response: [loại response tương ứng từ bảng trên]
   • Platform: [Android/iOS/Cross-Platform]
   • Workflow: [Step 1 → Step N theo detailed actions]

Bắt đầu review...
```

**Ví dụ:**
```
User: "review android"

AI Response:
📋 Tôi đang sử dụng file "ANDROID_PROJECT_RULES.md" review với mode:
   • User Command: review android
   • AI Response: Android platform review
   • Platform: Android
   • Workflow: 8 steps (Create TODO → Read rules → Execute review → Fix → Build → Document)

User: "review ios"

AI Response:
📋 Tôi đang sử dụng file "IOS_PROJECT_RULES.md" review với mode:
   • User Command: review ios
   • AI Response: iOS platform review  
   • Platform: iOS
   • Workflow: 8 steps (Create TODO → Read rules → Execute review → Fix → Build → Document)

User: "implement cross-platform user-settings"

AI Response:
📋 Implementing cross-platform feature với mode:
   • User Command: implement cross-platform user-settings
   • AI Response: Cross-platform feature implementation
   • Platform: Both Android & iOS
   • Workflow: 12 steps (Plan → Android → iOS → Test → Document)

Bắt đầu implementation...
```

---

## 🔄 Detailed Workflow Actions

**⚠️ RULE ADDITION CONFIRMATION PROTOCOL FIRST**

### **For: `add rule [number] [name] [priority]` command**

**Step 0: Parse & Preview (REQUIRED)**
```
AI MUST respond:
📝 Preview Rule Addition:
   • Number: [number]
   • Name: [name] 
   • Priority: [priority] (CRITICAL/REQUIRED/OPTIONAL)
   • Category: [auto-detected category based on name]
   • Will be added to: rules/[category]-rules.md

📊 Priority Level Reference:
   • 🔴 CRITICAL: App không thể function without this (security, core features)
   • 🟡 REQUIRED: Important for good UX, should implement  
   • 🟢 OPTIONAL: Nice-to-have, implement if time allows

⚠️ Xác nhận thông tin:
1. Priority level đúng chưa? (Current: [priority])
2. Category placement đúng chưa? 
3. Confirm để tiếp tục add rule

[YES/NO/EDIT]
```

**Step 1: Wait for user confirmation**
- ✅ **YES** → Proceed with adding rule
- ❌ **NO** → Cancel operation  
- ✏️ **EDIT** → Let user modify priority/category before adding

**Step 2: After confirmation, proceed with standard rule addition workflow**

---

## 🔄 Detailed Workflow Actions

**1. For "review all" / "full review":**
```
Step 0: Announce review mode to user (see above)
Step 1: Create TODO list with full review tasks
Step 2: Read review-baseline.md (check ALL baseline rules again)
Step 3: Read latest changes/review-YYYY-MM-DD.md (get previous state)
Step 4: Execute FULL review (re-check even passed rules)
Step 5: Generate comparison table:
    | Rule | Previous | Current | Status | Change |
    |------|----------|---------|--------|--------|
    | Hardcoded Strings | ✅ PASS | ✅ PASS | ➡️ UNCHANGED | - |
    | MainProfile | ❌ FAIL | ✅ PASS | ✅ IMPROVED | Implemented |
Step 6: Show all findings (even if no changes)
Step 7: Ask user confirmation
Step 8: Fix confirmed issues
Step 9: Build verification
Step 10: Create review documentation with comparison
        ⚠️ FILE LOCATION RULES:
        ✅ ONLY create/update files in THE PROJECT BEING REVIEWED:
           - ../DOCS/{platform}/review/review-baseline.md
           - ../DOCS/{platform}/review/changes/review-YYYY-MM-DD.md
        ❌ NEVER create review files in:
           - development-rules/ (only contains ANDROID_PROJECT_RULES.md)
           - Other projects not being reviewed
           - Root workspace folder
```

**2. For "review app" / "check compliance":**
```
Step 0: Announce review mode to user (see above)
Step 1: Create TODO list
Step 2: 📋 Read CHECKLIST files (NOT implementation files):
        - checklists/code-review-detection.md
        - checklists/ai-development-checklist.md
Step 3: Run detection commands from checklist
Step 4: Read review-baseline.md (SKIP these rules if reviewing)
Step 5: Read latest changes/ file (check only pending/failed rules)
Step 6: Execute targeted review (skip passed rules)
Step 7: Show only new issues found
Step 8: Ask user confirmation
Step 9: Fix confirmed issues
Step 10: Build verification
Step 11: Update review documentation
        ⚠️ FILE LOCATION: Same as above - only in project being reviewed
```

**3. For "implement [feature]" / "create [component]":**
```
Step 0: Announce implementation mode
Step 1: Create TODO list
Step 2: 📚 Read IMPLEMENTATION files (NOT checklists):
        - implementation/[topic]-implementation.md (manages standards & examples)
        - Example: For dialog → read implementation/dialog-implementation.md
Step 3: Follow code patterns and examples
Step 4: Apply implementation
Step 5: Run detection commands (from checklist) to verify
Step 6: Build verification
Step 7: Document if needed
```

**⚠️ CRITICAL - Choose the right files:**

| Task Type | Read This | NOT This |
|-----------|-----------|----------|
| Review existing code | ✅ Checklists | ❌ Implementation |
| Check compliance | ✅ Checklists | ❌ Implementation |
| Run detection | ✅ Checklists | ❌ Implementation |
| Implement new feature | ✅ Implementation | ❌ Checklists (until verify) |
| Create new component | ✅ Implementation | ❌ Checklists (until verify) |
| Fix known issue | ✅ Relevant Implementation | ❌ All files |

**Why this matters:**
- Checklists: Fast, focused, detection-based (for review)
- Implementation: Detailed, examples, patterns (for coding)
- Reading wrong files = slower + confused AI

**4. For "review [specific rule]":**
```
Step 0: Announce review mode to user (see above)
Step 1: Create TODO if multi-step
Step 2: Check only that specific rule
Step 3: Show findings
Step 4: Ask confirmation → Fix → Build → Document
```

**⚠️ CRITICAL - After announcing mode (MUST DO IMMEDIATELY):**
1. ✅ **FIRST ACTION:** Create TODO list using `manage_todo_list` tool
2. ✅ Show TODO list to user (will appear in VS Code TODO panel)
3. ✅ Ask user to confirm before proceeding
4. ✅ Execute step by step, mark in-progress/completed as you work
5. ❌ **NEVER proceed without creating TODO first**

---

## 📋 Multi-step Work Management

⚠️ **CRITICAL: TODO Tasks are MANDATORY for review/fix workflows**

Khi làm việc với file rules này, AI PHẢI:

1. **⭐ Tạo TODO Tasks trước khi bắt đầu (REQUIRED):**
   - ✅ **ALWAYS use `manage_todo_list` tool FIRST** khi user request:
     - "review app" / "check compliance" / "review all"
     - "fix [issue]" / "implement [feature]"
     - Any multi-step work (2+ steps)
   - ❌ **NEVER skip TODO creation** - Nếu skip, user không track được progress
   - Mỗi todo phải rõ ràng, có thể verify được
   - Mark todo as `in-progress` khi đang làm, `completed` ngay khi xong
   - Giúp AI và user track progress, đặc biệt quan trọng khi có rate limit

**TODO Format Template:**
```json
{
  "operation": "write",
  "todoList": [
    {"id": 1, "title": "Read existing progress/review files", "status": "not-started"},
    {"id": 2, "title": "Execute detection commands", "status": "not-started"},
    {"id": 3, "title": "Show findings to user for confirmation", "status": "not-started"},
    {"id": 4, "title": "Apply fixes after user confirms", "status": "not-started"},
    {"id": 5, "title": "Run build verification", "status": "not-started"},
    {"id": 6, "title": "Update review documentation", "status": "not-started"}
  ]
}
```

**Example TODO for Review Request:**
```
User: "review app"

AI MUST:
Step 1: Create TODO list immediately:
  ├─ 1. Read review baseline and last change file
  ├─ 2. Run compliance detection commands
  ├─ 3. Show all issues to user (wait for confirmation)
  ├─ 4. Fix confirmed issues
  ├─ 5. Run build verification (must pass)
  └─ 6. Create/update review documentation

Step 2: Mark #1 as in-progress → Read files
Step 3: Mark #1 as completed → Update TODO
Step 4: Mark #2 as in-progress → Run detection
...
```

---

## 🎯 Progress Tracking Implementation

**Tạo Progress Tracking File:**
   - Tạo file `progress-tracking/{app_id}_progress.md` để track implementation
   - File này lưu:
     - App ID và tên project
     - Danh sách rules đã implement
     - Danh sách rules đã review
     - Next steps khi tiếp tục
   - Khi close/reopen session, AI có thể đọc file này để biết đã làm đến đâu

**Progress Tracking File Format:**
   ```markdown
   # Progress Tracking - {app_name}
   
   **App ID:** {app_id}
   **Project Path:** {project_path}
   **Last Updated:** {timestamp}
   **Session:** {session_description}
   
   ---
   
   ## Implementation Status
   
   ### ✅ Completed Rules
   - [x] Rule 1: App Profile - Developer info added
   - [x] Rule 5: Naming Conventions - All strings follow snake_case
   
   ### 🔄 In Progress
   - [ ] Rule 9: Multi-language Support - Adding Vietnamese translations
   
   ### ⏳ Pending
   - [ ] Rule 13: Theme & Settings - Need to implement Dark mode
   - [ ] Rule 14: MainProfile Fragment - Need to create
   
   ---
   
   ## Review Status - Latest Session
   
   ### 📊 Review Summary Table
   
   | # | Rule/Check | Status | Previous | Current | Action Taken |
   |---|------------|--------|----------|---------|--------------|
   | 1 | Hardcoded Strings (Layout) | ✅ PASS | ❌ 8 issues | ✅ 0 issues | Fixed all 8 strings |
   | 2 | Hardcoded Strings (Java) | ✅ PASS | ❌ 1 issue | ✅ 0 issues | Fixed setText() |
   | 3 | Multi-language Support | ✅ PASS | - | ✅ EN + VI | No change needed |
   | 4 | Theme Support | ✅ PASS | - | ✅ Light/Dark | No change needed |
   | 5 | MainProfile Fragment | ❌ FAIL | ❌ Missing | ❌ Missing | Not yet implemented |
   | 6 | Hex Colors in Layouts | ✅ PASS | - | ✅ Clean | No change needed |
   
   ### 🔧 Changes Made This Session
   
   | File | Type | Line | Before | After | Status |
   |------|------|------|--------|-------|--------|
   | `main_home.xml` | Layout | 30 | `android:text="Hello, User!"` | `android:text="@string/home_placeholder_hello"` | ✅ Fixed |
   | `main_home.xml` | Layout | 40 | `android:text="🔥 7 day streak"` | `android:text="@string/home_placeholder_streak"` | ✅ Fixed |
   | `PracticeHistoryAdapter.java` | Java | 84 | `setText("Practice Session")` | `setText(R.string.practice_session)` | ✅ Fixed |
   | `strings.xml` | Resource | - | - | Added 6 new strings | ✅ Added |
   | `strings.xml` (vi) | Resource | - | - | Added 6 translations | ✅ Added |
   
   ### ✅ Reviewed & Passed (No Changes Needed)
   
   | Check | Result | Details |
   |-------|--------|---------|
   | Multi-language | ✅ PASS | `values-vi/strings.xml` exists with full translations |
   | Theme Support | ✅ PASS | `values-night/` exists with themes.xml and colors.xml |
   | App Profile | ✅ PASS | BUILD_TIME field present in build.gradle |
   | Version Info | ✅ PASS | versionCode 1, versionName "1.0.0" |
   | Color Resources | ✅ PASS | All hex colors in color definition files (allowed) |
   | Dark Color Anti-pattern | ✅ PASS | No `*_dark` references in layouts |
   
   ### ⚠️ Critical Issues Still Pending
   
   | # | Issue | Rule | Impact | Next Action |
   |---|-------|------|--------|-------------|
   | 1 | MainProfile Fragment Missing | Rule 14 (REQUIRED) | 🔴 Critical | Need to implement using template |
   | 2 | Fragment Naming Pattern | Rule 5 (Naming) | 🟡 Medium | Consider renaming or document exception |
   
   ---
   
   ## Compliance Score
   
   **Overall: 85% Compliant** (up from 70%)
   
   | Category | Previous | Current | Change |
   |----------|----------|---------|--------|
   | Code Quality | ❌ 60% | ✅ 100% | +40% ↑ |
   | Multi-language | ✅ 100% | ✅ 100% | - |
   | Theme Support | ✅ 100% | ✅ 100% | - |
   | Required Screens | ❌ 0% | ❌ 0% | - (MainProfile still missing) |
   | Overall | 70% | 85% | +15% ↑ |
   
   ---
   
   ## Next Steps (Priority Order)
   
   ### 🔴 Critical - Must Fix
   1. **Create MainProfile Fragment**
      - Use template from Rule 14
      - Implement all required sections
      - Add to bottom navigation
   
   ### 🟡 Medium Priority
   2. **Review Fragment Naming Convention**
      - Current: HomeFragment, LearnFragment
      - Expected: MainHome, MainLearn
      - Action: Rename or document exception
   ```

---

## 📝 Key Commands for AI Progress

**Key Commands:**
```bash
"Initialize AI progress tracking for {app_name}"
"Update AI progress: completed {task}"
"Save AI session state for rate limit recovery" 
"Resume AI session from last checkpoint"
"Sync AI progress with project documentation"

# Feature-specific tracking
"Start feature tracking: {feature_name}"
"Update feature progress: {feature_name} - {status}"
"Complete feature implementation: {feature_name}"
"Sync feature to docs: {feature_name}" (with confirmation)
"Show completed features" (view archived features)

# Bug tracking during implementation
"Log bug in current feature: {bug_description}"
"Update bug status: {bug_id} - {status}"
"Mark bug fixed: {bug_id} - {fix_description}"

# Testing & validation
"Run feature testing validation: {feature_name}"
"Confirm testing results: {feature_name} - {status}" (passed/minor-issues/failed)

# Chat history management (new)
"Check if new chat session is recommended"
"Create complete project handoff summary"
"Initialize from project summary" (for new chat sessions)

# Model change/resume protocol
"Review project progress and current implementation plan"
"Show current feature implementation approach: {feature_name}"
"Validate continuation of: {feature_name}"
```

---

## 🔄 Workflow khi bắt đầu làm việc

```
Step 1: Check if progress file exists
    ├─ YES → Read progress file
    │        ├─ Kiểm tra "Review Status" section
    │        ├─ Nếu có "⚠️ Issues Found" → CHỈ review/fix những issues đó
    │        ├─ Nếu có "⏳ Pending" rules → Review những rules đó
    │        └─ KHÔNG cần review lại rules đã PASS (✅ Reviewed & Passed)
    │
    └─ NO  → Create new progress file
             ├─ Add .ai-progress/ to .gitignore
             └─ Start full review từ đầu

Step 2: Create issue tracking file (SILENT - ONE FILE ONLY)
    ├─ ⚠️ CRITICAL: cd to APP FOLDER (sibling of development-rules)
    │   └─ Example: `cd "..\[app-name]"`
    ├─ Generate timestamp ONCE at start of session:
    │   └─ $timestamp = Get-Date -Format 'yyyy-MM-dd-HHmm'
    │   └─ ⚠️ REUSE this $timestamp for ALL file operations in session
    ├─ Create timestamped file ONCE: `../DOCS/{platform}/review/issues/issue-YYYY-MM-DD-HHMM.md`
    │   └─ Command: ONE execution only with full content
    │   └─ $issueFile = "docs\review\issues\issue-$timestamp.md"
    │       # ⚠️ CRITICAL: Generate timestamp ONCE at session start
    │       # NEVER regenerate timestamp during same session
    │       if (Test-Path $issueFile) {
    │           Write-Host "⚠️ Issue file already exists: $issueFile"
    │           Write-Host "Using existing file for this session."
    │       } else {
    │           $content = @"
    │           # Issue Tracking - {app_name}
    │           **Session:** Review App Compliance
    │           **Created:** $(Get-Date -Format 'yyyy-MM-dd HH:mm')
    │           **Status:** In Progress
    │           ---
    │           ## Summary
    │           | Status | Count |
    │           |--------|-------|
    │           | Pending | 0 |
    │           | Fixing | 0 |
    │           | Fixed | 0 |
    │           ---
    │           ## Issues
    │           | # | Category | Severity | File | Line | Issue | Status | Fixed At |
    │           |---|----------|----------|------|------|-------|--------|----------|
    │           
    │           "@
    │           Set-Content -Path $issueFile -Value $content -Encoding UTF8
    │           Write-Host "Created: $issueFile"
    │       }
    ├─ ❌ NEVER call New-Item or Set-Content multiple times in same session
    ├─ ❌ NEVER regenerate timestamp during same session (causes duplicates)
    ├─ ✅ Save $timestamp and $issueFile path to variables for entire session
    ├─ ⚠️ Summary table will be updated in Step 3.5 after all issues appended
    └─ Show: "✅ Ready: issue-YYYY-MM-DD-HHMM.md" (1 line)

Step 3: Execute review/detection - APPEND each issue immediately
    ├─ ⚠️ CRITICAL: Must READ actual file content to get EXACT line text
    ├─ FOR EACH detection check (run one by one):
    │   ├─ Run detection command
    │   ├─ Save results to variable: $results
    │   ├─ FOR EACH issue found in $results:
    │   │   ├─ ⚠️ MUST use read_file tool to get EXACT line content:
    │   │   │   └─ Read file at detected line number
    │   │   │   └─ Get exact text (not truncated grep output)
    │   │   ├─ Parse: file path, line number, exact issue text
    │   │   ├─ Escape markdown special chars (|, `, etc.)
    │   │   ├─ Append new row to $issueFile immediately:
    │   │   │   └─ Add-Content -Path $issueFile -Value "| $num | $category | $severity | $file | $line | $issue | 🔴 Pending | |" -Encoding UTF8
    │   │   └─ ❌ NEVER skip reading file - grep output is truncated
    │   └─ Show progress: "Rule X/10 → Y issues appended"
    ├─ ❌ NEVER create new issue file during detection
    ├─ ✅ ALWAYS append to same $issueFile variable
    ├─ ✅ Result: Issue file has ALL issues with EXACT line content
    └─ Final: "Total: XXX issues"
    
    **Example Workflow for Hardcoded String Detection:**
    ```powershell
    # Step 3a: Run detection
    $results = Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
        Select-String 'android:text="[^@]' | 
        Select-Object Path, LineNumber, Line
    
    # Step 3b: For each result, READ exact content and append
    $issueNum = 1
    foreach ($result in $results) {
        # ⚠️ CRITICAL: Use read_file tool to get EXACT line
        # read_file(filePath=$result.Path, startLine=$result.LineNumber, endLine=$result.LineNumber)
        # This returns: android:text="Hello World"  (full text, not truncated)
        
        $file = Split-Path $result.Path -Leaf
        $line = $result.LineNumber
        $exactText = "android:text=\"Hello World\""  # From read_file output
        
        # Escape pipe characters for markdown table
        $escapedText = $exactText -replace '\|', '\|'
        
        # Append to issue file immediately
        $row = "| $issueNum | Hardcoded String | Medium | $file | $line | ``$escapedText`` | 🔴 Pending | |"
        Add-Content -Path $issueFile -Value $row -Encoding UTF8
        
        $issueNum++
    }
    ```
    
    **Why READ file is CRITICAL:**
    - ✅ Grep output is TRUNCATED: `android:text="Hello...`
    - ✅ Need EXACT text for fix step: `android:text="Hello World"`
    - ✅ Prevents AI from guessing during fix
    - ✅ Ensures accurate string resource creation
    - ⚠️ **FORMAT ISSUE FIX:** Must escape markdown special chars properly
    
    **CRITICAL: Proper markdown table formatting:**
    ```powershell
    # Fix formatting and escape issues
    $file = Split-Path $result.Path -Leaf
    $line = $result.LineNumber
    $exactText = "android:text=\"Hello World\""  # From read_file output
    
    # ⚠️ CRITICAL: Escape ALL markdown special characters
    $escapedText = $exactText -replace '\|', '\|'    # Escape pipes
    $escapedText = $escapedText -replace '`', '\`'   # Escape backticks  
    $escapedText = $escapedText -replace '\*', '\*'  # Escape asterisks
    $escapedText = $escapedText -replace '_', '\_'   # Escape underscores
    
    # ⚠️ TRUNCATE if too long (prevent table overflow)
    if ($escapedText.Length -gt 80) {
        $escapedText = $escapedText.Substring(0, 77) + "..."
    }
    
    # ⚠️ PROPER TABLE FORMATTING with consistent spacing
    $row = "| $issueNum | Hardcoded String | Medium | $file | $line | ``$escapedText`` | 🔴 Pending | |"
    Add-Content -Path $issueFile -Value $row -Encoding UTF8
    
    $issueNum++
    ```
    
    **ADDITIONAL FIX - Add validation:**
    ```powershell
    # Validate exact text was retrieved
    if ([string]::IsNullOrEmpty($exactText)) {
        Write-Host "⚠️ WARNING: Could not read exact text for $file:$line"
        $exactText = "[Could not read exact content]"
    }
    ```

Step 3.5: Finalize Issue Tracking File
    ├─ Update summary table with final counts
    ├─ Add review session metadata
    ├─ This file is the SINGLE SOURCE OF TRUTH for this session's fixes
    ├─ User can review in VS Code Preview (Ctrl+Shift+V)
    ├─ AI reads THIS FILE to fix (not re-search)
    └─ ⚠️ Issue file format example:
        ```markdown
        ## Issues
        | # | Category | Severity | File | Line | Issue | Status | Fixed At |
        |---|----------|----------|------|------|-------|--------|----------|
        | 1 | Hardcoded String | Medium | main_home.xml | 30 | `android:text="Hello"` | 🔴 Pending | |
        | 2 | Hardcoded String | Medium | main_home.xml | 45 | `android:hint="Enter name"` | 🔴 Pending | |
        ```
        
    **Updating Status During Fixes:**
    ```powershell
    # Update single row status to "Fixing"
    $content = Get-Content $issueFile -Raw
    $content = $content -replace '\| 1 \| (.*?) \| 🔴 Pending \| \|', '| 1 | $1 | 🔧 Fixing | |'
    Set-Content $issueFile -Value $content -NoNewline -Encoding UTF8
    
    # After fix success, update to "Fixed"
    $timestamp = Get-Date -Format "HH:mm"
    $content = Get-Content $issueFile -Raw
    $content = $content -replace '\| 1 \| (.*?) \| 🔧 Fixing \| \|', "| 1 | `$1 | ✅ Fixed | $timestamp |"
    Set-Content $issueFile -Value $content -NoNewline -Encoding UTF8
    ```
```

---

## 🎯 STANDARD RULES WORKFLOW

### **Standard Rule Creation Commands**

| Command Pattern | AI Action | Files Created |
|-----------------|-----------|---------------|
| `add rule [number] [name] [priority] [description]` | Add rule to appropriate category file | 1. rules/[category]-rules.md entry |
| `create standards [feature-name]` | Create standards file with UI + Java | 1. implementation/android/[feature]-standards.md |
| `add complete rule [number] [name] [priority]` | Complete rule creation workflow | 1. rules/ entry + 2. implementation/ guide + 3. android/ file |
| `create implementation [name] referencing [standards]` | Create implementation guide | 1. implementation/[name]-implementation.md |
| `update structure [file] to new standard` | Update file to new template | Updated file with proper structure |

### **Complete Rule Creation Workflow**

**For: `add complete rule [number] [name] [priority]`**

**Step 0: Extended Preview (REQUIRED)**
```
AI MUST respond:
📝 Preview Complete Rule Creation:
   • Number: [number]
   • Name: [name]
   • Priority: [priority]
   • Category: [auto-detected]
   
📁 Files will be created:
   1. rules/[category]-rules.md → Add quick reference entry
   2. implementation/[name]-implementation.md → Full implementation guide
   3. implementation/android/[name]-standards.md → UI + Java code standards

📊 Priority Level Reference:
   • 🔴 CRITICAL: App cannot function without this
   • 🟡 REQUIRED: Important for good UX
   • 🟢 OPTIONAL: Nice-to-have feature

⚠️ Xác nhận:
1. Priority level: [priority] - đúng chưa?
2. Tạo tất cả 3 files - OK?
3. Category: [category] - đúng chưa?

[YES/NO/EDIT]
```

**After confirmation:**
```
Step 1: Create TODO with all subtasks
Step 2: Determine correct category file (setup/ui-ux/advanced/quality)
Step 3: Add quick reference to rules/[category]-rules.md
Step 4: Create implementation/[name]-implementation.md with:
    - AI announcement protocol
    - Related standards references  
    - Java implementation reference to standards
    - Integration checklist
Step 5: Create implementation/android/[name]-standards.md with:
    - Complete UI layouts
    - Complete Java implementation
    - Navigation back to implementation
Step 6: Update navigation links in all affected files
Step 7: Update ANDROID_PROJECT_RULES.md numbering if needed
```

**Template Usage:**
- Use AI_GUIDELINES.md templates for structure
- Use ANDROID_PROJECT_RULES.md template examples  
- Follow file organization protocol (implementation → standards separation)
- Always include proper navigation links

**Example Commands:**
```
add complete rule 2.26 input-validation CRITICAL
→ Creates rules entry + implementation guide + standards with UI + Java

create standards bottom-sheet-dialog  
→ Creates implementation/android/bottom-sheet-dialog-standards.md with UI + Java

add rule 2.27 crash-reporting OPTIONAL "Crash reporting and analytics integration"
→ Adds entry to rules/advanced-rules.md only
```

---

*Last updated: December 2024*