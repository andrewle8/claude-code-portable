@echo off
echo ============================================
echo  Claude Code Portable - First Time Setup
echo ============================================
echo.

set "SCRIPT_DIR=%~dp0"
set "PATH=%SCRIPT_DIR%node;%SCRIPT_DIR%npm-global;%PATH%"
set "NPM_CONFIG_PREFIX=%SCRIPT_DIR%npm-global"

REM Redirect temp/cache to the drive
if not exist "%SCRIPT_DIR%temp" mkdir "%SCRIPT_DIR%temp"
if not exist "%SCRIPT_DIR%npm-cache" mkdir "%SCRIPT_DIR%npm-cache"
set "TEMP=%SCRIPT_DIR%temp"
set "TMP=%SCRIPT_DIR%temp"
set "npm_config_cache=%SCRIPT_DIR%npm-cache"
set "HOME=%SCRIPT_DIR%config"
set "USERPROFILE=%SCRIPT_DIR%config"

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
