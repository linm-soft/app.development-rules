# Session Management Commands

## 💾 Session State Commands

### Save State
```bash
"Save AI session state for rate limit recovery"
# Updates {app}_context.md with current work
# Documents exact stopping point
# Saves environment state
```

```bash
"Emergency session save"
# Quick save for immediate interruption
# Minimal essential info only
```

```bash
"Create session checkpoint: {description}"
# Named checkpoint for complex work
# Example: "Create session checkpoint: before_major_refactor"
```

### Resume State
```bash
"Resume AI session from last checkpoint"
# Reads {app}_context.md
# Validates environment
# Continues from exact stopping point
```

```bash
"Resume session with progress review"
# Reads context + summarizes what was done
# Plans next steps
# Asks for user confirmation
```

```bash
"Emergency recovery - show me where we left off"
# Quick state assessment
# Immediate continuation plan
```

## 🤖 Model Management Commands

### Model Changes
```bash
"Review project progress and current plan"
# For new AI model taking over
# Reads all .ai-progress files
# Creates continuation plan
```

```bash
"Provide complete model change handoff summary"
# Detailed analysis of all previous work
# Technical decisions made
# Code patterns established
```

```bash
"Compare capabilities with previous model and plan continuation"
# Capability assessment
# Identifies differences
# Recommends approach
```

### Consistency Commands
```bash
"Continue work with exact same patterns and decisions"
# Conservative mode
# Matches all previous approaches
# No deviations from established patterns
```

```bash
"Validate model transition and show readiness"
# Confirms new model understands context
# Shows capability alignment
# Requests user confirmation
```

## 🔄 Session Workflow Commands

### Session Initialization
```bash
"Initialize new AI session for project: {app}"
# Sets up workspace context
# Reviews project state
# Prepares for work
```

```bash
"Quick session start"
# Fast initialization
# Minimal context loading
# For simple tasks
```

### Session Management
```bash
"Switch focus to feature: {name}"
# Changes active work context
# Updates session focus
# Example: "Switch focus to feature: call_blocking"
```

```bash
"Pause current session work"
# Saves current state
# Marks session as paused
# Documents resumption point
```

```bash
"End session with summary"
# Creates session summary
# Updates progress files
# Prepares for next session
```

## 📊 Session Analytics Commands

### Progress Tracking
```bash
"Show session progress summary"
# What was accomplished this session
# Time spent on each task
# Efficiency metrics
```

```bash
"Compare session to previous sessions"
# Velocity comparison
# Pattern identification
# Productivity trends
```

### Time Management
```bash
"Track session time: {hours}h on {task}"
# Manual time logging
# Example: "Track session time: 2h on call blocking implementation"
```

```bash
"Show session time breakdown"
# Time spent per feature/task
# Efficiency analysis
# Time allocation review
```

## 🌐 Context Management Commands

### Context Loading
```bash
"Load full project context"
# Reads all available context files
# Builds complete picture
# For complex session start
```

```bash
"Load minimal context for: {task}"
# Task-specific context loading
# Faster initialization
# Example: "Load minimal context for: bug fixing"
```

### Context Validation
```bash
"Validate current session context"
# Confirms understanding is correct
# Identifies missing information
# Requests clarification if needed
```

```bash
"Refresh session context"
# Re-reads all context files
# Updates understanding
# Handles file changes
```

## 🔧 Environment Commands

### Environment Check
```bash
"Validate session environment"
# Checks workspace status
# Verifies file accessibility
# Confirms build status
```

```bash
"Show session environment status"
# Current directory
# Git status
# Build state
# Dependencies
```

### Environment Recovery
```bash
"Recover session environment"
# Fixes environment issues
# Restores workspace state
# Handles missing dependencies
```

```bash
"Reset session environment"
# Clean environment setup
# Removes temporary files
# Fresh start
```

## 🎯 Focus Management Commands

### Task Focus
```bash
"Set session focus: {task}"
# Defines primary work focus
# Updates context priority
# Example: "Set session focus: debugging crash reports"
```

```bash
"Switch session focus to: {new_task}"
# Changes primary focus
# Saves current work state
# Example: "Switch session focus to: UI improvements"
```

### Multi-tasking
```bash
"Show active session tasks"
# Lists all parallel work
# Shows priority order
# Time allocation per task
```

```bash
"Balance session workload"
# Optimizes task distribution
# Suggests priority adjustments
# Time management recommendations
```

