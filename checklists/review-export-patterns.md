# ✅ Export Pattern Validation Checklist

## Quick Detection Commands

### 1. Find Overly Broad Exclude Patterns

```powershell
# Find patterns that might exclude valid files
Select-String -Pattern '\"\*[^/\\]*\*\"' export-full-project.ps1
```

**Expected:**
- ✅ Should return specific patterns like "*.tmp*", "*.temp*"
- ❌ Should NOT return broad patterns like "*debug*", "*build*"

### 2. Test Pattern Against Project Files

```powershell
# Test if pattern would exclude valid project files
$TestFiles = @(
    "main_profile_debug_section.xml",
    "BuildConfig.java", 
    "generated_values.xml",
    "dialog_release_notes.xml",
    "debug_utils.java",
    "version_release.xml"
)

$Pattern = "*debug*"  # Replace with pattern to test
$TestFiles | Where-Object { $_ -like $Pattern }
```

### 3. Validate Current Exclude List

```powershell
# Show all exclude patterns in export script
Get-Content export-full-project.ps1 | Select-String -Pattern '^\s*".*",'
```

## Pattern Guidelines

### ✅ GOOD Patterns (Specific)
```powershell
"*/build/*"              # Only build folders
"*/debug/*"              # Only debug folders  
"*/generated/*"          # Only generated folders
"*.log"                  # Only .log files
"*.tmp"                  # Only .tmp files
"*.class"                # Only .class files
"gradlew*"               # Gradle wrapper files
```

### ❌ BAD Patterns (Too Broad)  
```powershell
"*debug*"                # Excludes debug_section.xml
"*build*"                # Excludes BuildConfig.java
"*generated*"            # Excludes generated_values.xml
"*release*"              # Excludes release_notes.md
"*.log*"                 # Excludes dialog.xml
"*test*"                 # Excludes contest.xml, latest.xml
```

### 🔧 Pattern Conversion Examples
```powershell
# Convert broad patterns to specific ones
"*debug*"     →  "*/debug/*", "*/debug\\*", "*.debug"
"*build*"     →  "*/build/*", "*/build\\*", "gradlew*" 
"*generated*" →  "*/generated/*", "*/generated\\*"
"*release*"   →  "*/release/*", "*/release\\*"
"*.log*"      →  "*.log", "*.logs"
```

## Testing Workflow

### 1. Before Adding New Pattern
```powershell
# 1. List files that would match
Get-ChildItem -Recurse -Name | Where-Object { $_ -like "*new_pattern*" }

# 2. Check if any are valid project files
# 3. Refine pattern if needed
```

### 2. After Pattern Changes
```powershell
# Run export and verify important files included
.\export-project.bat
# Check exported files contain expected layouts/resources
```

## Common False Positives

### Files Often Incorrectly Excluded
- `main_profile_debug_section.xml` - Layout component
- `dialog_build_info.xml` - Dialog layout  
- `BuildConfig.java` - Auto-generated config
- `generated_values.xml` - Resource file
- `debug_utils.java` - Debug utility class
- `release_notes.md` - Documentation
- `test_constants.xml` - Test configuration

### Solutions
```powershell
# Instead of "*debug*" use:
"*/debug/*"              # Debug build folders only
"*/debug\\*"

# Instead of "*build*" use:  
"*/build/*"              # Build output folders only
"*/build\\*"
"gradlew*"               # Gradle wrapper specifically

# Instead of "*generated*" use:
"*/generated/*"          # Generated code folders only
"*/generated\\*"
```

## Compliance Checklist

- [ ] NO patterns like `"*word*"` for common words
- [ ] All folder exclusions use `"*/folder/*"` format
- [ ] File extensions are specific: `"*.ext"` not `"*.ext*"`
- [ ] Tested against actual project file structure
- [ ] Important files like layouts/resources not excluded
- [ ] Export includes all necessary source code files
- [ ] Build artifacts properly excluded

**Result:**
- ✅ All patterns specific and accurate = COMPLIANT
- ❌ Any broad patterns found = UPDATE REQUIRED

---

*Related rule: [android-project-rules.md](../platform-rules/android-project-rules.md) - Rule 2.25*