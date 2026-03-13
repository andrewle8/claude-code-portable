# Claude Code Portable

Run Claude Code from a USB drive on any Windows machine. No installation on the host system required.

## Quick Start

1. Plug the USB drive into a Windows machine
2. Run `setup.cmd` (downloads Node.js + installs Claude Code, one-time, needs internet)
3. Run `launch-claude.cmd`
4. Log in with your Claude subscription on first launch

## What's Included

| File | Purpose |
|------|---------|
| `setup.cmd` | One-time setup: downloads Node.js and installs Claude Code to the drive |
| `launch-claude.cmd` | Starts Claude Code |
| `update-claude.cmd` | Updates Claude Code to the latest version |
| `install-claude.cmd` | Installs Claude Code only (skips Node.js download, use if Node is already on the drive) |

## How It Works

- Portable Node.js runs from the `node/` folder on the drive
- Claude Code installs to `npm-global/` on the drive
- Auth tokens and config are stored in `config/` on the drive
- All paths are relative using `%~dp0`, so the drive letter doesn't matter
- Nothing is installed or left behind on the host machine

## Requirements

- Windows 10 or later
- USB 3.0+ drive recommended (temp files and npm cache are stored on the drive)
- Internet connection (for setup and Claude Code usage)
- A Claude subscription or Anthropic API key

## Using an API Key Instead

If you prefer to use an API key instead of a Claude subscription, set the environment variable before launching:

```cmd
set ANTHROPIC_API_KEY=sk-ant-...
launch-claude.cmd
```

Or add the `set` line to `launch-claude.cmd` before the "Starting Claude Code" echo.

## Folder Structure

```
claude-portable/
├── setup.cmd           ← Run first (one-time)
├── launch-claude.cmd   ← Run to start Claude Code
├── update-claude.cmd   ← Run to update
├── install-claude.cmd  ← Alternative: install only (no Node download)
├── node/               ← Portable Node.js (created by setup)
├── npm-global/         ← Claude Code package (created by setup)
├── npm-cache/          ← npm download cache (created by setup)
├── config/             ← Auth, settings, and redirected AppData (created by setup)
└── temp/               ← Temporary files (created by setup)
```

## Zero Trace on Host

All scripts redirect the following onto the drive itself:

| Variable | Redirected To | Purpose |
|----------|--------------|---------|
| `HOME` | `config/` | Unix-style home (used by npm, git, Node.js) |
| `USERPROFILE` | `config/` | Windows home directory |
| `APPDATA` | `config/AppData/Roaming/` | Windows app data (used by env-paths, npm fallbacks) |
| `LOCALAPPDATA` | `config/AppData/Local/` | Windows local app data (used for Claude debug logs) |
| `TEMP` / `TMP` | `temp/` | Temporary files |
| `npm_config_cache` | `npm-cache/` | npm download cache |
| `NPM_CONFIG_PREFIX` | `npm-global/` | npm global install location |
| `CLAUDE_CONFIG_DIR` | `config/` | Claude Code config and credentials |
| `NODE_REPL_HISTORY` | `config/` | Node.js REPL history file |

Nothing is written to the host machine's filesystem.

## Notes

- The `node/`, `npm-global/`, `npm-cache/`, `config/`, and `temp/` directories are gitignored since they contain binaries, auth tokens, and temp data
- Auto-update works normally since `NPM_CONFIG_PREFIX` points to the drive
- Drive letter changes between machines are handled automatically via `%~dp0`
- Place the folder at a short path (e.g., `E:\claude\`) to avoid Windows 260-character path limits
- First login is required on each new USB drive — credentials are stored on the drive in `config/`
