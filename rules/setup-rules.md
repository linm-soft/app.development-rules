# Setup Rules (2.1-2.8)

> Basic project setup and organization standards

---

## 📢 AI ANNOUNCEMENT PROTOCOL

**⚠️ MANDATORY: When AI reads this file, ALWAYS announce:**

```
AI assistance đang check "setup-rules"...
```

**Purpose:** Let user know AI is referencing setup rules.

---

## 2.1. App Profile

**📂 See:** [`implementation/app-profile.md`](../implementation/app-profile.md)

**Quick Reference:**
- Developer: `[Your Name/Company]`
- Contact: `[Your Email]`
- Website: `[Your Website]`
- BUILD_TIME config for release date display

---

## 2.2. Application ID Format

**⚠️ REQUIRED:** Standard application ID format for all apps

**Format:** `linm.soft.[appname]`

**Examples:**
```xml
<!-- Android (app/build.gradle) -->
android {
    defaultConfig {
        applicationId "linm.soft.smartcallblock"
        applicationId "linm.soft.dailyspeak"
        applicationId "linm.soft.quicksnooze"
    }
}

<!-- iOS (Info.plist) -->
<key>CFBundleIdentifier</key>
<string>linm.soft.smartcallblock</string>
```

**Naming Rules:**
- Use lowercase only: `smartcallblock` not `SmartCallBlock`
- No hyphens or underscores: `dailyspeak` not `daily-speak` 
- Remove spaces: `quicksnooze` not `quick snooze`
- Keep it short but descriptive

**Build Script Integration:**
- Build scripts automatically detect and use this format
- Compatible with both Android and iOS projects
- Ensures unique app identification across platforms

---

## 2.3. Project Structure

**📂 See:** [`implementation/project-structure.md`](../implementation/project-structure.md)

**Quick Reference:**
- Standard Android project layout
- Java package: `com.appname`
- **REQUIRED:** `MainProfile.java` fragment in every app

---

## 2.4. Gradle Configuration

**📂 See:** [`implementation/gradle-configuration.md`](../implementation/gradle-configuration.md)

**Quick Reference:**
- Local Gradle distribution required
- Copy build scripts from `development-rules/build/`
- Configure `local.properties` and `gradle.properties`

---

## 2.5. Naming Conventions

**📂 See:** [`implementation/naming-conventions.md`](../implementation/naming-conventions.md)

**Quick Reference:**
- Activity: `[Feature]Activity.java`
- Fragment: `Main[Feature].java`
- Layout: `[type]_[feature]_[name].xml`
- Resource: `[type]_[feature]_[name]`

---

## 2.6. Build Setup

**📂 See:** [`implementation/build-setup.md`](../implementation/build-setup.md)

**Quick Reference:**
- BUILD_TIME in BuildConfig
- `build-apk.bat` for debug builds
- `build-release.bat` for release APK

---

## 2.7. Java Code Organization

**📂 See:** [`implementation/java-organization.md`](../implementation/java-organization.md)

**Quick Reference:**
- Activity: Variables → onCreate → Methods → Inner classes
- Model: Private fields → Constructor → Getters/Setters
- DatabaseHelper: Constants → Constructor → Methods

---

## 2.8. Resources Organization

**📂 See:** [`implementation/resources-organization.md`](../implementation/resources-organization.md)

**Quick Reference:**
- Colors: Semantic naming (`primary`, `text_primary`)
- Dimensions: Consistent spacing (4dp increments)
- Styles: Component-based (`Widget.Button.Primary`)

---

## 2.9. File Splitting Rules

**📂 See:** [`implementation/file-splitting.md`](../implementation/file-splitting.md)

**Quick Reference:**
- Layout > 200 lines → split sections with `<include>`
- Resources: Always split by category
- Pattern: `[name]_section_[part].xml`

---
**📚 Related Rules:**
- [UI/UX Rules](./ui-ux-rules.md) - 2.9-2.15
- [Advanced Rules](./advanced-rules.md) - 2.16-2.22
- [Quality Rules](./quality-rules.md) - 3.0-4.0