# Export Tools - README

## Công cụ Export Dự án SmartCallBlock

### 1. export-project.bat (Export tùy chọn)
- **Mục đích**: Export dự án với các tùy chọn linh hoạt
- **Tính năng**: Cho phép chọn giữ hoặc bỏ qua Gradle files
- **Sử dụng**: 
  ```
  export-project.bat
  ```
- **Khuyến nghị**: Chọn option "Bỏ qua Gradle files" khi export cho Android Studio

### 2. quick-export-no-gradle.bat (Export nhanh)
- **Mục đích**: Export nhanh, tự động bỏ qua tất cả Gradle files
- **Tính năng**: Không cần tương tác, tự động loại bỏ Gradle files
- **Sử dụng**: 
  ```
  quick-export-no-gradle.bat
  ```
- **Khuyến nghị**: Dùng khi cần export nhanh để import vào Android Studio

## Vấn đề Gradle khi import vào Android Studio

### Lý do cần bỏ qua Gradle files:
1. **Version conflicts**: Gradle wrapper version có thể khác với Android Studio
2. **Build cache**: .gradle folder chứa cache có thể gây xung đột
3. **Local properties**: local.properties có thể chứa đường dẫn không phù hợp
4. **Build artifacts**: Các file build có thể gây lỗi sync

### Files/folders được bỏ qua khi dùng SkipGradle:
- `gradle/` folder
- `.gradle/` folder  
- `gradlew`, `gradlew.bat`
- `gradle.properties`
- `local.properties`
- `build.gradle` files
- `settings.gradle` files
- `proguard-rules.pro`
- Các build artifacts khác

### Sau khi import vào Android Studio:
1. Android Studio sẽ tự tạo lại Gradle wrapper phù hợp
2. Sync project sẽ download dependencies cần thiết
3. Không cần cấu hình thêm gì

## Output

Cả hai script đều tạo ra:
- **Folder export** trong `Source/Export/`
- **ZIP file** chứa toàn bộ project
- **export-info.json** với thông tin chi tiết
- **README.md** hướng dẫn sử dụng

## Lưu ý

- Export sẽ bao gồm cả Android, iOS và Documentation
- development-rules folder luôn được loại bỏ
- Các build artifacts và temp files tự động bị loại bỏ
- Có thể mở folder output tự động sau khi export xong