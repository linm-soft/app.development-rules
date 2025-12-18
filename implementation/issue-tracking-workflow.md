# Issue Tracking Workflow

## Overview
This document contains detailed workflow for issue tracking and resolution during app compliance reviews.

## Core Workflow Steps

### Step 1: Check Progress File
```
├─ Check `.ai-progress/[app-name]-progress.md` exists?
│  ├─ YES → Read existing progress
│  │        ├─ Check "Review Status" section
│  │        ├─ If "⚠️ Issues Found" → ONLY review/fix those issues
│  │        ├─ If "⏳ Pending" rules → Review those rules
│  │        └─ NO need to review rules already PASS (✅ Reviewed & Passed)
│  └─ NO  → Create new progress file
│             ├─ Add .ai-progress/ to .gitignore
│             └─ Start full review from beginning
```

### Step 2: Create Issue Tracking File (SILENT - ONE FILE ONLY)
```
├─ ⚠️ CRITICAL: cd to APP FOLDER (sibling of development-rules)
│   └─ Example: `cd "..\[app-name]"`
├─ Generate timestamp ONCE at start of session:
│   └─ $timestamp = Get-Date -Format 'yyyy-MM-dd-HHmm'
│   └─ ⚠️ REUSE this $timestamp for ALL file operations in session
├─ Create timestamped file ONCE: `docs/review/issues/issue-YYYY-MM-DD-HHMM.md`
```

**PowerShell Commands:**
```powershell
# Create issue file ONCE per session
$issueFile = "docs\review\issues\issue-$timestamp.md"
if (Test-Path $issueFile) {
    Write-Host "⚠️ Issue file already exists: $issueFile"
    Write-Host "Using existing file for this session."
} else {
    $content = @"
# Issue Tracking - {app_name}
**Session:** Review App Compliance
**Created:** $(Get-Date -Format 'yyyy-MM-dd HH:mm')
**Status:** In Progress
---
## Summary
| Status | Count |
|--------|-------|
| Pending | 0 |
| Fixing | 0 |
| Fixed | 0 |
---
## Issues
| # | Category | Severity | File | Line | Issue | Status | Fixed At |
|---|----------|----------|------|------|-------|--------|----------|

"@
    Set-Content -Path $issueFile -Value $content -Encoding UTF8
    Write-Host "Created: $issueFile"
}
```

### Step 3: Execute Review/Detection - APPEND Each Issue Immediately
```
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
```

**Example Hardcoded String Detection Workflow:**
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

**Critical Markdown Table Formatting:**
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
```

### Step 4: User Confirmation Phase
```
├─ Show final issue count: "Total: XXX issues"
├─ Show link to issue file for user review
├─ Ask: "Proceed to fix these issues? (y/n)"
├─ If NO: Stop and document issues only
└─ If YES: Proceed to Step 5
```

### Step 5: Fix Issues from Issue File (NOT re-search)
```
├─ ⚠️ Read issue tracking markdown file (source of truth)
├─ FOR EACH pending issue in table:
│   ├─ Extract exact info: file, line, issue text
│   ├─ Use read_file to get context around that line
│   ├─ Apply fix using replace_string_in_file:
│   │   ├─ oldString: context + exact issue text (from file)
│   │   └─ newString: fixed version
│   ├─ Update Status="✅ Fixed" with timestamp in issue file
│   └─ Continue to next issue
└─ Final summary: X fixed, Y skipped
```

**Example Fix Workflow:**
```markdown
From issue file table row:
| 1 | Hardcoded String | Medium | main_home.xml | 30 | `android:text="Hello World"` | 🔴 Pending | |

AI Actions:
1. Read issue file → Extract: file=main_home.xml, line=30, text=`android:text="Hello World"`
2. Use read_file(main_home.xml, 27, 33) → Get context
3. Create string resource: hello_world="Hello World"
4. replace_string_in_file:
   oldString: (lines 27-33 with exact text from file)
   newString: (same lines but `android:text="@string/hello_world"`)
