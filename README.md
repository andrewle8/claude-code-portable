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
└── config/             ← Auth and settings (created on first launch)
```

## Notes

- The `node/`, `npm-global/`, and `config/` directories are gitignored since they contain binaries and auth tokens
- Auto-update works normally since `NPM_CONFIG_PREFIX` points to the drive
- Drive letter changes between machines are handled automatically via `%~dp0`
