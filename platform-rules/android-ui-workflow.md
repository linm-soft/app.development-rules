# Android UI/Icon Resource Workflow Commands

> Quick reference commands for AI when handling Android rules with UI resources

## 🎯 DETECTION COMMANDS

### Auto-Detect UI Resource Needs
```
Keywords triggering confirmation: UI, icon, layout, design, visual, drawable, dialog, button, color, theme
File patterns: *.xml in /res/, *.png, *.svg, layout_*, ic_*, color*, string*
Rule patterns: Custom UI, Dialog system, Icon framework, Theme implementation
```

### Confirmation Prompt Template
```
🔍 RESOURCE CONFIRMATION NEEDED:

New rule [X.XX - Rule Name] requires UI resources:
✅ Icons: [list all .xml icon files needed]
✅ Layouts: [list all .xml layout files needed]  
✅ Colors: [list color resource names needed]
✅ Strings: [list string resource names needed]
✅ Other: [animations, styles, etc.]

📁 Copy these resources to current project?
[Yes] - Copy ALL resources and implement
[No] - Create documentation only, no files
[Custom] - Let me select specific resources

📋 Estimated files: X icons, Y layouts, Z color definitions
```

## ⚙️ RESPONSE HANDLING

### "Yes" - Full Implementation
```
1. Copy ALL resource files to appropriate /res/ folders
2. Implement Java classes using new resources
3. Create usage examples (like DialogExamples.java)
4. Update documentation with resource structure
5. Add resource files to implementation checklist
6. Show completion summary with file paths
```

### "No" - Documentation Only  
```
1. Create rule documentation with implementation guide
2. Include resource file specifications (what WOULD be copied)
3. Show code examples with placeholder resource names
4. Add note: "Resources not copied - implement manually when needed"
5. Create migration guide for future implementation
```

### "Custom" - Selective Implementation
```
1. Show interactive checklist of detected resources
2. User selects which resources to copy
3. Copy only selected resources
4. Implement partial functionality using available resources
5. Document which resources were skipped and why
6. Provide instructions for manual implementation of skipped items
```

## 📋 COMPLETION VERIFICATION

### Success Confirmation Template
```
✅ RULE [X.XX] IMPLEMENTATION COMPLETE:

📁 Resources Created:
- /drawable/ic_feature_*.xml (X files) → [project]/app/src/main/res/drawable/
- /layout/layout_feature.xml (Y files) → [project]/app/src/main/res/layout/
- /values/colors.xml → Added Z color definitions (+ dark mode variants)
- /values/strings.xml → Added W string resources

🔧 Java Implementation:
- FeatureClass.java → Uses new resource IDs correctly
- FeatureExample.java → Demonstrates usage patterns
- DialogUtils.java → Enhanced with new functionality

📖 Documentation:
- [rule-implementation.md] → Complete implementation guide
- [icon-standards.md] → Icon specifications (if applicable)
- Resource file structure documented
- Migration checklist provided

🧪 Ready for Testing:
- Examples created for immediate testing
- All resource IDs validated in code
- Multi-language support confirmed
- Dark mode support verified
```

## 🔍 VALIDATION COMMANDS

### Pre-Copy Checks
```
- [ ] All resource names follow naming conventions
- [ ] No duplicate resource IDs in target project  
- [ ] Color definitions include dark mode variants
- [ ] String resources support multi-language
- [ ] Icon sizes follow Material Design specs (24dp)
- [ ] Layout files use proper spacing standards
```

### Post-Copy Verification
```
- [ ] All copied files compile without errors
- [ ] Java classes reference correct resource IDs
- [ ] Examples demonstrate all functionality
- [ ] Documentation matches actual implementation
- [ ] Resource organization follows project structure
- [ ] No missing dependencies for new resources
```

## 🎨 RESOURCE ORGANIZATION STANDARDS

### Icon Files
```
Naming: ic_[feature]_[type].xml
Examples: ic_dialog_success.xml, ic_menu_settings.xml, ic_button_delete.xml
Location: /app/src/main/res/drawable/
Standards: 24dp, vector, Material Design 3, theme-aware tinting
```

### Layout Files  
```
Naming: layout_[component]_[variant].xml  
Examples: layout_dialog_base.xml, layout_button_confirm.xml
Location: /app/src/main/res/layout/
Standards: Material Design 3, responsive, RTL support
```

### Color Resources
```
Naming: color[Component][Purpose] 
Examples: colorDialogSuccess, colorButtonDanger, colorTextPrimary
Location: /values/colors_ui.xml + /values-night/colors_ui.xml
Standards: Material Design 3 palette, accessibility contrast
```

### String Resources
```
Naming: [feature]_[purpose]
Examples: dialog_success_title, button_confirm_text, menu_settings_label  
Location: /values/strings.xml (base) + /values-[lang]/strings.xml
Standards: Multi-language ready, descriptive naming, proper escaping
```

## 🚀 USAGE EXAMPLES

### Dialog System Implementation
```
User: "create dialog confirm system"
AI Detects: Icons (success, error, warning), layouts (dialog_base), colors (dialog types)
AI Prompts: User confirmation for resource copying
User: "Yes"  
AI Executes: Copy 6 icons + 3 layouts + 8 colors + 12 strings → Implement CommonDialog.java → Create examples
Result: Complete dialog framework ready for use
```

### Icon Standards Addition (Rule 2.17)
```
User: "add icon standards rule với icons từ smart-call-block"
AI Detects: 25+ icon files in smart-call-block/res/drawable/, icon standards needed
AI Prompts: "RESOURCE CONFIRMATION: Found 25 icons (ic_home, ic_check, ic_dialog_*, etc.) Copy to icon standards?"
User: "Yes"
AI Executes: 
✅ Create android-icon-standards.md documentation
✅ Copy all ic_*.xml files to standards implementation  
✅ Add Rule 2.17 to ANDROID_PROJECT_RULES.md
✅ Update ui-ux-rules.md with icon standards
✅ Create comprehensive icon library with categories
Result: Complete icon standards rule with 25+ production-ready icons
```

### Icon Standards Addition
```
User: "add icon standards to rule 2.16"
AI Detects: Multiple icon files, color definitions, documentation needs
AI Prompts: Resource confirmation with file list
User: "Custom" → Selects icons only, skips layouts
AI Executes: Copy icon files only → Document layout requirements → Partial implementation guide
Result: Icons available, layouts documented for future implementation
```

---

*This workflow ensures consistent resource management across all Android projects while maintaining user control over implementation scope.*