# 🎯 FAB Button Positioning

## Problem

FAB buttons bị che bởi Bottom Navigation Menu và Audio Player Mini View, khiến user không thể access được các action buttons quan trọng.

---

## Solution Overview

**Spacing Logic:**
- Bottom Navigation Height: **~56dp**
- Additional safe spacing: **24dp**
- **Total margin bottom: 80dp** (minimum required)
- Mini player peek height: **64dp** (when active)
- **With player margin: 144dp** (80dp + 64dp)

**Multiple Component Stack (Bottom to Top):**
1. **Bottom Navigation:** 56dp height (fixed at bottom)
2. **Audio Player Mini View:** 64dp peek height (when active)
3. **FAB Button:** Positioned 80dp from bottom (when no player)

---

## Critical Rules

### ✅ Required Layout Rules

1. **FAB must have minimum 80dp `layout_marginBottom`** when Bottom Navigation exists
2. **When audio player is showing:** FAB should move up dynamically or use 144dp margin (80dp + 64dp)
3. **FAB must NEVER be positioned at 0dp or 16dp** from bottom if Bottom Navigation exists
4. **Always use `layout_gravity="bottom|end"`** for consistent positioning
5. **Use `CoordinatorLayout`** for automatic FAB behavior with Snackbar/BottomSheet

---

## Implementation

### Basic Layout Structure

```xml
<androidx.coordinatorlayout.widget.CoordinatorLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <!-- Main content -->
    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/recycler_view"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:paddingBottom="80dp"
        android:clipToPadding="false" />

    <!-- FAB positioned above bottom navigation -->
    <com.google.android.material.floatingactionbutton.FloatingActionButton
        android:id="@+id/fab_refresh"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="bottom|end"
        android:layout_margin="16dp"
        android:layout_marginBottom="80dp"
        app:srcCompat="@drawable/ic_refresh"
        app:tint="@color/icon_tint" />

</androidx.coordinatorlayout.widget.CoordinatorLayout>
```

### Required Dimensions

**`res/values/dimens.xml`:**
```xml
<resources>
    <!-- FAB positioning -->
    <dimen name="fab_margin_default">80dp</dimen>          <!-- Bottom nav + spacing -->
    <dimen name="fab_margin_with_player">144dp</dimen>    <!-- Bottom nav + player + spacing -->
    
    <!-- Component heights -->
    <dimen name="bottom_navigation_height">56dp</dimen>
    <dimen name="mini_player_height">64dp</dimen>
    <dimen name="fab_safe_spacing">24dp</dimen>
</resources>
```

### Dynamic Adjustment (Java)

**When Audio Player Shows/Hides:**

```java
/**
 * Adjust FAB position when mini player shows or hides
 * @param miniPlayerVisible true if mini player is showing
 */
private void adjustFabPosition(boolean miniPlayerVisible) {
    if (fabRefresh == null) return;
    
    CoordinatorLayout.LayoutParams params = 
        (CoordinatorLayout.LayoutParams) fabRefresh.getLayoutParams();
    
    int bottomMargin = miniPlayerVisible 
        ? getResources().getDimensionPixelSize(R.dimen.fab_margin_with_player) // 144dp
        : getResources().getDimensionPixelSize(R.dimen.fab_margin_default);    // 80dp
    
    params.bottomMargin = bottomMargin;
    fabRefresh.setLayoutParams(params);
    
    // Optional: Animate the transition
    fabRefresh.animate()
        .translationY(miniPlayerVisible ? -64f : 0f)
        .setDuration(200)
        .start();
}
```

**Integration with Mini Player State:**

```java
// In your activity/fragment
private void setupMiniPlayerListener() {
    miniPlayer.addOnSlideListener(new BottomSheetBehavior.BottomSheetCallback() {
        @Override
        public void onStateChanged(@NonNull View bottomSheet, int newState) {
            boolean isVisible = (newState == BottomSheetBehavior.STATE_COLLAPSED || 
                               newState == BottomSheetBehavior.STATE_EXPANDED);
            adjustFabPosition(isVisible);
        }

        @Override
        public void onSlide(@NonNull View bottomSheet, float slideOffset) {
            // Smooth FAB movement during slide
            float translation = -slideOffset * 
                getResources().getDimensionPixelSize(R.dimen.mini_player_height);
            fabRefresh.setTranslationY(translation);
        }
    });
}
```

