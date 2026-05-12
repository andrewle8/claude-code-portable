#!/usr/bin/env bash
# =============================================================
#  Portable environment for Claude Code on macOS
# =============================================================
#  Sourced by launch.sh / cleanup.sh. Argument $1 = drive root.
#
#  Redirects everything we can onto the USB drive. The one
#  unavoidable trace on macOS is the Keychain entry "Claude
#  Code-credentials" created on /login; clean it up with
#  cleanup.sh before ejecting.
# =============================================================

DRIVE_ROOT="${1:-}"
if [[ -z "$DRIVE_ROOT" ]]; then
    echo "_env.sh: DRIVE_ROOT argument missing" >&2
    return 1 2>/dev/null || exit 1
fi

# ---- Detect platform-specific binary directory ----
ARCH="$(uname -m)"
case "$ARCH" in
    arm64)  export PORTABLE_PLATFORM="darwin-arm64" ;;
    x86_64) export PORTABLE_PLATFORM="darwin-x64"   ;;
esac
export PORTABLE_BIN="$DRIVE_ROOT/mac/bin/$PORTABLE_PLATFORM/claude"

# ---- Zero-trace: redirect HOME, temp, caches ----
export HOME="$DRIVE_ROOT/config"
export TMPDIR="$DRIVE_ROOT/temp/"
export CLAUDE_CONFIG_DIR="$DRIVE_ROOT/config"

# XDG vars (Claude Code does not currently honor these per
# GitHub issue #1455, but other tools we shell out to do).
export XDG_CONFIG_HOME="$DRIVE_ROOT/config"
export XDG_CACHE_HOME="$DRIVE_ROOT/config/cache"
export XDG_DATA_HOME="$DRIVE_ROOT/config/share"
export XDG_STATE_HOME="$DRIVE_ROOT/config/state"

# Override the binary's bundled data dir so updates land on the drive.
export CLAUDE_LOCAL_PATH="$DRIVE_ROOT/mac/share/claude"

# ---- git isolation: stop the host's credential helper from running ----
export GIT_CONFIG_GLOBAL="$DRIVE_ROOT/config/.gitconfig"
export GIT_CONFIG_SYSTEM="$DRIVE_ROOT/config/.gitconfig-system"

# ---- Claude Code behavior ----
export DISABLE_AUTOUPDATER=1
export DISABLE_TELEMETRY=1

# ---- Ensure required dirs exist on the drive ----
mkdir -p "$HOME" "$TMPDIR" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
