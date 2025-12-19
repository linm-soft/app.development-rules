# File Organization & Structure Guidelines

[← Back to AI Guidelines](../ai-guidelines.md)

## 📂 NEW DOCUMENTATION ARCHITECTURE (December 17, 2025)

### 🎯 **Development Rules Structure**
- **`development-rules/`** - Development workflows, standards, and cross-platform rules
  - **`platform-rules/`** - Android/iOS specific development rules
  - **`guides/`** - Migration guides and workflow documentation
  - **`implementation/`** - Code implementation patterns
  - **`procedures/`** - Step-by-step development procedures
  - **`tool/`** - Build automation and development tools

### 📂 **Centralized Project Documentation**
- **`smart-call-block/DOCS/`** - Complete project documentation hub
  - **`android/`** - Android platform documentation
  - **`ios/`** - iOS platform documentation  
  - **`api/`** - API reference documentation
  - **Root files** - Project summary, version tracking, feature matrix

### 🔄 **Documentation Separation Logic**
- **Development Rules:** Process, standards, workflows (applies to ALL projects)
- **Project Documentation:** Technical specs, implementation details (project-specific)
- **API Documentation:** Complete API reference and integration guides

## 📋 File Organization Standards
- **Main file (ANDROID_PROJECT_RULES.md):** Quick Reference ONLY - max 3-4 lines per section
- **Category files (rules/*.md):** Quick reference with links to implementation details
- **Implementation details:** ALWAYS go in separate `implementation/*.md` files
- **Design standards:** Go in `implementation/android/*.md` for Android-specific implementations
- **Step-by-step procedures:** Go in `procedures/*.md` for detailed workflow guides
- **Navigation structure:** ANDROID_PROJECT_RULES → rules/ → implementation/android/ → procedures/

**🚨 CRITICAL: NEVER PUT JAVA CODE IN IMPLEMENTATION FILES**
- **implementation/*.md**: HIGH-LEVEL GUIDES ONLY - No Java code allowed
- **implementation/android/*.md**: COMPLETE JAVA IMPLEMENTATION - All code goes here
- **Violation Detection**: Any ```java block in implementation/*.md is WRONG

## Link Patterns
- **Rules to Implementation:** `**📂 See:** [`implementation/[topic]-implementation.md`](../implementation/[topic]-implementation.md)`
- **Rules to Standards:** `**📂 See:** [`implementation/android/[topic]-standards.md`](../implementation/android/[topic]-standards.md)`
- **Rules to Procedures:** `**📂 See:** [`procedures/[topic]-procedures.md`](../procedures/[topic]-procedures.md)`
- **Standards back to Implementation:** `[← Back to Implementation](../)`
- **Implementation back to Rules:** `[← Back to Main Rules](../ANDROID_PROJECT_RULES.md)`

## 🔄 MANDATORY Rule Creation Workflow
1. **Create quick reference** in appropriate rules/*.md file (NO Java code)
2. **Create implementation guide** in implementation/ with patterns/concepts (NO Java code)  
3. **Create complete standards file** in implementation/android/ with ALL Java code
4. **Create detailed procedures** in procedures/ for step-by-step workflows (if needed)
5. **Validate separation**: Implementation = concepts, Standards = code, Procedures = step-by-step workflows
6. **Update navigation links** in all affected files

## 📋 MANDATORY Implementation File Requirements

**⚠️ EVERY implementation/*.md file MUST include:**

### 🚨 ZERO TOLERANCE: NO JAVA CODE POLICY
```
❌ FORBIDDEN IN implementation/*.md:
- Any ```java code blocks  
- Complete class implementations
- Method implementations with code bodies
- Detailed code examples

✅ ALLOWED IN implementation/*.md:
- High-level pattern descriptions
- Integration concepts and workflows
- References to standards files
- Checklists and guidelines
```

### Required Sections
**1. Standards References Section:**
```markdown
## 🎯 RELATED STANDARDS

**📂 Design Standards References:**
- [Spacing & Padding Standards](standards/spacing-padding-standards.md) - [usage description]
- [Border & Shape Standards](standards/border-shape-standards.md) - [usage description]  
- [Style System Architecture](standards/style-system-architecture.md) - [usage description]

**📂 Implementation Standards:**
- [Component Implementation](standards/component-implementation.md) - Complete UI + Java implementation
```

**2. Java Implementation Reference (MANDATORY):**
```markdown
## ⚙️ JAVA IMPLEMENTATION

**📂 Complete Implementation:** [Related Standards File](standards/component-standards.md)

This file contains comprehensive implementation including:
- Complete Java class implementations
- UI layout examples  
- Integration steps and usage patterns
- String resources and styling

**📂 Note**: This implementation uses design standards from:
- [Referenced standards] for [specific usage]
```

### Content Separation Rules
- **implementation/*.md**: Concepts, workflows, integration guides, references
- **implementation/android/*.md**: Ready-to-copy Java code, complete UI layouts
- **procedures/*.md**: Step-by-step workflows, migration guides, detailed processes  
- **NO OVERLAP**: If it's code, it belongs in android/; if it's detailed steps, it belongs in procedures/
- **NO EXCEPTIONS**: Even small code snippets must go to android/

### When to Use procedures/ Folder
**CREATE procedures/*.md files when you have:**
- Migration workflows (e.g., AlertDialog → CommonDialog)
- Step-by-step setup instructions
- Detailed troubleshooting procedures
- Multi-phase implementation processes
- Cleanup and validation workflows

**Examples of procedures/ content:**
- `commondialog-migration.md` - Complete migration workflow from AlertDialog
- `build-troubleshooting.md` - Step-by-step build failure resolution
- `database-migration.md` - Database version upgrade procedures

### Pre-Creation Validation
Before creating ANY implementation file:
- [ ] Does my content include Java code? → Move to android/
- [ ] Am I writing complete implementations? → Move to android/  
- [ ] Is this a high-level guide/concept? → Keep in implementation/
- [ ] Do I reference where the actual code lives? → Required link to android/

### Validation Checklist
Before creating/updating any rule or implementation:
- [ ] **Java Code Location Check**: Any ```java blocks? Must be in android/ file
- [ ] **Implementation File Purity**: implementation/*.md has NO code, only concepts?
- [ ] **Standards File Completeness**: android/*.md has ALL actual implementations?
- [ ] **Procedures File Purpose**: procedures/*.md contains step-by-step workflows only?
- [ ] **Reference Links**: Does implementation/ properly reference android/ and procedures/?
- [ ] **Navigation Structure**: Links follow correct pattern (rules → implementation → android → procedures)?
- [ ] **Content Separation**: Clear separation between concepts vs code vs step-by-step workflows?

## 🔍 AUTO-DETECTION RULES FOR AI
```
IF (file_path.includes("implementation/") && content.includes("```java")) {
  ERROR: "Java code detected in implementation file!"
  ACTION: "Move all Java code to android/ file"
  FIX: "Replace with reference to standards file"
}

IF (creating_new_rule && has_java_implementation) {
  WORKFLOW: "Create empty implementation guide → Create standards file → Add references"
  NEVER: "Put Java code directly in implementation file"
}
```

## 🚫 COMMON VIOLATIONS & FIXES

### ❌ VIOLATION: Java Code in Implementation Files
```markdown
<!-- WRONG: implementation/my-feature.md -->
## Implementation
```java
public class MyClass {
    public void method() {
        // implementation code
    }
}
```
```

**✅ CORRECT FIX:**
```markdown
<!-- implementation/my-feature.md -->
## ⚙️ JAVA IMPLEMENTATION
**📂 Complete Implementation:** [My Feature Standards](../android/my-feature-standards.md)
This file contains comprehensive implementation including...
```

### ❌ VIOLATION: Mixed Content in Single File
**WRONG:** Single file with both concepts and code
**✅ CORRECT FIX:** Separate into:
- **implementation/feature.md** - High-level concepts and references
- **implementation/android/feature-standards.md** - Complete Java implementations

### ❌ VIOLATION: Missing References
**WRONG:** Implementation without standards reference
**✅ CORRECT FIX:**
```markdown
## ⚙️ JAVA IMPLEMENTATION
**📂 Complete Implementation:** [Feature Standards](../android/feature-standards.md)
```