#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script: fix_xcode_project.py
Tự động kiểm tra và sửa lỗi format phổ biến cho project.pbxproj (Xcode parse error)
"""
import sys
import re
from pathlib import Path

def fix_pbxproj(pbxproj_path):
    with open(pbxproj_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Loại bỏ dòng trùng lặp hoàn toàn
    lines = content.splitlines()
    seen = set()
    new_lines = []
    for line in lines:
        if line.strip() not in seen:
            new_lines.append(line)
            seen.add(line.strip())
    content = '\n'.join(new_lines)

    # 2. Sửa lỗi thiếu dấu ; ở cuối entry
    content = re.sub(r'(\};)(?!\s*;)', r'\1;', content)

    # 3. Sửa lỗi thiếu dấu đóng ngoặc } cuối file
    if not content.strip().endswith('}'):  # Xcode project luôn kết thúc bằng }
        content = content.strip() + '\n}'

    # 4. Sửa lỗi thừa dấu ; sau dấu }
    content = re.sub(r'\};;+', r'};', content)

    # 5. (Tuỳ chọn) Có thể thêm các rule khác nếu phát hiện lỗi phổ biến

    with open(pbxproj_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"✓ Đã kiểm tra & sửa lỗi format cho: {pbxproj_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 fix_xcode_project.py <path-to-project.pbxproj>")
        sys.exit(1)
    fix_pbxproj(sys.argv[1])
