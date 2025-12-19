# 🚀 Quick Start - Sync Xcode Project

## Cách sử dụng

### 1️⃣ Chạy script (cách nhanh nhất)
```bash
# Nếu đang trong project folder
/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh

# Hoặc chỉ định project path
/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh /path/to/ios/project
```

Ví dụ cho SmartCallBlock:
```bash
/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh /Users/mac/Project/Source/Mobile/smart-call-block/IOS
```

### 2️⃣ Hoặc tạo alias để dễ nhớ
```bash
# Thêm vào ~/.zshrc hoặc ~/.bash_profile
alias sync-xcode="/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh"

# Sau đó reload shell
source ~/.zshrc

# Sử dụng
sync-xcode /path/to/project
```

## Script làm gì?

✅ Tự động phát hiện `.xcodeproj` file  
✅ Tự động phát hiện Swift files trong project  
✅ Thêm files vào `.pbxproj`  
✅ Tạo backup file gốc  
✅ Xóa DerivedData cache  
✅ Xóa build artifacts  
✅ Mở Xcode lại  

## File được quản lý

Script **tự động phát hiện** tất cả `.swift` files - không hardcode danh sách.

## Vị trí tools

📍 **Script chính:** `/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh`  
📍 **Folder:** `/Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/`  
📍 **Backup:** Auto tạo trong `/tmp/xcode_backup/`  

## 🐛 Nếu có vấn đề

1. **Script không chạy?**
   ```bash
   chmod +x /Users/mac/Project/Source/Mobile/development-rules/tool/xcode-file-sync/sync_xcode_project.sh
   ```

2. **Muốn khôi phục backup?**
   ```bash
   ls -la /tmp/xcode_backup/
   # Sau đó copy file backup làm project.pbxproj
   ```

3. **Xcode vẫn không nhận file?**
   ```bash
   # Xóa tất cả cache
   rm -rf ~/Library/Developer/Xcode/DerivedData
   
   # Mở lại Xcode
   open -a Xcode /path/to/project.xcodeproj
   ```

---

**Created:** Dec 19, 2025  
**Status:** ✅ Ready to use  
**Maintenance:** Run whenever new files are added to project  
**Compatibility:** ✅ All iOS projects
