# Text Resource Extraction & HTML Theme Generation Rules

[← Back to AI Guidelines](../ai-guidelines.md)

## 🎯 Text Resource Extraction Workflow

### 📝 **String Resource Listing Protocol**
**When user requests text extraction from project:**

#### **Step 1: Automatic Text Discovery**
```yaml
Text Extraction Scan:
  Android Resources:
    - strings.xml: [list all string resources]
    - UI hardcoded text: [scan Java/Kotlin files]
    - Layout hardcoded text: [scan XML files]
    - Menu text: [scan menu XML files]
  
  iOS Resources:
    - Localizable.strings: [list all string resources] 
    - SwiftUI hardcoded text: [scan Swift files]
    - Storyboard text: [scan storyboard files]
    - Info.plist text: [scan plist files]
  
  Cross-Platform:
    - API response text: [scan response models]
    - Error messages: [scan error handling]
    - Validation messages: [scan validation code]
```

#### **Step 2: Text Categorization**
```yaml
Text Resource Categories:
  UI Labels:
    - Button text: [action labels]
    - Header titles: [screen titles]
    - Input placeholders: [form placeholders]
    - Navigation text: [menu items, tabs]
  
  Messages:
    - Success messages: [completion notifications]
    - Error messages: [validation errors, system errors]  
    - Information messages: [help text, descriptions]
    - Confirmation dialogs: [action confirmations]
  
  Content:
    - Feature descriptions: [feature explanations]
    - Instructions: [user guidance]
    - Status text: [current state indicators]
    - Placeholder content: [empty states]
```

#### **Step 3: Output Format Generation**
**AI should generate comprehensive text list:**

```markdown
# Text Resource Extraction Report
## Project: [project-name]
## Generated: [date]

### Android Text Resources
#### strings.xml Resources
| Key | Text | Category | Screen/Component |
|-----|------|----------|------------------|
| app_name | Smart Call Block | App Identity | Global |
| btn_save | Save | Action | Forms |
| msg_success | Saved successfully | Success | Notifications |

#### Hardcoded Text Found
| File | Line | Text | Suggested Key | Priority |
|------|------|------|---------------|----------|
| MainActivity.java | 45 | "Loading..." | loading_message | High |
| AddNumberFragment.java | 78 | "Enter phone number" | hint_phone_number | Medium |

### iOS Text Resources  
#### Localizable.strings Resources
| Key | Text | Category | Screen/Component |
|-----|------|----------|------------------|
| app_name | Smart Call Block | App Identity | Global |
| save_button | Save | Action | Forms |

### Cross-Platform Text Consistency
| Concept | Android | iOS | Status |
|---------|---------|-----|--------|
| Save Action | "Save" | "Save" | ✅ Consistent |
| Cancel Action | "Cancel" | "Cancel" | ✅ Consistent |
| Loading State | "Loading..." | "Loading" | ⚠️ Inconsistent |

### Recommendations
- [ ] Move hardcoded text to resource files
- [ ] Standardize cross-platform terminology  
- [ ] Add missing string keys
- [ ] Review text for accessibility
```

## 🎨 HTML Theme Generation Workflow

### 🎯 **Theme HTML Editor Creation**
**When user requests theme HTML generation:**

#### **Step 1: Theme Analysis**
```yaml
Theme Discovery Scan:
  Android Theme System:
    - colors.xml: [extract all color definitions]
    - styles.xml: [extract theme definitions]
    - Material Design 3: [identify MD3 usage]
    - Dark/Light variants: [detect theme variants]
  
  iOS Theme System:
    - Color assets: [extract color definitions]
    - SwiftUI themes: [extract theme modifiers]
    - System integration: [detect system theme usage]
    - Appearance variants: [light/dark support]
  
  Cross-Platform Consistency:
    - Color mapping: [identify equivalent colors]
    - Theme structure: [compare theme organization]
    - Brand colors: [extract brand identity colors]
```

