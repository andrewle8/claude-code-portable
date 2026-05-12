#!/usr/bin/env bash
# =============================================================
#  Claude Code Portable - macOS Host-Trace Audit
# =============================================================
#  Run AFTER using launch.sh to verify nothing was written to
#  the host's filesystem. Reports findings; does not modify
#  anything. Run this WITHOUT sourcing _env.sh so HOME points
#  to the real host directory.
# =============================================================

set -u

LEAKS=0
report_leak()  { echo "  [LEAK] $1"; LEAKS=$((LEAKS+1)); }
report_ok()    { echo "  [OK] $1"; }
report_info()  { echo "  [INFO] $1"; }

echo "============================================"
echo " Host-Trace Audit (macOS)"
echo "============================================"
echo " Host \$HOME: $HOME"
echo "============================================"
echo

# Sanity check: HOME should be the real host home, not the USB.
if [[ "$HOME" == /Volumes/* ]]; then
    echo "ERROR: \$HOME points at /Volumes/* — you sourced _env.sh."
    echo "Open a fresh terminal and run this script directly."
    exit 1
fi

paths_to_check=(
    "$HOME/.claude"
    "$HOME/.claude.json"
    "$HOME/Library/Application Support/Claude"
    "$HOME/Library/Application Support/claude-code"
    "$HOME/Library/Caches/claude"
    "$HOME/Library/Caches/anthropic"
    "$HOME/Library/Preferences/com.anthropic.claude.plist"
    "$HOME/Library/Logs/claude"
    "$HOME/Library/LaunchAgents/com.anthropic.claude.plist"
    "$HOME/.local/bin/claude"
    "$HOME/.local/share/claude"
)

for p in "${paths_to_check[@]}"; do
    echo "[check] $p"
    if [[ -e "$p" ]]; then
        report_leak "$p exists"
    else
        report_ok "not present"
    fi
    echo
done

# Keychain check — this is the ONE expected leak if you used OAuth.
echo "[check] Keychain entry 'Claude Code-credentials'"
if security find-generic-password -s "Claude Code-credentials" >/dev/null 2>&1; then
    report_leak "Keychain entry exists — run mac/cleanup.sh to remove"
else
    report_ok "not present"
fi
echo

# Inactive LaunchAgents and other autostart hooks
echo "[check] LaunchAgents referencing anthropic/claude"
matches="$(ls "$HOME/Library/LaunchAgents/" 2>/dev/null | grep -iE 'anthropic|claude' || true)"
if [[ -n "$matches" ]]; then
    report_leak "LaunchAgent(s) found:"
    echo "$matches" | sed 's/^/    /'
else
    report_ok "none"
fi
echo

echo "============================================"
if [[ $LEAKS -eq 0 ]]; then
    echo " RESULT: clean - no host traces found"
else
    echo " RESULT: $LEAKS leak(s) detected - review output above"
fi
echo "============================================"
