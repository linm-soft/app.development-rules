# ✅ Permissions Handling Checklist

## Quick Check

Verify permissions are properly declared and synchronized:

### 1. Check Permission Synchronization (CRITICAL)

```powershell
$manifest = Get-Content "app\src\main\AndroidManifest.xml" -Raw
$mainActivity = Get-Content "app\src\main\java\com\*\MainActivity.java" -Raw
$mainProfile = Get-ChildItem -Path "app\src\main\java" -Filter "MainProfile.java" -Recurse | 
                Select-Object -First 1 | 
                ForEach-Object { Get-Content $_.FullName -Raw }

# Count permissions
$manifestCount = ([regex]::Matches($manifest, 'uses-permission')).Count
$termsCount = ([regex]::Matches($mainActivity, 'TYPE_PERMISSION')).Count
$profileCount = ([regex]::Matches($mainProfile, 'PermissionInfo\(')).Count

Write-Host "`n=== Permission Synchronization ===" -ForegroundColor Cyan
Write-Host "AndroidManifest.xml: $manifestCount permissions" -ForegroundColor White
Write-Host "MainActivity terms: $termsCount items" -ForegroundColor White
Write-Host "MainProfile list: $profileCount items" -ForegroundColor White

if ($manifestCount -eq $termsCount -and $manifestCount -eq $profileCount) {
    Write-Host "`n✅ All 3 places synchronized!" -ForegroundColor Green
} else {
    Write-Host "`n❌ CRITICAL: Permission count mismatch!" -ForegroundColor Red
    Write-Host "   Fix: Sync all 3 places" -ForegroundColor Yellow
    Write-Host "   1. AndroidManifest.xml (declare permission)" -ForegroundColor Yellow
    Write-Host "   2. MainActivity.getPermissionTerms() (terms dialog)" -ForegroundColor Yellow
    Write-Host "   3. MainProfile.getAppPermissions() (permission list)" -ForegroundColor Yellow
}
```

**Expected:** ✅ Same count in all 3 places

### 2. Check MainProfile Has Permission Section

```powershell
if ($mainProfile -match 'getAppPermissions|PermissionInfo') {
    Write-Host "✅ Permission section implemented in MainProfile" -ForegroundColor Green
    
    # Check for permission check logic
    if ($mainProfile -match 'checkSelfPermission|canDrawOverlays') {
        Write-Host "✅ Permission status check implemented" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Permission status check not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ MISSING: Permission section in MainProfile" -ForegroundColor Red
}
```

### 3. Check Permission Strings

```powershell
# Check for permission strings in both languages
$enPerms = Select-String -Path "app\src\main\res\values\strings*.xml" -Pattern 'name="permission_'
$viPerms = Select-String -Path "app\src\main\res\values-vi\strings*.xml" -Pattern 'name="permission_'

Write-Host "`n=== Permission Strings ===" -ForegroundColor Cyan
Write-Host "English: $($enPerms.Count) permission strings"
Write-Host "Vietnamese: $($viPerms.Count) permission strings"

if ($enPerms.Count -eq $viPerms.Count -and $enPerms.Count -gt 0) {
    Write-Host "✅ Permission strings complete in both languages" -ForegroundColor Green
} else {
    Write-Host "⚠️  Permission strings may be incomplete" -ForegroundColor Yellow
}
```

### 4. Check openAppSettings Method

```powershell
if ($mainProfile -match 'Settings\.ACTION_APPLICATION_DETAILS_SETTINGS') {
    Write-Host "✅ openAppSettings method implemented" -ForegroundColor Green
} else {
    Write-Host "⚠️  openAppSettings method not found" -ForegroundColor Yellow
}
```

### 5. List All Permissions

```powershell
Write-Host "`n=== Permissions Declared ===" -ForegroundColor Cyan
Select-String -Path "app\src\main\AndroidManifest.xml" -Pattern 'uses-permission.*name="([^"]+)"' | 
    ForEach-Object { 
        $perm = $_.Matches.Groups[1].Value -replace 'android\.permission\.', ''
        Write-Host "  - $perm" -ForegroundColor White
    }
```

## Compliance Checklist

**Critical Synchronization:**
- [ ] Same permission count in all 3 places:
  - [ ] AndroidManifest.xml (declared)
  - [ ] MainActivity.getPermissionTerms() (terms dialog)
  - [ ] MainProfile.getAppPermissions() (permission list)

**MainProfile Implementation:**
- [ ] `getAppPermissions()` method exists
- [ ] Returns `List<PermissionInfo>`
- [ ] Check permission status logic (`checkSelfPermission`)
- [ ] Handle special permissions (SYSTEM_ALERT_WINDOW)
- [ ] `openAppSettings()` method exists
- [ ] Refresh permissions in `onResume()`

**UI Display:**
- [ ] Permission section visible in MainProfile layout
- [ ] Shows permission name, description, status
- [ ] Action button for denied permissions
- [ ] Status updates when returning from Settings

**Strings:**
- [ ] Permission strings in `values/strings_profile.xml`
- [ ] Permission strings in `values-vi/strings_profile.xml`
- [ ] String names follow pattern: `permission_[type]_name/desc`

**Result:**
- ✅ All 3 places synchronized + MainProfile implemented = COMPLIANT
- ❌ Mismatch in counts = FIX REQUIRED (sync all 3)
- ⚠️ Missing UI elements = Recommended to complete

---

*For implementation details, see: [permissions-handling.md](../implementation/permissions-handling.md)*
