# Rate Limit Recovery Workflow

## � Chat History Management

### When to Start New Chat
**Indicators for new chat session:**
- Chat history > 50 messages
- Context becoming cluttered or confusing
- Starting completely new feature development
- Multiple rate limits in current conversation
- AI responses becoming less accurate due to context overload

### New Chat Decision Matrix
| Situation | Action | User Confirmation |
|-----------|--------|-----------------|
| New feature request + long history | Start new chat | Required |
| Rate limit + history >50 messages | Offer new chat option | Recommended |
| Complex context + confusion | Suggest new chat | Optional |
| Clean feature completion | Continue current chat | Not needed |

## �🚨 Before Rate Limit (Save State)

### Emergency Save Protocol
When rate limit is imminent:

1. **Update Context File**
```markdown
# AI Context Recovery - {app}
**Last Updated:** {datetime}
**Rate Limit Reason:** {claude_rate_limit/daily_limit/session_timeout}

## Current Session State
- **Active Features:** {list_active_features}
- **Current Task:** {exact_task_being_performed}
- **Progress:** {percentage_and_milestone}
- **Files Being Edited:** {list_files}

## Exact Stopping Point
- **Last Action:** {exact_last_action}
- **Next Planned Step:** {next_step_to_take}
- **Code Position:** {file:line_number_or_function}
- **Unsaved Changes:** {any_uncommitted_work}

## Environment State
- **Project Directory:** {workspace_path}
- **Active Branch:** {git_branch}
- **Build Status:** {compiled/errors/warnings}
- **Dependencies:** {any_pending_installs}

## Continuation Instructions
{detailed_instructions_for_next_ai_session}
```

2. **Update Feature Progress**
```markdown
### {date} - RATE LIMIT PAUSE ⏸️
- **Progress:** {current_percentage}
- **Last Completed:** {last_milestone}
- **Next Task:** {immediate_next_step}
- **Context Saved:** {app}_context.md updated
- **Time:** {time_spent_this_session}
```

3. **Quick Command**
```bash
"Save AI session state for rate limit recovery"
```

## 🔄 After Rate Limit (Recovery)

### New Session Checklist
1. **Read Context File First**
   - Open `.ai-progress/{app}_context.md`
   - Review exact stopping point
   - Check environment state

2. **Validate Environment**
   ```markdown
   ## Recovery Validation
   - [ ] Project directory accessible  
   - [ ] Git status verified
   - [ ] Build status checked
   - [ ] Dependencies validated
   - [ ] Active features identified
   ```

3. **Resume from Checkpoint**
   ```markdown
   ### {date} - Session Resumed ▶️
   - **Recovery Point:** {exact_resumption_point}
   - **Context Validated:** ✅
   - **Environment Status:** Ready
   - **Continuing with:** {next_task}
   ```

### Recovery Command
```bash
"Resume AI session from last checkpoint"
```

## � New Chat Protocol

### Pre-New Chat Summary
When chat history becomes too long or new feature starts:

