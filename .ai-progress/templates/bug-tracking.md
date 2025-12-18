# Bug Tracking Templates

## 🐛 Standard Bug Report Template

### Initial Bug Report
```markdown
#### BUG-{sequential_number}: {Brief_Descriptive_Title}
**Reported:** {YYYY-MM-DD HH:mm:ss} | **Severity:** {Critical/High/Medium/Low} | **Status:** Found
**Feature:** {related_feature_or_component} | **Reporter:** {AI/User/Testing}

## Bug Description
{clear_description_of_the_issue}

## Impact Assessment
- **User Impact:** {how_this_affects_end_users}
- **Frequency:** {always/often/sometimes/rare}
- **Affected Users:** {all/specific_group/edge_case}
- **Business Impact:** {critical/moderate/minimal}

## Reproduction Steps
1. {specific_step_1}
2. {specific_step_2}
3. {specific_step_3}
4. **Result:** {what_actually_happens}

## Expected vs Actual Behavior
- **Expected:** {what_should_happen}
- **Actual:** {what_currently_happens}
- **Evidence:** {screenshots/logs/error_messages}

## Technical Details
- **Environment:** {development/testing/production}
- **Platform:** {Android_version/device_type}
- **Code Location:** {file_and_line_number_if_known}
- **Related Code:** {relevant_functions_or_classes}

## Investigation Notes
{initial_analysis_and_findings}

## Fix Priority
- **Severity Justification:** {why_this_severity_level}
- **Fix Timeline:** {immediate/this_sprint/next_sprint/backlog}
- **Dependencies:** {other_work_that_must_happen_first}
```

## 🔍 Bug Investigation Template

### Investigation Progress
```markdown
### BUG-{number} Investigation - {YYYY-MM-DD}

## Root Cause Analysis
### Initial Hypothesis
{what_we_think_is_causing_the_issue}

### Investigation Steps Taken
1. **{investigation_step}** - {findings}
2. **{investigation_step}** - {findings}
3. **{investigation_step}** - {findings}

### Code Analysis
- **Suspect Code Sections:**
  - {file_path}:{line_range} - {why_suspicious}
  - {file_path}:{line_range} - {why_suspicious}
- **Related Functions:** {list_of_related_functions}
- **Data Flow:** {how_data_moves_through_the_system}

### Test Results
- **Reproduction Attempts:** {successful/failed} ({details})
- **Edge Case Testing:** {results}
- **Related Functionality:** {impact_on_other_features}

## Root Cause Identified
**Primary Cause:** {technical_explanation_of_root_cause}
**Contributing Factors:** {other_factors_that_made_this_possible}
**Prevention:** {how_to_prevent_similar_issues}

## Solution Design
**Approach:** {high_level_fix_strategy}
**Implementation:** {specific_changes_needed}
**Risk Assessment:** {potential_side_effects}
**Testing Strategy:** {how_to_verify_the_fix}
```

## 🔧 Bug Resolution Template

### Fix Implementation
```markdown
### BUG-{number} Resolution - {YYYY-MM-DD}
**Status:** Found → Fixed
**Resolution Time:** {hours_spent}h
**Fixed By:** {AI_model_or_developer}

## Solution Implemented
### Changes Made
- **{file_path}:** {description_of_changes}
- **{file_path}:** {description_of_changes}
- **{file_path}:** {description_of_changes}

### Code Changes Summary
```{language}
// Before (problematic code)
{original_code_snippet}

// After (fixed code)
{corrected_code_snippet}
```

## Fix Details
**Root Cause:** {technical_explanation}
**Solution Approach:** {why_this_approach_was_chosen}
**Side Effects:** {any_other_changes_or_impacts}
**Performance Impact:** {better/same/slightly_worse}

## Testing Performed
- [ ] **Unit Tests:** {test_results}
- [ ] **Integration Tests:** {test_results}
- [ ] **Regression Tests:** {test_results}
- [ ] **Edge Case Tests:** {test_results}

## Validation Required
### User Testing Scenarios
1. **Original Issue:** {test_the_original_problem_is_fixed}
2. **Related Functionality:** {test_no_regression_in_related_features}
3. **Edge Cases:** {test_edge_cases_are_handled}

**Testing Instructions for User:**
{clear_step_by_step_testing_instructions}

## Quality Assurance
- **Code Review:** {self_review_completed}
- **Documentation Updated:** {yes/no/not_applicable}
- **Similar Issues:** {checked_for_similar_patterns}
- **Prevention Measures:** {added_safeguards_or_validation}
```

## 🚨 Critical Bug Template

