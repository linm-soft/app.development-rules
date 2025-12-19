# 🎨 Resources Organization

## Colors - Semantic Naming

```xml
<!-- colors.xml -->
<resources>
    <!-- Brand Colors -->
    <color name="primary">#09A3E3</color>
    <color name="primary_dark">#0891CC</color>
    <color name="primary_light">#ACDEF2</color>
    <color name="accent">#FF5722</color>
    
    <!-- Background Colors -->
    <color name="background">#F5F5F5</color>
    <color name="background_dark">#1A1A1A</color>
    <color name="card_background">#FFFFFF</color>
    <color name="card_background_dark">#2D2D2D</color>
    
    <!-- Text Colors -->
    <color name="text_primary">#212121</color>
    <color name="text_secondary">#757575</color>
    <color name="text_hint">#9E9E9E</color>
    <color name="text_disabled">#BDBDBD</color>
    
    <!-- Status Colors -->
    <color name="success">#4CAF50</color>
    <color name="warning">#FF9800</color>
    <color name="error">#F44336</color>
    
    <!-- UI Element Colors -->
    <color name="divider">#E0E0E0</color>
    <color name="button_danger">#F44336</color>
    <color name="button_disabled">#E0E0E0</color>
</resources>
```

## Dimensions - Consistent Spacing

```xml
<!-- dimens.xml -->
<resources>
    <!-- Spacing (use multiples of 4dp or 8dp) -->
    <dimen name="spacing_tiny">4dp</dimen>
    <dimen name="spacing_small">8dp</dimen>
    <dimen name="spacing_medium">12dp</dimen>
    <dimen name="spacing_normal">16dp</dimen>
    <dimen name="spacing_large">24dp</dimen>
    <dimen name="spacing_xlarge">32dp</dimen>
    
    <!-- Text Sizes -->
    <dimen name="text_size_tiny">10sp</dimen>
    <dimen name="text_size_small">12sp</dimen>
    <dimen name="text_size_normal">14sp</dimen>
    <dimen name="text_size_medium">16sp</dimen>
    <dimen name="text_size_large">18sp</dimen>
    <dimen name="text_size_xlarge">20sp</dimen>
    <dimen name="text_size_title">24sp</dimen>
    <dimen name="text_size_headline">32sp</dimen>
    
    <!-- Component Sizes -->
    <dimen name="button_height">48dp</dimen>
    <dimen name="button_min_width">88dp</dimen>
    <dimen name="icon_size_small">16dp</dimen>
    <dimen name="icon_size_normal">24dp</dimen>
    <dimen name="icon_size_large">32dp</dimen>
    <dimen name="card_corner_radius">8dp</dimen>
    <dimen name="card_elevation">2dp</dimen>
</resources>
```

## Styles - Component-Based

```xml
<!-- styles.xml -->
<resources>
    <!-- Text Styles -->
    <style name="Text" />
    
    <style name="Text.Title">
        <item name="android:textSize">@dimen/text_size_title</item>
        <item name="android:textColor">@color/text_primary</item>
        <item name="android:textStyle">bold</item>
    </style>
    
    <style name="Text.Body">
        <item name="android:textSize">@dimen/text_size_normal</item>
        <item name="android:textColor">@color/text_primary</item>
    </style>
    
    <style name="Text.Caption">
        <item name="android:textSize">@dimen/text_size_small</item>
        <item name="android:textColor">@color/text_secondary</item>
    </style>
    
    <!-- Button Styles -->
    <style name="Button" parent="Widget.MaterialComponents.Button">
        <item name="android:minHeight">@dimen/button_height</item>
        <item name="cornerRadius">@dimen/card_corner_radius</item>
    </style>
    
    <style name="Button.Primary">
        <item name="backgroundTint">@color/primary</item>
        <item name="android:textColor">@android:color/white</item>
    </style>
    
    <style name="Button.Secondary">
        <item name="backgroundTint">@color/card_background</item>
        <item name="android:textColor">@color/text_primary</item>
    </style>
    
    <style name="Button.Danger">
        <item name="backgroundTint">@color/button_danger</item>
        <item name="android:textColor">@android:color/white</item>
    </style>
    
    <!-- Card Styles -->
    <style name="Card" parent="Widget.MaterialComponents.CardView">
        <item name="cardCornerRadius">@dimen/card_corner_radius</item>
        <item name="cardElevation">@dimen/card_elevation</item>
        <item name="cardBackgroundColor">@color/card_background</item>
    </style>
</resources>
```
