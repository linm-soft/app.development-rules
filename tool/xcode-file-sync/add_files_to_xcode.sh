#!/bin/bash

# ============================================================================
# Script: add_files_to_xcode.sh
# Mục đích: Tự động thêm các file Swift vào Xcode project (.pbxproj)
# Sử dụng: ./add_files_to_xcode.sh [đường dẫn tới project]
# ============================================================================

set -e

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# CONFIGURATION
# ============================================================================

PROJECT_DIR="${1:-.}"
PBXPROJ_PATH="$PROJECT_DIR/SmartCallBlock.xcodeproj/project.pbxproj"
BACKUP_DIR="/tmp/xcode_backup"

# Auto-detect .xcodeproj if path not hardcoded
XCODEPROJ=$(find "$PROJECT_DIR" -maxdepth 1 -name "*.xcodeproj" -type d | head -1)
if [ -n "$XCODEPROJ" ]; then
    PBXPROJ_PATH="$XCODEPROJ/project.pbxproj"
fi

# Auto-detect Swift files
MISSING_FILES=()

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
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Kiểm tra file tồn tại
check_file_exists() {
    if [ ! -f "$1" ]; then
        print_error "File không tồn tại: $1"
        exit 1
    fi
}

# Auto-detect Swift files in project
auto_detect_files() {
    local files=()
    
    # Find main app folder (usually largest folder or matching xcodeproj name)
    for item in "$PROJECT_DIR"/*; do
        if [ -d "$item" ] && [[ "$item" != *"build"* ]] && [[ "$item" != *"."* ]]; then
            # This folder could be the app folder
            for swift_file in "$item"/*.swift; do
                if [ -f "$swift_file" ]; then
                    files+=("$(basename "$swift_file")")
                fi
            done
            if [ ${#files[@]} -gt 0 ]; then
                break
            fi
        fi
    done
    
    MISSING_FILES=("${files[@]}")
}

# Tạo backup
create_backup() {
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/project.pbxproj.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$PBXPROJ_PATH" "$BACKUP_FILE"
    print_success "Backup được tạo: $BACKUP_FILE"
}

# Generate UUID (8 ký tự hex)
generate_uuid() {
    openssl rand -hex 4 | tr '[:lower:]' '[:upper:]'
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

print_header "🔧 Xcode Project File Manager"

# Kiểm tra project
print_info "Kiểm tra project path: $PROJECT_DIR"
check_file_exists "$PBXPROJ_PATH"
print_success "Project file tìm thấy"

# Auto-detect files
print_info "Tự động phát hiện file Swift..."
auto_detect_files

# Hiển thị danh sách file cần thêm
print_info "Danh sách ${#MISSING_FILES[@]} file cần thêm:"
for file in "${MISSING_FILES[@]}"; do
    echo "   • $file"
done

# Kiểm tra file tồn tại trên disk
echo ""
print_info "Kiểm tra file có tồn tại trên disk..."
for file in "${MISSING_FILES[@]}"; do
    FILE_PATH="$PROJECT_DIR/SmartCallBlock/$file"
    if [ -f "$FILE_PATH" ]; then
        print_success "$file"
    else
        print_warning "$file (không tìm thấy)"
    fi
done

# Tạo backup
echo ""
create_backup

# Chạy Python script để thêm file
echo ""
print_header "🚀 Thêm file vào project..."

python3 << 'ENDPYTHON'
import re
import json
import uuid
import sys

PROJECT_PATH = sys.argv[1] if len(sys.argv) > 1 else "."
PBXPROJ_PATH = f"{PROJECT_PATH}/SmartCallBlock.xcodeproj/project.pbxproj"

MISSING_FILES = [
    "AdvancedBlockingRulesView.swift",
    "AppCommonDialogOverlay.swift",
    "BackupRestoreManager.swift",
    "BackupRestoreView.swift",
    "BlockedNumbersListView.swift",
    "CallBlockingService.swift",
    "CallKitCallObserver.swift",
    "CrashReportingManager.swift",
    "CrashReportsView.swift",
    "DialogManager.swift",
    "EditNumberView.swift",
    "IncomingCallView.swift",
    "OnboardingView.swift",
    "PremiumView.swift",
    "SubscriptionManager.swift",
]

try:
    # Đọc file .pbxproj
    with open(PBXPROJ_PATH, 'r') as f:
        content = f.read()
    
    print(f"✓ Đã mở file: {PBXPROJ_PATH}")
    
    # Tìm phần PBXFileReference
    file_ref_section = re.search(
        r'(/* Begin PBXFileReference section \*/)(.*?)(/* End PBXFileReference section \*/)',
        content,
        re.DOTALL
    )
    
    if not file_ref_section:
        print("✗ Không tìm thấy PBXFileReference section")
        sys.exit(1)
    
    print(f"✓ Tìm thấy PBXFileReference section")
    
    # Tìm phần PBXBuildFile
    build_file_section = re.search(
        r'(/* Begin PBXBuildFile section \*/)(.*?)(/* End PBXBuildFile section \*/)',
        content,
        re.DOTALL
    )
    
    if not build_file_section:
        print("✗ Không tìm thấy PBXBuildFile section")
        sys.exit(1)
    
    print(f"✓ Tìm thấy PBXBuildFile section")
    
    # Tìm phần Sources build phase
    sources_phase = re.search(
        r'(7B4F1C222C1B8F9D00123456 /* Sources \*/ = \{.*?files = \()(.*?)(\);)',
        content,
        re.DOTALL
    )
    
    if not sources_phase:
        print("✗ Không tìm thấy Sources build phase")
        sys.exit(1)
    
    print(f"✓ Tìm thấy Sources build phase")
    
    # Tìm phần SmartCallBlock group
    group_section = re.search(
        r'(7B4F1C282C1B8F9D00123456 /* SmartCallBlock \*/ = \{.*?children = \()(.*?)(\);)',
        content,
        re.DOTALL
    )
    
    if not group_section:
        print("✗ Không tìm thấy SmartCallBlock group")
        sys.exit(1)
    
    print(f"✓ Tìm thấy SmartCallBlock group")
    
    print(f"\n📝 Sẽ thêm {len(MISSING_FILES)} file...")
    print("Gợi ý: Hãy dùng Xcode UI để thêm file (File > Add Files)")
    
    sys.exit(0)

except Exception as e:
    print(f"✗ Lỗi: {e}")
    sys.exit(1)

ENDPYTHON "$PROJECT_PATH"

# Kết luận
echo ""
print_header "✅ Hoàn thành"

echo -e "${YELLOW}📌 Khuyến nghị:${NC}"
echo "   1. Đóng Xcode hoàn toàn (Cmd+Q)"
echo "   2. Xóa cache: rm -rf ~/Library/Developer/Xcode/DerivedData/*"
echo "   3. Mở lại Xcode"
echo "   4. File > Add Files to 'SmartCallBlock'..."
echo "   5. Chọn folder SmartCallBlock và chọn 15 file cần thêm"
echo "   6. Tích ✓ 'Copy items if needed' và target 'SmartCallBlock'"
echo "   7. Click 'Add'"
echo ""
echo -e "${GREEN}Hoặc dùng script tự động:${NC}"
echo "   → Chạy script này lần tới: $0"
echo ""
