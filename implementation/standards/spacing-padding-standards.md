# Spacing & Padding Standards Implementation (Rule 2.20)

> Complete spacing and padding system for consistent UI layout

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "spacing-padding standards"...
```

**Purpose:** Let user know AI is referencing spacing implementation details.

---

## 🎯 SPACING SYSTEM STANDARD

### **1. 4DP INCREMENT SYSTEM**

**Core Principle: ALL spacing values MUST be multiples of 4dp**

**Standard Spacing Scale:**
```xml
<!-- dimens_spacing.xml -->
<dimen name="spacing_tiny">4dp</dimen>     <!-- 4dp -->
<dimen name="spacing_small">8dp</dimen>    <!-- 8dp -->
<dimen name="spacing_medium">12dp</dimen>  <!-- 12dp -->
<dimen name="spacing_normal">16dp</dimen>  <!-- 16dp - Most common -->
<dimen name="spacing_large">20dp</dimen>   <!-- 20dp -->
<dimen name="spacing_xlarge">24dp</dimen>  <!-- 24dp -->
<dimen name="spacing_xxlarge">32dp</dimen> <!-- 32dp -->
```

**Usage Guidelines:**
- **spacing_tiny (4dp)**: Minimal gaps, inner padding for small elements
- **spacing_small (8dp)**: Section dividers, small component gaps
- **spacing_medium (12dp)**: Input field padding, card content margins
- **spacing_normal (16dp)**: Standard padding/margin (MOST COMMON)
- **spacing_large (20dp)**: Container padding, dialog padding
- **spacing_xlarge (24dp)**: Section gaps, major component separation
- **spacing_xxlarge (32dp)**: Screen-level margins, major layout gaps

---

### **2. RTL SUPPORT REQUIREMENTS**

**⚠️ CRITICAL: ALWAYS use start/end instead of left/right**

**✅ CORRECT:**
```xml
<LinearLayout
    android:paddingStart="@dimen/spacing_normal"
    android:paddingEnd="@dimen/spacing_normal"
    android:layout_marginStart="@dimen/spacing_small"
    android:layout_marginEnd="@dimen/spacing_small" />
```

**❌ WRONG:**
```xml
<LinearLayout
    android:paddingLeft="16dp"    <!-- NO! Hardcoded + left/right -->
    android:paddingRight="16dp"
    android:layout_marginLeft="8dp"
    android:layout_marginRight="8dp" />
```

**Complete RTL Attribute Mapping:**
- `paddingLeft` → `paddingStart`
- `paddingRight` → `paddingEnd`
- `layout_marginLeft` → `layout_marginStart`
- `layout_marginRight` → `layout_marginEnd`
- `drawableLeft` → `drawableStart`
- `drawableRight` → `drawableEnd`

---

### **3. COMPONENT-SPECIFIC PATTERNS**

**A. Button Padding Standards:**
```xml
<!-- Standard Button -->
<Button
    android:paddingStart="@dimen/spacing_normal"
    android:paddingEnd="@dimen/spacing_normal"
    android:paddingTop="@dimen/spacing_medium"
    android:paddingBottom="@dimen/spacing_medium" />

<!-- Action Button (compact) -->
<Button
    android:paddingStart="@dimen/spacing_large"
    android:paddingEnd="@dimen/spacing_large"
    android:paddingTop="@dimen/spacing_small"
    android:paddingBottom="@dimen/spacing_small" />

<!-- Small Action Button -->
<Button
    android:paddingStart="@dimen/spacing_tiny"
    android:paddingEnd="@dimen/spacing_tiny"
    android:paddingTop="@dimen/spacing_tiny"
    android:paddingBottom="@dimen/spacing_tiny" />
```

**B. Dialog Patterns:**
```xml
<!-- Dialog Container -->
<LinearLayout
    android:padding="@dimen/spacing_large" />    <!-- 20dp -->

<!-- Dialog Section Spacing -->
<LinearLayout 
    android:layout_marginBottom="@dimen/spacing_normal" />  <!-- 16dp -->

<!-- Dialog Input Fields -->
<EditText
    android:padding="@dimen/spacing_medium"     <!-- 12dp -->
    android:layout_marginBottom="@dimen/spacing_small" />  <!-- 8dp -->

<!-- Dialog Button Container -->
<LinearLayout
    android:paddingTop="@dimen/spacing_normal"  <!-- 16dp -->
    android:layout_marginTop="@dimen/spacing_small" />     <!-- 8dp -->
