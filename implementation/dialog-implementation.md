# 🎨 Dialog Implementation Manager

> **Manages dialog standards, examples, and user confirmation workflows**

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "dialog implementation"...
```

**Purpose:** Let user know AI is referencing dialog implementation details.

---

## 🎯 RELATED STANDARDS

**📂 Design Standards References:**
- [Spacing & Padding Standards](standards/spacing-padding-standards.md) - Dialog spacing and button padding
- [Border & Shape Standards](standards/border-shape-standards.md) - Dialog corner radius and shapes
- [Style System Architecture](standards/style-system-architecture.md) - Dialog button and text styles

**📂 Implementation Standards:**
- [Dialog Rules](standards/dialog-rules.md) - Complete dialog patterns and styling

---

## 🎯 **Implementation Workflow**

### STEP 1: Detect Current Dialog Implementation
```bash
# Find current dialog usage
grep -r "AlertDialog\|Dialog" app/src/main/java/ --include="*.java"
find . -name "*.xml" -exec grep -l "dialog" {} \;
```

### STEP 2: Compare with Standards
**📂 Available Standards:**
- [Dialog Rules](./standards/dialog-rules.md) - Complete dialog patterns and styling

### STEP 3: User Confirmation Required

```
🔧 APPLY DIALOG STANDARDS?

Current Status: [description of current dialog setup]
Standard Available: Material Design 3 dialogs with consistent styling

Choose your option:
☐ Apply Standard Dialog Pattern (recommended)
  → Material Design 3 compliance
  → Consistent button styling and positioning
  → Proper theme integration
  → Standard confirmation/alert patterns
  
☐ Keep Current Implementation
  → No dialog changes made
  → Current dialog structure preserved

☐ Custom Migration
  → Apply specific dialog standards only
  → Choose which dialogs to standardize

❓ Please confirm your choice before proceeding.
```

## 📋 **Review & Examples**

### Current Implementation Check
- [ ] **Material Design:** Do dialogs follow MD3 guidelines?
- [ ] **Button Positioning:** Are OK/Cancel buttons properly positioned?
- [ ] **Theme Compliance:** Do dialogs use app theme colors?
- [ ] **Accessibility:** Are dialogs properly labeled?

### Examples for Review

## ⚙️ JAVA IMPLEMENTATION

### **Standard Dialog Pattern**

```java
public class DialogUtils {
    
    public static void showConfirmationDialog(Context context, String message, 
            DialogInterface.OnClickListener positiveListener) {
        new AlertDialog.Builder(context)
            .setTitle(R.string.confirm)
            .setMessage(message)
            .setPositiveButton(R.string.ok, positiveListener)
            .setNegativeButton(R.string.cancel, null)
            .show();
    }
    
    public static void showInfoDialog(Context context, String title, String message) {
        new AlertDialog.Builder(context)
            .setTitle(title)
            .setMessage(message)
            .setPositiveButton(R.string.ok, null)
            .show();
    }
    
    public static void showChoiceDialog(Context context, String title, String[] items,
            DialogInterface.OnClickListener itemListener) {
        new AlertDialog.Builder(context)
            .setTitle(title)
            .setItems(items, itemListener)
            .setNegativeButton(R.string.cancel, null)
            .show();
    }
}
```

**📂 Note**: This implementation uses design standards from:
- [Dialog Rules](standards/dialog-rules.md) for complete patterns and styling
- [Style Architecture](standards/style-system-architecture.md) for button and text styles
- [Spacing Standards](standards/spacing-padding-standards.md) for dialog padding

--- ⚡ **Apply Standards Process**

### If User Chooses "Apply Standard":
1. Read implementation from `standards/dialog-rules.md`
2. Apply Material Design 3 dialog patterns
3. Update all existing dialog usages
4. Ensure theme consistency

### Migration Steps:
```
Applying Dialog Standards:
  - Update AlertDialog.Builder usage
  - Apply standard button positioning  
  - Add proper theme attributes
  - Update dialog layouts to MD3
  
Continue with migration? (y/n)
```

**📂 Implementation Details:** See [standards/dialog-rules.md](./standards/dialog-rules.md)