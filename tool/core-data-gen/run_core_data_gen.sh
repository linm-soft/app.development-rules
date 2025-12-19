#!/bin/bash
# Auto-run Core Data generation before Xcode build
# Place this in a pre-build Run Script Phase

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATOR="${SCRIPT_DIR}/generate_core_data_files.py"

if [ -f "$GENERATOR" ]; then
    echo "🔄 Auto-generating Core Data files..."
    python3 "$GENERATOR"
    if [ $? -eq 0 ]; then
        echo "✅ Core Data files ready"
    else
        echo "❌ Core Data generation failed"
        exit 1
    fi
else
    echo "⚠️  Generator script not found at $GENERATOR"
fi
