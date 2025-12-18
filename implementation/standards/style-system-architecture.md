# Style System Architecture Implementation

> Complete style hierarchy and component architecture for maintainable UI

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "style system architecture"...
```

**Purpose:** Let user know AI is referencing style architecture details.

---

## 🎯 STYLE SYSTEM ARCHITECTURE

### **1. FILE ORGANIZATION STRATEGY**

**Core Style Files Structure:**
```
values/
├── styles.xml                 # Main theme + imports
├── styles_shared.xml          # Text, Container, Card (shared)
├── styles_button.xml          # Button component styles
├── styles_input.xml           # Input/Form component styles
├── styles_list.xml            # List item component styles
├── styles_dialog.xml          # Dialog component styles
└── styles_theme.xml           # Theme definitions (light/dark)
```

**File Purpose:**
- **styles.xml**: App theme and imports other style files
- **styles_shared.xml**: Base text appearances, common containers
- **styles_button.xml**: All button variants and states
- **styles_input.xml**: EditText, form fields, validation styles
- **styles_list.xml**: RecyclerView items, list containers
- **styles_dialog.xml**: Dialog layouts, dialog components
- **styles_theme.xml**: Theme definitions and color mappings

---

### **2. STYLE HIERARCHY SYSTEM**

**A. Text Appearance Hierarchy:**
```xml
<!-- styles_shared.xml -->
<resources>
    <!-- Base Text Appearance -->
    <style name="TextAppearance.App" parent="TextAppearance.Material3.BodyMedium">
        <item name="android:fontFamily">sans-serif</item>
        <item name="android:textColor">@color/text_primary</item>
    </style>

    <!-- Heading Styles -->
    <style name="TextAppearance.Heading" parent="TextAppearance.App">
        <item name="android:textSize">@dimen/text_size_heading</item>
        <item name="android:textStyle">bold</item>
        <item name="android:textColor">@color/text_primary</item>
    </style>

    <style name="TextAppearance.Subheading" parent="TextAppearance.App">
        <item name="android:textSize">@dimen/text_size_subheading</item>
        <item name="android:textStyle">bold</item>
        <item name="android:textColor">@color/text_primary</item>
    </style>

    <!-- Body Text Styles -->
    <style name="TextAppearance.Body" parent="TextAppearance.App">
        <item name="android:textSize">@dimen/text_size_body</item>
        <item name="android:textColor">@color/text_primary</item>
    </style>

    <style name="TextAppearance.Body.Bold" parent="TextAppearance.Body">
        <item name="android:textStyle">bold</item>
    </style>

    <style name="TextAppearance.Body.Secondary" parent="TextAppearance.Body">
        <item name="android:textColor">@color/text_secondary</item>
    </style>

    <!-- Caption and Support Text -->
    <style name="TextAppearance.Caption" parent="TextAppearance.App">
        <item name="android:textSize">@dimen/text_size_caption</item>
        <item name="android:textColor">@color/text_hint</item>
    </style>

    <style name="TextAppearance.Label" parent="TextAppearance.App">
        <item name="android:textSize">@dimen/text_size_label</item>
        <item name="android:textStyle">bold</item>
        <item name="android:textColor">@color/text_primary</item>
    </style>
</resources>
```

**B. Container Styles:**
```xml
<!-- styles_shared.xml -->
<resources>
    <!-- Base Container -->
    <style name="Container.Base">
        <item name="android:layout_width">match_parent</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="android:orientation">vertical</item>
    </style>

    <!-- Screen Container -->
    <style name="Container.Screen" parent="Container.Base">
        <item name="android:padding">@dimen/spacing_screen</item>
    </style>

    <!-- Section Container -->
    <style name="Container.Section" parent="Container.Base">
        <item name="android:layout_marginBottom">@dimen/spacing_section</item>
    </style>

    <!-- Card Container -->
    <style name="Container.Card" parent="Container.Base">
        <item name="android:background">@drawable/bg_card_default</item>
        <item name="android:padding">@dimen/spacing_card_internal</item>
        <item name="android:layout_margin">@dimen/spacing_card_external</item>
    </style>
