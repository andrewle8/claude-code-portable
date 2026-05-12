# Claude Code Portable

> Run Anthropic's Claude Code CLI from a USB drive on Windows and macOS. No installation, no admin rights, no traces left on the host machine. Built for developers travelling abroad, IT troubleshooters, and anyone who needs the real Claude Code on a borrowed PC.

[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-blue)](#requirements)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Status](https://img.shields.io/badge/status-active-brightgreen)](#)

This project lets you carry the official Anthropic Claude Code CLI on a USB drive and run it on any Windows or macOS machine without installing software on the host. Unlike community reimplementations, it ships the real `@anthropic-ai/claude-code` package (Windows) and the official notarized native binary (macOS), so your Claude subscription, custom commands, and MCP servers all work as expected.

## What it does

Plug the USB drive into a foreign Windows or Mac computer, run a launcher, and you get a full Claude Code session backed by your existing Claude subscription. The configuration, OAuth tokens, conversation history, temp files, and caches all live on the drive. The host machine is not modified.

Use cases include:

- Run Claude Code on a locked-down work computer where you cannot install anything.
- Carry a portable AI coding assistant on a travel laptop.
- Emergency troubleshooting from a USB drive when you cannot touch the host OS.
- Demo or onboarding kits where the same drive boots Claude Code on any machine.

## How it differs from alternatives

The web app at `claude.ai/code` is the simplest no-install option but requires browser login on the host (cookies left behind) and needs network access. A portable CLI lets you work offline-tolerant, with full filesystem access, MCP servers, and slash commands. The other portable Claude project on GitHub (OpenClaude-Portable) is a community fork that proxies API requests through its own implementation; this project runs the actual Claude Code binary published by Anthropic.

## Quick start (Windows)

One-time setup on a trusted machine with internet:

```cmd
win\setup.cmd
```

This downloads portable Node.js v22 and installs `@anthropic-ai/claude-code` to the drive. Nothing is written outside the drive.

On any Windows machine afterwards:

```cmd
win\launch.cmd
```

On first launch on a new host, type `/login` at the Claude prompt to authenticate with your Claude subscription. The OAuth token is saved into the drive's `config/` directory and reused on later runs.

## Quick start (macOS)

One-time setup on your own Mac:

```bash
mac/setup.sh
```

This runs Anthropic's official `install.sh`, then copies the resulting notarized binary onto the USB drive. After this you do not need internet on the foreign Mac for the binary itself.

On any Mac afterwards:

```bash
mac/launch.sh
```

On first run on a new Mac, type `/login` to authenticate. Before ejecting the drive, run:

```bash
mac/cleanup.sh
```

This removes the one unavoidable host trace on macOS: the OAuth token entry in the user's Keychain. See [Honest trade-offs](#honest-trade-offs) below.

## Verify zero host trace

After using the drive on a machine you do not own, run the audit script in a fresh terminal:

```cmd
verify\verify-win.cmd
```

```bash
verify/verify-mac.sh
```

The script checks the real host paths (`%APPDATA%`, `~/Library/Application Support`, the Keychain, the registry) and reports anything it finds. Use this once on your own laptop before travelling to confirm the launcher actually contains all writes.

## How it works

Every state directory Claude Code, Node.js, and npm use is redirected onto the drive via environment variables set at launch time:

| Variable | Redirected to | Purpose |
|---|---|---|
| `HOME` / `USERPROFILE` | `config/` | Unix and Windows home directory |
| `APPDATA` / `LOCALAPPDATA` | `config/AppData/*` | Windows app data |
| `XDG_CONFIG_HOME` / `XDG_CACHE_HOME` | `config/`, `config/cache/` | POSIX config and cache |
| `TEMP` / `TMP` / `TMPDIR` | `temp/` | Temporary files |
| `CLAUDE_CONFIG_DIR` | `config/` | Claude Code credentials and settings |
| `npm_config_cache` | `npm-cache/` | npm package cache (Windows) |
| `NPM_CONFIG_PREFIX` | `npm-global/` | npm global install location (Windows) |
| `GIT_CONFIG_GLOBAL` | `config/.gitconfig` | Prevents host git credential helpers |
| `DISABLE_AUTOUPDATER` | `1` | Prevents background update checks |
| `DISABLE_TELEMETRY` | `1` | Prevents Statsig telemetry connections |

Drive letters and mount points are resolved at launch, so the same drive works whether mounted as `E:\`, `F:\`, or `/Volumes/CLAUDE`.

## Honest trade-offs

This project is built on verified behavior, not marketing. The known caveats:

1. **macOS Keychain entry is unavoidable.** When you `/login` on macOS, Claude Code writes an OAuth token to the user's login Keychain under the service name `Claude Code-credentials`. No environment variable disables this. `mac/cleanup.sh` removes it before you eject the drive.

2. **Windows native installer is not portable**, which is why the Windows side uses the npm package rather than the native binary. The npm route works cleanly on exFAT through path redirection. The native installer hard-codes `~/.local/bin` and requires Git for Windows on the host, so it is not suitable for foreign machines.

3. **exFAT is the only universal filesystem.** Both Windows and macOS mount exFAT read-write without drivers. NTFS is read-only on macOS by default, APFS is unreadable on Windows. exFAT does not support symlinks, so on macOS we ship a single resolved binary rather than an npm tree.

4. **Disabling telemetry may disable some feature flags.** `DISABLE_TELEMETRY=1` blocks Statsig connections, which Anthropic also uses for some feature-flag delivery. This is an acceptable trade-off for emergency-use deployments.

5. **First run on a new machine requires `/login`** unless you copy your existing token over. This is by design: every new host gets its own session you can revoke.

## Requirements

- USB 3.0+ drive, 4 GB or more, formatted as exFAT.
- Windows 10 or later, or macOS 13 (Ventura) or later.
- An active Claude subscription (Pro, Team, Max) or Anthropic API access.
- Internet connection on the host machine at runtime (Claude Code makes API calls).

## Folder layout

```
claude-code-portable/
├── win/
│   ├── setup.cmd        # one-time, downloads Node + Claude Code
│   ├── launch.cmd       # run to start Claude Code
│   ├── update.cmd       # update Claude Code to latest npm version
│   └── _env.cmd         # internal: portable env-var setup
├── mac/
│   ├── setup.sh         # one-time, run on a trusted Mac
│   ├── launch.sh        # run to start Claude Code
│   ├── cleanup.sh       # removes Keychain entry before eject
│   └── _env.sh          # internal: portable env-var setup
├── verify/
│   ├── verify-win.cmd   # host-trace audit (Windows)
│   └── verify-mac.sh    # host-trace audit (macOS)
├── config/              # created at runtime; OAuth tokens, settings
├── temp/                # created at runtime; temp files
├── node/                # created by win/setup.cmd; portable Node.js
└── npm-global/          # created by win/setup.cmd; Claude Code package
```

`config/`, `temp/`, `node/`, `npm-global/`, and `npm-cache/` are gitignored because they hold binaries and auth material.

## FAQ

**Does the host machine see anything I do?** No, with one exception on macOS (see Honest trade-offs). All file writes go onto the drive. Network connections to Anthropic's API are visible to the host's network stack, just as they would be in a browser.

**Will Claude Code auto-update from the drive?** No. `DISABLE_AUTOUPDATER=1` is set, so updates only happen when you run `win/update.cmd` from a trusted machine with internet.

**Can I run this on a Linux host?** Not directly. Linux support would mirror the macOS approach (native binary copy) and is on the roadmap if there is demand.

**Will SmartScreen or Gatekeeper block it?** Both the npm-installed Claude Code on Windows and the native binary on macOS are signed by Anthropic, PBC. Gatekeeper should not prompt; SmartScreen may show a warning the first time on a new Windows host.

**What about Vietnam, China, or other regions with restricted internet?** Claude Code makes API calls to `api.anthropic.com`. If that domain is blocked on the host network, the CLI will not function regardless of how it is installed. A VPN configured on the host (or a local SOCKS proxy on the drive) is your concern, not this project's.

## License

MIT. See `LICENSE`.
