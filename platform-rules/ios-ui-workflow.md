# iOS UI/Asset Resource Workflow Commands

> Quick reference commands for AI when handling iOS rules with UI resources

## 🎯 DETECTION COMMANDS

### Auto-Detect iOS Resource Needs
```
Keywords triggering confirmation: UI, icon, asset, design, visual, SwiftUI, storyboard, xib, color, theme
File patterns: *.xcassets, *.imageset, *.colorset, *.swift (views), *.storyboard, *.xib
Rule patterns: Custom UI, SwiftUI views, Asset catalogs, Color schemes, Localizable strings
```

### Confirmation Prompt Template
```
🔍 iOS RESOURCE CONFIRMATION NEEDED:

New rule [X.XX - Rule Name] requires iOS resources:
✅ Assets: [list all .xcassets, .imageset files needed]
✅ SwiftUI Views: [list all .swift view files needed]  
✅ Colors: [list color asset names needed]
✅ Localizable Strings: [list string keys needed]
✅ Other: [storyboards, xibs, etc.]

📁 Copy these resources to current iOS project?
[Yes] - Copy ALL resources and implement
[No] - Create documentation only, no files
[Custom] - Let me select specific resources

📋 Estimated files: X assets, Y views, Z color definitions
```

## ⚙️ RESPONSE HANDLING

### "Yes" - Full Implementation
```
1. Copy ALL asset files to appropriate .xcassets folders
2. Implement Swift view classes using new assets
3. Create usage examples (like SwiftUI previews)
4. Update documentation with asset structure
5. Add asset files to implementation checklist
6. Show completion summary with file paths
```

### "No" - Documentation Only  
```
1. Create rule documentation with implementation guide
2. Include asset file specifications (what WOULD be copied)
3. Show Swift code examples with placeholder asset names
4. Add note: "Assets not copied - implement manually when needed"
5. Create migration guide for future implementation
```

### "Custom" - Selective Implementation
```
1. Show interactive checklist of detected resources
2. User selects which resources to copy
3. Copy only selected resources
4. Implement partial functionality using available assets
5. Document which resources were skipped and why
6. Provide instructions for manual implementation of skipped items
```

## 📋 COMPLETION VERIFICATION

### Success Confirmation Template
```
✅ iOS RULE [X.XX] IMPLEMENTATION COMPLETE:

📁 Assets Created:
- Assets.xcassets/Icons/ (X imagesets) → [project]/Assets.xcassets/
- Assets.xcassets/Colors/ (Y colorsets) → [project]/Assets.xcassets/
- Localizable.strings → Added Z string resources

🔧 Swift Implementation:
- FeatureView.swift → Uses new asset names correctly
- FeatureExamples.swift → SwiftUI preview examples
- AssetManager.swift → Enhanced with new functionality

📖 Documentation:
- [rule-implementation.md] → Complete implementation guide
- [ios-asset-standards.md] → Asset specifications (if applicable)
- Asset catalog structure documented
- Migration checklist provided

🧪 Ready for Testing:
- SwiftUI previews created for immediate testing
- All asset names validated in code
- Multi-language support confirmed
- Dark mode support verified (iOS 13+)
```

## 🔍 VALIDATION COMMANDS

### Pre-Copy Checks
```
- [ ] All asset names follow iOS naming conventions
- [ ] No duplicate asset names in target project  
- [ ] Color definitions include light/dark mode variants
- [ ] String resources support multi-language
- [ ] Icon sizes follow iOS Human Interface Guidelines
- [ ] Asset files use proper iOS formats (PDF, PNG)
```

### Post-Copy Verification
```
- [ ] All copied assets compile without errors
- [ ] Swift classes reference correct asset names
- [ ] SwiftUI previews demonstrate all functionality
- [ ] Documentation matches actual implementation
- [ ] Asset organization follows iOS project structure
- [ ] No missing dependencies for new assets
```

## 🎨 iOS RESOURCE ORGANIZATION STANDARDS

### Asset Catalog Structure
```
Assets.xcassets/
├── AppIcon.appiconset/
├── Colors/
│   ├── Primary.colorset
│   ├── Secondary.colorset
│   └── Accent.colorset
├── Icons/
│   ├── home.imageset
│   ├── settings.imageset
│   └── success.imageset
└── Images/
    ├── background.imageset
    └── logo.imageset
```

### Icon Assets
```
Naming: descriptive_name (e.g., home, settings, success)
Format: PDF (vector) or PNG @1x, @2x, @3x
Location: Assets.xcassets/Icons/
Standards: iOS Human Interface Guidelines, SF Symbols compatibility
```

### Color Assets
```
Naming: PascalCase (e.g., PrimaryBackground, AccentColor)
Location: Assets.xcassets/Colors/
Standards: Support Any/Dark appearance, accessibility contrast
```

### Localizable Strings
```
Naming: feature.purpose (e.g., dialog.success.title, button.confirm.text)
Location: 
- Base: Localizable.strings
- Localized: [lang].lproj/Localizable.strings
Standards: Multi-language ready, proper escaping, NSLocalizedString usage
```

### SwiftUI View Files
```
Naming: ComponentView.swift (e.g., DialogView.swift, ButtonView.swift)
Location: Views/[Feature]/
Standards: SwiftUI best practices, iOS 14+ compatibility, preview support
```

## 🚀 USAGE EXAMPLES

### iOS Dialog System Implementation
```
User: "create SwiftUI dialog confirm system"
AI Detects: Icons (success, error, warning), colors (dialog types), strings (titles/messages)
AI Prompts: User confirmation for resource copying
User: "Yes"  
AI Executes: Copy 6 icons + 3 color sets + 12 strings → Implement DialogView.swift → Create previews
Result: Complete SwiftUI dialog framework ready for use
```

### iOS Asset Standards Addition
```
User: "add iOS asset standards rule with icons from smart-call-block"
AI Detects: Multiple .imageset files in Assets.xcassets, asset standards needed
AI Prompts: "RESOURCE CONFIRMATION: Found iOS assets (home, check, dialog_*, etc.) Copy to asset standards?"
User: "Yes"
AI Executes: 
✅ Create ios-asset-standards.md documentation
✅ Copy all .imageset files to standards implementation  
✅ Add Asset Management rule to IOS_PROJECT_RULES.md
✅ Create comprehensive asset library with categories
Result: Complete iOS asset standards rule with production-ready assets
```

### SwiftUI Component Library
```
User: "add SwiftUI component library to rule 2.16"
AI Detects: Multiple SwiftUI view files, color definitions, documentation needs
AI Prompts: Resource confirmation with file list
User: "Custom" → Selects views only, skips assets
AI Executes: Copy SwiftUI files only → Document asset requirements → Partial implementation guide
Result: SwiftUI components available, assets documented for future implementation
```

---

*This workflow ensures consistent iOS resource management across all iOS projects while maintaining user control over implementation scope.*