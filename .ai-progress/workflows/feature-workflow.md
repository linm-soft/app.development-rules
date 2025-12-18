# Feature Implementation Workflow

## 🚀 Starting New Feature

### Step 1: Create Feature File
```
User: "Implement feature X"
AI Action: Create .ai-progress/features/implement_X_{timestamp}.md
```

### Step 2: Document Initial Plan
```markdown
# Feature Implementation - {name}
**Created:** {datetime} | **Status:** In Progress | **Priority:** High
**Progress:** 0% | **Testing:** Pending | **ETA:** 3h

## User Requirements
{original_user_request}

## Implementation Plan
1. Analyze current code structure
2. Implement core functionality  
3. Add error handling
4. Write/update tests
5. Update documentation

## Expected Changes
- Files: MainActivity.java, fragment_home.xml
- New features: Call blocking logic
- Dependencies: None

## Progress Log
### {date} - Started
- **Progress:** 0% → 20%
- **Completed:** Initial analysis  
- **Next:** Core implementation
- **Time:** 1h
```

### Step 3: Update Main Progress
Add feature to `.ai-progress/{app}_main_progress.md`:
```markdown
### Active Features
- **implement_X_{date}.md** - In Progress (20%) - 2h remaining
```

## 🔄 During Implementation

### Progress Updates
Update every significant milestone:
```markdown
### {date} Update
- **Progress:** 30% → 60%
- **Completed:** Core implementation, validation logic
- **Next:** Error handling & edge cases
- **Blockers:** None
- **Time:** +2h (Total: 3h)
- **Files Modified:** MainActivity.java, CallBlocker.java
```

### Bug Tracking
Log any bugs found during implementation:
```markdown
#### BUG-001: Memory leak in call detector
- **Severity:** Medium | **Status:** Fixed
- **Solution:** Added proper cleanup in onDestroy()
- **Time:** 0.5h | **Files:** CallDetectorService.java
```

## 🎯 Feature Completion Process

### Step 1: Implementation Complete
Update progress to 100%:
```markdown
### {date} - Implementation Complete
- **Progress:** 80% → 100%
- **Completed:** All implementation, testing setup
- **Status:** Ready for validation
- **Total Time:** 4h
```

### Step 2: Testing Validation
Prompt user for testing:
```
Feature '{name}' implementation is complete. 

To proceed with archival, please test the following:
1. {specific_test_case_1}
2. {specific_test_case_2} 
3. {specific_test_case_3}

Please reply with test results: "passed", "minor-issues", or "failed" with details.
```

### Step 3: Handle Test Results

#### If Testing Passed
```markdown
### {date} - Testing Passed ✅
- **Test Results:** All tests passed
- **User Confirmation:** Received
- **Status:** Ready for archive
```
→ Proceed to [`testing-validation.md#feature-completion--archival`](./testing-validation.md#feature-completion--archival)

#### If Minor Issues
```markdown
### {date} - Testing Issues (Minor)
- **Issues Found:** {list_issues}
- **Impact:** Low
- **Status:** Fixing issues
```
→ Fix issues, retest, then proceed to completion

#### If Testing Failed
```markdown
### {date} - Testing Failed ❌
- **Issues Found:** {critical_issues}
- **Impact:** High
- **Status:** Investigating & fixing
```
→ Debug and fix critical issues, implement again

## 🔧 Common Patterns

### Large Feature Breakdown
For complex features, create sub-tasks:
```markdown
## Implementation Breakdown
### Phase 1: Core Functionality (40%)
- [ ] Basic call detection
- [ ] Block list management
- [x] UI integration

### Phase 2: Advanced Features (35%) 
- [ ] Smart blocking rules
- [ ] Statistics tracking
- [ ] Export/import

### Phase 3: Polish (25%)
- [ ] Error handling
- [ ] Performance optimization
- [ ] Documentation
```

### Time Management
Track time accurately:
```markdown
## Time Tracking
- **Estimated:** 4h
- **Actual:** 5.5h
- **Breakdown:**
  - Analysis: 1h
  - Implementation: 3.5h
  - Testing setup: 1h
- **Efficiency:** 73% (5.5h vs 4h planned)
```

## 🆘 Troubleshooting

### Feature Stuck/Blocked
```markdown
### {date} - BLOCKED ⚠️
- **Issue:** Cannot proceed due to {reason}
- **Blocking factor:** {dependency/knowledge/resource}
- **User action needed:** {what_user_should_do}
- **Time lost:** 1h
```

### Need User Clarification
```markdown
### {date} - Clarification Needed 
- **Question:** {specific_question}
- **Current assumption:** {what_ai_assumes}
- **Impact:** Cannot proceed until clarified
- **Files affected:** {list}
```

---
**📚 Related Workflows:**
- [Testing Validation](./testing-validation.md)
- [Bug Tracking](../templates/bug-tracking.md)