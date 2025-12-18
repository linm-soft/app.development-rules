# Documentation Migration Guide

[← Back to AI Guidelines](../ai-guidelines.md)

## 📋 Universal Documentation Migration Protocol

This guide provides step-by-step procedures for migrating any project documentation to follow the universal standards defined in development-rules.

## 🎯 Migration Overview

### Purpose
Convert existing project documentation to the universal structure that ensures:
- ✅ **Consistency** across all projects
- ✅ **Discoverability** of technical information
- ✅ **Maintainability** of documentation
- ✅ **AI-friendly** navigation and automation

### Target Structure
```
[project]/
├── DOCS/
│   ├── README.md                     # Documentation index
│   ├── project-summary.md            # Project overview & status
│   ├── version-tracking.md           # Version history & roadmap
│   ├── feature-tracking.md           # Feature implementation matrix
│   ├── android/
│   │   ├── architecture.md           # Android system design
│   │   ├── build-guide.md           # Build instructions
│   │   ├── database-schema.md       # Database design
│   │   ├── setup-guide.md           # Configuration & setup
│   │   └── monetization-system.md   # Billing integration
│   ├── ios/
│   │   ├── architecture.md           # iOS system design
│   │   ├── build-guide.md           # Build instructions
│   │   ├── database-schema.md       # Database design
│   │   ├── setup-guide.md           # Configuration & setup
│   │   └── monetization-system.md   # Billing integration
│   └── api/
│       ├── README.md                 # API documentation index
│       ├── android-api-reference.md # Android API reference
│       └── ios-api-reference.md     # iOS API reference
```

## 🔍 Pre-Migration Assessment

### Step 1: Documentation Inventory
**AI should scan for existing documentation:**

```yaml
Current Documentation Scan:
  Platform Docs:
    - Android: [list found android docs]
    - iOS: [list found ios docs]
  API Documentation: [list api docs]
  Build Documentation: [list build guides]
  Architecture Documentation: [list architecture docs]
  Scattered Files: [list docs in wrong locations]
  Missing Files: [list missing required files]
```

### Step 2: Content Classification
**Categorize existing content:**

| Content Type | Current Location | Target Location |
|--------------|------------------|-----------------|
| Architecture docs | Various | `DOCS/[platform]/architecture.md` |
| Build guides | Various | `DOCS/[platform]/build-guide.md` |
| API references | Various | `DOCS/api/[platform]-api-reference.md` |
| Database schemas | Various | `DOCS/[platform]/database-schema.md` |
| Setup instructions | Various | `DOCS/[platform]/setup-guide.md` |

### Step 3: Link Analysis
**Map all cross-references that need updating:**

```yaml
Reference Mapping:
  Internal Links: [list links between docs]
  External References: [list refs from development-rules]
  Broken Links: [identify broken references]
  Update Required: [list links needing updates]
```

## 🚀 Migration Execution

### Phase 1: Structure Creation
```bash
# Create universal directory structure
mkdir -p [project]/DOCS/{android,ios,api}

# Create all required files with templates
touch [project]/DOCS/README.md
touch [project]/DOCS/project-summary.md
touch [project]/DOCS/version-tracking.md
touch [project]/DOCS/feature-tracking.md
touch [project]/DOCS/android/{architecture,build-guide,database-schema,setup-guide,monetization-system}.md
touch [project]/DOCS/ios/{architecture,build-guide,database-schema,setup-guide,monetization-system}.md
touch [project]/DOCS/api/{README,android-api-reference,ios-api-reference}.md
```

### Phase 2: Content Migration
**For each existing documentation file:**

1. **Identify content category** (architecture, build, API, etc.)
2. **Extract relevant sections** from source file
3. **Adapt content** to universal template format
4. **Merge content** into target file
5. **Update version information** and cross-references

### Phase 3: Template Application
**Use these universal templates:**

#### Documentation Index Template
```markdown
# [Project Name] Documentation

## 📁 Documentation Structure
[Standard navigation structure]

## 🗂️ Documentation Sections
[Platform documentation links]

## 🔧 API Reference
[API documentation links]

---
*Documentation maintained by [project] development team*
*Last updated: [date]*
```

#### Project Summary Template
```markdown
# [Project Name] - Project Summary

## 📱 Version Information
- **Android:** v[version] (Build [build]) - Target SDK [sdk]
- **iOS:** v[version] (Build [build]) - iOS [min-version]+
- **Package ID:** [package-id]
- **Release Date:** [date]

## 📊 Development Status Overview
[Status information]

## 📱 Application Architecture
[Architecture overview]
```

#### Architecture Template
```markdown
# [Platform] Architecture - [Project Name]

## 🏗️ System Overview
[Architecture description]

## 📊 Application Structure
[Component breakdown]

## 🔄 Data Flow
[Data flow diagrams and descriptions]
```

### Phase 4: Reference Updates
**Update all cross-references:**

1. **Internal project links** → Update to new structure
2. **Development rules references** → Update to universal patterns
3. **Platform-specific links** → Ensure correct platform targeting
4. **API documentation links** → Point to centralized API docs

## ✅ Post-Migration Validation

### Automated Checks
```yaml
Structure Validation:
  - ✅ All 17 required files present
  - ✅ Correct directory structure
  - ✅ Proper file naming (lowercase-with-hyphens)

Content Validation:
  - ✅ All content properly categorized
  - ✅ Version information updated
  - ✅ Cross-references working
  - ✅ No broken links

Quality Validation:
  - ✅ Content follows universal templates
  - ✅ Consistent formatting
  - ✅ Complete API documentation
  - ✅ Platform-specific content separated
```

### Manual Review Checklist
- [ ] **Navigation** - Can users easily find information?
- [ ] **Completeness** - All technical aspects documented?
- [ ] **Accuracy** - Information current and correct?
- [ ] **Consistency** - Follows universal standards?
- [ ] **Maintenance** - Clear ownership and update process?

## 🔄 Continuous Compliance

### Regular Reviews
**Monthly documentation review:**
1. **Structure compliance** - Verify universal pattern maintained
2. **Content updates** - Ensure information current
3. **Link validation** - Check all references working
4. **Template adherence** - Confirm consistent formatting

### Automated Monitoring
**AI should periodically:**
1. **Scan documentation structure** for compliance
2. **Identify missing files** or incorrect organization
3. **Suggest improvements** for better organization
4. **Flag outdated content** based on version changes

### Migration Support for New Projects
**For new projects:**
1. **Start with universal structure** from day one
2. **Use standard templates** for all documentation
3. **Follow naming conventions** consistently
4. **Reference development-rules** for guidance

## 🛠️ Migration Tools

### AI Assistant Commands
```bash
# Structure validation
"Check documentation structure compliance"

# Content migration
"Migrate docs to universal structure"

# Reference updates
"Update all documentation cross-references"

# Validation
"Validate documentation completeness"
```

### Automation Scripts
**PowerShell migration helpers:**
- `validate-doc-structure.ps1` - Check structure compliance
- `migrate-documentation.ps1` - Automated content migration
- `update-references.ps1` - Update cross-references
- `generate-templates.ps1` - Create missing files with templates

---

*Documentation Migration Guide - Development Rules*  
*Last updated: December 17, 2025*