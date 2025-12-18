# Model Change Protocol

## 🤖 When AI Model Changes

### Scenario Types
1. **Rate limit → New Claude session**
2. **Claude → GPT-4 switch** 
3. **Different AI service entirely**
4. **Version upgrades (Claude 3.5 → Claude 4)**

## 📚 New Model Onboarding

### Step 1: Read All Context
**Priority Reading Order:**
1. **Main Progress:** `.ai-progress/{app}_main_progress.md`
2. **Recent Features:** `.ai-progress/features/implement_*_latest.md`
3. **Completed Work:** `.ai-completed/features_summary.md`
4. **Recovery Context:** `.ai-progress/{app}_context.md` (if available)

### Step 2: Environment Discovery
```markdown
## Environment Assessment
- **Workspace:** {discovered_project_structure}
- **Active Files:** {files_with_recent_changes}
- **Build Status:** {compilation_status}
- **Git State:** {branch_and_changes}
- **Dependencies:** {package_status}
```

### Step 3: Capability Declaration
```markdown
## New Model Declaration
- **Model:** {claude-3.5/gpt-4/etc}
- **Capabilities:** {coding_languages_and_frameworks}
- **Limitations:** {known_restrictions}
- **Continuity Plan:** {how_to_maintain_consistency}
```

## 🔄 Continuation Strategies

### Conservative Approach (Recommended)
```markdown
## Model Change - Conservative Continuation
**Previous Model:** Claude 3.5 Sonnet
**New Model:** Claude 4.0
**Strategy:** Follow exact existing patterns

### Continuation Plan
1. **Review all previous decisions:** Read full feature history
2. **Maintain code style:** Match existing patterns exactly
3. **Ask for clarification:** Confirm any uncertain decisions
4. **Document differences:** Note any capability changes

### User Confirmation Request
"I'm continuing from {previous_model} work. I've reviewed the progress and plan to:
- Continue feature X from {progress_point}
- Use the same approach as established: {approach_description}
- Maintain existing code patterns and conventions

Please confirm this continuation plan or provide adjustments."
```

### Progressive Approach
```markdown
## Model Change - Progressive Continuation  
**Previous Model:** Claude 3.5 Sonnet
**New Model:** Claude 4.0
**Strategy:** Improve upon existing work while maintaining compatibility

### Enhancement Opportunities
1. **Code Quality:** Better error handling, optimization
2. **Architecture:** Cleaner patterns, better separation
3. **Testing:** More comprehensive test coverage
4. **Documentation:** Clearer comments and docs

### User Consultation
"I can continue the existing work with potential improvements:
- Current approach: {existing_approach}
- Potential enhancements: {list_improvements}
- Compatibility: {backward_compatibility_plan}

Would you like me to continue conservatively or implement improvements?"
```

## 🛡️ Consistency Protocols

### Code Style Consistency
```markdown
## Style Analysis
**Previous Patterns Identified:**
- **Naming:** camelCase for variables, PascalCase for classes
- **Comments:** Javadoc style with @param and @return
- **Error Handling:** Try-catch with specific exception types
- **Architecture:** MVP pattern with separate service layer

**Consistency Rules:**
1. Match existing naming conventions exactly
2. Use same comment style and detail level
3. Follow established error handling patterns  
4. Maintain architectural decisions
```

### Decision Consistency
```markdown
## Previous Decisions to Maintain
1. **Technology Choices:** {framework_and_library_decisions}
2. **Architecture Patterns:** {design_pattern_choices}
3. **User Interface:** {ui_framework_and_style_decisions}
4. **Data Management:** {database_and_storage_decisions}
5. **Testing Strategy:** {testing_framework_and_approach}

**Deviation Rules:**
- Only deviate if user explicitly requests changes
- Document all deviations with reasoning
- Maintain backward compatibility
```

## 📋 Handoff Templates