#### **Step 2: HTML Theme Editor Generation**
**AI should generate interactive theme editor:**

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[Project Name] - Theme Color Editor</title>
    <style>
        /* Complete CSS framework for theme editing */
    </style>
</head>
<body>
    <div class="theme-editor">
        <!-- Header Section -->
        <header>
            <h1>[Project Name] Theme Editor</h1>
            <div class="theme-controls">
                <button id="exportAndroid">Export Android Colors</button>
                <button id="exportIOS">Export iOS Colors</button>
                <button id="previewMode">Preview Mode</button>
            </div>
        </header>

        <!-- Color Palette Section -->
        <section class="color-palette">
            <h2>Brand Colors</h2>
            <div class="color-group" data-category="primary">
                <label>Primary Colors</label>
                <!-- Color pickers for primary colors -->
            </div>
            
            <div class="color-group" data-category="surface">
                <label>Surface Colors</label>
                <!-- Color pickers for surface colors -->
            </div>
        </section>

        <!-- Preview Section -->
        <section class="preview-section">
            <h2>Live Preview</h2>
            <div class="preview-container">
                <!-- Mock UI components showing theme -->
            </div>
        </section>

        <!-- Export Section -->
        <section class="export-section">
            <h2>Generated Code</h2>
            <div class="code-output">
                <div class="android-output">
                    <h3>Android colors.xml</h3>
                    <pre id="androidColors"></pre>
                </div>
                <div class="ios-output">
                    <h3>iOS Color Assets</h3>
                    <pre id="iosColors"></pre>
                </div>
            </div>
        </section>
    </div>

    <script>
        // Complete JavaScript for theme editing functionality
    </script>
</body>
</html>
```

#### **Step 3: Feature Requirements**
```yaml
HTML Theme Editor Features:
  Color Management:
    ✅ Interactive color pickers
    ✅ Real-time preview updates
    ✅ Color palette organization
    ✅ Accessibility contrast checking
    
  Code Generation:
    ✅ Android colors.xml generation
    ✅ iOS color asset generation  
    ✅ SwiftUI color code generation
    ✅ Cross-platform color mapping
    
  Preview System:
    ✅ Live UI component preview
    ✅ Dark/light theme toggle
    ✅ Multiple component types
    ✅ Responsive design preview
    
  Export Options:
    ✅ Download color files
    ✅ Copy code to clipboard
    ✅ Generate theme documentation
    ✅ Export brand guidelines
```

## 🔄 Implementation Protocol

### **Text Extraction Command**
```bash
User Request: "List out all text resources"
AI Response: 
1. Scan project for text resources
2. Categorize and organize findings
3. Generate comprehensive report
4. Identify hardcoded text issues
5. Provide cross-platform consistency analysis
```

### **Theme HTML Generation Command**  
```bash
User Request: "Create HTML theme editor"
AI Response:
1. Analyze current theme system
2. Extract color definitions
3. Generate interactive HTML editor
4. Include cross-platform export
5. Add live preview functionality
```

## ⚠️ Quality Requirements

### Text Resource Quality
- [ ] **Complete coverage** of all UI text
- [ ] **Categorization** by usage context
- [ ] **Cross-platform consistency** analysis
- [ ] **Accessibility considerations** included
- [ ] **Localization readiness** assessment

### Theme HTML Quality
- [ ] **Interactive functionality** working
- [ ] **Real-time preview** accurate
- [ ] **Code generation** correct for both platforms
- [ ] **Responsive design** for various screen sizes
- [ ] **Accessibility compliance** in theme editor

## 🎯 Automation Integration

### Build Integration
```yaml
Text Resource Automation:
  - Pre-commit hooks: Check for hardcoded text
  - CI/CD integration: Validate text consistency
  - Automated reports: Generate text audit reports
  
Theme HTML Automation:
  - Theme validation: Check color accessibility
  - Asset generation: Auto-generate color resources
  - Documentation: Update theme documentation
```

---

*Text & Theme Resource Management Rules - Development Rules*  
*Last updated: December 17, 2025*