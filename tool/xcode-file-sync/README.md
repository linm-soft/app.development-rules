# 🚀 Xcode File Sync Tool

Công cụ tự động kiểm tra và thêm file Swift vào Xcode project - **Làm việc với tất cả iOS projects**.

## 📋 Danh sách file được quản lý

Tool **tự động phát hiện** tất cả file `.swift` trong project folder - không cần hardcode danh sách.

## 🔧 Cách sử dụng

### Option 1: Shell Script (Auto Sync) - **Khuyến nghị** ⭐
```bash
# Sync current directory
/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh

# Hoặc chỉ định project path
/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh /path/to/ios/project

# Ví dụ
/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh /Users/mac/Project/Source/Mobile/smart-call-block/IOS
```

### Option 2: Python Script (Kiểm tra)
```bash
python3 /Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/add_xcode_files.py /path/to/ios/project
```

### Option 3: Shell Script (Kiểm tra)
```bash
bash /Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/add_files_to_xcode.sh /path/to/ios/project
```

### Option 4: Thủ công qua Xcode UI (Khuyến nghị)

1. **Đóng Xcode hoàn toàn:**
   ```bash
   killall Xcode
   ```

2. **Xóa cache:**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/*
   ```

3. **Mở lại Xcode**

4. **File > Add Files to "ProjectName"...**

5. **Chọn thư mục với file Swift**

6. **Chọn file cần thêm**

7. **Tích các option:**
   - ✅ Copy items if needed
   - ✅ Add to targets: ProjectName

8. **Click "Add"**

## 📁 Vị trí file

- **Shell Script (Auto):** `sync_xcode_project.sh`
- **Shell Script (Check):** `add_files_to_xcode.sh`
- **Python Script:** `add_xcode_files.py`
- **Documentation:** `README.md` (file này)
- **Quick Start:** `QUICK_START.md`

## ⚙️ Tính năng

✅ **Auto-detect** project folder (`.xcodeproj`)  
✅ **Auto-detect** Swift files trong app folder  
✅ **Tự động tạo backup** `.pbxproj` trước khi thay đổi  
✅ **Xóa Xcode cache** tự động  
✅ **Mở lại Xcode** sau khi sync  
✅ **Hoạt động với tất cả iOS projects** (không hardcode)  

## ⚠️ Lưu ý quan trọng

1. **Backup tự động:** Script sẽ tạo backup `.pbxproj` tại `/tmp/xcode_backup/`
2. **Đóng Xcode:** Luôn đóng Xcode trước khi thêm file
3. **Xóa cache:** Cache DerivedData có thể gây vấn đề - luôn xóa sau khi thêm file

## 🐛 Xử lý sự cố

### Nếu file vẫn không hiển thị trong Xcode:

```bash
# 1. Đóng Xcode
killall Xcode

# 2. Xóa cache
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 3. Mở lại Xcode
open -a Xcode /path/to/project.xcodeproj
```

### Nếu muốn khôi phục backup:

```bash
# Xem danh sách backup
ls -la /tmp/xcode_backup/

# Khôi phục file gần nhất
cp /tmp/xcode_backup/project.pbxproj.backup.* \
   /path/to/project.xcodeproj/project.pbxproj
```

### Project path không tìm thấy .xcodeproj:

```bash
# Kiểm tra .xcodeproj tồn tại
find /your/project -name "*.xcodeproj" -type d

# Nếu tồn tại, chỉ định đúng path
/path/to/xcode-file-sync/sync_xcode_project.sh /correct/path/to/project
```
3. Tất cả 15 file phải hiển thị dưới SmartCallBlock folder
4. Không có cảnh báo (⚠️) hay lỗi (❌)

## 📝 Lịch sử thay đổi

- **2025-12-19**: Tạo tool ban đầu
  - Thêm hỗ trợ 15 file Swift
  - Tạo backup tự động
  - Thêm hướng dẫn Xcode UI
  - Organize vào development-rules/tool/xcode-file-sync

---

**Tác giả:** GitHub Copilot  
**Ngôn ngữ:** Bash / Python3  
**Yêu cầu:** Xcode 15.4+, Python 3.7+  
**Status:** ✅ Ready to use