**Step 1: Create Comprehensive Summary**
```markdown
# Session Handoff Summary - {app}
**Summary Created:** {datetime}
**Reason for New Chat:** {long_history/new_feature/rate_limit/confusion}
**Previous Chat Duration:** {message_count} messages, {time_span}

## Complete Project Context
### Project Overview
- **Application:** {name_and_purpose}
- **Technology Stack:** {frameworks_libraries_languages}
- **Architecture:** {design_patterns_and_structure}
- **Current Phase:** {development_stage}

### All Features Status
#### Completed Features ✅
- **{feature_1}:** {brief_description_and_outcome}
- **{feature_2}:** {brief_description_and_outcome}

#### Active Features 🔄
- **{feature_1}:** {current_progress_and_next_steps}
- **{feature_2}:** {current_progress_and_next_steps}

#### Planned Features 📋
- **{feature_1}:** {priority_and_description}
- **{feature_2}:** {priority_and_description}

## Critical Technical Decisions
### Architecture Decisions Made
1. **{decision_area}:** {decision_and_reasoning}
2. **{decision_area}:** {decision_and_reasoning}
3. **{decision_area}:** {decision_and_reasoning}

### Code Patterns Established
- **Naming Conventions:** {specific_patterns}
- **Error Handling:** {approach_and_standards}
- **Testing Strategy:** {framework_and_approach}
- **File Structure:** {organization_principles}

### Dependencies & Libraries
- **Core Dependencies:** {list_with_versions}
- **Development Tools:** {build_test_lint_tools}
- **External APIs:** {services_and_integrations}

## Current Implementation Context
### Active Work Details
**Primary Focus:** {current_main_task}
**Files Being Modified:** {list_current_files}
**Recent Changes:** {what_was_just_implemented}
**Next Immediate Steps:** {specific_actionable_next_tasks}

### Code Context
```{language}
// Current implementation area
{relevant_code_snippet_showing_current_work}
```

**Implementation Notes:** {technical_details_and_considerations}

## User Preferences & Constraints
### Established Preferences
- **Testing Approach:** {user_preferred_testing_method}
- **Code Style:** {specific_style_requirements}
- **Feature Priorities:** {user_priority_order}
- **Communication Style:** {how_user_likes_updates}

### Known Constraints
- **Time Limitations:** {any_time_constraints}
- **Technical Limitations:** {platform_or_tool_constraints}
- **Resource Constraints:** {budget_or_access_limitations}

## Quality & Testing Context
### Testing Results History
- **Recent Test Results:** {pass_fail_status_of_recent_features}
- **Known Issues:** {current_bugs_or_problems}
- **Performance Notes:** {any_performance_considerations}

### Quality Standards
- **Code Quality Requirements:** {standards_established}
- **Documentation Standards:** {doc_requirements}
- **User Experience Standards:** {ux_requirements}

## New Chat Instructions
### For New AI Session
1. **Read this summary completely** before starting work
2. **Confirm understanding** of project context and current state
3. **Validate environment** (files, build status, dependencies)
4. **Continue from** {specific_continuation_point}
5. **Maintain consistency** with all established patterns and decisions

### Immediate Next Actions
1. {specific_next_action_1}
2. {specific_next_action_2}
3. {specific_next_action_3}

### Critical Success Factors
- {success_factor_1}
- {success_factor_2}
- {success_factor_3}
```

**Step 2: User Confirmation for New Chat**
```
📱 **New Chat Recommended**

Current chat history: {message_count} messages
Reason: {specific_reason}

I've created a comprehensive summary with:
✅ Complete project context and technical decisions
✅ All feature status and implementation details  
✅ Current work state and next steps
✅ Code patterns and user preferences

This summary contains everything needed for a new AI session to continue seamlessly without research.

**Options:**
1. **Start new chat** - I'll save this summary to progress files for new session
2. **Continue here** - We'll manage with current context

Recommended: New chat for optimal performance
```

**Step 3: Save Summary to Progress Files**
Update `.ai-progress/{app}_context.md` with comprehensive summary

**Step 4: New Chat Initialization**
```markdown
# New Chat Session - {app}
**Started:** {datetime}
**Previous Session Summary:** Available in .ai-progress/{app}_context.md
**Continuation Point:** {specific_resumption_task}

## Session Initialization
1. Read complete project summary from context file ✅
2. Validate understanding of all technical decisions ✅
3. Confirm current implementation state ✅
4. Ready to continue from: {specific_next_action}

**AI Confirmation:** "I've reviewed the complete project context and am ready to continue from {continuation_point}. Should I proceed with {next_action}?"
```

## �📋 Recovery Templates

### Standard Context Save
```markdown
# AI Context Recovery - SmartCallBlock
**Last Updated:** 2024-01-15 14:30:45
**Rate Limit Reason:** Claude daily limit reached

## Current Session State
- **Active Features:** implement_call_blocker_20240115.md
- **Current Task:** Implementing contact-based blocking logic
- **Progress:** 65% - Core functionality complete, working on whitelist
- **Files Being Edited:** MainActivity.java, CallBlocker.java

## Exact Stopping Point
- **Last Action:** Added contact permission check in CallBlocker.java
- **Next Planned Step:** Implement whitelist validation logic
- **Code Position:** CallBlocker.java:checkContactWhitelist() function
- **Unsaved Changes:** None - all changes committed

## Environment State
- **Project Directory:** d:\MyRepo\AI-App\Android.App\smart-call-block
- **Active Branch:** main
- **Build Status:** Compiles successfully, no errors
- **Dependencies:** All installed, no pending changes

## Continuation Instructions
1. Resume implementing checkContactWhitelist() in CallBlocker.java
2. Add contact provider query logic
3. Handle permissions gracefully
4. Test with known contacts
5. Update progress to 75% when complete
```