## 📋 Session Planning Commands

### Work Planning
```bash
"Plan session work: {duration} hours"
# Creates work plan for time available
# Prioritizes tasks
# Example: "Plan session work: 4 hours"
```

```bash
"Estimate session completion time"
# Based on current tasks
# Provides time estimates
# Identifies potential delays
```

### Goal Setting
```bash
"Set session goals: {goals_list}"
# Defines session objectives
# Creates success criteria
# Example: "Set session goals: Complete call blocking, Start UI themes"
```

```bash
"Review session goal progress"
# Tracks goal completion
# Identifies obstacles
# Adjusts expectations
```

## 🚨 Emergency Session Commands

### Crisis Management
```bash
"Emergency session state save"
# Immediate state preservation
# For critical interruptions
# Minimal data loss
```

```bash
"Session crash recovery"
# Restores from last known state
# Identifies lost work
# Plans recovery strategy
```

### Quick Actions
```bash
"Quick session summary"
# Rapid overview of current state
# Essential information only
# For time-critical situations
```

```bash
"Session backup to safe state"
# Creates recovery point
# Preserves current work
# Allows safe experimentation
```

## 📞 Communication Commands

### Status Communication
```bash
"Generate session status report"
# Formal progress report
# For user/stakeholder communication
# Professional format
```

```bash
"Show session accomplishments"
# What was completed
# Value delivered
# Next steps
```

### Collaboration Commands
```bash
"Prepare session handoff to: {person/team}"
# Documentation for human handoff
# Technical details
# Continuation instructions
```

```bash
"Create session collaboration summary"
# Multi-person work coordination
# Task distribution
# Communication requirements
```

## 💬 Chat History Management Commands

### Long History Detection
```bash
"Check chat history length and recommend action"
# Evaluates current conversation length
# Recommends continue/new chat/summary needed
```

```bash
"Assess context clarity and chat efficiency"
# Reviews if current context is becoming cluttered
# Suggests optimization strategies
```

### New Chat Decision
```bash
"Evaluate need for new chat session"
# Analyzes current situation for new chat recommendation
# Considers history length, complexity, new features
```

```bash
"Recommend new chat for feature: {name}"
# Specific evaluation for starting new feature
# Example: "Recommend new chat for feature: data_backup"
```

### Comprehensive Summary Creation
```bash
"Create complete project handoff summary"
# Generates comprehensive context document
# Includes all technical decisions, patterns, and current state
```

```bash
"Generate new chat initialization summary"
# Creates summary optimized for new session startup
# Focus on continuation without research
```

### New Chat Transition
```bash
"Prepare new chat session with full context"
# Creates summary and prepares transition
# Provides user with new chat recommendation
```

```bash
"Save comprehensive context for new session"
# Updates all progress files with complete state
# Prepares for seamless handoff
```

### New Chat Initialization Commands
```bash
"Initialize new session from project summary"
# First command in new chat to load context
# Reads comprehensive summary and validates understanding
```

```bash
"Validate new session context and show readiness"
# Confirms new AI has complete understanding
# Shows continuation plan for user approval
```

```bash
"Resume project work from handoff summary"
# Continues work from previous session's comprehensive summary
# Maintains all established patterns and decisions
```

## 🎯 Command Usage Patterns

### Timing Patterns
- **Session Start:** Use initialization and context loading commands
- **During Work:** Use focus and progress tracking commands
- **Before Rate Limit:** Use save state commands
- **After Break:** Use resume and validation commands
- **Session End:** Use summary and handoff commands

### Emergency Patterns
- **Rate Limit Approaching:** `"Save AI session state for rate limit recovery"`
- **Unexpected Interruption:** `"Emergency session save"`
- **Lost Context:** `"Emergency recovery - show me where we left off"`
- **Model Change:** `"Review project progress and current plan"`

### Efficiency Patterns
- **Fast Start:** `"Quick session start"` + `"Load minimal context"`
- **Deep Work:** `"Load full project context"` + `"Set session focus"`
- **Multi-task:** `"Show active session tasks"` + `"Balance session workload"`
- **Time Management:** `"Plan session work"` + `"Track session time"`

---
**📚 Related References:**
- [Feature Commands](./feature-commands.md)
- [Testing Commands](./testing-commands.md)
- [Rate Limit Recovery](../workflows/rate-limit-recovery.md)