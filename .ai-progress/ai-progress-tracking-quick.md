# AI Progress Tracking - Master Navigation

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "ai-progress-tracking-quick"...
```

**Purpose:** Let user know AI is referencing progress tracking guidelines.

---

## 📍 Quick Navigation
**Current Task:** Read only what you need for your current step

### 🚀 Starting Work
- **New feature request:** → [`workflows/feature-workflow.md`](./workflows/feature-workflow.md)
- **Resume after rate limit:** → [`workflows/rate-limit-recovery.md`](./workflows/rate-limit-recovery.md)  
- **AI model changed:** → [`workflows/model-change.md`](./workflows/model-change.md)
- **Long chat history:** → [`workflows/rate-limit-recovery.md#new-chat-protocol`](./workflows/rate-limit-recovery.md#new-chat-protocol)

### 🔧 During Work
- **Feature commands:** → [`commands/feature-commands.md`](./commands/feature-commands.md)
- **Bug tracking:** → [`templates/bug-tracking.md`](./templates/bug-tracking.md)
- **Complete feature:** → [`workflows/testing-validation.md`](./workflows/testing-validation.md)

### 📚 Quick References
- **All commands:** → [`commands/`](./commands/)
- **File structure:** → [Essential Files](#essential-files)
- **Emergency help:** → [Critical Protocols](#critical-protocols)

## 📁 Essential Files

**⚠️ IMPORTANT:** Create `.ai-progress/` folder in the APP being implemented, NOT in development-rules!

**Example for daily-speak app:**
```
daily-speak/                         # ← CREATE .ai-progress HERE
├── .ai-progress/
│   ├── daily-speak_main_progress.md     # Session overview
│   ├── daily-speak_context.md           # Rate limit recovery
│   ├── features/implement_{name}_{date}.md  # Feature tracking
│   └── sessions/session_{timestamp}.md  # Session logs
├── .ai-completed/                        # Archived completed features
│   ├── implement_{name}_{date}.md        # Completed features  
│   └── features_summary.md              # Quick overview
└── app/
    └── src/
```

**Path Pattern:** `{workspace}/{app-folder}/.ai-progress/`

## ⚡ Critical Protocols

### New Chat Session Checklist
1. **Confirm app folder:** Ask user to confirm which app folder to create `.ai-progress/` in
2. **Read progress:** Check `.ai-progress/{app}_main_progress.md`
3. **Review features:** Check `.ai-progress/features/` for active work
4. **Check history:** Review `.ai-completed/features_summary.md`
5. **If model change:** → [`workflows/model-change.md`](./workflows/model-change.md)
6. **If long history:** → [`workflows/rate-limit-recovery.md#new-chat-protocol`](./workflows/rate-limit-recovery.md#new-chat-protocol)

### Chat History Management
- **>50 messages:** Consider new chat for optimal performance
- **New major feature:** Always recommend new chat session
- **Context confusion:** Create comprehensive summary and new chat
- **Rate limit + long history:** Mandatory new chat protocol

### Emergency Commands
```bash
"Confirm .ai-progress folder location before creating"    # Prevent wrong folder creation
"Resume AI session from last checkpoint"                  # Rate limit recovery
"Review project progress and current plan"                # Model change
"Show active feature implementations"                     # See current work
"Save AI session state for rate limit recovery"           # Before rate limit
"Check if new chat session is recommended"                # Chat history assessment
"Create complete project handoff summary"                 # New chat preparation
```

---
**📚 For detailed workflows and templates, use the navigation links above**