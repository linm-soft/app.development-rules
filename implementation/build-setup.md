# 🔧 Build Setup & Debug

[← Back to Main Rules](../ANDROID_PROJECT_RULES.md)

---

## Initial Project Build Setup

Khi setup build system cho project Android mới, thực hiện theo thứ tự:

### 1. Gradle Configuration

**Copy build templates từ `development-rules/build/`:**

```bash
# Copy build scripts
cp development-rules/build/build-apk.bat project-name/
cp development-rules/build/build-release.bat project-name/
cp development-rules/build/build-bundle.bat project-name/
cp development-rules/build/export-source.ps1 project-name/
cp development-rules/build/get-version.ps1 project-name/
```

**Cập nhật app name trong scripts:**

- `build-apk.bat`: Đổi "Smart Call Block" → "Your App Name"
- `build-release.bat`: Đổi package/app name references
- `export-source.ps1`: Cập nhật app name trong output filename

### 2. Gradle Wrapper Setup

**Tạo/Copy Gradle wrapper từ shared-lib:**

```bash
# Copy wrapper files
cp -r shared-lib/gradle project-name/
```

**Tạo `gradlew.bat` và `gradlew`:**

Sử dụng template Gradle wrapper standard hoặc copy từ project khác.

**Cấu hình `gradle-wrapper.properties`:**

```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=file\:///C:/Users/<username>/AppData/Local/Temp/gradle-8.0-bin.zip
networkTimeout=10000
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```

### 3. Project Configuration Files

**Tạo `local.properties`:**

```properties
# Android SDK location
sdk.dir=C\:\\Android\\Sdk

# API Keys (nếu cần)
GOOGLE_CLOUD_API_KEY=your_key_here
BILLING_PUBLIC_KEY=your_key_here
```

**Kiểm tra `gradle.properties`:**

```properties
# Optimize build
org.gradle.jvmargs=-Xmx4096m -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.caching=true

# Android settings
android.useAndroidX=true
android.enableJetifier=true
android.nonTransitiveRClass=true
android.enableR8.fullMode=true

# KHÔNG dùng deprecated options:
# android.enableBuildCache=true  ❌ Removed in AGP 7.0+
# org.gradle.jvmargs=-XX:MaxPermSize=1024m  ❌ Removed in Java 8+
```

### 4. Build Configuration

**`build.gradle` (root level):**

```groovy
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.0.2'
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

plugins {
    id 'com.android.application' version '8.0.2' apply false
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
```

**`settings.gradle`:**

```groovy
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}

rootProject.name = "YourAppName"
include ':app'
```

**⚠️ QUAN TRỌNG:** Với `FAIL_ON_PROJECT_REPOS`, KHÔNG khai báo repositories trong `build.gradle` (root), chỉ trong `settings.gradle`.

### 5. Dependency Resolution

**Common conflicts cần fix trong `app/build.gradle`:**

```groovy
configurations.all {
    resolutionStrategy {
        // Force Guava version for Android
        force 'com.google.guava:guava:32.1.1-android'
        
        // Force protobuf-javalite (not protobuf-java)
        force 'com.google.protobuf:protobuf-javalite:3.23.2'
    }
    
    // Exclude conflicting dependencies
    exclude group: 'com.google.guava', module: 'listenablefuture'
    exclude group: 'com.google.protobuf', module: 'protobuf-java'
}
```

**Exclude proto-common khi dùng Firebase + Google Cloud:**

```groovy
implementation ('com.google.cloud:google-cloud-speech:4.14.0') {
    exclude group: 'com.google.api.grpc', module: 'proto-google-common-protos'
}
implementation ('com.google.cloud:google-cloud-texttospeech:2.22.0') {
    exclude group: 'com.google.api.grpc', module: 'proto-google-common-protos'
}
```

## Build Debugging Checklist

Khi build fail, debug theo thứ tự. See full details in this file for all scenarios.

## Build Commands

```bash
# Debug build
./gradlew assembleDebug

# Release build (cần keystore)
./gradlew assembleRelease

# Clean build
./gradlew clean assembleDebug

# Bundle for Play Store
./gradlew bundleRelease

# Check dependencies
./gradlew app:dependencies

# Verbose build
./gradlew assembleDebug --info

# Build with stacktrace
./gradlew assembleDebug --stacktrace
```

## Build Output Location

```
app/build/outputs/apk/
├── debug/
│   └── app-debug.apk
└── release/
    └── app-release.apk

app/build/outputs/bundle/release/
└── app-release.aab
```
