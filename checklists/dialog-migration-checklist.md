# Dialog Migration Checklist Template

> Use this checklist when migrating from AlertDialog to Common Dialog Framework (Rule 2.16)

**📖 For detailed migration procedures, see: [CommonDialog Migration Procedures](../procedures/commondialog-migration.md)**

## � RECENT FRAMEWORK UPDATES (2025-12-15)
- ✅ **NullPointerException fixes** - Stable context handling
- ✅ **Custom layout optimization** - Direct view usage, no containers
- ✅ **Duplicate button prevention** - Clean UI for custom layouts
- ✅ **Simplified background system** - Native look and feel

## �📋 PROJECT: [Project Name]
**Date Started**: [YYYY-MM-DD]  
**Developer**: [Your Name]  
**Estimated Dialogs**: [Number]

---

## 🎯 MIGRATION STRATEGY

### Phase 1: Assessment (Required Before Starting)
- [ ] **Inventory existing dialogs**: Count all AlertDialog usages
- [ ] **Categorize by complexity**: Simple vs Complex vs Custom layouts
- [ ] **Identify Common Dialog candidates**: Which can use standard types?
- [ ] **Document exceptions**: What requires custom AlertDialog implementation?

### Phase 2: Framework Setup (One-time)
- [ ] **Copy Common Dialog Framework** to project
- [ ] **Verify framework compiles** without errors
- [ ] **Test sample dialog** shows correctly
- [ ] **Confirm DialogUtils integration** works

### Phase 3: Migration Execution

#### New Dialogs (MANDATORY)
- [ ] **All new dialogs use Common Dialog Framework**
- [ ] **No new AlertDialog.Builder usage**
- [ ] **Code review verification**

#### Existing Simple Dialogs (On-touch basis)
- [ ] **Confirm dialogs**: Replace with `DialogType.CONFIRM`
- [ ] **Success dialogs**: Replace with `DialogType.SUCCESS`
- [ ] **Error dialogs**: Replace with `DialogType.ERROR`
- [ ] **Info dialogs**: Replace with `DialogType.INFO`

#### Existing Complex Dialogs (Major refactor only)
- [ ] **Custom form dialogs**: Migrate to `DialogType.CUSTOM`
- [ ] **Multi-step wizards**: Consider if Common Dialog appropriate
- [ ] **Performance-critical dialogs**: Document why keeping AlertDialog

### Phase 4: Cleanup & Removal ⚠️ 
**CRITICAL: Only after all testing passes**

#### Old Code Removal Checklist
- [ ] **Remove AlertDialog imports**: Clean up unused import statements
- [ ] **Remove old dialog helper methods**: Delete unused utility functions
- [ ] **Remove unused dialog layouts**: Delete layout files no longer referenced
- [ ] **Run compliance check**: Verify zero AlertDialog references remain
- [ ] **Final testing**: Confirm all dialogs still work after cleanup

**🚨 Quick Cleanup Verification Commands:**
```powershell
# Check for remaining AlertDialog references
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | Select-String 'AlertDialog'

# Should return ZERO results after cleanup
```

---

## 📝 DIALOG INVENTORY

### Simple Dialogs (Easy Migration)
| File | Method | Current Type | Target Type | Status | Notes |
|------|--------|--------------|-------------|---------|-------|
| MainActivity.java | showDeleteConfirm() | AlertDialog | DialogType.CONFIRM | ⏳ Pending | Delete user data |
| SettingsActivity.java | showLogoutDialog() | AlertDialog | DialogType.CONFIRM | ✅ Complete | Standard logout |
| UserProfile.java | showSaveSuccess() | AlertDialog | DialogType.SUCCESS | ⏳ Pending | Profile saved |

### Complex Dialogs (Evaluate Carefully)
| File | Method | Current Type | Migration Decision | Reason |
|------|--------|--------------|-------------------|---------|
| QuickBlock.java | showQuickBlockDialog() | Custom Layout | Migrate to CUSTOM | Good fit for Common Dialog |
| PermissionHelper.java | showPermissionDialog() | AlertDialog | Keep AlertDialog | Third-party integration |
| DatabaseExport.java | showProgressDialog() | Custom | Migrate to LOADING | Standard loading pattern |

---

## ✅ VALIDATION CHECKLIST

### Per Dialog Migration
- [ ] **Functionality preserved**: Dialog behaves same as before
- [ ] **Styling consistent**: Matches app theme and spacing
- [ ] **Text resources**: All strings externalized
- [ ] **Button actions**: Positive/negative buttons work correctly
- [ ] **Cancellation**: Back button and outside touch behavior correct

### Project-Wide Validation  
- [ ] **No new AlertDialog imports**: Search for `import androidx.appcompat.app.AlertDialog`
- [ ] **Code review passed**: Team lead approved migration
- [ ] **UI/UX testing**: All dialogs tested in light/dark theme
- [ ] **Regression testing**: Existing functionality unaffected

---

## 📊 MIGRATION METRICS

### Progress Tracking
- **Total Dialogs Identified**: [Number]
- **Migrated to Common Dialog**: [Number] 
- **Kept as AlertDialog**: [Number]
- **New Dialogs Using Framework**: [Number]
- **Migration Completion**: [Percentage]%

### Benefits Achieved
- [ ] **Consistency**: All dialogs follow same design patterns
- [ ] **Maintainability**: Centralized dialog styling and behavior
- [ ] **Development Speed**: Faster dialog creation for new features
- [ ] **Code Quality**: Reduced code duplication

---

## 🚨 EXCEPTIONS DOCUMENTATION

### Dialogs NOT Migrated (Document Reasons)
| File | Method | Reason | Alternative Considered | Review Date |
|------|--------|--------|----------------------|-------------|
| ThirdPartyLib.java | showCustomDialog() | Library requirement | Wrapper considered | 2025-12-13 |
| PerformanceCritical.java | showFastDialog() | Performance needs | Optimization possible | 2025-12-13 |

---

## 📅 TIMELINE

- **Assessment Complete**: [Date]
- **Framework Setup**: [Date] 
- **First Migration**: [Date]
- **50% Complete**: [Date]
- **Migration Complete**: [Date]
- **Final Testing**: [Date]

---

**✅ MIGRATION COMPLETE CRITERIA:**
- All new dialogs use Common Dialog Framework
- Legacy AlertDialog usage documented and justified
- Team trained on new dialog patterns
- Documentation updated with migration outcomes