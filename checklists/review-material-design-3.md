# Material Design 3 Migration Review Checklist

> **🎯 Purpose:** Detect and verify Material Design 3 migration compliance
> **📱 Support:** Check MD3 implementation and device compatibility

---

## 🔍 Quick Detection Commands

### 0. Detect Custom Components (Before Migration)

```powershell
# Find custom View/ViewGroup classes
Write-Host "=== Custom View Classes ==="
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String "class.*extends.*(View|ViewGroup|Button|CardView)" | 
    Select-Object Path, LineNumber, Line

# Find custom XML components in layouts
Write-Host "`n=== Custom XML Components ==="
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String "<([a-z]+\.)+[A-Z][a-zA-Z]*" | 
    Select-Object Path, LineNumber, Line

# Find custom drawable components
Write-Host "`n=== Custom Drawables ==="
Get-ChildItem -Path "app\src\main\res\drawable" -Filter "*.xml" -Recurse | 
    Select-String "shape|selector|layer-list" | 
    Select-Object Path, LineNumber, Line | 
    Where-Object { $_.Line -notmatch "vector|adaptive-icon" }

# Find custom styles that may conflict with MD3
Write-Host "`n=== Custom Styles ==="
Get-ChildItem -Path "app\src\main\res\values" -Filter "styles.xml" -Recurse | 
    Select-String "<style.*name=\"(Widget\.|Base\.)" | 
    Select-Object Path, LineNumber, Line

# Find potential MD3 migration candidates
Write-Host "`n=== Migration Candidates ==="
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String "androidx\.cardview|AppCompatButton|android\.widget\.Button" | 
    Select-Object Path, LineNumber, Line