### Emergency Bug Report
```markdown
#### 🚨 CRITICAL BUG-{number}: {Urgent_Issue_Title}
**Severity:** CRITICAL | **Status:** BLOCKING | **Priority:** P0
**Discovered:** {YYYY-MM-DD HH:mm:ss}
**Impact:** {system_down/data_loss/security_breach/etc}

## IMMEDIATE IMPACT
- **System Status:** {operational/degraded/down}
- **Users Affected:** {count_or_percentage}
- **Business Impact:** {revenue/reputation/compliance_risk}
- **Data At Risk:** {type_and_scope_of_data_exposure}

## CRITICAL DETAILS
**Error Description:** {what_is_happening}
**Trigger Condition:** {what_causes_this_to_occur}
**Frequency:** {every_time/intermittent/specific_conditions}

## IMMEDIATE RESPONSE REQUIRED
### Emergency Actions Taken
- [ ] {immediate_mitigation_step_1}
- [ ] {immediate_mitigation_step_2}
- [ ] {immediate_mitigation_step_3}

### Investigation Priority
1. **URGENT:** {most_critical_investigation_step}
2. **HIGH:** {secondary_investigation_step}
3. **MEDIUM:** {follow_up_investigation_step}

## ESCALATION
**User Notification Required:** {yes/no}
**Timeline for Fix:** {immediate/within_hours/within_day}
**Workaround Available:** {yes_description/no}

### Progress Updates
**{time}:** {status_update}
**{time}:** {status_update}
**{time}:** {status_update}
```

## 📊 Bug Analytics Template

### Bug Tracking Dashboard
```markdown
# Bug Analytics - {time_period}

## Bug Statistics
**Total Bugs:** {total_count}
**Open Bugs:** {open_count}  
**Resolved Bugs:** {resolved_count}
**Bug Resolution Rate:** {percentage}%

### Bugs by Severity
- **Critical:** {count} ({percentage}%)
- **High:** {count} ({percentage}%)
- **Medium:** {count} ({percentage}%)
- **Low:** {count} ({percentage}%)

### Bugs by Feature/Component
| Component | Total | Open | Resolved | Resolution Rate |
|-----------|-------|------|----------|----------------|
| {component_1} | {total} | {open} | {resolved} | {percentage}% |
| {component_2} | {total} | {open} | {resolved} | {percentage}% |

## Bug Trends
### Resolution Time Analysis
- **Average Resolution Time:** {hours}h
- **Critical Bug Avg Time:** {hours}h
- **High Priority Avg Time:** {hours}h
- **Medium Priority Avg Time:** {hours}h

### Bug Discovery Patterns
- **Most Common Bug Types:** {list_top_3_types}
- **Most Affected Components:** {list_components}
- **Peak Discovery Times:** {when_bugs_are_found_most}

## Quality Metrics
### Bug Prevention Effectiveness
- **Bugs per Feature:** {average_ratio}
- **Regression Rate:** {percentage}%
- **User-Reported vs Dev-Found:** {ratio}

### Resolution Efficiency
- **First-Time Fix Rate:** {percentage}%
- **Reopened Bugs:** {count} ({percentage}%)
- **Average Investigation Time:** {hours}h
```

## 🔄 Bug Lifecycle Template

### Bug Status Transitions
```markdown
## Bug Lifecycle Tracking - BUG-{number}

### Status History
| Date | Time | Status | Action | Notes |
|------|------|--------|--------|--------|
| {date} | {time} | Found | Initial Report | {discovery_context} |
| {date} | {time} | InProgress | Investigation Started | {assigned_to} |
| {date} | {time} | Fixed | Solution Implemented | {fix_description} |
| {date} | {time} | Testing | User Validation | {testing_instructions} |
| {date} | {time} | Verified | Testing Passed | {test_results} |
| {date} | {time} | Closed | Resolution Confirmed | {final_notes} |

### Time Spent by Phase
- **Discovery to Assignment:** {hours}h
- **Investigation Time:** {hours}h  
- **Implementation Time:** {hours}h
- **Testing Time:** {hours}h
- **Total Resolution Time:** {hours}h

### Quality Gates Passed
- [ ] Root cause identified
- [ ] Solution implemented
- [ ] Code review completed
- [ ] Unit tests updated
- [ ] User testing passed
- [ ] No regression detected
- [ ] Documentation updated
```

## 🎯 Bug Prevention Template

### Prevention Analysis
```markdown
## Bug Prevention Review - BUG-{number}

### Prevention Analysis
**Could This Have Been Prevented:** {yes/no/partially}

### Prevention Opportunities
1. **Better Testing:** {specific_testing_that_would_catch_this}
2. **Code Review:** {review_points_that_would_identify_issue}
3. **Validation:** {input_validation_or_checks_needed}
4. **Documentation:** {documentation_that_would_help}

### Process Improvements
**Recommended Changes:**
- {process_improvement_1}
- {process_improvement_2}
- {process_improvement_3}

**Implementation Plan:**
- [ ] {improvement_action_1}
- [ ] {improvement_action_2}
- [ ] {improvement_action_3}

### Similar Issue Prevention
**Code Patterns to Avoid:** {list_problematic_patterns}
**Defensive Coding:** {suggested_defensive_measures}
**Testing Enhancements:** {additional_test_coverage_needed}

### Learning Documentation
**Lessons Learned:** {key_takeaways}
**Best Practices:** {practices_to_follow_going_forward}
**Reference Material:** {documentation_or_examples_to_create}
```

---
**📚 Related Templates:**
- [Feature Template](./feature-template.md)
- [Progress Template](./progress-template.md)