5. Update issue table row: Status="✅ Fixed" at "2025-12-12 14:30"
```

### Step 6: Build Verification (REQUIRED - MUST PASS)
```
├─ Run build command: `.\gradlew assembleDebug` or `.\build-apk.bat`
├─ Check for compilation errors
├─ If build FAILS:
│   ├─ Analyze error messages
│   ├─ Fix compilation errors (missing imports, syntax errors, etc.)
│   ├─ Re-run build until SUCCESS
│   └─ ❌ DO NOT proceed to Step 7 if build fails
└─ If build SUCCESS:
    ├─ ✅ Mark as "Build Verified"
    └─ Proceed to Step 7
```

### Step 7: Create Review Documentation (REQUIRED)
```
├─ ✅ MUST create `../DOCS/{platform}/review/` folder structure:
│   ├─ ../DOCS/{platform}/review/review-baseline.md (if not exists)
│   ├─ ../DOCS/{platform}/review/changes/review-YYYY-MM-DD.md (always)
│   └─ ../DOCS/{platform}/review/issues/issue-YYYY-MM-DD-HHMM.md (timestamped per session)
├─ Update issue markdown with final status:
│   ├─ Update summary table with final counts
│   ├─ Mark all fixed issues with ✅ Fixed + timestamp
│   ├─ Add Verification section: ✅ PASSED / ❌ FAILED
│   ├─ Add Build Status: ✅ PASSED / ❌ FAILED
│   └─ Add Completed At timestamp
├─ Update review-baseline.md with stable rules
├─ Create/Update today's review-YYYY-MM-DD.md with:
│   ├─ Review Reference Tracking table
│   ├─ Link to issue tracking MD: `[View Issues](issues/issue-YYYY-MM-DD-HHMM.md)`
│   ├─ Comparison table (Previous vs Current)
│   ├─ Issues Summary Table (from markdown summary)
│   ├─ Files Modified Table (from fixed issues)
│   ├─ Expandable Issue Details (or reference issue MD for full details)
│   └─ End of Day Summary
├─ Add "Build Status: ✅ PASSED" to documentation
├─ Update progress file (.ai-progress/)
└─ ❌ NEVER skip review documentation creation
```

## Smart Review Strategy

| Situation | Action | Reason |
|-----------|--------|--------|
| Progress file has ✅ "No hardcoded strings" | ❌ DO NOT re-scan | Already verified |
| Progress file has ⚠️ "MainProfile missing" | ✅ ONLY check MainProfile | Focus on specific issue |
| Progress file has ⏳ "Theme not checked" | ✅ ONLY review Theme rules | Not reviewed yet |
| User requests "review all" explicitly | ✅ Full review + Show comparison | User requested |
| User requests "fix X" | ✅ ONLY fix X | Targeted fix |

**Principles:**
- ✅ **TRUST progress file** - If already PASS, don't check again
- ⚠️ **FOCUS on issues only** - Save time and tokens
- 🔄 **Full review only when:** User requests or no progress file exists

## Full Re-review Protocol

**When user requests complete review:**

```
Step 1: Read existing progress file (if exists)
    ├─ Remember previous review results
    └─ Save old compliance score

Step 2: Execute full review again
    ├─ Scan all rules from beginning
    ├─ Detect current issues
    └─ Compare with previous results

Step 3: Generate comparison report
    ├─ Show Previous vs Current state
    ├─ Highlight improvements (✅ Fixed)
    ├─ Highlight regressions (❌ New issues)
    └─ Show unchanged items (➡️ Same)

Step 4: Update progress file with comparison tables
```

## Why This Approach Works

**Benefits:**
- ✅ **Accuracy** - EXACT line content from `read_file` (not truncated grep)
- ✅ **Speed** - No re-searching during fix phase
- ✅ **Reliability** - Single source of truth in markdown file
- ✅ No need to re-run grep commands
- ✅ EXACT line content already in issue file
- ✅ Faster fix execution
- ✅ Guaranteed accuracy (no regex mismatch)

**Why READ file is CRITICAL:**
- ✅ Grep output is TRUNCATED: `android:text="Hello...`
- ✅ Need EXACT text for fix step: `android:text="Hello World"`
- ✅ Prevents AI from guessing during fix
- ✅ Ensures accurate string resource creation