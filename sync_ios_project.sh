#!/bin/bash
#
# sync_ios_project.sh
# Automatically synchronize new Swift files with Xcode project
#
# Usage: ./sync_ios_project.sh [optional: file_to_add.swift]
# 
# Date: December 19, 2025
#

set -e

PROJECT_DIR="/Users/mac/Project/Source/Mobile/smart-call-block/IOS"
XCODE_PROJECT="$PROJECT_DIR/SmartCallBlock.xcodeproj"
PBXPROJ="$XCODE_PROJECT/project.pbxproj"
SOURCE_DIR="$PROJECT_DIR/SmartCallBlock"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# FUNCTION: Print formatted messages
# ============================================================================
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

# ============================================================================
# FUNCTION: Validate prerequisites
# ============================================================================
validate_prerequisites() {
    print_header "Validating Prerequisites"
    
    # Check if project directory exists
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Project directory not found: $PROJECT_DIR"
        exit 1
    fi
    print_success "Project directory found"
    
    # Check if Xcode project exists
    if [ ! -f "$PBXPROJ" ]; then
        print_error "Xcode project file not found: $PBXPROJ"
        exit 1
    fi
    print_success "Xcode project found"
    
    # Check if xcodebuild is available
    if ! command -v xcodebuild &> /dev/null; then
        print_error "xcodebuild not found. Install Xcode command line tools."
        exit 1
    fi
    print_success "xcodebuild available"
    
    echo ""
}

# ============================================================================
# FUNCTION: Find all Swift files
# ============================================================================
find_swift_files() {
    print_info "Scanning for Swift files..."
    
    if [ -z "$1" ]; then
        # Find all Swift files if no specific file provided
        find "$SOURCE_DIR" -name "*.swift" -type f 2>/dev/null | sort
    else
        # Use specific file if provided
        if [ -f "$1" ]; then
            echo "$1"
        else
            print_error "File not found: $1"
            exit 1
        fi
    fi
}

# ============================================================================
# FUNCTION: Check if file is in project
# ============================================================================
is_file_in_project() {
    local file="$1"
    local filename=$(basename "$file")
    
    if grep -q "\"$filename\"" "$PBXPROJ" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# FUNCTION: Get list of Swift files currently in project
# ============================================================================
get_project_files() {
    grep -o '"[^"]*\.swift"' "$PBXPROJ" 2>/dev/null | tr -d '"' | sort -u
}

# ============================================================================
# FUNCTION: Compare files and report status
# ============================================================================
compare_files() {
    print_header "File Status Check"
    
    local all_files=$(find_swift_files)
    local project_files=$(get_project_files)
    
    local in_project=0
    local missing=0
    
    echo -e "${BLUE}Swift Files in Project:${NC}\n"
    
    while IFS= read -r file; do
        local filename=$(basename "$file")
        
        if is_file_in_project "$file"; then
            print_success "$filename"
            ((in_project++))
        else
            print_warning "$filename (NOT IN PROJECT)"
            ((missing++))
        fi
    done <<< "$all_files"
    
    echo ""
    print_info "Total files: $(echo "$all_files" | wc -l)"
    print_info "In project: $in_project"
    print_warning "Missing: $missing"
    echo ""
    
    echo "$missing"
}

# ============================================================================
# FUNCTION: Build and verify
# ============================================================================
build_and_verify() {
    print_header "Building Project"
    
    cd "$PROJECT_DIR"
    
    print_info "Cleaning build folder..."
    xcodebuild -project SmartCallBlock.xcodeproj clean -quiet 2>/dev/null || true
    
    print_info "Building SmartCallBlock..."
    if xcodebuild -project SmartCallBlock.xcodeproj \
                 -scheme SmartCallBlock \
                 -configuration Debug \
                 -quiet 2>/dev/null; then
        print_success "Build successful"
        return 0
    else
        print_error "Build failed"
        return 1
    fi
}

# ============================================================================
# FUNCTION: Generate report
# ============================================================================
generate_report() {
    print_header "Sync Report"
    
    local total_files=$(find "$SOURCE_DIR" -name "*.swift" -type f | wc -l)
    local project_files=$(grep -o '"[^"]*\.swift"' "$PBXPROJ" 2>/dev/null | wc -l)
    
    echo ""
    echo "📊 Summary:"
    echo "   Total Swift files: $total_files"
    echo "   In Xcode project: $project_files"
    
    if [ "$total_files" -eq "$project_files" ]; then
        print_success "All files synchronized!"
    else
        print_warning "$((total_files - project_files)) files may need to be added"
    fi
    
    echo ""
    echo "📝 File List:"
    find "$SOURCE_DIR" -name "*.swift" -type f | while read -r file; do
        echo "   $(basename "$file")"
    done
    
    echo ""
}

# ============================================================================
# FUNCTION: Interactive mode - add missing files
# ============================================================================
add_missing_files() {
    print_header "Adding Missing Files to Xcode Project"
    
    local missing_files=()
    local all_files=$(find_swift_files)
    
    while IFS= read -r file; do
        if ! is_file_in_project "$file"; then
            missing_files+=("$file")
        fi
    done <<< "$all_files"
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        print_success "No missing files to add"
        return 0
    fi
    
    print_info "Found ${#missing_files[@]} files to add"
    echo ""
    
    for file in "${missing_files[@]}"; do
        local filename=$(basename "$file")
        print_info "Adding $filename..."
        # Note: Actual pbxproj modification requires xcodeproj gem or manual parsing
        # For now, we just report what needs to be added
        echo "   ⚠️ Needs manual addition via Xcode GUI:"
        echo "   1. Right-click 'SmartCallBlock' in Xcode"
        echo "   2. Select 'Add Files to SmartCallBlock'"
        echo "   3. Choose: $file"
        echo ""
    done
}

# ============================================================================
# FUNCTION: Show usage
# ============================================================================
show_usage() {
    echo "iOS Project Sync Script"
    echo ""
    echo "Usage: $0 [options] [file.swift]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -s, --sync          Sync all Swift files (default)"
    echo "  -c, --check         Check status without syncing"
    echo "  -b, --build         Build project after sync"
    echo "  -r, --report        Generate detailed report"
    echo ""
    echo "Examples:"
    echo "  $0                           # Sync all files and build"
    echo "  $0 MyNewView.swift          # Sync specific file"
    echo "  $0 --check                  # Check sync status"
    echo "  $0 --report                 # Generate report"
    echo ""
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

main() {
    local mode="sync"
    local file=""
    local do_build=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -c|--check)
                mode="check"
                do_build=false
                shift
                ;;
            -r|--report)
                mode="report"
                do_build=false
                shift
                ;;
            -b|--build)
                do_build=true
                shift
                ;;
            -s|--sync)
                mode="sync"
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                file="$1"
                shift
                ;;
        esac
    done
    
    # Execute based on mode
    validate_prerequisites
    
    case $mode in
        sync)
            print_header "iOS Project Sync"
            missing=$(compare_files)
            if [ "$missing" -gt 0 ]; then
                add_missing_files
            fi
            if [ "$do_build" = true ]; then
                build_and_verify
            fi
            generate_report
            ;;
        check)
            compare_files > /dev/null
            ;;
        report)
            generate_report
            ;;
    esac
    
    print_success "Done!"
    echo ""
}

# Run main function
main "$@"
