@echo off
echo ============================================
echo  Claude Code Portable - First Time Setup
echo ============================================
echo.

set "SCRIPT_DIR=%~dp0"
set "PATH=%SCRIPT_DIR%node;%SCRIPT_DIR%npm-global;%PATH%"
set "NPM_CONFIG_PREFIX=%SCRIPT_DIR%npm-global"

echo Installing Claude Code to USB drive...
echo This may take a few minutes.
echo.

"%SCRIPT_DIR%node\npm.cmd" install -g @anthropic-ai/claude-code

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Installation failed. Check your internet connection.
    pause
    exit /b 1
)

echo.
echo ============================================
echo  Installation complete!
echo  Run launch-claude.cmd to start Claude Code.
echo ============================================
pause
