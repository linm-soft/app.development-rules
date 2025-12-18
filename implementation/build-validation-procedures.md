# 🔧 Build Validation & Troubleshooting

> **Prevents common build failures and provides resolution procedures**

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "build validation procedures"...
```

**Purpose:** Let user know AI is checking build validation and troubleshooting guidelines.

---

## 🎯 Pre-Build Validation Checklist

### 1. Resource Duplicate Detection
```powershell
# Check for duplicate string resources
Get-ChildItem -Path "app\src\main\res\values*" -Filter "*.xml" -Recurse | 
    ForEach-Object { 
        Select-String -Path $_.FullName -Pattern 'name="([^"]+)"' -AllMatches | 
        Group-Object { $_.Matches[0].Groups[1].Value } | 
        Where-Object { $_.Count -gt 1 }
    }

# Check for duplicate color resources  
Get-ChildItem -Path "app\src\main\res\values*" -Filter "colors*.xml" -Recurse | 
    ForEach-Object { 
        Select-String -Path $_.FullName -Pattern 'name="([^"]+)"' -AllMatches |
        Group-Object { $_.Matches[0].Groups[1].Value } |
        Where-Object { $_.Count -gt 1 }
    }
```

### 2. XML Syntax Validation
```powershell
# Check for escaped quotes in XML
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse |
    Select-String 'android:\w+="[^"]*\\"[^"]*"'

# Check for malformed attributes
Get-ChildItem -Path "app\src\main\res\layout" -Filter "*.xml" -Recurse |
    Select-String 'android:\w+=[^"]'
```

### 3. Resource Reference Validation  
```powershell
# Check for non-existent drawable references
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse |
    Select-String 'R\.drawable\.(\w+)' |
    ForEach-Object { 
        $drawable = $_.Matches[0].Groups[1].Value
        if (!(Test-Path "app\src\main\res\drawable*\$drawable.*")) {
            Write-Output "Missing drawable: $drawable in $($_.Filename)"
        }
    }

# Check for non-existent layout references
Get-ChildItem -Path "app\src\main\java" -Filter "*.java" -Recurse |
    Select-String 'R\.layout\.(\w+)' |
    ForEach-Object { 
        $layout = $_.Matches[0].Groups[1].Value
        if (!(Test-Path "app\src\main\res\layout\$layout.xml")) {
            Write-Output "Missing layout: $layout in $($_.Filename)"
        }
    }
```

---

## 🚨 Common Build Failures & Solutions

### 1. Resource Merger Errors

#### Error Pattern:
```
Resource and asset merger: Found item [Type/name] more than one time
```

#### Solution Procedure:
1. **Identify duplicates:**
   ```powershell
   grep -r "name=\"problem_resource_name\"" app/src/main/res/
   ```
2. **Remove duplicates** - Keep only one definition
3. **Verify fix:**
   ```powershell
   .\gradlew.bat clean
   .\gradlew.bat compileDebugJavaWithJavac
   ```

### 2. XML Parse Errors

#### Error Pattern:
```
Open quote is expected for attribute "android:text"
ParseError at [row,col]: Message: Open quote is expected
```

#### Solution Procedure:
1. **Find escaped quotes:**
   ```powershell
   Select-String 'android:\w+=\"[^"]*\\"' app/src/main/res/layout/*.xml
   ```
2. **Replace escaped quotes:**
   - `android:text=\"value\"` → `android:text="value"`
3. **Validate XML syntax**

### 3. Java Compilation: Cannot Find Symbol

#### Error Pattern:
```
error: cannot find symbol
  symbol:   variable/method/class [name]
  location: class [ClassName]
```

#### Solution Procedure:
1. **Check imports:** Ensure required classes are imported
2. **Verify method exists:** Check if method is defined in target class
3. **Resource references:** Validate R.string, R.drawable, R.layout exist
4. **Missing dependencies:** Check if required modules are included

### 4. CommonDialog Framework Issues

#### Error Pattern:
```
cannot find symbol: method show()
location: class Builder
```

#### Solution:
Ensure CommonDialog.Builder has show() method:
```java
public class Builder {
    // ... other methods ...
    
    public CommonDialog show() {
        CommonDialog dialog = build();
        dialog.show();
        return dialog;
    }
}
```

#### Usage Pattern:
```java
// ✅ CORRECT - Builder.show()
new CommonDialog.Builder(context)
    .setTitle("Title")
    .show();

// ✅ ALTERNATIVE - build().show()  
new CommonDialog.Builder(context)
    .setTitle("Title")
    .build()
    .show();
```

---

## 🔄 Build Recovery Procedures

### Quick Recovery Steps:
1. **Clean build:**
   ```bash
   .\gradlew.bat clean
   ```
2. **Incremental compilation test:**
   ```bash
   .\gradlew.bat compileDebugJavaWithJavac
   ```
3. **Full debug build:**
   ```bash
   .\gradlew.bat assembleDebug
   ```

### Advanced Recovery:
1. **Clear Gradle cache:**
   ```bash
   .\gradlew.bat cleanBuildCache
   ```
2. **Refresh dependencies:**
   ```bash
   .\gradlew.bat --refresh-dependencies build
   ```
3. **Force regenerate R class:**
   ```bash
   rm -rf app/build/generated/source/r/
   .\gradlew.bat assembleDebug
   ```

---

## ⚠️ Prevention Guidelines

### 1. Resource Management
- **Never duplicate resource names** across different files
- **Use consistent naming conventions** for resources
- **Validate XML syntax** before committing
- **Use resource references** instead of hardcoded values

### 2. Code Quality
- **Import required classes** explicitly  
- **Verify method signatures** match usage
- **Handle exceptions properly** with appropriate catch blocks
- **Use existing resources** rather than creating new ones

### 3. Testing Protocol
- **Test compilation** after each major change
- **Run clean builds** periodically  
- **Validate resource references** before adding new ones
- **Document custom component usage** patterns

---

**Status:** Use this guide to prevent and resolve build compilation issues effectively.