# 👤 App Profile

[← Back to Implementation](../)

---

## Developer Information

| Field | Value |
|-------|-------|
| **Developer** | Linh.BoDinh |
| **Contact** | support@soft-linm.com |
| **Website** | [soft-linm.com](https://soft-linm.com) |

## Build Information

| Field | Source |
|-------|--------|
| **Version Name** | `versionName` in `app/build.gradle` |
| **Version Code** | `versionCode` in `app/build.gradle` |
| **Release Date** | Auto-generated from build time |

## Implementation trong Profile/About Screen

### 1. Thêm vào `build.gradle` (app level):

```groovy
android {
    defaultConfig {
        // Add build time as config field
        buildConfigField "long", "BUILD_TIME", System.currentTimeMillis() + "L"
    }
}
```

### 2. Strings resources:

```xml
<!-- values/strings.xml -->
<string name="profile_developer">Developed by Linh.BoDinh</string>
<string name="profile_contact">Contact: support@soft-linm.com</string>
<string name="profile_website">Website: soft-linm.com</string>
<string name="profile_version">Version %s</string>
<string name="profile_release_date">Released: %s</string>

<!-- values-vi/strings.xml -->
<string name="profile_developer">Phát triển bởi Linh.BoDinh</string>
<string name="profile_contact">Liên hệ: support@soft-linm.com</string>
<string name="profile_website">Website: soft-linm.com</string>
<string name="profile_version">Phiên bản %s</string>
<string name="profile_release_date">Ngày phát hành: %s</string>
```

### 3. Java code để lấy thông tin:

```java
// Get version name
String versionName = BuildConfig.VERSION_NAME;

// Get build/release date
long buildTime = BuildConfig.BUILD_TIME;
String releaseDate = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
    .format(new Date(buildTime));

// Display
tvVersion.setText(getString(R.string.profile_version, versionName));
tvReleaseDate.setText(getString(R.string.profile_release_date, releaseDate));
tvDeveloper.setText(R.string.profile_developer);
tvContact.setText(R.string.profile_contact);
tvWebsite.setText(R.string.profile_website);

// Open website
tvWebsite.setOnClickListener(v -> {
    Intent intent = new Intent(Intent.ACTION_VIEW, 
        Uri.parse("https://soft-linm.com"));
    startActivity(intent);
});

// Send email
tvContact.setOnClickListener(v -> {
    Intent intent = new Intent(Intent.ACTION_SENDTO,
        Uri.parse("mailto:support@soft-linm.com"));
    startActivity(intent);
});
```
