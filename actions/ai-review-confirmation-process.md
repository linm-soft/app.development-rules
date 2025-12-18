# 🔍 AI Review Confirmation Process

## REQUIRED: Auto-Check After Every Edit

**AI PHẢI tự động check sau mỗi lần edit file:**

| Action | Auto-Check | Tool |
|--------|-----------|------|
| Edit layout XML | Check hardcoded text | `grep_search` với pattern `android:text="[^@]` |
| Edit Java code | Check hardcoded strings | `grep_search` với pattern `setText.*"` |
| Edit colors | Verify hex colors | `grep_search` với pattern `#[0-9A-Fa-f]{6,8}` |

## Review Confirmation Workflow

### Step 1: Display All Issues Found

**Format:**
```
Found {X} issues requiring attention:

## 📊 Summary
| Status | Count | Issue IDs |
|--------|-------|-----------|
| 🔴 Pending | X | #1-X |
| ✅ Fixed | 0 | - |
| **Total** | **X** | - |

## 📋 Issues List
| ID | Category | Severity | Status | File | Issue |
|----|----------|----------|--------|------|-------|
| 1 | Hardcoded String | 🔴 High | 🔴 Pending | `main_home.xml` | "Hello, User!" |
| 2 | Hardcoded Color | 🟡 Medium | 🔴 Pending | `colors.xml` | "#09A3E3" |

📄 Full details will be in: docs\review\issues\issue-{timestamp}.md
```

**CRITICAL - After showing summary:**
```powershell
# AI MUST automatically run this command to open file for user review
code "docs\review\issues\issue-{timestamp}.md"
```
This opens the issue file in VS Code so user can review all details in markdown preview.

### Step 2: Request User Confirmation

**Ask:**
```
Would you like me to fix these issues?
- Type "yes" or "fix all" to fix all issues
- Type "skip X" to skip specific issue numbers
- Type "no" or "cancel" to skip fixes
```

### Step 3: Match User Intent

| User Response | Action |
|---------------|--------|
| "có" / "ok" / "fix" / "sửa hết" / "yes" / "fix all" | Fix tất cả issues |
| "skip 3,5" / "bỏ qua 3,5" | Fix tất cả trừ issue #3 và #5 |
| "không" / "cancel" / "bỏ qua" / "no" | Không fix gì cả |
| Hỏi chi tiết về issue | Giải thích issue đó |

### Step 4: After Fixing

1. **Report** số lượng issues đã fix
2. **Re-run detection** để verify không còn issues
3. **Update progress file** nếu có

## ⚠️ CRITICAL RULES

**KHÔNG tự động fix mà không hỏi user trước!**

**LUÔN show findings trước khi fix:**
- Display all detected issues
- Wait for user confirmation
- Only fix after user approves

## Example Workflow

```
AI: "Found 5 hardcoded strings:
     1. main_home.xml:42 - android:text='Hello'
     2. LoginActivity.java:89 - setText('Welcome')
     3. dialog_confirm.xml:15 - android:hint='Enter name'
     4. MainProfile.java:120 - Toast.makeText(..., 'Success', ...)
     5. main_settings.xml:67 - android:contentDescription='Settings'
     
     Fix all these issues?"

User: "skip 4"

AI: [Fixes issues 1, 2, 3, 5]
     "Fixed 4 out of 5 issues. Skipped issue #4 as requested.
     
     Re-running detection...
     ✅ No hardcoded strings remaining (except skipped #4)."
```

## Detection Commands Reference

### Layout Hardcoded Strings

```powershell
# android:text
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String 'android:text="[^@]' | 
    Select-Object Path, LineNumber, Line

# android:hint
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String 'android:hint="[^@]' | 
    Select-Object Path, LineNumber, Line

# android:contentDescription
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String 'android:contentDescription="[^@]' | 
    Select-Object Path, LineNumber, Line
```

### Java Hardcoded Strings

```powershell
# setText("...")
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'setText\s*\(\s*"' | 
    Select-Object Path, LineNumber, Line

# Toast.makeText with hardcoded string
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String 'Toast\.makeText\s*\([^,]+,\s*"' | 
    Select-Object Path, LineNumber, Line
```

### Hardcoded Colors

```powershell
# Find hex colors in layouts
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String '#[0-9A-Fa-f]{6,8}' | 
    Select-Object Path, LineNumber, Line
```

## Integration with Main Workflow

**This process applies to:**
- "review all" workflow - After running all checklists
- "review app" workflow - After targeted review
- Any manual code editing by AI

**Always execute:**
1. Make changes
2. Auto-check for issues
3. Display findings
4. Wait for user confirmation
5. Fix approved issues
6. Re-verify
