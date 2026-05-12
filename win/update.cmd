@echo off
setlocal EnableExtensions

REM ===========================================================
REM  Claude Code Portable - Windows Update
REM ===========================================================

title Claude Code Portable - Update

set "WIN_DIR=%~dp0"
if "%WIN_DIR:~-1%"=="\" set "WIN_DIR=%WIN_DIR:~0,-1%"
for %%I in ("%WIN_DIR%\..") do set "DRIVE_ROOT=%%~fI"

call "%~dp0_env.cmd" "%DRIVE_ROOT%"

echo Updating Claude Code...
call "%DRIVE_ROOT%\node\npm.cmd" update -g @anthropic-ai/claude-code
if errorlevel 1 (
    echo.
    echo ERROR: Update failed.
    pause
    exit /b 1
)

echo.
echo [OK] Update complete.
pause
endlocal
