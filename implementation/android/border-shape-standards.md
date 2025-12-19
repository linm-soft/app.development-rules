# Border & Shape Standards Implementation

> Complete border, stroke, and shape system for consistent visual design

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "border-shape standards"...
```

**Purpose:** Let user know AI is referencing border/shape implementation details.

---

## 🎯 BORDER & SHAPE SYSTEM

### **1. CORNER RADIUS STANDARDS**

**Standard Radius Scale (4dp increments):**
```xml
<!-- dimens_component.xml -->
<dimen name="radius_none">0dp</dimen>        <!-- Sharp corners -->
<dimen name="radius_small">4dp</dimen>       <!-- Subtle rounding -->
<dimen name="radius_normal">8dp</dimen>      <!-- Standard rounding (MOST COMMON) -->
<dimen name="radius_medium">12dp</dimen>     <!-- Card radius -->
<dimen name="radius_large">16dp</dimen>      <!-- Prominent rounding -->
<dimen name="radius_xlarge">20dp</dimen>     <!-- Very round -->
<dimen name="radius_round">50dp</dimen>      <!-- Fully round (circles) -->
```

**Component-Specific Radius:**
```xml
<!-- Component radius definitions -->
<dimen name="button_corner_radius">8dp</dimen>     <!-- Standard buttons -->
<dimen name="card_corner_radius">12dp</dimen>      <!-- Cards -->
<dimen name="input_corner_radius">8dp</dimen>      <!-- Input fields -->
<dimen name="dialog_corner_radius">16dp</dimen>    <!-- Dialog containers -->
<dimen name="chip_corner_radius">16dp</dimen>      <!-- Pills/chips -->
<dimen name="badge_corner_radius">8dp</dimen>      <!-- Status badges -->
```

---

### **2. STROKE WIDTH STANDARDS**

**Standard Stroke Widths:**
```xml
<!-- dimens_component.xml -->
<dimen name="stroke_none">0dp</dimen>         <!-- No border -->
<dimen name="stroke_thin">0.5dp</dimen>       <!-- Hairline (dividers) -->
<dimen name="stroke_normal">1dp</dimen>       <!-- Standard border (MOST COMMON) -->
<dimen name="stroke_thick">2dp</dimen>        <!-- Emphasized border -->
<dimen name="stroke_bold">3dp</dimen>         <!-- Bold border (focus states) -->
```

**Usage Guidelines:**
- **0.5dp**: Subtle dividers, table borders
- **1dp**: Standard borders for cards, buttons, inputs
- **2dp**: Emphasized states, primary borders
- **3dp**: Focus indicators, active states

---

### **3. BACKGROUND DRAWABLE PATTERNS**

**A. Basic Shape Template:**
```xml
<!-- bg_component_state.xml -->
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="@color/background_color" />
    <corners android:radius="@dimen/radius_normal" />
    <stroke
        android:width="@dimen/stroke_normal"
        android:color="@color/border_color" />
</shape>
```

**B. Button Background Patterns:**
```xml
<!-- bg_button_primary.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/primary" />
    <corners android:radius="@dimen/button_corner_radius" />
</shape>

<!-- bg_button_secondary.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/button_secondary" />
    <corners android:radius="@dimen/button_corner_radius" />
    <stroke
        android:width="@dimen/stroke_normal"
        android:color="@color/primary" />
</shape>

<!-- bg_button_outline.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@android:color/transparent" />
    <corners android:radius="@dimen/button_corner_radius" />
    <stroke
        android:width="@dimen/stroke_normal"
        android:color="@color/primary" />
</shape>
```

**C. Card Background Patterns:**
```xml
<!-- bg_card_default.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/card_background" />
    <corners android:radius="@dimen/card_corner_radius" />
</shape>

<!-- bg_card_bordered.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/card_background" />
    <corners android:radius="@dimen/card_corner_radius" />
    <stroke
        android:width="@dimen/stroke_normal"
        android:color="@color/card_border" />
</shape>

<!-- bg_card_highlighted.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/primary_light" />
    <corners android:radius="@dimen/card_corner_radius" />
    <stroke
        android:width="@dimen/stroke_thick"
        android:color="@color/primary" />