---

## RecyclerView Padding

**Important:** When using FAB with RecyclerView, add bottom padding to prevent last item from being hidden:

```xml
<androidx.recyclerview.widget.RecyclerView
    android:id="@+id/recycler_view"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:paddingBottom="@dimen/fab_margin_default"
    android:clipToPadding="false" />
```

**Why `clipToPadding="false"`:**
- Allows RecyclerView content to scroll under the padding
- Last item can scroll completely into view
- FAB doesn't cover content

---

## CoordinatorLayout Benefits

### Automatic Behaviors

1. **Snackbar Integration:**
   - FAB automatically moves up when Snackbar shows
   - No manual adjustment needed

2. **BottomSheet Interaction:**
   - FAB can automatically hide/show with BottomSheet
   - Use `layout_dodgeInsetEdges` and `layout_insetEdge`

3. **Scroll-based Behavior:**
   ```xml
   <com.google.android.material.floatingactionbutton.FloatingActionButton
       app:layout_behavior="com.google.android.material.behavior.HideBottomViewOnScrollBehavior" />
   ```
   - FAB hides when scrolling down
   - FAB shows when scrolling up

---

## User Experience Benefits

✅ **Refresh button always accessible** - User can trigger actions anytime  
✅ **No conflict with bottom navigation** - Proper spacing prevents overlaps  
✅ **No conflict with audio player** - Dynamic adjustment maintains accessibility  
✅ **Smooth scrolling không bị blocked** - Content can scroll freely  
✅ **Consistent with Material Design guidelines** - Professional appearance  

---

## Detection & Verification

### PowerShell Check Command

```powershell
# Check FAB positioning in all layout files
Get-ChildItem -Path .\app\src\main\res\layout -Filter "*.xml" -Recurse | 
    Select-String -Pattern "FloatingActionButton" -Context 5,5 | 
    Where-Object { $_.Line -match "marginBottom" }
```

### Manual Verification Checklist

- [ ] FAB has `layout_marginBottom` >= 80dp when Bottom Navigation exists
- [ ] FAB uses `layout_gravity="bottom|end"`
- [ ] FAB is inside `CoordinatorLayout` (recommended)
- [ ] RecyclerView has `paddingBottom` matching FAB margin
- [ ] RecyclerView has `clipToPadding="false"`
- [ ] Dimensions defined in `dimens.xml` (not hardcoded)
- [ ] Dynamic adjustment implemented if audio player exists
- [ ] FAB visible in both light and dark themes
- [ ] FAB tint color defined using `app:tint="@color/..."`

---

## Common Mistakes to Avoid

❌ **Using 16dp bottom margin** - Standard margin is NOT enough with Bottom Navigation  
❌ **Forgetting clipToPadding** - Last RecyclerView item will be hidden  
❌ **Hardcoding dp values** - Use dimens.xml for maintainability  
❌ **Not using CoordinatorLayout** - Miss out on automatic behaviors  
❌ **Ignoring audio player** - FAB gets covered when player shows  
❌ **Static positioning** - FAB should respond to UI state changes  

---

## Testing Checklist

Test FAB positioning in these scenarios:

1. [ ] **With Bottom Navigation only** - FAB visible at 80dp from bottom
2. [ ] **With Audio Player showing** - FAB moves up to 144dp from bottom
3. [ ] **Scrolling to bottom** - Last RecyclerView item fully visible
4. [ ] **Snackbar shows** - FAB automatically moves up
5. [ ] **Dark mode** - FAB visible with proper contrast
6. [ ] **Rotation** - FAB maintains correct position
7. [ ] **Different screen sizes** - FAB positioning scales correctly

---

## Related Rules

- **2.12. Bottom Navigation** - Base component that requires FAB adjustment
- **2.13. Theme & Settings** - FAB colors must respect theme system
- **Material Design 3** - FAB styling and behavior guidelines

---

*Last updated: December 12, 2025*
