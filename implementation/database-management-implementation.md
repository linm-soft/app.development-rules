# Database Management Implementation (Rule 2.26)

> Standardized implementation for database export/import functionality with user confirmation flows

## 🎯 RELATED STANDARDS
**📂 Design Standards References:**
- [Spacing & Padding Standards](standards/spacing-padding-standards.md) - Layout spacing and Material Design margins
- [Border & Shape Standards](standards/border-shape-standards.md) - Card corners and button styling
- [Style System Architecture](standards/style-system-architecture.md) - Button styles and text hierarchy

**📂 Implementation Standards:**
- [Database Management Component](standards/database-management-component.md) - Complete UI + Java implementation

## ⚙️ JAVA IMPLEMENTATION
**📂 Complete Implementation:** [Database Management Component](standards/database-management-component.md)

This file contains comprehensive implementation including:
- Complete Java class implementations with export/import flows
- UI layout examples with Material Design 3 styling
- User confirmation dialogs and progress indicators
- Integration steps for file handling and database operations
- Required string resources and drawable references
- Error handling and validation patterns

**📂 Note**: This implementation uses design standards from [Spacing Standards](standards/spacing-padding-standards.md), [Border Standards](standards/border-shape-standards.md), and [Style System](standards/style-system-architecture.md)

## 🔄 KEY IMPLEMENTATION FLOWS

### 1. Export Database Flow
1. **User Interaction** → Export button click
2. **Confirmation Dialog** → Show export confirmation with clear messaging
3. **Background Export** → Progress dialog during operation
4. **Result Feedback** → Success/error notification
5. **File Location** → Inform user of backup file location

### 2. Import Database Flow
1. **File Selection** → File picker integration (ActivityResultContracts)
2. **File Validation** → Verify backup file integrity
3. **Overwrite Warning** → Clear confirmation dialog about data replacement
4. **Import Process** → Progress indicator during operation
5. **Result Feedback** → Success/error notification with rollback info

## 📱 UI PATTERN REQUIREMENTS

### Layout Structure
- **Card Container** → CardView with Material Design styling
- **Section Title** → Primary text with appropriate hierarchy
- **Action Items** → Horizontal layout: Description + Action Button
- **Info Section** → Optional storage location information

### User Experience Standards
- **Confirmation Required** → Both export and import must show confirmation dialogs
- **Progress Indicators** → Show progress for operations > 2 seconds
- **Error Recovery** → Clear error messages with actionable steps
- **Accessibility** → Screen reader support and minimum touch targets

## 🔐 SECURITY CONSIDERATIONS

### File Handling
- **Storage Permissions** → Request appropriate storage access
- **File Validation** → Verify backup file format and integrity
- **Secure Storage** → Use app-specific directories when possible

### Data Protection
- **Sensitive Data** → Consider encryption for sensitive backups
- **User Consent** → Clear messaging about data being exported
- **Rollback Safety** → Maintain original data during import until success

## ✅ IMPLEMENTATION CHECKLIST

### Setup Requirements
- [ ] Add storage permissions to AndroidManifest.xml
- [ ] Configure file provider for secure file access
- [ ] Add required string resources for all dialogs and messages
- [ ] Implement base database helper methods for export/import

### UI Implementation
- [ ] Create database management section layout following standard template
- [ ] Implement export confirmation dialog with clear messaging
- [ ] Implement import confirmation dialog with overwrite warning
- [ ] Add progress dialogs for both operations
- [ ] Include optional storage info section

### Java Implementation
- [ ] Export functionality with file creation and progress tracking
- [ ] Import functionality with file validation and data replacement
- [ ] File picker integration using ActivityResultContracts
- [ ] Error handling for storage permissions and file operations
- [ ] Success/error feedback with user-friendly messages

### Testing Checklist
- [ ] Test export flow with confirmation and cancellation
- [ ] Test import flow with valid and invalid files
- [ ] Test storage permission requests and denials
- [ ] Test UI on different screen sizes and orientations
- [ ] Test accessibility features (screen reader, navigation)

### Integration Validation
- [ ] Verify backup file can be imported successfully
- [ ] Test data integrity after import operation
- [ ] Verify cleanup of temporary files
- [ ] Test rollback functionality if import fails
- [ ] Validate error messages provide actionable guidance

## 🎯 REUSABILITY NOTES

This implementation pattern can be used across all Android projects requiring data backup/restore functionality:

- **Project-Agnostic** → Template works for any database structure
- **Customizable Messaging** → Strings can be adapted to specific app context
- **Scalable Architecture** → Supports additional backup options (cloud, etc.)
- **Consistent UX** → Same user experience across all apps

## 📚 INTEGRATION EXAMPLES

### Quick Implementation Command
```
User: "add database management"
AI: Read this file → Apply template → Customize for specific database schema
```

### Customization Points
- Database schema and export format
- File naming conventions and storage locations
- Confirmation dialog messaging for specific app context
- Additional validation rules for imported data