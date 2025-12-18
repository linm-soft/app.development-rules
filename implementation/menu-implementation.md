# 📱 Menu Implementation Manager

> **Manages menu standards, examples, and user confirmation workflows**

## 🎯 **Implementation Workflow**

### STEP 1: Detect Current Implementation
```bash
# Detect menu patterns in current project
find . -name "*.xml" -exec grep -l "BottomNavigationView\|menu" {} \;
grep -c "<item" res/menu/*.xml 2>/dev/null || echo "No menus found"
```

### STEP 2: Compare with Standards
**📂 Available Standards:**
- [Menu Standards](./standards/menu-standards.md) - Complete menu patterns
- [Bottom Navigation](./standards/bottom-navigation.md) - Specialized bottom nav
- [Menu Detection Workflow](./standards/menu-detection-workflow.md) - Detection & migration

### STEP 3: User Confirmation Required

When applying standards, **ALWAYS show this confirmation:**

```
🔧 APPLY MENU STANDARDS?

Current Status: [description of current menu setup]
Available Standard: [standard pattern name]

Choose your option:
☐ Apply Standard Pattern (recommended)
  → Will implement: [brief description]
  → Benefits: [key benefits]
  → Files to modify: [list of files]
  
☐ Keep Current Implementation
  → No changes will be made
  → Current structure preserved

☐ Custom Migration
  → Apply partial standards only
  → User selects specific improvements

❓ Please confirm your choice before proceeding.
```

## 📋 **Review & Examples**

### Current Implementation Check
- [ ] **Menu Count:** Are there >5 items in any menu?
- [ ] **UX Compliance:** Do bottom nav items follow Material Design?
- [ ] **Overflow Handling:** Is "More" pattern implemented correctly?

### Examples for Review
```xml
<!-- Example: Current vs Standard Bottom Navigation -->
<!-- CURRENT (non-standard) -->
<com.google.android.material.bottomnavigation.BottomNavigationView
    android:layout_width="match_parent"
    android:layout_height="wrap_content" />

<!-- STANDARD (recommended) -->
<com.google.android.material.bottomnavigation.BottomNavigationView
    android:layout_width="match_parent" 
    android:layout_height="70dp"
    app:labelVisibilityMode="selected"
    app:itemIconSize="24dp" />
```

## ⚡ **Apply Standards Process**

### If User Chooses "Apply Standard":
1. Read detailed implementation from `standards/menu-standards.md`
2. Apply code patterns with user-confirmed modifications
3. Show migration steps and get approval for each
4. Implement with proper error handling

### If User Chooses "Keep Current":
- No modifications
- Document decision for future reference
- Still provide optimization suggestions

### If User Chooses "Custom Migration":
- Show checklist of available improvements
- Let user select which standards to apply
- Implement only selected standards

## 🔄 **Migration Confirmation**

For each standard being applied:
```
Applying: [Standard Name]
Files to modify:
  - [file1.xml] → Add app:labelVisibilityMode="selected"
  - [file2.java] → Update PopupMenu handling
  
Continue? (y/n)
```

**❌ NEVER apply standards without explicit user confirmation**
**✅ ALWAYS explain what will change before making changes**