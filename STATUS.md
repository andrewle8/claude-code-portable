# Verification Status

Where each part of the project is on the verified → smoke-tested → battle-tested ladder.

| Component | Status | Notes |
|---|---|---|
| Windows scripts (`win/`) | Code-reviewed, refactor of prior working version | Smoke test on a real Windows host before relying on |
| macOS scripts (`mac/`) | Code-reviewed, never run against the real binary | Smoke test on a clean Mac required before public claim |
| Verify scripts (`verify/`) | Code-reviewed, never run against a real leak | Recommended: induce a fake leak and confirm detection |
| README claims | Each line traces to research or implementation | Treat as a hypothesis until smoke-tested |
| GitHub repo metadata | Live, verified via API | Done |

## Known low-confidence areas

1. **First-run `/login` on Mac** writes the OAuth token. With `CLAUDE_CONFIG_DIR` and `HOME` both pointing at the drive, it should land on the drive — but `CLAUDE_CONFIG_DIR` is officially undocumented (GitHub issue #3833) and has buggy behavior in some versions. **Test:** after `/login` on Mac, run `verify-mac.sh` and confirm no host leak; check the drive's `config/` for `.credentials.json` or similar.

2. **Mac binary running from exFAT after re-mount.** macOS synthesizes the executable bit on exFAT mounts. `launch.sh` runs `chmod +x` defensively, but if the synthesized mode is wrong the chmod may not stick on a read-only mount.

3. **`DISABLE_TELEMETRY=1`** is documented but has side effects (may disable some feature flags). If Claude Code behaves oddly, this is the first thing to comment out.

4. **Windows `GIT_CONFIG_SYSTEM`** redirect may be ignored by git on Windows; the system-wide `gitconfig` at `C:\Program Files\Git\etc\gitconfig` could still be read. This affects git isolation purity, not core Claude Code functionality.

## Smoke test plan

### Windows

```cmd
:: 1. Format USB as exFAT, copy repo to E:\claude\
:: 2. One-time setup (needs internet):
E:\claude\win\setup.cmd

:: 3. Eject and replug to simulate foreign host scenario.

:: 4. Launch Claude Code:
E:\claude\win\launch.cmd
:: Inside Claude, run: /login

:: 5. Use Claude Code briefly, exit.

:: 6. In a FRESH CMD window (no portable env applied):
E:\claude\verify\verify-win.cmd
:: Expected: RESULT: clean
```

### macOS

```bash
# 1. On YOUR Mac (one-time, copies binary to drive):
/Volumes/CLAUDE/mac/setup.sh

# 2. Eject, replug on a different Mac.

# 3. Launch Claude Code:
/Volumes/CLAUDE/mac/launch.sh
# Inside Claude, run: /login

# 4. Before ejecting:
/Volumes/CLAUDE/mac/cleanup.sh

# 5. In a FRESH terminal (no _env.sh sourced):
/Volumes/CLAUDE/verify/verify-mac.sh
# Expected: RESULT: clean
```

## Pre-public-release checklist

- [ ] Windows smoke test passes
- [ ] macOS smoke test passes
- [ ] Verify scripts correctly detect a deliberately-induced leak
- [ ] Confirm OAuth token persists across launches (no re-login on each run)
- [ ] Confirm scripts work when drive mounted at different paths (E:\, F:\, /Volumes/CLAUDE-2)
- [ ] Update README to remove any "verified" language until above is true
