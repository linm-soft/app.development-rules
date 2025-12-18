# Testing Commands Reference

## 🧪 Testing Workflow Commands

### Start Testing Process
```bash
"Run feature testing validation: {name}"
# Initiates testing workflow for completed feature
# Prompts user with specific test scenarios
# Example: "Run feature testing validation: call_blocking"
```

```bash
"Start testing validation for: {name}"
# Alternative command format
# Example: "Start testing validation for: ui_themes"
```

### Testing Results
```bash
"Confirm testing results: {name} - passed"
# User confirms successful testing
# Triggers archival process
# Example: "Confirm testing results: call_blocking - passed"
```

```bash
"Confirm testing results: {name} - minor-issues"
# User reports non-critical issues
# Triggers issue resolution workflow
# Example: "Confirm testing results: ui_themes - minor-issues"
```

```bash
"Confirm testing results: {name} - failed"
# User reports critical failures
# Triggers debugging and fix workflow
# Example: "Confirm testing results: data_backup - failed"
```

### Testing Status Queries
```bash
"Show testing status for: {name}"
# Displays current testing state
# Shows pending tests and results
# Example: "Show testing status for: call_blocking"
```

```bash
"List features pending testing"
# Shows all features awaiting user validation
# Prioritizes by completion date
```

## 🔍 Test Management Commands

### Test Planning
```bash
"Generate test plan for: {name}"
# Creates comprehensive testing scenarios
# Covers edge cases and integrations
# Example: "Generate test plan for: call_blocking"
```

```bash
"Create testing checklist: {name}"
# Simple checklist format for user testing
# Example: "Create testing checklist: ui_themes"
```

### Test Coverage
```bash
"Review test coverage for: {name}"
# Analyzes completeness of testing scenarios
# Identifies gaps
# Example: "Review test coverage for: data_backup"
```

```bash
"Add test scenario to: {name} - {scenario}"
# Adds additional testing requirement
# Example: "Add test scenario to: call_blocking - international numbers"
```

## 🚨 Issue Resolution Commands

### Minor Issues
```bash
"Fix minor testing issues: {name}"
# Starts minor issue resolution
# Quick fixes for non-critical problems
# Example: "Fix minor testing issues: ui_themes"
```

```bash
"Address testing feedback: {name} - {feedback}"
# Handles specific user feedback
# Example: "Address testing feedback: call_blocking - slow response time"
```

### Critical Issues
```bash
"Debug critical testing failure: {name}"
# Comprehensive debugging process
# Root cause analysis
# Example: "Debug critical testing failure: data_backup"
```

```bash
"Investigate test failure: {name} - {failure_description}"
# Targeted investigation
# Example: "Investigate test failure: call_blocking - crashes on incoming call"
```

## 📊 Testing Analytics Commands

### Test Metrics
```bash
"Show testing success rate"
# Overall testing pass/fail statistics
# Identifies problematic features
```

```bash
"Analyze testing patterns for: {name}"
# Testing history and trends
# Common failure points
# Example: "Analyze testing patterns for: ui_features"
```

### Quality Metrics
```bash
"Calculate feature quality score: {name}"
# Based on testing results and issues
# Quality indicators and trends
# Example: "Calculate feature quality score: call_blocking"
```

```bash
"Show testing efficiency metrics"
# Time from implementation to testing pass
# Iteration counts before success
```

## 🔄 Retest Commands

### Scheduled Retesting
```bash
"Schedule retest for: {name}"
# After issue fixes
# Sets up retest workflow
# Example: "Schedule retest for: ui_themes"
```

```bash
"Execute retest: {name}"
# Runs testing validation again
# After fixes applied
# Example: "Execute retest: call_blocking"
```

### Regression Testing
```bash
"Run regression test for: {name}"
# Tests existing functionality after changes
# Ensures no breaking changes
# Example: "Run regression test for: main_features"
```

