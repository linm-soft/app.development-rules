# 📋 Issue Tracking System

## Purpose

**Issue tracking files (`docs/review/issues/issue-YYYY-MM-DD-HHMM.md`) are the SINGLE SOURCE OF TRUTH.**

1. AI detects issues → Creates markdown file with all details
2. User reviews in VS Code Preview (Ctrl+Shift+V)
3. User confirms → AI reads markdown to fix (NOT re-search)
4. AI updates status incrementally (🔴→🔧→✅)

**Why Markdown?** Easy to review in VS Code Preview, Git-friendly diffs, no special tools needed

---

## File Format Template

```markdown
# 🔍 Issue Tracking - {APP_NAME}

**Review Session:** {YYYY-MM-DD HH:MM} | **Type:** {review_type} | **Path:** `{path}`

## 📊 Summary
| Status | Count | Issue IDs |
|--------|-------|-----------|
| 🔴 Pending | X | #1-X |
| ✅ Fixed | 0 | - |
| **Total** | **X** | - |

## 📋 Issues List

### Category Name (e.g., Hardcoded Strings)
| ID | Severity | Status | File | Issue Description |
|----|----------|--------|------|-------------------|
| 1 | 🔴 High | 🔴 Pending | `{file}.xml` | "Hardcoded text" |

## 🔍 Issue Details (Optional for Bulk/Simple Issues)

> **Note for AI:** For simple bulk issues (like hardcoded strings/colors), the table above is sufficient. 
> Only use the detailed view below for complex logic issues or when specific context is critical for the fix.

<details>
<summary><b>Issue #X:</b> {description}</summary>

**File:** `{path}` | **Line:** {line} | **Category:** {category} | **Severity:** 🔴 High

### Old Value (EXACT)
\`\`\`{lang}
{exact_old_code}
\`\`\`

### New Value (EXACT)
\`\`\`{lang}
{exact_new_code}
\`\`\`

### Context (5 lines before + after)
\`\`\`{lang}
{context}
\`\`\`

---
**Fixed At:** - | **Fixed Value:** -
</details>
```

---

## Status & Severity

| Status | Emoji | Severity | Emoji |
|--------|-------|----------|-------|
| Pending | 🔴 | High | 🔴 |
| Fixing | 🔧 | Medium | 🟡 |
| Fixed | ✅ | Low | 🟢 |
| Skipped | ⏭️ |
| Failed | ❌ |

---

## AI Workflow - INCREMENTAL APPROACH

**Step 1:** Create empty markdown file with template

**Step 2:** FOR EACH detection rule in checklist:
- Run detection command
- IF issues found → Add to markdown → Save (incremental)
- Show progress: "✅ Rule 1/8: Found 3 issues"

**Step 3:** Show summary → **Auto-open file in VS Code** → User reviews & confirms

**CRITICAL:** After displaying "Full details will be in: docs\review\issues\issue-XXX.md":
```powershell
# AI MUST run this command to open file in VS Code
code "docs\review\issues\issue-{timestamp}.md"
```

**Step 4:** FOR EACH issue:
- Read Old/New values from markdown
- Apply fix
- Update status (🔴→🔧→✅)
- Save incrementally

**Benefits:** Real-time progress, resumable, safe for rate limits, **user can review in VS Code immediately**

---

## Example Progress

```
✅ Rule 1/8: Hardcoded Strings in Layouts → Found 3 issues
✅ Rule 2/8: Hardcoded Strings in Java → Found 2 issues  
✅ Rule 3/8: CardView Backgrounds → No issues ✅
```

After fixing:
```markdown
| Status | Count | Issue IDs |
|--------|-------|-----------|
| 🔴 Pending | 3 | #4-6 |
| ✅ Fixed | 2 | #1-2 |
```
