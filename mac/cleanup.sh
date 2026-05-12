#!/usr/bin/env bash
# =============================================================
#  Claude Code Portable - macOS Cleanup
# =============================================================
#  Removes the one unavoidable host trace on macOS: the OAuth
#  credential entry that Claude Code writes to the user's login
#  Keychain on /login. Run this BEFORE ejecting the drive from
#  a foreign Mac.
#
#  Reference: Anthropic auth docs confirm credentials are stored
#  in the macOS Keychain under service "Claude Code-credentials".
# =============================================================

set -u

KEYCHAIN_SERVICE="Claude Code-credentials"

echo "Removing Claude Code Keychain entry on this Mac..."

if security find-generic-password -s "$KEYCHAIN_SERVICE" >/dev/null 2>&1; then
    if security delete-generic-password -s "$KEYCHAIN_SERVICE" >/dev/null 2>&1; then
        echo "[OK] Keychain entry removed."
    else
        echo "[WARN] Found entry but failed to delete. Run manually:"
        echo "  security delete-generic-password -s '$KEYCHAIN_SERVICE'"
        exit 1
    fi
else
    echo "[OK] No Keychain entry found (nothing to clean)."
fi

echo
echo "You can now eject the drive."