</resources>
```

---

### **3. BUTTON STYLE SYSTEM**

**A. Base Button Architecture:**
```xml
<!-- styles_button.xml -->
<resources>
    <!-- Base Button Style -->
    <style name="ButtonStyle" parent="Widget.Material3.Button">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">@dimen/button_height</item>
        <item name="android:textAppearance">@style/TextAppearance.Body.Bold</item>
        <item name="android:paddingStart">@dimen/spacing_normal</item>
        <item name="android:paddingEnd">@dimen/spacing_normal</item>
        <item name="android:insetTop">0dp</item>
        <item name="android:insetBottom">0dp</item>
        <item name="cornerRadius">@dimen/button_corner_radius</item>
    </style>

    <!-- Primary Button -->
    <style name="ButtonStyle.Primary" parent="ButtonStyle">
        <item name="android:textColor">@color/on_primary</item>
        <item name="backgroundTint">@color/primary</item>
    </style>

    <!-- Secondary Button -->
    <style name="ButtonStyle.Secondary" parent="ButtonStyle">
        <item name="android:textColor">@color/primary</item>
        <item name="backgroundTint">@color/secondary_container</item>
        <item name="strokeColor">@color/primary</item>
        <item name="strokeWidth">@dimen/stroke_normal</item>
    </style>

    <!-- Outline Button -->
    <style name="ButtonStyle.Outline" parent="Widget.Material3.Button.OutlinedButton">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">@dimen/button_height</item>
        <item name="android:textColor">@color/primary</item>
        <item name="android:textAppearance">@style/TextAppearance.Body.Bold</item>
        <item name="strokeColor">@color/primary</item>
        <item name="strokeWidth">@dimen/stroke_normal</item>
        <item name="cornerRadius">@dimen/button_corner_radius</item>
    </style>

    <!-- Danger Button -->
    <style name="ButtonStyle.Danger" parent="ButtonStyle">
        <item name="android:textColor">@color/on_error</item>
        <item name="backgroundTint">@color/error</item>
    </style>

    <!-- Small Action Button -->
    <style name="ButtonStyle.Action" parent="ButtonStyle">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">@dimen/button_height_small</item>
        <item name="android:textSize">@dimen/text_size_small</item>
        <item name="android:paddingStart">@dimen/spacing_small</item>
        <item name="android:paddingEnd">@dimen/spacing_small</item>
    </style>

    <style name="ButtonStyle.Action.Edit" parent="ButtonStyle.Action">
        <item name="backgroundTint">@color/primary</item>
        <item name="android:text">@string/edit</item>
    </style>

    <style name="ButtonStyle.Action.Delete" parent="ButtonStyle.Action">
        <item name="backgroundTint">@color/error</item>
        <item name="android:text">@string/delete</item>
    </style>
</resources>
```

**B. Button Usage Examples:**
```xml
<!-- Primary action -->
<Button
    style="@style/ButtonStyle.Primary"
    android:text="@string/save" />

<!-- Secondary action -->
<Button
    style="@style/ButtonStyle.Secondary"
    android:text="@string/cancel" />

<!-- List item action -->
<Button
    style="@style/ButtonStyle.Action.Edit"
    android:id="@+id/btnEdit" />
```

---

### **4. INPUT STYLE SYSTEM**

**A. Input Field Architecture:**
```xml
<!-- styles_input.xml -->
<resources>
    <!-- Base Input Style -->
    <style name="InputStyle" parent="Widget.Material3.TextInputLayout.OutlinedBox">
        <item name="android:layout_width">match_parent</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="android:layout_marginBottom">@dimen/spacing_small</item>
        <item name="boxStrokeColor">@color/primary</item>
        <item name="boxStrokeWidth">@dimen/stroke_normal</item>
        <item name="boxCornerRadiusTopStart">@dimen/input_corner_radius</item>
        <item name="boxCornerRadiusTopEnd">@dimen/input_corner_radius</item>
        <item name="boxCornerRadiusBottomStart">@dimen/input_corner_radius</item>
        <item name="boxCornerRadiusBottomEnd">@dimen/input_corner_radius</item>
    </style>

    <!-- Input Field Text -->
    <style name="InputStyle.EditText" parent="Widget.Material3.TextInputEditText.OutlinedBox">
        <item name="android:textAppearance">@style/TextAppearance.Body</item>
        <item name="android:padding">@dimen/spacing_medium</item>
        <item name="android:background">@android:color/transparent</item>
    </style>

    <!-- Error Input Style -->
    <style name="InputStyle.Error" parent="InputStyle">
        <item name="boxStrokeColor">@color/error</item>
        <item name="boxStrokeWidth">@dimen/stroke_thick</item>
        <item name="errorTextColor">@color/error</item>
    </style>

    <!-- Search Input Style -->
    <style name="InputStyle.Search" parent="InputStyle">
        <item name="startIconDrawable">@drawable/ic_search</item>
        <item name="startIconTint">@color/text_hint</item>
        <item name="endIconMode">clear_text</item>
        <item name="endIconTint">@color/text_hint</item>
    </style>