```

**C. List Item Patterns:**
```xml
<!-- List Item Container -->
<LinearLayout
    android:padding="@dimen/spacing_normal"          <!-- 16dp -->
    android:layout_marginBottom="@dimen/spacing_tiny" />  <!-- 4dp gap -->

<!-- List Item Content Separation -->
<TextView 
    android:layout_marginEnd="@dimen/spacing_small" />    <!-- 8dp -->

<!-- List Action Buttons -->
<Button
    android:layout_marginStart="@dimen/spacing_small" />  <!-- 8dp -->
```

**D. Card Patterns:**
```xml
<!-- Card Container -->
<CardView
    android:layout_margin="@dimen/spacing_small"    <!-- 8dp external -->
    app:contentPadding="@dimen/spacing_normal" />    <!-- 16dp internal -->

<!-- Card Section Dividers -->
<View
    android:layout_marginVertical="@dimen/spacing_medium" />  <!-- 12dp -->

<!-- Card Header/Footer -->
<LinearLayout
    android:paddingHorizontal="@dimen/spacing_normal"  <!-- 16dp -->
    android:paddingVertical="@dimen/spacing_small" />  <!-- 8dp -->
```

---

### **4. LAYOUT ORGANIZATION PATTERNS**

**A. Screen-Level Structure:**
```xml
<LinearLayout
    android:padding="@dimen/spacing_normal">  <!-- 16dp screen padding -->
    
    <!-- Header Section -->
    <LinearLayout
        android:layout_marginBottom="@dimen/spacing_large" />  <!-- 20dp section gap -->
    
    <!-- Content Sections -->
    <LinearLayout
        android:layout_marginBottom="@dimen/spacing_normal" /> <!-- 16dp between sections -->
        
    <!-- Footer/Action Area -->
    <LinearLayout
        android:layout_marginTop="@dimen/spacing_xlarge" />    <!-- 24dp major separation -->
</LinearLayout>
```

**B. Form Layout Patterns:**
```xml
<LinearLayout android:orientation="vertical">
    
    <!-- Form Title -->
    <TextView
        android:layout_marginBottom="@dimen/spacing_normal" />  <!-- 16dp -->
    
    <!-- Input Field Groups -->
    <LinearLayout
        android:layout_marginBottom="@dimen/spacing_medium" /> <!-- 12dp between groups -->
        
        <!-- Individual Input -->
        <EditText
            android:padding="@dimen/spacing_medium"             <!-- 12dp internal -->
            android:layout_marginBottom="@dimen/spacing_small" />  <!-- 8dp between fields -->
        
        <!-- Field Description -->
        <TextView
            android:layout_marginBottom="@dimen/spacing_normal" />  <!-- 16dp after group -->
    
    <!-- Action Buttons -->
    <LinearLayout
        android:layout_marginTop="@dimen/spacing_large" />     <!-- 20dp separation -->
</LinearLayout>
```

---

### **5. DIMENSION FILE ORGANIZATION**

**A. File Structure:**
```
values/
├── dimens.xml                 # Main reference file
├── dimens_spacing.xml         # Padding/margin values
├── dimens_component.xml       # Component sizes (button height, etc.)
└── dimens_text.xml           # Text sizes
```

**B. dimens_spacing.xml (Complete):**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Base spacing scale (4dp increments) -->
    <dimen name="spacing_tiny">4dp</dimen>
    <dimen name="spacing_small">8dp</dimen>
    <dimen name="spacing_medium">12dp</dimen>
    <dimen name="spacing_normal">16dp</dimen>        <!-- Most common -->
    <dimen name="spacing_large">20dp</dimen>
    <dimen name="spacing_xlarge">24dp</dimen>
    <dimen name="spacing_xxlarge">32dp</dimen>
    
    <!-- Special-purpose spacing -->
    <dimen name="spacing_section">24dp</dimen>       <!-- Between major sections -->
    <dimen name="spacing_screen">16dp</dimen>        <!-- Screen-level padding -->
    <dimen name="spacing_card_internal">16dp</dimen> <!-- Card content padding -->
    <dimen name="spacing_card_external">8dp</dimen>  <!-- Card margin -->
    <dimen name="spacing_list_gap">4dp</dimen>       <!-- Between list items -->
</resources>
```

