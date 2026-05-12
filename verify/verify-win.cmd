@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ===========================================================
REM  Claude Code Portable - Windows Host-Trace Audit
REM ===========================================================
REM  Run AFTER using launch.cmd to verify nothing was written
REM  to the host's filesystem or registry. Reports findings;
REM  does not modify anything.
REM ===========================================================

title Claude Code Portable - Verify (Windows)

set "LEAK_COUNT=0"

echo ============================================
echo  Host-Trace Audit (Windows)
echo ============================================
echo  Real %%APPDATA%%:      %APPDATA%
echo  Real %%LOCALAPPDATA%%: %LOCALAPPDATA%
echo  Real %%USERPROFILE%%:  %USERPROFILE%
echo ============================================
echo.

REM We need the REAL host paths, not the redirected portable ones.
REM This script must run in a plain CMD window WITHOUT the portable
REM env applied, so the system AppData paths resolve to the host.

echo [check] %%APPDATA%%\Claude
if exist "%APPDATA%\Claude" (
    echo   [LEAK] Found: %APPDATA%\Claude
    dir /b "%APPDATA%\Claude"
    set /a LEAK_COUNT+=1
) else (
    echo   [OK] not present
)
echo.

echo [check] %%APPDATA%%\.claude
if exist "%APPDATA%\.claude" (
    echo   [LEAK] Found: %APPDATA%\.claude
    dir /b "%APPDATA%\.claude"
    set /a LEAK_COUNT+=1
) else (
    echo   [OK] not present
)
echo.

echo [check] %%LOCALAPPDATA%%\Claude
if exist "%LOCALAPPDATA%\Claude" (
    echo   [LEAK] Found: %LOCALAPPDATA%\Claude
    dir /b "%LOCALAPPDATA%\Claude"
    set /a LEAK_COUNT+=1
) else (
    echo   [OK] not present
)
echo.

echo [check] %%USERPROFILE%%\.claude
if exist "%USERPROFILE%\.claude" (
    echo   [LEAK] Found: %USERPROFILE%\.claude
    dir /b "%USERPROFILE%\.claude"
    set /a LEAK_COUNT+=1
) else (
    echo   [OK] not present
)
echo.

echo [check] %%USERPROFILE%%\.claude.json
if exist "%USERPROFILE%\.claude.json" (
    echo   [LEAK] Found: %USERPROFILE%\.claude.json
    set /a LEAK_COUNT+=1
) else (
    echo   [OK] not present
)
echo.

echo [check] %%APPDATA%%\npm
if exist "%APPDATA%\npm" (
    echo   [INFO] %APPDATA%\npm exists ^(may be pre-existing on host^)
    echo          Inspect manually to determine if Claude Code created it.
) else (
    echo   [OK] not present
)
echo.

echo [check] HKCU\Software\Anthropic ^(registry^)
reg query "HKCU\Software\Anthropic" >nul 2>&1
if not errorlevel 1 (
    echo   [LEAK] Registry key present:
    reg query "HKCU\Software\Anthropic"
    set /a LEAK_COUNT+=1
) else (
    echo   [OK] not present
)
echo.

echo [check] HKCU\Software\Claude ^(registry^)
reg query "HKCU\Software\Claude" >nul 2>&1
if not errorlevel 1 (
    echo   [LEAK] Registry key present:
    reg query "HKCU\Software\Claude"
    set /a LEAK_COUNT+=1
) else (
    echo   [OK] not present
)
echo.

echo ============================================
if %LEAK_COUNT%==0 (
    echo  RESULT: clean - no host traces found
) else (
    echo  RESULT: !LEAK_COUNT! leak^(s^) detected - review output above
)
echo ============================================
pause
endlocal