</resources>
```

**B. Form Layout Styles:**
```xml
<!-- styles_input.xml -->
<resources>
    <!-- Form Container -->
    <style name="FormContainer" parent="Container.Base">
        <item name="android:padding">@dimen/spacing_large</item>
    </style>

    <!-- Form Section -->
    <style name="FormSection" parent="Container.Base">
        <item name="android:layout_marginBottom">@dimen/spacing_normal</item>
    </style>

    <!-- Form Label -->
    <style name="FormLabel" parent="Widget.AppCompat.TextView">
        <item name="android:textAppearance">@style/TextAppearance.Label</item>
        <item name="android:layout_marginBottom">@dimen/spacing_tiny</item>
    </style>

    <!-- Form Button Container -->
    <style name="FormButtonContainer" parent="Container.Base">
        <item name="android:orientation">horizontal</item>
        <item name="android:layout_marginTop">@dimen/spacing_large</item>
        <item name="android:gravity">end</item>
    </style>
</resources>
```

---

### **5. LIST STYLE SYSTEM**

**A. List Item Architecture:**
```xml
<!-- styles_list.xml -->
<resources>
    <!-- Base List Item -->
    <style name="ListItem" parent="Container.Base">
        <item name="android:orientation">horizontal</item>
        <item name="android:padding">@dimen/spacing_normal</item>
        <item name="android:layout_marginBottom">@dimen/spacing_list_gap</item>
        <item name="android:background">?attr/selectableItemBackground</item>
        <item name="android:gravity">center_vertical</item>
    </style>

    <!-- List Item with Card Background -->
    <style name="ListItem.Card" parent="ListItem">
        <item name="android:background">@drawable/bg_card_default</item>
        <item name="android:layout_margin">@dimen/spacing_card_external</item>
        <item name="android:elevation">@dimen/card_elevation</item>
    </style>

    <!-- List Item Content Container -->
    <style name="ListItemContent" parent="Container.Base">
        <item name="android:layout_width">0dp</item>
        <item name="android:layout_weight">1</item>
        <item name="android:layout_marginEnd">@dimen/spacing_small</item>
    </style>

    <!-- List Item Title -->
    <style name="ListItemTitle" parent="Widget.AppCompat.TextView">
        <item name="android:textAppearance">@style/TextAppearance.Body.Bold</item>
        <item name="android:maxLines">1</item>
        <item name="android:ellipsize">end</item>
    </style>

    <!-- List Item Subtitle -->
    <style name="ListItemSubtitle" parent="Widget.AppCompat.TextView">
        <item name="android:textAppearance">@style/TextAppearance.Caption</item>
        <item name="android:maxLines">2</item>
        <item name="android:ellipsize">end</item>
    </style>

    <!-- List Item Action Container -->
    <style name="ListItemActions" parent="Container.Base">
        <item name="android:orientation">horizontal</item>
        <item name="android:layout_width">wrap_content</item>
    </style>
