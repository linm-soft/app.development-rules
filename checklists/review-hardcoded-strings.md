# ✅ Hardcoded Strings Checklist

## Quick Check

Run detection commands to find hardcoded strings:

### 1. Hardcoded Strings in Layouts

```powershell
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse | 
    Select-String 'android:(text|hint|contentDescription)="[^@]' | 
    Select-Object -Property Path, LineNumber, Line
```

**Expected:**
- ✅ No output = GOOD (all strings use `@string/`)
- ❌ Has output = FIX REQUIRED

### 2. Hardcoded Strings in Java

```powershell
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse | 
    Select-String '(setText|makeText|setContentDescription)\s*\([^,]*"' | 
    Select-Object -Property Path, LineNumber, Line
```

**Expected:**
- ✅ No output = GOOD (all use `R.string.xxx`)
- ❌ Has output = FIX REQUIRED

### 3. Check String Files Exist

```powershell
$enStrings = Get-ChildItem "app\src\main\res\values\strings*.xml"
$viStrings = Get-ChildItem "app\src\main\res\values-vi\strings*.xml"

Write-Host "English: $($enStrings.Count) files"
Write-Host "Vietnamese: $($viStrings.Count) files"

if ($enStrings.Count -eq $viStrings.Count) {
    Write-Host "✅ String files match" -ForegroundColor Green
} else {
    Write-Host "❌ File count mismatch" -ForegroundColor Red
}
```

## Allowed Exceptions

These are OK to have:
- Layout dimensions: `android:layout_width="48dp"`
- Boolean/numeric: `android:enabled="true"`
- Log tags: `String TAG = "MainActivity"`
- URL/Email constants: `String URL = "https://..."`

## NOT Allowed

- User-facing text (NEVER hardcode)
- Toast messages (use `R.string.xxx`)
- Dialog text (use `@string/xxx`)
- Button text (use `@string/xxx`)
- Hint text (use `@string/xxx`)
- Content descriptions (use `@string/xxx`)

## Compliance Checklist

- [ ] NO hardcoded text in layouts (`android:text="..."`)
- [ ] NO hardcoded text in Java (`setText("...")`)
- [ ] NO hardcoded Toast messages
- [ ] All strings use `R.string.xxx` or `@string/xxx`
- [ ] String files exist in both `values/` and `values-vi/`
- [ ] String names identical in both languages

**Result:**
- ✅ All checks pass = COMPLIANT
- ❌ Any hardcoded strings found = FIX REQUIRED

---

*For implementation details, see: [multi-language-support.md](../implementation/multi-language-support.md)*
