# ⚙️ Gradle Configuration

## Initial Project Build Setup

Khi setup build system cho project Android mới, thực hiện theo thứ tự:

### 1. Copy Build Templates

**From `development-rules/build/`:**

```bash
cp development-rules/build/build-apk.bat project-name/
cp development-rules/build/build-release.bat project-name/
cp development-rules/build/export-source.ps1 project-name/
cp development-rules/build/get-version.ps1 project-name/
```

**Update app name in scripts:**
- `build-apk.bat`: Change "Smart Call Block" → "Your App Name"
- `build-release.bat`: Update package/app name references
- `export-source.ps1`: Update app name in output filename

### 2. Gradle Wrapper Setup

**Create/Copy Gradle wrapper:**

```bash
cp -r shared-lib/gradle project-name/
```

**Configure `gradle-wrapper.properties`:**

```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=file\:///C:/Users/<username>/AppData/Local/Temp/gradle-8.0-bin.zip
networkTimeout=10000
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```

### 3. Project Configuration Files

**`local.properties`:**

```properties
# Android SDK location
sdk.dir=C\:\\Android\\Sdk

# API Keys (if needed)
GOOGLE_CLOUD_API_KEY=your_key_here
BILLING_PUBLIC_KEY=your_key_here
```

**`gradle.properties`:**

```properties
# Optimize build
org.gradle.jvmargs=-Xmx4096m -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.caching=true

# Android settings
android.useAndroidX=true
android.enableJetifier=true
android.nonTransitiveRClass=true
```

### 4. Local Gradle Distribution

**REQUIRED** để build được offline và consistent:

1. Download Gradle binary distribution (gradle-8.0-bin.zip)
2. Place in: `C:/Users/<username>/AppData/Local/Temp/`
3. Update `gradle-wrapper.properties` với `file:///` URL
4. Test build: `.\gradlew.bat assembleDebug`

**Benefits:**
- No internet required for builds
- Consistent Gradle version across team
- Faster builds (no download wait)
