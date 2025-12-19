#!/bin/bash

# ============================================================================
# Script: sync_xcode_project.sh
# Mục đích: Tự động thêm tất cả file Swift vào Xcode project
# Sử dụng: ./sync_xcode_project.sh [project-path]
# ============================================================================

set -e

# Get project path from argument or use current directory
PROJECT_ROOT="${1:-.}"

# Auto-detect .xcodeproj file
XCODEPROJ=$(find "$PROJECT_ROOT" -maxdepth 1 -name "*.xcodeproj" -type d | head -1)

if [ -z "$XCODEPROJ" ]; then
    echo "❌ No .xcodeproj found in $PROJECT_ROOT"
    exit 1
fi

PROJECT_FILE=$(basename "$XCODEPROJ")
PBXPROJ_PATH="$PROJECT_ROOT/$PROJECT_FILE/project.pbxproj"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# FUNCTIONS
# ============================================================================

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# ============================================================================
# MAIN
# ============================================================================

print_header "📱 Xcode Project Sync"

# 1. Kiểm tra project tồn tại
print_info "Kiểm tra project..."
if [ ! -f "$PBXPROJ_PATH" ]; then
    print_error "Project file không tìm thấy: $PBXPROJ_PATH"
fi
print_success "Project tìm thấy"

# 2. Đóng Xcode
print_info "Đóng Xcode..."
if pgrep -x "Xcode" > /dev/null; then
    killall Xcode
    sleep 2
    print_success "Xcode đã đóng"
else
    print_success "Xcode không chạy"
fi

# 3. Chạy Python script để thêm file
print_info "Thêm file vào project..."
python3 << 'ENDPYTHON'
import re
import uuid
import shutil
import sys
import glob
from pathlib import Path
from datetime import datetime

PBXPROJ_PATH = sys.argv[1]
PROJECT_ROOT = sys.argv[2]

# Auto-detect Swift files in project
swift_files_dir = Path(PROJECT_ROOT)
swift_files = []

# Find main folder (usually the app name)
for item in swift_files_dir.iterdir():
    if item.is_dir() and item.name != "build" and not item.name.startswith("."):
        # This is likely the main app folder
        for swift_file in item.glob("*.swift"):
            swift_files.append(swift_file.name)
        break

if not swift_files:
    print(f"⚠️  No Swift files found in {PROJECT_ROOT}")
    sys.exit(0)

print(f"  • Found {len(swift_files)} Swift files")
MISSING_FILES = swift_files

def generate_id():
    return uuid.uuid4().hex[:8].upper()

# Backup
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
backup_path = f"{PBXPROJ_PATH}.backup.{timestamp}"
shutil.copy2(PBXPROJ_PATH, backup_path)
print(f"  ✓ Backup: {backup_path}")

# Đọc file
with open(PBXPROJ_PATH, 'r') as f:
    content = f.read()

# Kiểm tra file đã có
existing = set()
for m in re.finditer(r'path = "([^"]+\.swift)"', content):
    existing.add(m.group(1))

to_add = [f for f in MISSING_FILES if f not in existing]

if not to_add:
    print(f"  ✓ Tất cả file đã có")
    exit(0)

print(f"  • Cần thêm: {len(to_add)} file")

# ID mapping
ids = {}
for f in to_add:
    ids[f] = generate_id()

# Thêm vào PBXFileReference
file_refs = ""
for f in to_add:
    file_refs += f'\t\t7B4F{ids[f]}2C1B8F9E00123456 /* {f} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {f}; sourceTree = "<group>"; }};\n'

content = re.sub(
    r'(\s*)(/\* End PBXFileReference section \*/)',
    file_refs + r'\1\2',
    content
)

# Thêm vào PBXBuildFile
build_files = ""
for f in to_add:
    build_files += f'\t\t7B4F{generate_id()}2C1B8F9E00123456 /* {f} in Sources */ = {{isa = PBXBuildFile; fileRef = 7B4F{ids[f]}2C1B8F9E00123456 /* {f} */; }};\n'

content = re.sub(
    r'(\s*)(/\* End PBXBuildFile section \*/)',
    build_files + r'\1\2',
    content
)

# Thêm vào SmartCallBlock group
for f in to_add:
    content = re.sub(
        r'(7B4F1C282C1B8F9D00123456 /\* SmartCallBlock \*/ = \{.*?children = \([^)]*)',
        rf'\1\n\t\t\t\t7B4F{ids[f]}2C1B8F9E00123456 /* {f} */,',
        content,
        count=1,
        flags=re.DOTALL
    )

# Thêm vào Sources build phase
for f in to_add:
    content = re.sub(
        r'(7B4F1C222C1B8F9D00123456 /\* Sources \*/ = \{.*?files = \([^)]*)',
        rf'\1\n\t\t\t\t7B4F{generate_id()}2C1B8F9E00123456 /* {f} in Sources */,',
        content,
        count=1,
        flags=re.DOTALL
    )

# Ghi file
with open(PBXPROJ_PATH, 'w') as f:
    f.write(content)

print(f"  ✓ Đã thêm {len(to_add)} file")
ENDPYTHON "$PBXPROJ_PATH" "$PROJECT_ROOT"

print_success "File đã thêm vào project"

# 4. Xóa cache
print_info "Xóa Xcode cache..."
/bin/rm -rf ~/Library/Developer/Xcode/DerivedData 2>/dev/null || true
/bin/rm -rf ~/.cache/xcode* 2>/dev/null || true
/bin/rm -rf "$PROJECT_ROOT/$PROJECT_FILE/build" 2>/dev/null || true
print_success "Cache đã xóa"

# 5. Mở lại Xcode
print_info "Mở Xcode..."
open -a Xcode "$PROJECT_ROOT/$PROJECT_FILE" &
sleep 3
print_success "Xcode đang mở"

print_header "✅ Hoàn thành!"
echo -e "📌 ${YELLOW}Hãy chờ Xcode indexing hoàn tất (dòng status ở dưới cùng)${NC}"
echo -e "📌 ${YELLOW}Sau đó kiểm tra Project Navigator (bên trái) để xem tất cả file${NC}"
echo ""
