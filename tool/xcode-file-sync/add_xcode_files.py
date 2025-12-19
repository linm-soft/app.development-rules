#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Script: add_xcode_files.py
Mục đích: Tự động thêm file Swift vào Xcode project (.pbxproj)
Sử dụng: python3 add_xcode_files.py [đường dẫn tới project]
"""

import sys
import os
import re
import uuid
import shutil
from pathlib import Path
from datetime import datetime

# ============================================================================
# CONFIGURATION
# ============================================================================

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

# ============================================================================
# COLORS
# ============================================================================

class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def print_header(msg):
    print(f"\n{Colors.BLUE}{'─' * 60}{Colors.END}")
    print(f"{Colors.BLUE}{Colors.BOLD}{msg}{Colors.END}")
    print(f"{Colors.BLUE}{'─' * 60}{Colors.END}\n")

def print_success(msg):
    print(f"{Colors.GREEN}✓ {msg}{Colors.END}")

def print_error(msg):
    print(f"{Colors.RED}✗ {msg}{Colors.END}")

def print_warning(msg):
    print(f"{Colors.YELLOW}⚠ {msg}{Colors.END}")

def print_info(msg):
    print(f"{Colors.CYAN}ℹ {msg}{Colors.END}")

def generate_uuid_hex():
    """Generate 8-char hex UUID for Xcode"""
    return uuid.uuid4().hex[:8].upper()

# ============================================================================
# PBXPROJ HANDLER
# ============================================================================

class PBXProjHandler:
    def __init__(self, project_path):
        self.project_path = Path(project_path)
        
        # Auto-detect .xcodeproj
        xcodeproj_files = list(self.project_path.glob("*.xcodeproj"))
        if not xcodeproj_files:
            print_error("No .xcodeproj found in project path")
            raise FileNotFoundError("xcodeproj not found")
        
        self.pbxproj_path = xcodeproj_files[0] / "project.pbxproj"
        self.content = None
        self.backup_path = None
    
    def check_project(self):
        """Kiểm tra project tồn tại"""
        if not self.pbxproj_path.exists():
            print_error(f"Project file không tồn tại: {self.pbxproj_path}")
            return False
        print_success(f"Project file tìm thấy: {self.pbxproj_path}")
        return True
    
    def load_project(self):
        """Tải file .pbxproj"""
        try:
            with open(self.pbxproj_path, 'r', encoding='utf-8') as f:
                self.content = f.read()
            print_success("Tải file .pbxproj thành công")
            return True
        except Exception as e:
            print_error(f"Lỗi khi tải file: {e}")
            return False
    
    def create_backup(self):
        """Tạo backup file gốc"""
        try:
            backup_dir = Path("/tmp/xcode_backup")
            backup_dir.mkdir(parents=True, exist_ok=True)
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            self.backup_path = backup_dir / f"project.pbxproj.backup.{timestamp}"
            shutil.copy2(self.pbxproj_path, self.backup_path)
            print_success(f"Backup tạo tại: {self.backup_path}")
            return True
        except Exception as e:
            print_error(f"Lỗi khi tạo backup: {e}")
            return False
    
    def find_section(self, section_name):
        """Tìm section trong .pbxproj"""
        pattern = f"/* Begin {section_name} section \\*/(.*?)/* End {section_name} section \\*/"
        match = re.search(pattern, self.content, re.DOTALL)
        return match
    
    def check_file_exists_in_project(self, filename):
        """Kiểm tra file đã có trong project"""
        pattern = f'path = "{filename}"'
        return pattern in self.content
    
    def get_missing_files(self):
        """Lấy danh sách file chưa có"""
        missing = []
        
        # Auto-detect main app folder
        for item in self.project_path.iterdir():
            if item.is_dir() and item.name not in ["build", ".build"] and not item.name.startswith("."):
                # This is likely the main app folder
                for swift_file in item.glob("*.swift"):
                    if not self.check_file_exists_in_project(swift_file.name):
                        missing.append(swift_file.name)
                break
        
        return missing
    
    def print_missing_files(self):
        """Hiển thị danh sách file cần thêm"""
        missing = self.get_missing_files()
        print_info(f"Tìm thấy {len(missing)} file cần thêm:")
        for f in missing:
            print(f"   • {f}")
        return missing

# ============================================================================
# MAIN
# ============================================================================

def main():
    # Accept project path from argument
    if len(sys.argv) < 2:
        print_header("🔧 Xcode Project File Manager")
        print_error("Usage: python3 add_xcode_files.py <project-path>")
        print("\nExample:")
        print("  python3 add_xcode_files.py /path/to/ios/project")
        print("  python3 add_xcode_files.py .")
        sys.exit(1)
    
    project_path = sys.argv[1]
    
    print_header("🔧 Xcode Project File Manager")
    
    handler = PBXProjHandler(project_path)
    
    # Kiểm tra project
    if not handler.check_project():
        sys.exit(1)
    
    # Tải file
    if not handler.load_project():
        sys.exit(1)
    
    # Tìm file cần thêm
    missing_files = handler.print_missing_files()
    
    if not missing_files:
        print_success("Tất cả file đã có trong project!")
        sys.exit(0)
    
    # Tạo backup
    print()
    if not handler.create_backup():
        sys.exit(1)
    
    # Thông báo
    print_header("📝 Thông Báo")
    print_warning("Script này hiện chỉ hỗ trợ kiểm tra file.")
    print_warning("Để thêm file vào project, vui lòng dùng Xcode UI:")
    print()
    print("Các bước thực hiện:")
    print("  1. Đóng Xcode hoàn toàn: Cmd+Q")
    print("  2. Xóa cache: rm -rf ~/Library/Developer/Xcode/DerivedData/*")
    print("  3. Mở lại Xcode project")
    print("  4. File > Add Files to 'SmartCallBlock'...")
    print("  5. Chọn folder SmartCallBlock")
    print("  6. Chọn các file:")
    for f in missing_files:
        print(f"     ☐ {f}")
    print("  7. Tích ✓ 'Copy items if needed'")
    print("  8. Chọn target: 'SmartCallBlock'")
    print("  9. Click 'Add'")
    print()
    print_success("Backup file được lưu - bạn có thể khôi phục nếu có vấn đề")

if __name__ == "__main__":
    main()
