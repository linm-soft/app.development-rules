# ✅ Multi-language Support Checklist

## Quick Check

Verify both English and Vietnamese translations are synchronized:

### 1. Check Language Folders Exist

```powershell
if ((Test-Path "app\src\main\res\values") -and (Test-Path "app\src\main\res\values-vi")) {
    Write-Host "✅ Both language folders exist" -ForegroundColor Green
} else {
    Write-Host "❌ Missing language folder" -ForegroundColor Red
}
```

### 2. Check String File Parity

```powershell
$enFiles = Get-ChildItem "app\src\main\res\values\strings*.xml"
$viFiles = Get-ChildItem "app\src\main\res\values-vi\strings*.xml"

Write-Host "English strings files: $($enFiles.Count)"
Write-Host "Vietnamese strings files: $($viFiles.Count)"

if ($enFiles.Count -eq $viFiles.Count) {
    Write-Host "✅ File count matches" -ForegroundColor Green
} else {
    Write-Host "❌ File count mismatch!" -ForegroundColor Red
}
```

### 3. Check String Names Match

```powershell
foreach ($enFile in $enFiles) {
    $basename = $enFile.Name
    $viFile = "app\src\main\res\values-vi\$basename"
    
    if (-not (Test-Path $viFile)) {
        Write-Host "❌ MISSING: $viFile" -ForegroundColor Red
        continue
    }
    
    Write-Host "`nChecking $basename..." -ForegroundColor Cyan
    
    $enNames = Select-String -Path $enFile.FullName -Pattern 'name="([^"]+)"' | 
               ForEach-Object { $_.Matches.Groups[1].Value }
    $viNames = Select-String -Path $viFile -Pattern 'name="([^"]+)"' | 
               ForEach-Object { $_.Matches.Groups[1].Value }
    
    $missing = Compare-Object $enNames $viNames | Where-Object { $_.SideIndicator -eq '<=' }
    
    if ($missing) {
        Write-Host "❌ Strings missing in Vietnamese:" -ForegroundColor Red
        $missing.InputObject | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    } else {
        Write-Host "✅ All strings present in both languages" -ForegroundColor Green
    }
}
```

### 4. Check for Hardcoded Strings

See: [review-hardcoded-strings.md](./review-hardcoded-strings.md)

## Compliance Checklist

- [ ] Both `values/` and `values-vi/` folders exist
- [ ] Same number of `strings*.xml` files in both folders
- [ ] String names identical in both languages
- [ ] No hardcoded text in Java code
- [ ] No hardcoded text in XML layouts
- [ ] String names use snake_case (not camelCase)
- [ ] String names prefixed by feature

**Result:**
- ✅ All checks pass = COMPLIANT
- ❌ Any check fails = FIX REQUIRED

---

*For implementation details, see: [multi-language-support.md](../implementation/multi-language-support.md)*
