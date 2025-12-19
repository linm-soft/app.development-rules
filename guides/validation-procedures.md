# Validation Checklists & Procedures

[← Back to AI Guidelines](../AI_GUIDELINES.md)

## 📋 VALIDATION CHECKLISTS

### 🔍 File Structure Validation Checklist
- [ ] Main rules file has max 3-4 lines per section
- [ ] Category rules link to implementation details
- [ ] Java code only exists in standards/ files
- [ ] Implementation files contain concepts only
- [ ] All navigation links are present and correct
- [ ] File naming follows convention: `[topic]-[type].md`

### 🔍 Content Separation Validation
- [ ] **implementation/*.md**: Contains NO ```java blocks
- [ ] **implementation/android/*.md**: Contains ALL actual Java code
- [ ] Each implementation file references its standards counterpart
- [ ] No duplicate content between files
- [ ] Clear responsibility separation maintained

### 🔍 Navigation Link Validation
- [ ] Rules → Implementation links work
- [ ] Implementation → Standards links work
- [ ] Back-navigation links present
- [ ] No broken or circular references
- [ ] Consistent link formatting used

## 🚨 VIOLATION DETECTION & REPORTING

### Auto-Detection Rules
```
VIOLATION_1: Java code in implementation/*.md files
- DETECTION: Search for "```java" in implementation/ directory
- ACTION: Move all Java code to standards/ equivalent
- FIX: Replace with reference link to standards file

VIOLATION_2: Missing standards reference in implementation
- DETECTION: Implementation file without "Complete Implementation:" section  
- ACTION: Add mandatory standards reference
- FIX: Include proper standards file link with description

VIOLATION_3: Mixed content in single file
- DETECTION: File contains both concepts AND complete code
- ACTION: Separate into implementation + standards files
- FIX: Move code to standards/, keep concepts in implementation/
```

### 📊 Validation Report Format
```markdown
## FILE ORGANIZATION VALIDATION REPORT

**📂 Files Checked:** [count]
**⚠️ Violations Found:** [count]
**✅ Compliance Rate:** [percentage]

### VIOLATIONS DETECTED:
1. **[Violation Type]** - [File Path]
   - Issue: [Description]
   - Fix Required: [Action needed]
   - Priority: [High/Medium/Low]

### COMPLIANCE STATUS:
- ✅ Proper file separation: [file list]
- ⚠️ Needs fixes: [file list with issues]
- ❌ Major violations: [file list with critical issues]

### NEXT ACTIONS:
1. [Priority 1 fixes]
2. [Priority 2 fixes]  
3. [Priority 3 fixes]
```

## 🔄 REVIEW PROCEDURES

### Pre-Commit Validation
Before any file changes:
1. Run structure validation checklist
2. Verify no Java code in implementation/ 
3. Confirm all references are valid
4. Test navigation links work
5. Validate file naming conventions

### Post-Change Verification
After file modifications:
1. Re-validate entire affected section
2. Check for broken links
3. Verify content separation maintained
4. Test all navigation paths
5. Update any cross-references needed

### Periodic Compliance Review
Monthly validation process:
1. Full structure scan for violations
2. Link validation across all files  
3. Content duplication detection
4. Naming convention compliance check
5. Generate compliance report

## 🎯 COMPLIANCE SCORING

### Scoring Criteria
- **File Separation (40 points)**: Proper implementation vs standards separation
- **Link Structure (25 points)**: Working navigation and references
- **Content Quality (20 points)**: No duplication, clear purpose
- **Naming Convention (10 points)**: Consistent file naming
- **Structure Compliance (5 points)**: Follows hierarchy rules

### Score Thresholds
- **95-100**: Excellent compliance
- **85-94**: Good compliance, minor fixes needed
- **70-84**: Moderate compliance, review required
- **Below 70**: Poor compliance, major restructuring needed

## 🚀 OPTIMIZATION TARGETS

### File Length Targets
- **Main rules files**: Max 200 lines
- **Category rules**: Max 150 lines  
- **Implementation guides**: Max 300 lines
- **Standards files**: No limit (complete implementations)

### Organization Efficiency
- Maximum 3 levels deep in any section
- Each section must have clear entry and exit points
- Related content must be cross-linked
- Avoid orphaned files without clear purpose

### Performance Metrics
- Time to find specific rule: < 30 seconds
- Navigation steps to implementation: ≤ 2 clicks
- Link failure rate: < 1%
- Duplicate content ratio: < 5%