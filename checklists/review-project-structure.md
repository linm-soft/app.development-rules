# ✅ Project Structure Checklist

## Quick Check

Run these commands to verify project structure compliance:

### 1. Check MainProfile Fragment Exists (REQUIRED)

```powershell
# Check MainProfile.java exists
$profile = Get-ChildItem -Path "app\src\main\java" -Filter "MainProfile.java" -Recurse

if ($profile) {
    Write-Host "✅ MainProfile.java found: $($profile.FullName)" -ForegroundColor Green
} else {
    Write-Host "❌ MISSING: MainProfile.java (REQUIRED)" -ForegroundColor Red
}
```

**Expected:** ✅ File must exist in root package or fragments subfolder

### 2. Check Standard Folder Structure

```powershell
$folders = @(
    "app\src\main\java",
    "app\src\main\res\layout",
    "app\src\main\res\values",
    "app\src\main\res\values-vi",
    "app\src\main\res\drawable"
)

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "✅ $folder" -ForegroundColor Green
    } else {
        Write-Host "❌ MISSING: $folder" -ForegroundColor Red
    }
}
```

**Expected:** ✅ All standard folders exist

### 3. Check Package Structure

```powershell
# Check for organized package structure
$javaPath = "app\src\main\java\com"

if (Test-Path $javaPath) {
    $structure = Get-ChildItem $javaPath -Directory -Recurse | Select-Object -First 10
    Write-Host "✅ Package structure found" -ForegroundColor Green
    $structure | ForEach-Object { Write-Host "  - $($_.Name)" }
} else {
    Write-Host "❌ Package structure not found" -ForegroundColor Red
}
```

## Compliance Checklist

- [ ] MainProfile.java exists (REQUIRED)
- [ ] Standard folders: java, layout, values, values-vi, drawable
- [ ] Package follows com.appname.* structure
- [ ] Fragments organized (root or fragments/ subfolder)

**Result:**
- ✅ All checks pass = COMPLIANT
- ❌ Any check fails = FIX REQUIRED

---

*For implementation details, see: [project-structure.md](../implementation/project-structure.md)*
