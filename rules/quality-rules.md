# Quality Rules (3.0-4.0)

> Code review and development checklist standards

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "quality-rules"...
```

**Purpose:** Let user know AI is referencing quality rules.

---

## 3. Code Review ⚠️ REQUIRED

**🔍 See:** [`checklists/code-review-detection.md`](../checklists/code-review-detection.md)

**⚠️ AI: Read CHECKLIST first when reviewing, not implementation files!**

**Quick Reference:**
- Run 4 PowerShell detection commands before submit
- Check: Hardcoded strings, hex colors, `_dark` anti-patterns
- Zero output = compliant
- Detection commands return instant results

**Why Checklist first:**
- ✅ Faster - Just run commands, get results
- ✅ Focused - Only what matters for review
- ✅ Actionable - Clear pass/fail criteria
- ❌ Don't read 15 implementation files for simple review

---

## 4. AI Development Checklist

**✅ See:** [`checklists/ai-development-checklist.md`](../checklists/ai-development-checklist.md)

**Quick Reference:**
- Quick checklist for common development tasks
- Activity/Fragment creation steps
- Multi-language requirements
- Theme/Dark mode rules
- Permission synchronization
- File splitting workflow

**When to use:**
- ✅ Creating new Activity/Fragment/Dialog
- ✅ Adding resources (colors, strings, dimensions)
- ✅ Quick verification before implementing
- ✅ Reference for naming patterns
- ❌ For detailed implementation → See Implementation Details above

---
**📚 Related Rules:**
- [Setup Rules](./setup-rules.md) - 2.1-2.8
- [UI/UX Rules](./ui-ux-rules.md) - 2.9-2.15
- [Advanced Rules](./advanced-rules.md) - 2.16-2.22