### Complete Handoff Document
```markdown
# Model Change Handoff - SmartCallBlock
**Timestamp:** 2024-01-15 15:30:00
**Previous Model:** Claude 3.5 Sonnet  
**New Model:** Claude 4.0

## Project State Summary
- **Active Features:** 2 in progress, 1 pending testing
- **Progress:** 65% overall completion
- **Recent Focus:** Call blocking engine implementation
- **Next Priority:** Testing validation and UI polish

## Technical Decisions Made
1. **Architecture:** MVP with service layer separation
2. **Call Detection:** PhoneStateListener approach chosen
3. **Data Storage:** SharedPreferences for settings, SQLite for logs
4. **UI Framework:** Material Design 3 with custom themes
5. **Testing:** JUnit + Espresso for UI tests

## Code Patterns Established
- **Error Handling:** Graceful degradation with user notifications
- **Permissions:** Runtime permission requests with explanations
- **Logging:** Custom LogHelper with different levels
- **Configuration:** Centralized settings management

## Current Implementation Status
### Feature 1: Core Call Blocking (75%)
- ✅ Phone state detection
- ✅ Blacklist management  
- ⏳ Whitelist implementation (in progress)
- ⏳ Testing validation (pending)

### Feature 2: UI Enhancement (40%)
- ✅ Main activity layout
- ⏳ Settings fragment (in progress)
- ⏳ Dark mode implementation
- ⏳ Material Design 3 components

## Continuation Instructions
1. **Immediate Task:** Complete whitelist implementation in CallBlocker.java
2. **Testing:** Prompt user for validation once implementation complete
3. **Code Style:** Match existing camelCase and Javadoc patterns
4. **Error Handling:** Use established try-catch patterns
5. **User Communication:** Follow established validation protocols

## Critical Context
- User prefers testing validation before archival
- Code must compile without errors
- Material Design 3 compliance required
- No breaking changes to existing functionality
```

## 🤝 User Collaboration

### Model Change Announcement
```
🤖 **Model Change Detected**

Previous session work reviewed:
- **Project:** SmartCallBlock Android App
- **Active Features:** {count} in progress  
- **Last Progress:** {summary_of_recent_work}
- **Continuation Plan:** {how_planning_to_continue}

I'll maintain all previous decisions and code patterns. Please let me know if you'd like me to adjust the approach or if any previous work needs modification.
```

### Capability Comparison
```markdown
## Model Capability Assessment
**Previous Model Strengths:** {what_worked_well}
**New Model Strengths:** {potential_improvements}
**Potential Challenges:** {areas_that_might_differ}

**Recommended Strategy:**
- Continue with proven approaches
- Leverage new capabilities gradually
- Maintain compatibility and consistency
```

## ⚡ Quick Commands

### Standard Model Change
```bash
"Review project progress and current plan"
# AI will read all context and provide continuation plan
```

### Detailed Handoff Review
```bash
"Provide complete model change handoff summary"
# AI will analyze all work and create detailed handoff document
```

### Capability Assessment  
```bash
"Compare capabilities with previous model and plan continuation"
# AI will assess differences and recommend approach
```

### Conservative Mode
```bash
"Continue work with exact same patterns and decisions"
# AI will follow previous approaches precisely
```

## 🎯 Success Metrics

### Successful Model Transition
- [ ] All previous context understood
- [ ] Existing code patterns identified
- [ ] Previous decisions documented
- [ ] Continuation plan established
- [ ] User confirmation received
- [ ] Work resumed without disruption
- [ ] Consistency maintained

### Quality Indicators
- **Zero rework:** No need to redo previous work
- **Pattern consistency:** New code matches existing style
- **Decision continuity:** Same architectural choices maintained  
- **User satisfaction:** Smooth transition experience

---
**📚 Related Workflows:**
- [Rate Limit Recovery](./rate-limit-recovery.md)
- [Feature Workflow](./feature-workflow.md)
- [Session Commands](../commands/session-commands.md)