```bash
"Quick smoke test for: {name}"
# Basic functionality check
# Fast validation
# Example: "Quick smoke test for: call_blocking"
```

## 🎯 Specialized Testing Commands

### Performance Testing
```bash
"Run performance testing: {name}"
# Specific performance validation
# Memory, CPU, battery usage
# Example: "Run performance testing: call_blocking"
```

```bash
"Test app performance impact: {name}"
# Overall app performance after feature
# Example: "Test app performance impact: ui_themes"
```

### Security Testing
```bash
"Run security validation: {name}"
# Security-focused testing scenarios
# Permission and privacy checks
# Example: "Run security validation: data_backup"
```

```bash
"Test privacy compliance: {name}"
# Data privacy and GDPR compliance
# Example: "Test privacy compliance: contact_access"
```

### Integration Testing
```bash
"Test feature integration: {name}"
# Integration with existing features
# System compatibility
# Example: "Test feature integration: call_blocking"
```

```bash
"Run compatibility testing: {name}"
# Device and OS compatibility
# Example: "Run compatibility testing: ui_themes"
```

## 🛠️ Testing Automation Commands

### Automated Tests
```bash
"Generate automated tests for: {name}"
# Creates unit/integration tests
# Code-based testing
# Example: "Generate automated tests for: call_blocking"
```

```bash
"Run automated test suite"
# Executes all automated tests
# CI/CD integration
```

### Test Documentation
```bash
"Document testing procedures: {name}"
# Creates testing documentation
# For future reference
# Example: "Document testing procedures: call_blocking"
```

```bash
"Update test documentation: {name}"
# Updates existing test docs
# After changes or improvements
# Example: "Update test documentation: ui_themes"
```

## 📋 Test Reporting Commands

### Test Reports
```bash
"Generate test report: {name}"
# Comprehensive testing report
# Results, issues, recommendations
# Example: "Generate test report: call_blocking"
```

```bash
"Create testing summary for project"
# Overall project testing status
# All features combined
```

### User Communication
```bash
"Prepare testing instructions for user: {name}"
# User-friendly testing guide
# Clear step-by-step instructions
# Example: "Prepare testing instructions for user: ui_themes"
```

```bash
"Format testing results for review"
# Professional format for stakeholder review
# Executive summary style
```

## 🎯 Testing Command Patterns

### Standard Testing Flow
```
1. "Run feature testing validation: {name}"
2. User tests and responds
3. "Confirm testing results: {name} - {result}"
4. Handle result (pass/fix/debug)
5. If fixes: "Schedule retest for: {name}"
```

### Issue Resolution Flow
```
1. "Fix minor testing issues: {name}" OR "Debug critical testing failure: {name}"
2. Implement fixes
3. "Execute retest: {name}"
4. "Confirm testing results: {name} - passed"
```

### Quality Assurance Flow
```
1. "Generate test plan for: {name}"
2. "Run feature testing validation: {name}"
3. "Review test coverage for: {name}"
4. "Generate test report: {name}"
```

## 🚨 Emergency Testing Commands

### Critical Issues
```bash
"Emergency test halt: {name}"
# Stops testing due to critical issues
# Prevents further problems
# Example: "Emergency test halt: call_blocking"
```

```bash
"Critical bug found in testing: {name} - {description}"
# Reports critical testing failure
# Immediate attention required
# Example: "Critical bug found in testing: data_backup - data corruption"
```

### Recovery Commands
```bash
"Recover from failed testing: {name}"
# Systematic recovery process
# Root cause analysis and fixes
# Example: "Recover from failed testing: ui_themes"
```

```bash
"Reset testing state for: {name}"
# Clean slate for testing restart
# After major fixes
# Example: "Reset testing state for: call_blocking"
```

---
**📚 Related References:**
- [Feature Commands](./feature-commands.md)
- [Session Commands](./session-commands.md)
- [Testing Workflow](../workflows/testing-validation.md)