@echo off
REM ===========================================================
REM  Portable environment for Claude Code on Windows
REM ===========================================================
REM  Called by setup.cmd / launch.cmd / update.cmd.
REM  Argument %1 = drive root (parent of /win/)
REM
REM  Every variable set here redirects state ONTO the USB drive
REM  so nothing is written to the host machine.
REM ===========================================================

set "DRIVE_ROOT=%~1"
if "%DRIVE_ROOT%"=="" (
    echo _env.cmd: DRIVE_ROOT argument missing
    exit /b 1
)

REM ---- Core paths ----
set "PATH=%DRIVE_ROOT%\node;%DRIVE_ROOT%\npm-global;%PATH%"
set "NPM_CONFIG_PREFIX=%DRIVE_ROOT%\npm-global"
set "CLAUDE_CONFIG_DIR=%DRIVE_ROOT%\config"

REM ---- Zero-trace: redirect user directories to the drive ----
set "HOME=%DRIVE_ROOT%\config"
set "USERPROFILE=%DRIVE_ROOT%\config"
set "APPDATA=%DRIVE_ROOT%\config\AppData\Roaming"
set "LOCALAPPDATA=%DRIVE_ROOT%\config\AppData\Local"
set "TEMP=%DRIVE_ROOT%\temp"
set "TMP=%DRIVE_ROOT%\temp"

REM ---- npm isolation ----
set "npm_config_cache=%DRIVE_ROOT%\npm-cache"
set "npm_config_userconfig=%DRIVE_ROOT%\config\.npmrc"
set "NODE_REPL_HISTORY=%DRIVE_ROOT%\config\.node_repl_history"

REM ---- git isolation (prevents host credential helpers writing to the host) ----
set "GIT_CONFIG_GLOBAL=%DRIVE_ROOT%\config\.gitconfig"
set "GIT_CONFIG_SYSTEM=%DRIVE_ROOT%\config\.gitconfig-system"

REM ---- Claude Code behavior ----
REM  Disable background auto-updates (documented). Updates would
REM  download to %HOME%\.claude\downloads (which is on the drive),
REM  but turning them off means deterministic behavior and no
REM  unexpected network activity on a host you don't own.
set "DISABLE_AUTOUPDATER=1"

REM  Disable Statsig telemetry. Side effect: may disable some
REM  feature flags (e.g. some Opus 1M access paths). Acceptable
REM  trade-off for emergency-troubleshooting use.
set "DISABLE_TELEMETRY=1"

exit /b 0
