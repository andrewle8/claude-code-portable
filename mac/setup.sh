#!/usr/bin/env bash
# =============================================================
#  Claude Code Portable - macOS Setup (run ONCE on your own Mac)
# =============================================================
#  This is the only script you run BEFORE travel. It must be
#  executed on a Mac you trust, because the official Anthropic
#  installer writes to ~/.local/bin. We then copy the resulting
#  notarized binary to the USB drive so it can be carried.
#
#  Subsequent use on foreign Macs: just run launch.sh.
# =============================================================

set -euo pipefail

# Resolve drive root (parent of /mac/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRIVE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "============================================"
echo " Claude Code Portable - macOS Setup"
echo "============================================"
echo " Drive root: $DRIVE_ROOT"
echo

if [[ ! -w "$DRIVE_ROOT" ]]; then
    echo "ERROR: Drive root is not writable: $DRIVE_ROOT"
    echo "If this is an exFAT volume, check it is mounted read-write."
    exit 1
fi

# Detect arch (Apple Silicon vs Intel)
ARCH="$(uname -m)"
case "$ARCH" in
    arm64)  PLATFORM="darwin-arm64" ;;
    x86_64) PLATFORM="darwin-x64"   ;;
    *)      echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac
echo "Detected platform: $PLATFORM"
echo

BIN_DIR="$DRIVE_ROOT/mac/bin/$PLATFORM"
mkdir -p "$BIN_DIR"
mkdir -p "$DRIVE_ROOT/config"
mkdir -p "$DRIVE_ROOT/temp"

# Run the official installer on your local Mac
if [[ ! -x "$HOME/.local/bin/claude" ]]; then
    echo "Running official Claude Code installer (writes to ~/.local/bin)..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

if [[ ! -x "$HOME/.local/bin/claude" ]]; then
    echo "ERROR: Installer did not produce ~/.local/bin/claude"
    exit 1
fi

# Copy the notarized binary + version data to the drive.
# Per Anthropic docs, runtime data lives at ~/.local/share/claude.
echo "Copying binary to USB drive..."
cp -p "$HOME/.local/bin/claude" "$BIN_DIR/claude"
chmod +x "$BIN_DIR/claude"

if [[ -d "$HOME/.local/share/claude" ]]; then
    mkdir -p "$DRIVE_ROOT/mac/share"
    # -RL resolves symlinks because exFAT does not support them.
    rm -rf "$DRIVE_ROOT/mac/share/claude"
    cp -RL "$HOME/.local/share/claude" "$DRIVE_ROOT/mac/share/claude"
fi

# Verify signature survived the copy (notarization is embedded).
echo
echo "Verifying code signature..."
if codesign --verify --verbose "$BIN_DIR/claude" 2>&1 | grep -q "valid on disk"; then
    echo "[OK] Binary is signed and valid"
else
    echo "[WARN] Could not verify signature; binary may still work but Gatekeeper may prompt"
fi

# Strip any quarantine attribute so the binary runs on a fresh Mac
# without an "unidentified developer" prompt. The notarization
# stays intact; we only clear com.apple.quarantine.
xattr -dr com.apple.quarantine "$BIN_DIR/claude" 2>/dev/null || true

echo
echo "============================================"
echo " Setup complete."
echo " Eject the drive and run mac/launch.sh on"
echo " any Mac to start Claude Code."
echo "============================================"