</shape>
```

**D. Input Field Patterns:**
```xml
<!-- bg_input_default.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/input_background" />
    <corners android:radius="@dimen/input_corner_radius" />
    <stroke
        android:width="@dimen/stroke_normal"
        android:color="@color/input_border" />
</shape>

<!-- bg_input_focused.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/input_background" />
    <corners android:radius="@dimen/input_corner_radius" />
    <stroke
        android:width="@dimen/stroke_thick"
        android:color="@color/primary" />
</shape>

<!-- bg_input_error.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/input_background" />
    <corners android:radius="@dimen/input_corner_radius" />
    <stroke
        android:width="@dimen/stroke_thick"
        android:color="@color/error" />
</shape>
```

---

### **4. SELECTOR PATTERNS**

**A. Button State Selector:**
```xml
<!-- bg_button_primary_selector.xml -->
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Pressed state -->
    <item android:state_pressed="true">
        <shape android:shape="rectangle">
            <solid android:color="@color/primary_dark" />
            <corners android:radius="@dimen/button_corner_radius" />
        </shape>
    </item>
    
    <!-- Focused state -->
    <item android:state_focused="true">
        <shape android:shape="rectangle">
            <solid android:color="@color/primary" />
            <corners android:radius="@dimen/button_corner_radius" />
            <stroke
                android:width="@dimen/stroke_bold"
                android:color="@color/primary_light" />
        </shape>
    </item>
    
    <!-- Disabled state -->
    <item android:state_enabled="false">
        <shape android:shape="rectangle">
            <solid android:color="@color/button_disabled" />
            <corners android:radius="@dimen/button_corner_radius" />
        </shape>
    </item>
    
    <!-- Default state -->
    <item>
        <shape android:shape="rectangle">
            <solid android:color="@color/primary" />
            <corners android:radius="@dimen/button_corner_radius" />
        </shape>
    </item>
</selector>
```

**B. Input State Selector:**
```xml
<!-- bg_input_selector.xml -->
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Error state -->
    <item android:state_focused="true" android:state_selected="true">
        <shape android:shape="rectangle">
            <solid android:color="@color/input_background" />
            <corners android:radius="@dimen/input_corner_radius" />
            <stroke
                android:width="@dimen/stroke_thick"
                android:color="@color/error" />
        </shape>
    </item>
    
    <!-- Focused state -->
    <item android:state_focused="true">
        <shape android:shape="rectangle">
            <solid android:color="@color/input_background" />
            <corners android:radius="@dimen/input_corner_radius" />
            <stroke
                android:width="@dimen/stroke_thick"
                android:color="@color/primary" />
        </shape>
    </item>
    
    <!-- Default state -->
    <item>
        <shape android:shape="rectangle">
            <solid android:color="@color/input_background" />
            <corners android:radius="@dimen/input_corner_radius" />
            <stroke
                android:width="@dimen/stroke_normal"
                android:color="@color/input_border" />
        </shape>
    </item>
</selector>
```

**C. Chip/Toggle Selector:**
```xml
<!-- bg_chip_selector.xml -->
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Selected state -->
    <item android:state_selected="true">
        <shape android:shape="rectangle">
            <solid android:color="@color/primary"/>
            <corners android:radius="@dimen/chip_corner_radius"/>
        </shape>
    </item>
    
    <!-- Pressed state -->
    <item android:state_pressed="true">
        <shape android:shape="rectangle">
            <solid android:color="@color/primary_light"/>
            <corners android:radius="@dimen/chip_corner_radius"/>
            <stroke
                android:width="@dimen/stroke_normal"
                android:color="@color/primary"/>
        </shape>
    </item>
    
    <!-- Default state -->
    <item>
        <shape android:shape="rectangle">
            <solid android:color="@color/chip_background"/>
            <corners android:radius="@dimen/chip_corner_radius"/>
            <stroke
                android:width="@dimen/stroke_normal"
                android:color="@color/chip_border"/>
        </shape>
    </item>
