# 📱 Menu Standards Implementation Checklist

> **Pre-implementation verification for menu patterns**

## 🎯 REQUIRED Checks

### 🔍 Detection & Confirmation (CRITICAL)
- [ ] **Menu Detection:** Run commands to count menu items in all menu files
- [ ] **5+ Items Alert:** Show user confirmation with item list when >5 detected
- [ ] **User Choice:** Get explicit confirmation on which items move to "More" 
- [ ] **No Auto-Migration:** Never automatically move items without user approval

### Menu Item Limits (ALL MENU TYPES)
- [ ] **Bottom Navigation:** Maximum 4 items
- [ ] **App Bar Menu:** Maximum 5 items (3-4 recommended)
- [ ] **Context Menu:** Maximum 5 items (3-4 recommended)
- [ ] **Navigation Drawer:** Logical grouping with sections
- [ ] **No overflow:** All critical actions visible without scrolling
- [ ] **Excess Handling:** "More" tab or overflow menu implemented if >limits

### Show More Pattern (if exceeding limits)
- [ ] **Bottom Navigation >4:** 5th item becomes "More" with PopupMenu
- [ ] **App Bar >5:** Primary actions visible, secondary in overflow menu
- [ ] **PopupMenu:** Anchored to "More" navigation view
- [ ] **Menu Resources:** Separate more_navigation_menu.xml file
- [ ] **Fragment Factory:** Handles both main nav and overflow nav items
- [ ] **Overflow Menu:** Proper `app:showAsAction` attributes set

### App Bar Menu (Options Menu)
- [ ] **onCreateOptionsMenu()** implemented
- [ ] **onOptionsItemSelected()** with proper switch/case
- [ ] **res/menu/main_menu.xml** exists
- [ ] **Settings action** opens SettingsActivity
- [ ] **Share action** implements standard share intent
- [ ] **Menu icons** are 24dp and follow Material Design

### Bottom Navigation (if applicable)
- [ ] **app:labelVisibilityMode="selected"** attribute set
- [ ] **4 items maximum** in navigation menu
- [ ] **Fragment switching** properly implemented
- [ ] **Color selectors** for selected/unselected states
- [ ] **Icon states** match text selection states

## ⚠️ OPTIONAL Checks

### Navigation Drawer (if using)
- [ ] **DrawerLayout** properly configured
- [ ] **ActionBarDrawerToggle** implemented
- [ ] **NavigationView** with proper menu
- [ ] **Header layout** follows standards
- [ ] **Material theming** applied consistently

### Context Menu (if using)
- [ ] **onCreateContextMenu()** implemented
- [ ] **onContextItemSelected()** handles all actions
- [ ] **Long press registration** on target views
- [ ] **Standard actions** (edit/delete/share) available

## 🔍 Quality Checks

### Code Standards
- [ ] **Generic implementations** (no app-specific hardcoding)
- [ ] **Proper error handling** for menu actions
- [ ] **Consistent naming** following standards
- [ ] **Fragment management** uses proper transactions

### UI/UX Standards
- [ ] **Material Design** compliance
- [ ] **Accessibility** labels on all menu items
- [ ] **Consistent styling** across all menu types
- [ ] **Proper animations** and transitions

## 🚀 Performance Checks

- [ ] **Menu inflation** happens in onCreateOptionsMenu (not onCreate)
- [ ] **Fragment instances** reused where appropriate
- [ ] **Memory leaks** prevented in fragment transactions
- [ ] **Smooth animations** without janky transitions

---
**✅ All checks passed = Ready for implementation**