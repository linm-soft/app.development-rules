# Development Rules Documentation Index

## � Recent Critical Updates (December 18, 2025)
**iOS Project Fixed**: Resolved Xcode crash in SmartCallBlock project. See [Project Changelog](../smart-call-block/CHANGELOG_2025.md) for complete details.

## 📂 Development Rules Structure (Updated December 18, 2025)

This directory contains development guidelines, standards, and workflows that apply across all projects. For project-specific technical documentation, see the centralized DOCS/ folder in each project.

## 🎯 Core Files

### 📋 Main Guidelines
- **[ai-guidelines.md](ai-guidelines.md)** - Complete AI assistant workflow and development guidelines
- **[app-rules.md](app-rules.md)** - Universal rules for Android and iOS development
- **[workflow-commands.md](workflow-commands.md)** - AI workflow commands and user interaction patterns

## 📂 Directory Structure

### 🏗️ Platform-Specific Rules
- **[platform-rules/](platform-rules/)** - Platform-specific development standards
  - **[android-project-rules.md](platform-rules/android-project-rules.md)** - Android development rules
  - **[ios-project-rules.md](platform-rules/ios-project-rules.md)** - iOS development rules
  - **[android-ui-workflow.md](platform-rules/android-ui-workflow.md)** - Android UI workflow
  - **[ios-ui-workflow.md](platform-rules/ios-ui-workflow.md)** - iOS UI workflow

### 📚 Guides & Documentation
- **[guides/](guides/)** - Development guides and migration documentation
  - **[APPID_MIGRATION_GUIDE.md](guides/APPID_MIGRATION_GUIDE.md)** - Package ID migration procedures
  - **[documentation-migration-guide.md](guides/documentation-migration-guide.md)** - Universal documentation migration
  - **[file-organization-guidelines.md](guides/file-organization-guidelines.md)** - Documentation structure standards
  - **[ui-resource-workflow.md](guides/ui-resource-workflow.md)** - UI resource management workflow
  - **[ai-assistant-guidelines.md](guides/ai-assistant-guidelines.md)** - AI interaction guidelines
  - **[validation-procedures.md](guides/validation-procedures.md)** - Code validation procedures

### 🔧 Implementation & Procedures
- **[implementation/](implementation/)** - Code implementation patterns and standards
  - **[text-theme-resource-management.md](implementation/text-theme-resource-management.md)** - Text extraction & HTML theme generation
- **[procedures/](procedures/)** - Step-by-step development procedures
  - **[documentation-review-procedures.md](procedures/documentation-review-procedures.md)** - Documentation quality assurance
- **[rules/](rules/)** - Detailed development rule categories
- **[checklists/](checklists/)** - Development and review checklists
  - **[cross-platform-feature-implementation.md](checklists/cross-platform-feature-implementation.md)** - Feature implementation tracking
  - **iOS Checklists:**
    - **[ios-swiftui-development-checklist.md](checklists/ios/ios-swiftui-development-checklist.md)** - iOS SwiftUI development standards
    - **[ios-callkit-integration-checklist.md](checklists/ios/ios-callkit-integration-checklist.md)** - CallKit integration guidelines
    - **[ios-xcode-crash-troubleshooting.md](checklists/ios/ios-xcode-crash-troubleshooting.md)** - Xcode crash troubleshooting guide
- **[actions/](actions/)** - Automated development actions
- **[tool/](tool/)** - Build automation and development tools
  - **[validate-ios-text-encoding.ps1](tool/validate-ios-text-encoding.ps1)** - Text encoding and smart quotes validator/fixer
  - **[validate_ios_project.ps1](tool/validate_ios_project.ps1)** - iOS project structure validator

## 🔄 Documentation Separation

### Development Rules (This Location)
**Purpose:** Universal development standards, workflows, and automation for ALL projects
- ✅ **Process Guidelines** - How to develop features across any project
- ✅ **Code Standards** - Universal coding conventions and best practices
- ✅ **Workflow Automation** - Build scripts and development tools
- ✅ **Migration Guides** - Package ID and project migration procedures
- ✅ **Quality Assurance** - Code review and validation checklists

### Project Documentation ([project]/DOCS/)
**Purpose:** Project-specific technical implementation and architecture
- ✅ **Technical Specifications** - Architecture and database design
- ✅ **API Documentation** - Complete API reference and integration guides
- ✅ **Build Instructions** - Platform-specific build and setup procedures
- ✅ **Implementation Details** - Feature implementation and system design
- ✅ **Version Management** - Release tracking and feature matrices

## 🎯 Usage Guidelines

### For AI Assistants
1. **Start with:** [ai-guidelines.md](ai-guidelines.md) for complete workflow instructions
2. **Platform Detection:** Auto-route to appropriate platform-rules file
3. **Cross-Platform Projects:** Use [app-rules.md](app-rules.md)
4. **Technical Details:** Reference project-specific `[project]/DOCS/` for implementation
5. **Universal Application:** Apply these rules to ANY project (smart-call-block, daily-speak, etc.)
6. **Documentation Migration:** Use [documentation-migration-guide.md](guides/documentation-migration-guide.md)
7. **Quality Assurance:** Follow [documentation-review-procedures.md](procedures/documentation-review-procedures.md)

### For Developers
1. **Development Standards:** Reference platform-rules for coding guidelines
2. **Migration Tasks:** Use guides/ for package migration and project updates
3. **Build Automation:** Use tool/ for build scripts and automation
4. **Technical Implementation:** Reference project-specific DOCS/ for architecture details
5. **New Projects:** Use these guidelines as foundation for any new app

## 📈 Maintenance

### Update Process
- **Monthly Reviews** - Validate guidelines against current practices
- **Project Updates** - Sync with project-specific documentation changes
- **Tool Maintenance** - Update build scripts and automation tools
- **Quality Assurance** - Review checklists and validation procedures

### Version Control
- **Change Tracking** - Document all guideline modifications
- **Backward Compatibility** - Maintain compatibility with existing projects
- **Migration Support** - Provide upgrade paths for guideline changes

---

*Development Rules Documentation maintained by development team*  
*Last updated: December 18, 2025*