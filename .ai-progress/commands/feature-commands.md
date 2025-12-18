# Feature Commands Reference

## 🚀 Feature Management Commands

### Starting Features
```bash
"Start feature tracking: {name}"
# Creates: .ai-progress/features/implement_{name}_{timestamp}.md
# Updates: {app}_main_progress.md with new feature
# Example: "Start feature tracking: call_blocking"
```

```bash
"Start feature implementation: {description}"  
# Alternative command format
# Example: "Start feature implementation: Add dark mode support"
```

### Progress Updates
```bash
"Update feature progress: {name} - {status}"
# Updates progress in feature file and main progress
# Status examples: "30%", "core complete", "debugging", "testing ready"
# Example: "Update feature progress: call_blocking - 60% core implementation done"
```

```bash
"Update feature status: {name} to {milestone}"
# Updates to specific milestone
# Example: "Update feature status: ui_themes to testing phase"
```

### Feature Completion
```bash
"Complete feature implementation: {name}"
# Triggers testing validation workflow
# Prompts user for testing
# Example: "Complete feature implementation: call_blocking"
```

```bash
"Mark feature ready for testing: {name}"
# Alternative completion command
# Example: "Mark feature ready for testing: dark_mode"
```

### Feature Queries
```bash
"Show active feature implementations"
# Lists all features in .ai-progress/features/
# Shows progress percentage and status
```

```bash
"Show feature details: {name}"
# Shows detailed status of specific feature
# Example: "Show feature details: call_blocking"
```

```bash
"List current features and progress"
# Alternative query format
```

## 🔍 Feature Status Commands

### Progress Overview
```bash
"Show project progress overview"
# Shows all active features with percentages
# Estimates remaining time
# Shows blockers and issues
```

```bash
"Calculate total project completion"
# Calculates weighted progress across all features
# Shows overall timeline
```

### Time Tracking
```bash
"Show time spent on feature: {name}"
# Displays time breakdown for specific feature
# Example: "Show time spent on feature: call_blocking"
```

```bash
"Update feature time: {name} +{hours}h"
# Adds time to feature tracking
# Example: "Update feature time: ui_themes +2h"
```

```bash
"Show total development time"
# Aggregates time across all features
# Shows efficiency metrics
```

### Feature Health Check
```bash
"Check feature health: {name}"
# Reviews feature for blockers, issues, stale progress
# Example: "Check feature health: data_backup"
```

```bash
"Review stale features"
# Identifies features without recent updates
# Suggests actions for stuck features
```

## 🐛 Bug and Issue Commands

### Bug Logging
```bash
"Log bug in feature: {name} - {description}"
# Adds bug entry to feature file
# Example: "Log bug in feature: call_blocking - Memory leak in service"
```

```bash
"Report critical issue: {name} - {description}"
# Creates high-priority bug entry
# Example: "Report critical issue: app_crash - Null pointer in MainActivity"
```

### Bug Resolution
```bash
"Mark bug fixed: {name} - {bug_id}"
# Updates bug status to fixed
# Example: "Mark bug fixed: call_blocking - BUG-001"
```

```bash
"Close bug with solution: {name} - {bug_id} - {solution}"
# Marks bug as resolved with description
# Example: "Close bug with solution: ui_themes - BUG-002 - Added null check"
```

### Bug Queries
```bash
"Show bugs in feature: {name}"
# Lists all bugs for specific feature
# Example: "Show bugs in feature: call_blocking"
```

```bash
"Show all critical bugs"
# Lists high-priority bugs across all features
```

## 📊 Analytics Commands

### Feature Analytics
```bash
"Analyze feature complexity: {name}"
# Estimates remaining work and difficulty
# Example: "Analyze feature complexity: call_blocking"
```

```bash
"Compare feature progress rates"
# Shows development velocity for each feature
# Identifies fast/slow features
```

### Project Analytics
```bash
"Show development velocity"
# Calculates features completed per time period
# Shows trends and efficiency
```

```bash
"Estimate project completion time"
# Based on current progress rates
# Gives confidence intervals
```

## 🎯 Priority and Planning Commands

### Priority Management
```bash
"Set feature priority: {name} to {level}"
# Levels: critical, high, medium, low
# Example: "Set feature priority: call_blocking to critical"
```

```bash
"Reorder feature priorities"
# Interactive priority assignment
# Based on user input
```

### Planning Commands
```bash
"Create feature implementation plan: {description}"
# Breaks down large feature into phases
# Creates timeline and dependencies
# Example: "Create feature implementation plan: Complete backup system"
```

```bash
"Review feature dependencies"
# Identifies feature interdependencies
# Suggests optimal implementation order
```

## 🔄 Workflow Commands

### Feature Workflow
```bash
"Pause feature work: {name}"
# Saves current state for later resumption
# Example: "Pause feature work: ui_themes"
```

```bash
"Resume feature work: {name}"
# Continues paused feature from last checkpoint
# Example: "Resume feature work: ui_themes"
```

### Batch Operations
```bash
"Update all feature progress"
# Prompts for updates on all active features
# Batch update workflow
```

```bash
"Archive completed features"
# Moves all completed features to .ai-completed/
# Cleans up active progress
```

## 🚨 Emergency Commands

### Feature Rescue
```bash
"Emergency feature save: {name}"
# Saves current state immediately
# For rate limits or interruptions
# Example: "Emergency feature save: call_blocking"
```

```bash
"Recover lost feature work: {name}"
# Attempts to restore from available context
# Example: "Recover lost feature work: ui_themes"
```

### Feature Reset
```bash
"Reset feature to checkpoint: {name} - {checkpoint}"
# Rolls back to previous milestone
# Example: "Reset feature to checkpoint: call_blocking - core_complete"
```

```bash
"Restart feature implementation: {name}"
# Starts over with lessons learned
# Preserves user requirements
# Example: "Restart feature implementation: data_backup"
```

## 📝 Documentation Commands

### Auto-Documentation
```bash
"Generate feature documentation: {name}"
# Creates comprehensive feature docs
# Example: "Generate feature documentation: call_blocking"
```

```bash
"Update feature README: {name}"
# Updates relevant documentation files
# Example: "Update feature README: ui_themes"
```

### Cross-References
```bash
"Link feature to documentation: {name}"
# Creates links between feature and project docs
# Example: "Link feature to documentation: call_blocking"
```

```bash
"Sync feature to project documentation"
# Updates main project docs with feature info
```

## 🎯 Command Patterns

### Command Structure
```
Action + Target + Details
│       │        │
│       │        └── Specific parameters
│       └── Feature name or scope  
└── What to do
```

### Common Patterns
- **Progress Updates:** Always include percentage or milestone
- **Time Tracking:** Use `+{hours}h` format for additions
- **Bug References:** Use feature_name + bug_id format
- **Status Changes:** Use "to {new_status}" format
- **Queries:** Start with "Show" or "List" for read operations

### Error Handling
If command not recognized, AI should:
1. Suggest closest matching command
2. Ask for clarification
3. Provide command examples
4. Show available commands for the context

---
**📚 Related References:**
- [Session Commands](./session-commands.md)
- [Testing Commands](./testing-commands.md)
- [Feature Templates](../templates/feature-template.md)