</selector>
```

---

### **5. NAMING CONVENTIONS**

**File Naming Pattern:**
```
bg_[component]_[variant]_[state].xml
```

**Examples:**
- `bg_button_primary.xml` - Primary button background
- `bg_button_secondary.xml` - Secondary button background
- `bg_button_outline.xml` - Outline button background
- `bg_button_primary_selector.xml` - Button with state changes
- `bg_card_default.xml` - Standard card background
- `bg_card_bordered.xml` - Card with border
- `bg_input_default.xml` - Input field background
- `bg_input_selector.xml` - Input with state changes
- `bg_dialog_container.xml` - Dialog background
- `bg_chip_selector.xml` - Chip/toggle background

**Color Naming Integration:**
```xml
<!-- Colors should be semantic, not descriptive -->
<color name="card_background">@color/surface</color>
<color name="card_border">@color/outline</color>
<color name="button_primary">@color/primary</color>
<color name="button_secondary">@color/secondary</color>
<color name="input_background">@color/surface_variant</color>
<color name="input_border">@color/outline</color>
```

---

### **6. DIALOG-SPECIFIC PATTERNS**

**A. Dialog Container:**
```xml
<!-- bg_dialog_container.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/surface" />
    <corners android:radius="@dimen/dialog_corner_radius" />
</shape>
```

**B. Dialog Highlight Box:**
```xml
<!-- bg_dialog_highlight.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/primary_container" />
    <corners android:radius="@dimen/radius_normal" />
    <stroke
        android:width="@dimen/stroke_normal"
        android:color="@color/primary" />
</shape>
```

**C. Dialog Warning Box:**
```xml
<!-- bg_dialog_warning.xml -->
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/error_container" />
    <corners android:radius="@dimen/radius_normal" />
    <stroke
        android:width="@dimen/stroke_normal"
        android:color="@color/error" />
</shape>
```

---

### **7. VALIDATION RULES**

**⚠️ Required Standards:**

**A. Radius Requirements:**
```xml
<!-- ✅ REQUIRED: Use dimension resources -->
<corners android:radius="@dimen/radius_normal" />

<!-- ❌ FORBIDDEN: Hardcoded values -->
<corners android:radius="8dp" />
```

**B. Stroke Requirements:**
```xml
<!-- ✅ REQUIRED: Use stroke dimensions -->
<stroke
    android:width="@dimen/stroke_normal"
    android:color="@color/border_color" />

<!-- ❌ FORBIDDEN: Hardcoded stroke -->
<stroke
    android:width="1dp"
    android:color="#E0E0E0" />
```

**C. Color Requirements:**
```xml
<!-- ✅ REQUIRED: Use semantic colors -->
<solid android:color="@color/surface" />

<!-- ❌ FORBIDDEN: Hardcoded colors -->
<solid android:color="#FFFFFF" />
```

---

## ✅ IMPLEMENTATION CHECKLIST

**Dimension Resources:**
- [ ] radius_* scale with 4dp increments
- [ ] stroke_* scale with standard widths
- [ ] Component-specific radius/stroke dimensions
- [ ] NO hardcoded radius/stroke values

**Background Drawables:**
- [ ] Consistent naming: bg_component_variant.xml
- [ ] Use dimension and color resources
- [ ] State selectors for interactive elements
- [ ] Standard patterns for buttons, cards, inputs

**Component Standards:**
- [ ] Button backgrounds with proper states
- [ ] Card backgrounds with/without borders
- [ ] Input field backgrounds with focus states
- [ ] Dialog container backgrounds
- [ ] Chip/toggle selector backgrounds

**Color Integration:**
- [ ] Semantic color names (surface, outline, primary)
- [ ] NO hardcoded hex colors in drawables
- [ ] Consistent border color usage
- [ ] Theme-aware background colors

**State Management:**
- [ ] Selector drawables for interactive elements
- [ ] Proper state order (specific to general)
- [ ] Focus/pressed/disabled states defined
- [ ] Accessibility-compliant state indicators

This standard ensures consistent, scalable, and maintainable visual design across all Android applications!