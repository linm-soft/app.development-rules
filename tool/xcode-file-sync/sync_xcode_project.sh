#!/bin/bash

# ============================================================================
# Script: xcode_sync_all_swift.sh
# Mục đích: Review toàn bộ file Swift trong app iOS, xoá hết entry Swift cũ trong project.pbxproj, add lại toàn bộ file Swift hiện có vào Xcode project (không duplicate)
# Sử dụng: ./xcode_sync_all_swift.sh [project-path]
# ============================================================================

set -e

PROJECT_ROOT="${1:-.}"
XCODEPROJ=$(find "$PROJECT_ROOT" -maxdepth 1 -name "*.xcodeproj" -type d | head -1)
if [ -z "$XCODEPROJ" ]; then
    echo "❌ No .xcodeproj found in $PROJECT_ROOT"
    exit 1
fi
PROJECT_FILE=$(basename "$XCODEPROJ")
PBXPROJ_PATH="$PROJECT_ROOT/$PROJECT_FILE/project.pbxproj"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "🔍 Đang kiểm tra và thêm các file Swift còn thiếu vào project.pbxproj..."
python3 - <<ENDPYTHON
import re
import uuid
import sys
from pathlib import Path

PBXPROJ_PATH = "$PBXPROJ_PATH"
PROJECT_ROOT = "$PROJECT_ROOT"

def generate_id():
    return uuid.uuid4().hex[:24].upper()

with open(PBXPROJ_PATH, 'r') as f:
    content = f.read()

# Tìm group id của group đầu tiên tên SmartCallBlock
group_id = None
group_match = re.search(r'([A-F0-9]{24}) /\* SmartCallBlock \*/ = \{\\s*isa = PBXGroup;', content)
if group_match:
    group_id = group_match.group(1)

# Tìm sources build phase id đầu tiên
sources_id = None
sources_match = re.search(r'([A-F0-9]{24}) /\* Sources \*/ = \{\\s*isa = PBXSourcesBuildPhase;', content)
if sources_match:
    sources_id = sources_match.group(1)

if not group_id or not sources_id:
    print('❌ Không tìm thấy group id hoặc sources build phase id.')
    sys.exit(1)

# Sửa lại đường dẫn app_folder cho đúng cấu trúc thực tế
app_folder = Path(PBXPROJ_PATH).parent.parent / "SmartCallBlock"
swift_files = list(app_folder.glob('*.swift'))
if not swift_files:
    print(f'❌ Không tìm thấy file Swift nào trong {app_folder}')
    sys.exit(1)

# Parse PBXFileReference section
file_ref_section = re.search(r'/\* Begin PBXFileReference section \*/(.+?)/\* End PBXFileReference section \*/', content, re.DOTALL)
build_file_section = re.search(r'/\* Begin PBXBuildFile section \*/(.+?)/\* End PBXBuildFile section \*/', content, re.DOTALL)

# Fix regex: match any content between { and children = (, and after );
group_pat = r'%s /\* SmartCallBlock \*/ = \{[\s\S]*?isa = PBXGroup;[\s\S]*?children = \((.*?)\)[ \t\r\n]*;' % re.escape(group_id)
group_section = re.search(group_pat, content, re.DOTALL)
if not group_section:
    print(f'❌ Regex group_section failed. Pattern: {group_pat}')
    sys.exit(1)
sources_pat = r'%s /\* Sources \*/ = \{[\s\S]*?isa = PBXSourcesBuildPhase;[\s\S]*?files = \((.*?)\)[ \t\r\n]*;' % re.escape(sources_id)
sources_section = re.search(sources_pat, content, re.DOTALL)
if not sources_section:
    print(f'❌ Regex sources_section failed. Pattern: {sources_pat}')
    sys.exit(1)
if not (file_ref_section and build_file_section):
    print('❌ Không tìm thấy đủ section để thêm file.')
    sys.exit(1)

# Parse section content to list

def safe_group(section, idx, label):
    try:
        return section.group(idx)
    except IndexError:
        print(f'❌ {label} has no group({idx}). section: {section}')
        sys.exit(1)

