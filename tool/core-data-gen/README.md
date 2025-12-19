# 🗂️ Core Data Generation Tool

Công cụ tự động generate Core Data Swift files từ DataModel.xcdatamodel.

## 📋 Tính năng

- ✅ Parse Core Data model XML
- ✅ Auto-generate `Entity+CoreDataClass.swift` files
- ✅ Auto-generate `Entity+CoreDataProperties.swift` files
- ✅ Map Core Data types to Swift types
- ✅ Create NSManagedObject subclasses automatically

## 🔧 Cách sử dụng

### Option 1: Chạy trực tiếp
```bash
cd /Users/mac/Project/Source/Mobile/smart-call-block/IOS
python3 /Users/mac/Project/Source/Mobile/development-rules/tool/core-data-gen/generate_core_data_files.py
```

### Option 2: Dùng Run Script trong Xcode (Khuyến nghị)

1. **Mở Xcode Project**
2. **Build Phases > + > New Run Script Phase**
3. **Paste command:**
   ```bash
   bash /Users/mac/Project/Source/Mobile/development-rules/tool/core-data-gen/run_core_data_gen.sh
   ```
4. **Drag script phase** trước "Compile Sources"

### Option 3: Chạy script wrapper
```bash
bash /Users/mac/Project/Source/Mobile/development-rules/tool/core-data-gen/run_core_data_gen.sh
```

## 📁 Vị trí file

- **Python Generator:** `generate_core_data_files.py`
- **Bash Wrapper:** `run_core_data_gen.sh`
- **Documentation:** `README.md` (file này)

## ⚙️ Cấu hình

File mặc định tìm kiếm:
```
SmartCallBlock/DataModel.xcdatamodeld/DataModel.xcdatamodel/contents
```

Để thay đổi, edit `generate_core_data_files.py`:
```python
BASE_DIR = Path(__file__).parent / "SmartCallBlock"
DATAMODEL_PATH = BASE_DIR / "DataModel.xcdatamodeld" / "DataModel.xcdatamodel" / "contents"
```

## 📊 Supported Core Data Types

```
Core Data Type          →  Swift Type
─────────────────────────────────────
String                  →  String?
Date                    →  Date?
Integer 32              →  Int32
Integer 64              →  Int64
Double                  →  Double
Float                   →  Float
Boolean                 →  Bool
Binary                  →  Data?
Decimal                 →  NSDecimalNumber?
```

## ✅ Output Files

Generator tạo 2 file cho mỗi entity:

```
BlockedNumber+CoreDataClass.swift
BlockedNumber+CoreDataProperties.swift

CallHistory+CoreDataClass.swift
CallHistory+CoreDataProperties.swift
```

## 🐛 Xử lý sự cố

### Lỗi: "DataModel not found"
```bash
# Kiểm tra DataModel tồn tại
ls -la "/Users/mac/Project/Source/Mobile/smart-call-block/IOS/SmartCallBlock/DataModel.xcdatamodeld/DataModel.xcdatamodel/contents"
```

### Lỗi: "No entities found"
- DataModel XML có thể không hợp lệ
- Mở DataModel trong Xcode để verify

### File không update
- Xóa các file `*+CoreDataClass.swift` và `*+CoreDataProperties.swift` cũ
- Chạy generator lại

## 📝 Lịch sử thay đổi

- **2025-12-19**: Tạo tool
  - Support auto-generation từ DataModel.xcdatamodel
  - Support Xcode Run Script integration
  - Organize vào development-rules/tool/core-data-gen

---

**Tác giả:** GitHub Copilot  
**Ngôn ngữ:** Python3 / Bash  
**Yêu cầu:** Python 3.7+, Xcode 15.4+  
**Status:** ✅ Ready to use
