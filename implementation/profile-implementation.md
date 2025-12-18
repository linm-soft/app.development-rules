# 👤 Profile Implementation Manager

> **Manages profile standards, examples, and user confirmation workflows**

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "profile implementation"...
```

**Purpose:** Let user know AI is referencing profile implementation details.

---

## 🎯 RELATED STANDARDS

**📂 Design Standards References:**
- [Spacing & Padding Standards](standards/spacing-padding-standards.md) - Profile layout spacing
- [Style System Architecture](standards/style-system-architecture.md) - Profile component styling
- [Border & Shape Standards](standards/border-shape-standards.md) - Profile card and button shapes

**📂 Implementation Standards:**
- [App Profile](standards/app-profile.md) - Complete app profile patterns
- [MainProfile Fragment](standards/mainprofile-fragment.md) - Standard fragment implementation

---

## 🎯 **Implementation Workflow**

### STEP 1: Detect Current Profile Implementation
```bash
# Find profile-related files
find . -name "*profile*" -o -name "*Profile*" | head -10
grep -r "Profile" app/src/main/java/ --include="*.java" | head -5
```

### STEP 2: Compare with Standards
**📂 Available Standards:**
- [App Profile](./standards/app-profile.md) - Complete app profile patterns
- [MainProfile Fragment](./standards/mainprofile-fragment.md) - Standard fragment implementation

### STEP 3: User Confirmation Required

```
🔧 APPLY PROFILE STANDARDS?

Current Status: [description of current profile setup]
Standard Available: Consistent profile UI with standard layout patterns

Choose your option:
☐ Apply Standard Profile Pattern (recommended)
  → Standard profile layout and components
  → Consistent spacing and design patterns
  → Material Design compliance
  → Standard navigation and functionality
  
☐ Keep Current Implementation
  → No profile changes made
  → Current profile structure preserved

☐ Custom Migration
  → Apply specific profile standards only
  → Choose which profile components to standardize

❓ Please confirm your choice before proceeding.
```

## 📋 **Review & Examples**

### Current Implementation Check
- [ ] **Layout Consistency:** Does profile follow standard layout patterns?
- [ ] **Component Standards:** Are profile components properly structured?
- [ ] **Navigation:** Is profile navigation implemented correctly?
- [ ] **Data Handling:** Is profile data managed properly?

### Examples for Review

## ⚙️ JAVA IMPLEMENTATION

### **MainProfile Fragment Structure**

```java
public class MainProfile extends Fragment {
    
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_main_profile, container, false);
        
        // Initialize profile components according to standards
        setupProfileHeader(view);
        setupProfileActions(view);
        setupProfileSettings(view);
        
        return view;
    }
    
    private void setupProfileHeader(View view) {
        // Profile picture, name, email display
        // Uses spacing standards for layout
    }
    
    private void setupProfileActions(View view) {
        // Action buttons with standard styling
        // Permissions, settings, etc.
    }
    
    private void setupProfileSettings(View view) {
        // Settings section with consistent patterns
        // Theme, language, app info
    }
}
```

**📂 Note**: This implementation uses design standards from:
- [Spacing Standards](standards/spacing-padding-standards.md) for profile layout spacing
- [Style Architecture](standards/style-system-architecture.md) for component styling
- [App Profile Standards](standards/app-profile.md) for complete patterns

--- ⚡ **Apply Standards Process**

### If User Chooses "Apply Standard":
1. Read implementation from `standards/app-profile.md` and `standards/mainprofile-fragment.md`
2. Apply standard profile layout patterns
3. Update fragment structure and navigation
4. Ensure data handling consistency

### Migration Steps:
```
Applying Profile Standards:
  - Update profile layout structure
  - Apply standard spacing and components
  - Update fragment lifecycle handling
  - Implement standard navigation patterns
  
Continue with migration? (y/n)
```

**📂 Implementation Details:** 
- [standards/app-profile.md](./standards/app-profile.md)
- [standards/mainprofile-fragment.md](./standards/mainprofile-fragment.md)