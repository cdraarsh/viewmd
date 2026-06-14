#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
"$SCRIPT_DIR/scripts/release-build.sh" "$@"

echo ""
echo "To install:"
echo "  unzip -q build/dist/<generated-viewmd-zip> -d /tmp/viewmd-install"
echo "  cp -R /tmp/viewmd-install/ViewMD.app /Applications/"
echo ""
echo "To register with Launch Services:"
echo "  open /Applications/ViewMD.app"
echo ""
echo "To set as default .md handler:"
echo "  Right-click any .md file -> Get Info -> Open with -> ViewMD -> Change All..."