</resources>
```

---

### **6. DIALOG STYLE SYSTEM**

**A. Dialog Architecture:**
```xml
<!-- styles_dialog.xml -->
<resources>
    <!-- Dialog Container -->
    <style name="DialogContainer" parent="Container.Base">
        <item name="android:background">@drawable/bg_dialog_container</item>
        <item name="android:padding">@dimen/spacing_large</item>
        <item name="android:layout_margin">@dimen/spacing_normal</item>
    </style>

    <!-- Dialog Title -->
    <style name="DialogTitle" parent="Widget.AppCompat.TextView">
        <item name="android:textAppearance">@style/TextAppearance.Heading</item>
        <item name="android:layout_marginBottom">@dimen/spacing_normal</item>
        <item name="android:gravity">center</item>
    </style>

    <!-- Dialog Message -->
    <style name="DialogMessage" parent="Widget.AppCompat.TextView">
        <item name="android:textAppearance">@style/TextAppearance.Body</item>
        <item name="android:layout_marginBottom">@dimen/spacing_normal</item>
        <item name="android:gravity">center</item>
    </style>

    <!-- Dialog Highlight Box -->
    <style name="DialogHighlightBox" parent="Container.Base">
        <item name="android:background">@drawable/bg_dialog_highlight</item>
        <item name="android:padding">@dimen/spacing_medium</item>
        <item name="android:layout_marginVertical">@dimen/spacing_normal</item>
    </style>

    <!-- Dialog Highlight Text -->
    <style name="DialogHighlightText" parent="Widget.AppCompat.TextView">
        <item name="android:textAppearance">@style/TextAppearance.Body.Bold</item>
        <item name="android:textColor">@color/primary</item>
        <item name="android:gravity">center</item>
    </style>

    <!-- Dialog Warning -->
    <style name="DialogWarning" parent="Widget.AppCompat.TextView">
        <item name="android:textAppearance">@style/TextAppearance.Caption</item>
        <item name="android:textColor">@color/text_hint</item>
        <item name="android:layout_marginTop">@dimen/spacing_small</item>
        <item name="android:gravity">center</item>
    </style>

    <!-- Dialog Button Container -->
    <style name="DialogButtonContainer" parent="Container.Base">
        <item name="android:orientation">horizontal</item>
        <item name="android:layout_marginTop">@dimen/spacing_large</item>
        <item name="android:gravity">end</item>
    </style>

    <!-- Dialog Buttons -->
    <style name="DialogButton" parent="ButtonStyle">
        <item name="android:layout_marginStart">@dimen/spacing_small</item>
    </style>

    <style name="DialogButton.Cancel" parent="DialogButton">
        <item name="style">@style/ButtonStyle.Outline</item>
    </style>

    <style name="DialogButton.Confirm" parent="DialogButton">
        <item name="style">@style/ButtonStyle.Primary</item>
    </style>

    <style name="DialogButton.Danger" parent="DialogButton">
        <item name="style">@style/ButtonStyle.Danger</item>
    </style>
</resources>
```

---

### **7. STYLE USAGE PATTERNS**

**A. Consistent Style Application:**
```xml
<!-- Screen Layout -->
<LinearLayout style="@style/Container.Screen">
    
    <!-- Section with Card -->
    <LinearLayout style="@style/Container.Card">
        <TextView style="@style/DialogTitle" android:text="@string/title" />
        <TextView style="@style/DialogMessage" android:text="@string/message" />
    </LinearLayout>
    
    <!-- Form Section -->
    <LinearLayout style="@style/FormContainer">
        <com.google.android.material.textfield.TextInputLayout style="@style/InputStyle">
            <com.google.android.material.textfield.TextInputEditText style="@style/InputStyle.EditText" />
        </com.google.android.material.textfield.TextInputLayout>
        
        <LinearLayout style="@style/FormButtonContainer">
            <Button style="@style/ButtonStyle.Secondary" android:text="@string/cancel" />
            <Button style="@style/ButtonStyle.Primary" android:text="@string/save" />
        </LinearLayout>
    </LinearLayout>
    
</LinearLayout>
```

**B. List Item Usage:**
```xml
<!-- List Item -->
<LinearLayout style="@style/ListItem.Card">
    
    <LinearLayout style="@style/ListItemContent">
        <TextView style="@style/ListItemTitle" android:text="@string/item_title" />
        <TextView style="@style/ListItemSubtitle" android:text="@string/item_subtitle" />
    </LinearLayout>
    
    <LinearLayout style="@style/ListItemActions">
        <Button style="@style/ButtonStyle.Action.Edit" />
        <Button style="@style/ButtonStyle.Action.Delete" />
    </LinearLayout>
    
</LinearLayout>
```

---

## ✅ IMPLEMENTATION CHECKLIST

**File Organization:**
- [ ] styles.xml for theme and imports
- [ ] styles_shared.xml for text and containers
- [ ] styles_button.xml for button variants
- [ ] styles_input.xml for forms and inputs
- [ ] styles_list.xml for list components
- [ ] styles_dialog.xml for dialog components

**Style Hierarchy:**
- [ ] TextAppearance hierarchy established
- [ ] Container style base classes
- [ ] Component style inheritance
- [ ] Consistent naming conventions

**Component Styles:**
- [ ] Button style variants (Primary, Secondary, Outline, Danger)
- [ ] Input field styles with states
- [ ] List item component styles
- [ ] Dialog component styles
- [ ] Form layout styles

**Integration:**
- [ ] Styles use dimension resources
- [ ] Styles use semantic color names
- [ ] Material3 parent styles where appropriate
- [ ] Consistent spacing throughout styles

**Maintainability:**
- [ ] Logical file separation
- [ ] Clear inheritance hierarchy
- [ ] Reusable base styles
- [ ] Documentation in style files

This style system ensures consistent, maintainable, and scalable UI across all Android applications!