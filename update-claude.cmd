@echo off
echo ============================================
echo  Claude Code Portable - Update
echo ============================================
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Create required directories
if not exist "%SCRIPT_DIR%\config\AppData\Roaming" mkdir "%SCRIPT_DIR%\config\AppData\Roaming"
if not exist "%SCRIPT_DIR%\config\AppData\Local" mkdir "%SCRIPT_DIR%\config\AppData\Local"
if not exist "%SCRIPT_DIR%\temp" mkdir "%SCRIPT_DIR%\temp"
if not exist "%SCRIPT_DIR%\npm-cache" mkdir "%SCRIPT_DIR%\npm-cache"

REM Core paths
set "PATH=%SCRIPT_DIR%\node;%SCRIPT_DIR%\npm-global;%PATH%"
set "NPM_CONFIG_PREFIX=%SCRIPT_DIR%\npm-global"

REM Zero-trace: redirect all user directories to the drive
set "HOME=%SCRIPT_DIR%\config"
set "USERPROFILE=%SCRIPT_DIR%\config"
set "APPDATA=%SCRIPT_DIR%\config\AppData\Roaming"
set "LOCALAPPDATA=%SCRIPT_DIR%\config\AppData\Local"
set "TEMP=%SCRIPT_DIR%\temp"
set "TMP=%SCRIPT_DIR%\temp"

REM npm/Node isolation
set "npm_config_cache=%SCRIPT_DIR%\npm-cache"
set "npm_config_userconfig=%SCRIPT_DIR%\config\.npmrc"
set "NODE_REPL_HISTORY=%SCRIPT_DIR%\config\.node_repl_history"

echo Updating Claude Code...
echo.

call "%SCRIPT_DIR%\node\npm.cmd" update -g @anthropic-ai/claude-code

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