```

**Expected Output Analysis:**
```
=== Custom View Classes ===
CustomButton.java:15:    public class CustomButton extends AppCompatButton {
RoundedCardView.java:8:  public class RoundedCardView extends CardView {

=== Custom XML Components ===
activity_main.xml:25:    <com.app.views.CustomButton
settings_dialog.xml:12:  <com.app.dialogs.CustomDialog

=== Custom Drawables ===
button_gradient.xml:3:   <shape xmlns:android="http://schemas.android.com/apk/res/android">
card_rounded.xml:5:      <shape android:shape="rectangle">

=== Migration Candidates ===
fragment_home.xml:18:    <androidx.cardview.widget.CardView
activity_main.xml:45:    <AppCompatButton
```

### 0.1 Generate Component Comparison Table

```powershell
# Generate comparison data for user review
function Get-ComponentMigrationOptions {
    $results = @()
    
    # Analyze custom buttons
    $customButtons = Get-ChildItem -Path "app\src\main\java" -Filter "*Button*.java" -Recurse | 
        Select-String "class.*extends.*Button"
    foreach ($button in $customButtons) {
        $results += [PSCustomObject]@{
            Component = "CustomButton"
            Location = $button.Path
            MD3Equivalent = "MaterialButton"
            Benefits = "Material You theming, built-in ripple, accessibility"
            Effort = "Low"
            Recommendation = "Migrate"
        }
    }
    
    # Analyze CardViews
    $cardViews = Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
        Select-String "androidx\.cardview\.widget\.CardView"
    foreach ($card in $cardViews) {
        $results += [PSCustomObject]@{
            Component = "CardView"
            Location = $card.Path
            MD3Equivalent = "MaterialCardView" 
            Benefits = "Dynamic elevation, outline support, Material You colors"
            Effort = "Low"
            Recommendation = "Migrate"
        }
    }
    
    # Output formatted table
    $results | Format-Table -AutoSize
    return $results
}

# Execute analysis
$migrationOptions = Get-ComponentMigrationOptions
```

---

## 🔍 Quick Detection Commands

### 1. Check Material Design Version

```powershell
# Check current Material version in build.gradle
Get-Content "app\build.gradle" | Select-String "material:"
```

**Expected Output:**
```
implementation 'com.google.android.material:material:1.11.0'  # ✅ MD3
```

**❌ Fail if:**
- Version is 1.9.0 or lower (Material Design 2)
- Version is missing

---

### 2. Verify MD3 Theme Implementation

```powershell
# Check for MD3 theme parents
Get-ChildItem -Path "app\src\main\res\values" -Filter "themes.xml" -Recurse | 
    Select-String "Theme.Material3" | 
    Select-Object Path, LineNumber, Line
```

**Expected Output:**
```
themes.xml:5:    <style name="Base.Theme.AppName" parent="Theme.Material3.DayNight">  # ✅ MD3
```

**❌ Fail if:**
- Still using `Theme.MaterialComponents` (MD2)
- No MD3 theme parents found

---

### 3. Check for MD2 Remnants

```powershell
# Find old MD2 components (should be zero)
Get-ChildItem -Path "app\src\main\res" -Filter "*.xml" -Recurse | 
    Select-String "Theme.MaterialComponents|@style/Widget.MaterialComponents" | 
    Select-Object Path, LineNumber, Line
```

**Expected Output:**
```
(No output - all MD2 references removed)  # ✅ Clean
```

**❌ Fail if:**
- Any MD2 theme or style references found

---

### 4. Verify MD3 Color System

```powershell
# Check for MD3 color definitions
Get-Content "app\src\main\res\values\colors.xml" | 
    Select-String "md_theme_(light|dark)_" | Measure-Object -Line
```

**Expected Output:**
```
Count : 24  # ✅ At least 24 MD3 color definitions
```

**❌ Fail if:**
- Less than 20 MD3 color definitions
- No `md_theme_light_*` or `md_theme_dark_*` colors

---

### 5. Check Dynamic Colors Implementation

```powershell
# Check for Material You dynamic colors in Java files
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String "DynamicColors\.apply" | 
    Select-Object Path, LineNumber, Line
```

**Expected Output:**
```
MainActivity.java:25:        DynamicColors.applyToActivityIfAvailable(this);  # ✅ Implemented
```

**❌ Fail if:**
- No dynamic color implementation found
- Missing Android version check

---

### 6. Verify Material3 Components Usage

```powershell
# Check for MaterialCardView usage (MD3)
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String "com\.google\.android\.material\.card\.MaterialCardView" | 
    Measure-Object -Line
```

**Expected Output:**
```
Count : 3  # ✅ Using MaterialCardView (MD3)
```

**❌ Fail if:**
- Still using `androidx.cardview.widget.CardView` (MD2)
- No Material3 components found

---

## 📋 Manual Verification Checklist

### A. Pre-Migration: Custom Component Analysis

**🔍 User Confirmation Required:**
- [ ] **Review custom components** - Run detection commands above
- [ ] **Show comparison table** - Present MD3 alternatives vs custom components  
- [ ] **Get user decisions** - For each component: Migrate/Keep/Skip
- [ ] **Create migration plan** - Based on user selections
- [ ] **Create backups** - Before any component changes

**📝 Component Decision Template:**
```
Component: CustomButton.java
├─ Current: Custom styling with gradient drawable  
├─ MD3 Alternative: MaterialButton with theme attributes
├─ Benefits: Material You support, accessibility, consistency
├─ Migration Effort: Low (2 hours)
├─ Risks: May need style adjustments
└─ User Decision: [ ] Migrate [ ] Keep Custom [ ] Skip

Component: RoundedCardView.xml  
├─ Current: Custom drawable with fixed corner radius
├─ MD3 Alternative: MaterialCardView with dynamic corners
├─ Benefits: Elevation animation, theme colors, outline support
├─ Migration Effort: Medium (4 hours) 
├─ Risks: Layout changes may be needed
└─ User Decision: [ ] Migrate [ ] Keep Custom [ ] Skip
```

### B. Theme Files Structure

**Check these files exist:**
- [ ] `app/src/main/res/values/themes.xml` - Light theme with MD3 colors
- [ ] `app/src/main/res/values-night/themes.xml` - Dark theme with MD3 colors
- [ ] `app/src/main/res/values/colors.xml` - MD3 color system

### B. Theme Content Verification

**themes.xml (Light) must contain:**
- [ ] Parent: `Theme.Material3.DayNight`
- [ ] `colorPrimary` → `@color/md_theme_light_primary`
- [ ] `colorSurface` → `@color/md_theme_light_surface`
- [ ] `colorBackground` → `@color/md_theme_light_background`

**themes.xml (Night) must contain:**
- [ ] Parent: `Theme.Material3.DayNight` (same parent)
- [ ] `colorPrimary` → `@color/md_theme_dark_primary`
- [ ] `colorSurface` → `@color/md_theme_dark_surface`
- [ ] `colorBackground` → `@color/md_theme_dark_background`

### C. Java Code Verification

**MainActivity.java must have:**
- [ ] `import com.google.android.material.color.DynamicColors;`
- [ ] `DynamicColors.applyToActivityIfAvailable(this);` in onCreate()
- [ ] Android version check: `Build.VERSION.SDK_INT >= Build.VERSION_CODES.S`

### D. Component Migration

**Layout files should use:**
- [ ] `MaterialCardView` instead of `CardView`
- [ ] `MaterialButton` with MD3 styles
- [ ] `style="@style/Widget.Material3.*"` attributes

---

## 🚨 Common Issues & Detection

### Issue 0: User Wants to Keep Custom Components

**Detection:**
```powershell
# Track user decisions and validate compatibility
function Test-CustomComponentCompatibility {
    param([string]$ComponentPath)
    
    # Check if custom component uses MD2-specific attributes
    $md2Attributes = Get-Content $ComponentPath | 
        Select-String "app:theme|android:theme.*AppCompat" 
        
    if ($md2Attributes) {
        Write-Host "⚠️ Custom component uses MD2 attributes that may not work with MD3"
        Write-Host "Consider updating component to use MD3-compatible attributes"
    }
}

# Check custom components for MD2 dependencies  
Get-ChildItem -Path "app\src\main\java" -Filter "*Custom*.java" -Recurse |
    ForEach-Object { Test-CustomComponentCompatibility $_.FullName }
```

**✅ Action:** Update custom components to use MD3-compatible attributes while preserving custom functionality

### Issue 1: Mixed MD2/MD3 Usage

**Detection:**
```powershell
# Find mixed usage (should be zero)
Get-ChildItem -Path "app\src\main\res" -Filter "*.xml" -Recurse | 
    Select-String "MaterialComponents" | 
    Where-Object { $_.Line -notmatch "<!-- Old|Deprecated" }
```

**❌ Fail if:** Any active MD2 references found

### Issue 2: Missing Dynamic Colors

**Detection:**
```powershell
# Check if DynamicColors is imported but not used
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String "import.*DynamicColors" | 
    ForEach-Object {
        $file = $_.Filename
        $hasApply = Get-Content $_.Path | Select-String "DynamicColors\.apply"
        if (-not $hasApply) {
            Write-Output "❌ $file imports DynamicColors but doesn't use it"
        }
    }
```

### Issue 3: Incomplete Color Migration

**Detection:**
```powershell
# Check for hardcoded colors in themes (should reference MD3 colors)
Get-Content "app\src\main\res\values\themes.xml" | 
    Select-String "#[0-9A-F]{6,8}" | 
    Where-Object { $_.Line -notmatch "<!-- Legacy|Deprecated" }
```

**❌ Fail if:** Hardcoded colors found in theme files

---

## ✅ Success Criteria

### Minimum Requirements (MUST PASS)

0. **✅ User Confirmation Completed:** All custom components reviewed and decisions documented
1. **✅ Dependency Updated:** Material library version ≥ 1.11.0
2. **✅ Theme Parents:** All themes use `Theme.Material3.DayNight`
3. **✅ Color System:** MD3 color definitions present (≥20 colors)
4. **✅ No MD2 Remnants:** Zero `MaterialComponents` references (except user-selected custom components)
5. **✅ Dynamic Colors:** Implemented with version check
6. **✅ Build Success:** App compiles and runs without errors
7. **✅ Component Migration:** All user-selected components successfully migrated
8. **✅ Custom Component Compatibility:** Remaining custom components work with MD3 themes

### Recommended Enhancements (SHOULD PASS)

1. **🔶 MaterialCardView:** Migrated from androidx.cardview (unless user chose to keep custom)
2. **🔶 Material3 Styles:** Components use `Widget.Material3.*` styles  
3. **🔶 Graceful Degradation:** Fallback for Android 7-11 devices
4. **🔶 Theme Consistency:** Light and dark themes properly paired
5. **🔶 Migration Documentation:** Component decisions and changes documented
6. **🔶 Rollback Capability:** Backups available for rollback if needed

### Custom Component Compatibility Check

**✅ For each custom component user chose to keep:**
- [ ] Works with MD3 themes (no visual breaking)
- [ ] Uses MD3-compatible color attributes where possible
- [ ] Maintains functionality with MD3 navigation/layout changes  
- [ ] Documented reason for keeping custom vs migrating
- [ ] Has migration path defined for future (optional)

**📝 Migration Decision Log:**
```markdown
# Component Migration Decisions - [App Name]

## User Selections
| Component | Decision | Reason | Status |
|-----------|----------|--------|--------|
| CustomButton | ✅ Migrate | Better theming support | ✅ Completed |
| RoundedCardView | ❌ Keep | Complex animations not in MD3 | ⚠️ Compatibility checked |
| CustomDialog | ✅ Migrate | MD3 accessibility features | ✅ Completed |

## Compatibility Notes
- RoundedCardView: Updated color references to use ?attr/colorSurface
- All custom components tested with MD3 themes
- No functionality lost during migration
```

---

## 📊 Compliance Report Template

```markdown
# Material Design 3 Migration - Compliance Report

**App:** {app_name}
**Date:** {date}
**Status:** {PASS/FAIL/PARTIAL}

## Requirements Check

| Check | Status | Details |
|-------|--------|---------|
| Material Library ≥ 1.11.0 | ✅/❌ | Version: {version} |
| MD3 Theme Parents | ✅/❌ | Found in: {files} |
| MD3 Color System | ✅/❌ | Colors defined: {count} |
| No MD2 Remnants | ✅/❌ | Remaining MD2: {count} |
| Dynamic Colors | ✅/❌ | Implementation: {details} |
| Build Success | ✅/❌ | Result: {success/error} |

## Issues Found

{List any issues detected}

## Next Steps

{Actions needed to achieve full compliance}
```

---

## 🔄 Integration with Main Review

**When to run this checklist:**
- During full app compliance review
- When upgrading Material dependencies
- Before releasing new app versions
- When implementing new Material components

**Add to main review workflow:**
```powershell
# Add this to main code-review-detection.md
echo "=== Material Design 3 Compliance ==="
Get-Content "app\build.gradle" | Select-String "material:"
# ... other MD3 detection commands
```

---

*Last updated: December 2024*
*Part of: ANDROID_PROJECT_RULES.md checklist system*