**C. dimens_component.xml:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Button dimensions -->
    <dimen name="button_height">48dp</dimen>
    <dimen name="button_height_small">32dp</dimen>
    <dimen name="button_corner_radius">8dp</dimen>
    
    <!-- Card dimensions -->
    <dimen name="card_corner_radius">12dp</dimen>
    <dimen name="card_elevation">4dp</dimen>
    
    <!-- Input dimensions -->
    <dimen name="input_height">48dp</dimen>
    <dimen name="input_corner_radius">8dp</dimen>
    
    <!-- Icon dimensions -->
    <dimen name="icon_size_small">16dp</dimen>
    <dimen name="icon_size_normal">24dp</dimen>
    <dimen name="icon_size_large">32dp</dimen>
</resources>
```

---

### **6. VALIDATION RULES**

**⚠️ ZERO TOLERANCE for these violations:**

**A. Hardcoded Values:**
```xml
<!-- ❌ FORBIDDEN -->
<LinearLayout android:padding="16dp" />
<Button android:layout_marginBottom="12dp" />
<TextView android:layout_marginTop="8dp" />

<!-- ✅ REQUIRED -->
<LinearLayout android:padding="@dimen/spacing_normal" />
<Button android:layout_marginBottom="@dimen/spacing_medium" />
<TextView android:layout_marginTop="@dimen/spacing_small" />
```

**B. Non-4dp Values:**
```xml
<!-- ❌ FORBIDDEN -->
<dimen name="custom_spacing">15dp</dimen>  <!-- Not multiple of 4 -->
<dimen name="weird_margin">6dp</dimen>     <!-- Not in system -->

<!-- ✅ REQUIRED -->
<dimen name="custom_spacing">16dp</dimen>  <!-- Use standard values -->
<dimen name="special_gap">8dp</dimen>      <!-- From approved scale -->
```

**C. Left/Right Usage:**
```xml
<!-- ❌ FORBIDDEN -->
<TextView
    android:paddingLeft="@dimen/spacing_normal"
    android:drawableRight="@drawable/ic_arrow" />

<!-- ✅ REQUIRED -->
<TextView
    android:paddingStart="@dimen/spacing_normal"
    android:drawableEnd="@drawable/ic_arrow" />
```

---

### **7. QUICK REFERENCE GUIDE**

**Most Common Patterns:**
```xml
<!-- Screen container -->
android:padding="@dimen/spacing_normal"              <!-- 16dp -->

<!-- Section separation -->
android:layout_marginBottom="@dimen/spacing_large"   <!-- 20dp -->

<!-- Card content -->
android:padding="@dimen/spacing_normal"              <!-- 16dp -->
android:layout_margin="@dimen/spacing_small"         <!-- 8dp -->

<!-- Input fields -->
android:padding="@dimen/spacing_medium"              <!-- 12dp -->
android:layout_marginBottom="@dimen/spacing_small"   <!-- 8dp -->

<!-- Button padding -->
android:paddingHorizontal="@dimen/spacing_normal"    <!-- 16dp -->
android:paddingVertical="@dimen/spacing_medium"      <!-- 12dp -->

<!-- List item spacing -->
android:padding="@dimen/spacing_normal"              <!-- 16dp -->
android:layout_marginBottom="@dimen/spacing_tiny"    <!-- 4dp gap -->
```

---

## ✅ IMPLEMENTATION CHECKLIST

**File Structure:**
- [ ] dimens_spacing.xml with 4dp increment system
- [ ] dimens_component.xml with component dimensions
- [ ] dimens_text.xml with text sizes
- [ ] Main dimens.xml for reference

**Spacing System:**
- [ ] All spacing values are multiples of 4dp
- [ ] NO hardcoded dp values in layouts
- [ ] Consistent naming pattern (spacing_*)
- [ ] Special-purpose dimensions defined

**RTL Support:**
- [ ] ALWAYS use paddingStart/End instead of Left/Right
- [ ] ALWAYS use layout_marginStart/End
- [ ] ALWAYS use drawableStart/End
- [ ] Test with RTL languages (Arabic, Hebrew)

**Component Standards:**
- [ ] Button padding patterns established
- [ ] Dialog spacing patterns established  
- [ ] List item spacing patterns established
- [ ] Card spacing patterns established
- [ ] Form layout spacing patterns established

**Validation:**
- [ ] Zero hardcoded dp values
- [ ] Zero left/right attributes
- [ ] All values follow 4dp increment rule
- [ ] Consistent dimension naming

This standard ensures pixel-perfect, accessible, and maintainable layouts across all Android applications!