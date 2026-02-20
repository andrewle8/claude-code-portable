@echo off
echo ============================================
echo  Claude Code Portable - Update
echo ============================================
echo.

set "SCRIPT_DIR=%~dp0"
set "PATH=%SCRIPT_DIR%node;%SCRIPT_DIR%npm-global;%PATH%"
set "NPM_CONFIG_PREFIX=%SCRIPT_DIR%npm-global"

echo Updating Claude Code...
echo.

"%SCRIPT_DIR%node\npm.cmd" update -g @anthropic-ai/claude-code

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Update failed. Check your internet connection.
    pause
    exit /b 1
)

echo.
echo ============================================
echo  Update complete!
echo ============================================
pause