file_ref_entries = [x.strip() for x in file_ref_section.group(1).strip().split('\n') if x.strip()]
build_file_entries = [x.strip() for x in build_file_section.group(1).strip().split('\n') if x.strip()]
group_children = [x.strip() for x in safe_group(group_section, 1, "group_section").strip().split('\n') if x.strip()]
sources_files = [x.strip() for x in safe_group(sources_section, 1, "sources_section").strip().split('\n') if x.strip()]

# Collect existing Swift file names
existing_refs = set()
for entry in file_ref_entries:
    m = re.search(r'/\* ([^ ]+\.swift) \*/', entry)
    if m:
        existing_refs.add(m.group(1))
existing_buildfiles = set()
for entry in build_file_entries:
    m = re.search(r'/\* ([^ ]+\.swift) in Sources \*/', entry)
    if m:
        existing_buildfiles.add(m.group(1))

added = 0
for swift_file in swift_files:
    filename = swift_file.name
    if filename in existing_refs and filename in existing_buildfiles:
        continue
    file_id = generate_id()
    build_id = generate_id()
    # Add PBXFileReference
    file_ref_entries.append(f'{file_id} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "SmartCallBlock/{filename}"; sourceTree = "<group>"; }};')
    # Add PBXBuildFile
    build_file_entries.append(f'{build_id} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_id} /* {filename} */; }};')
    # Add to group children
    group_children.append(f'{file_id} /* {filename} */,')
    # Add to sources files
    sources_files.append(f'{build_id} /* {filename} in Sources */,')
    added += 1
    print(f'✓ Đã add: {filename}')

# Rebuild sections
def rebuild_section(start_pat, end_pat, new_lines, orig_content):
    start = re.search(start_pat, orig_content).end()
    end = re.search(end_pat, orig_content).start()
    return orig_content[:start] + '\n' + '\n'.join('    ' + l for l in new_lines) + '\n' + orig_content[end:]

content = rebuild_section(r'/\* Begin PBXFileReference section \*/', r'/\* End PBXFileReference section \*/', file_ref_entries, content)
content = rebuild_section(r'/\* Begin PBXBuildFile section \*/', r'/\* End PBXBuildFile section \*/', build_file_entries, content)


# Replace group children (fix regex pattern)
group_pat = r'(%s /\* SmartCallBlock \*/ = \{{[\s\S]*?isa = PBXGroup;[\s\S]*?children = \\()(.*?)(\\)[ \t\r\n]*;)' % re.escape(group_id)
try:
    content = re.sub(group_pat, lambda m: m.group(1) + '\n' + '\n'.join('        ' + l for l in group_children) + '\n    ' + m.group(3), content, flags=re.DOTALL)
except re.error as e:
    print(f'❌ Regex group_pat failed: {e}. Pattern: {group_pat}')
    sys.exit(1)

# Replace sources files (fix regex pattern)
sources_pat = r'(%s /\* Sources \*/ = \{{[\s\S]*?isa = PBXSourcesBuildPhase;[\s\S]*?files = \\()(.*?)(\\)[ \t\r\n]*;)' % re.escape(sources_id)
try:
    content = re.sub(sources_pat, lambda m: m.group(1) + '\n' + '\n'.join('        ' + l for l in sources_files) + '\n    ' + m.group(3), content, flags=re.DOTALL)
except re.error as e:
    print(f'❌ Regex sources_pat failed: {e}. Pattern: {sources_pat}')
    sys.exit(1)

with open(PBXPROJ_PATH, 'w') as f:
    f.write(content)
if added:
    print(f'✅ Đã thêm {added} file Swift còn thiếu vào project.')
else:
    print('✅ Không có file Swift nào cần thêm.')
ENDPYTHON

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Đang mở lại Xcode..."
open -a Xcode "$XCODEPROJ"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Hoàn thành! Hãy mở lại Xcode và build."

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Đang tự động sửa project.pbxproj nếu có lỗi..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
python3 "$SCRIPT_DIR/fix_xcode_project.py" "$PBXPROJ_PATH"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Đang mở lại Xcode..."
open -a Xcode "$XCODEPROJ"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Hoàn thành! Hãy mở lại Xcode và build."