### Emergency Context Save (Minimal)
```markdown
# Emergency Recovery - SmartCallBlock
**Emergency Save:** 2024-01-15 16:45:12

**CRITICAL INFO:**
- Feature: implement_call_blocker_20240115.md at 80%
- Task: Fixing memory leak in CallDetectorService.java:onDestroy()
- Next: Add cleanup code for phoneStateListener
- Files: CallDetectorService.java (unsaved changes in memory)

**IMMEDIATE ACTION NEEDED:**
Continue fixing memory leak - add phoneStateListener.cleanup() in onDestroy()
```

## 🔧 Advanced Recovery Scenarios

### Multiple Active Features
```markdown
## Active Work (Multiple Features)
1. **implement_call_blocker_20240115.md** - 75% complete
   - Next: Testing validation
   
2. **implement_ui_themes_20240115.md** - 30% complete  
   - Next: Dark mode implementation
   
3. **fix_crash_reports_20240115.md** - 90% complete
   - Next: Final testing

**Priority Order:** Complete call_blocker first, then ui_themes, then crash fix
```

### Mid-File Edit Recovery
```markdown
## Code Position Recovery
**File:** MainActivity.java
**Function:** onCreate()
**Line Range:** 45-67 (adding call detection service)
**Partial Code:**
```java
// Last completed line:
callDetectorService = new CallDetectorService(this);

// Next to add:
callDetectorService.setBlockingEnabled(true);
callDetectorService.setWhitelistEnabled(getPreferences().getBoolean("whitelist_enabled", true));
```
```

### Build Error Recovery
```markdown
## Build Status Recovery
**Status:** Compilation errors
**Errors:**
1. MainActivity.java:67 - Undefined method setBlockingEnabled()
2. CallBlocker.java:23 - Missing import for ContactsContract

**Fix Order:**
1. Add setBlockingEnabled() method to CallDetectorService
2. Import ContactsContract in CallBlocker.java
3. Rebuild and verify
```

## ⚡ Quick Recovery Commands

### Standard Recovery
```bash
"Resume AI session from last checkpoint"
# AI will read context.md and continue from exact stopping point
```

### Validate Recovery Environment  
```bash
"Validate recovery environment and show status"
# AI will check all systems and confirm readiness
```

### Emergency Recovery
```bash
"Emergency recovery - show me where we left off"
# AI will quickly scan all progress files and summarize state
```

### Recovery with Review
```bash
"Resume session with progress review"
# AI will read context, summarize what was done, and plan next steps
```

## 💬 New Chat Session Commands

### Chat History Assessment
```bash
"Check if new chat session is recommended"
# AI evaluates chat length, complexity, and context clarity
```

```bash
"Create new chat session summary"
# Generates comprehensive handoff summary for new session
```

### New Feature in Long Chat
```bash
"Start new feature in fresh chat session"
# Prompts for new chat when starting major new work
```

```bash
"Recommend new chat for feature: {name}"
# Evaluates if new chat needed for specific feature work
```

### Summary and Handoff
```bash
"Generate complete project handoff summary"
# Creates comprehensive context document for new session
```

```bash
"Prepare new chat session with full context"
# Saves summary and provides new chat initialization instructions
```

### New Chat Initialization
```bash
"Initialize from project summary"
# New chat command to load context and continue work
```

```bash
"Validate new session context and continue"
# Confirms understanding and readiness to proceed
```

## 🎯 Recovery Success Metrics

### Complete Recovery Checklist
- [ ] Context file read successfully
- [ ] Environment validated (files, directories, build status)
- [ ] Active features identified
- [ ] Exact stopping point located
- [ ] Next steps clearly defined
- [ ] Work resumed without loss of progress
- [ ] Continuation logged in feature files

### New Chat Session Success Metrics
- [ ] Comprehensive summary created with all context
- [ ] Technical decisions and patterns documented
- [ ] User preferences and constraints captured
- [ ] Current work state precisely described
- [ ] New session can continue without research
- [ ] Zero information loss during transition
- [ ] New AI session confirms understanding

### Recovery Time Goals
- **Simple recovery:** < 2 minutes
- **Complex recovery:** < 5 minutes  
- **Emergency recovery:** < 1 minute
- **Multiple features:** < 10 minutes
- **New chat transition:** < 5 minutes (summary creation)
- **New chat initialization:** < 3 minutes (context loading)

---
**📚 Related Workflows:**
- [Model Change Workflow](./model-change.md)
- [Feature Workflow](./feature-workflow.md)
- [Session Commands](../commands/session-commands.md)