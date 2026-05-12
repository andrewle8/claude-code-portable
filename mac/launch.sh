#!/usr/bin/env bash
# =============================================================
#  Claude Code Portable - macOS Launcher
# =============================================================
#  Run this on any Mac to start Claude Code from the USB drive.
#  On first run on a new machine, type /login at the prompt.
# =============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRIVE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=_env.sh
source "$SCRIPT_DIR/_env.sh" "$DRIVE_ROOT"

if [[ ! -x "$PORTABLE_BIN" ]]; then
    # exFAT may strip the executable bit on cross-machine mount.
    chmod +x "$PORTABLE_BIN" 2>/dev/null || true
fi

if [[ ! -f "$PORTABLE_BIN" ]]; then
    echo "ERROR: Claude Code binary not found at:"
    echo "  $PORTABLE_BIN"
    echo
    echo "Run mac/setup.sh on a trusted Mac first."
    exit 1
fi

cat <<EOF
============================================
 Claude Code Portable
============================================
 Drive:    $DRIVE_ROOT
 Platform: $PORTABLE_PLATFORM
 First run on this Mac: type /login
 Before ejecting:        run mac/cleanup.sh
============================================

EOF

exec "$PORTABLE_BIN" "$@"
