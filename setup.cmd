@echo off
echo ============================================
echo  Claude Code Portable - Setup
echo ============================================
echo.
echo This script downloads Node.js and installs
echo Claude Code to this USB drive.
echo.
echo Requirements: Internet connection
echo.

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Check if Node is already set up
if exist "%SCRIPT_DIR%\node\node.exe" (
    echo [OK] Node.js already present
) else (
    echo Downloading Node.js v22.22.0 portable...
    echo.
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/latest-v22.x/node-v22.22.0-win-x64.zip' -OutFile '%SCRIPT_DIR%\node-portable.zip'"
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to download Node.js
        pause
        exit /b 1
    )
    echo Extracting...
    powershell -Command "Expand-Archive -Path '%SCRIPT_DIR%\node-portable.zip' -DestinationPath '%SCRIPT_DIR%' -Force"
    xcopy /E /Y /Q "%SCRIPT_DIR%\node-v22.22.0-win-x64\*" "%SCRIPT_DIR%\node\"
    rmdir /S /Q "%SCRIPT_DIR%\node-v22.22.0-win-x64"
    del "%SCRIPT_DIR%\node-portable.zip"
    echo [OK] Node.js installed
)

echo.

REM Create all required directories
if not exist "%SCRIPT_DIR%\npm-global" mkdir "%SCRIPT_DIR%\npm-global"
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

REM Check if Claude Code is already installed
if exist "%SCRIPT_DIR%\npm-global\claude.cmd" (
    echo [OK] Claude Code already installed
    echo.
    echo Run update-claude.cmd to update to the latest version.
) else (
    echo Installing Claude Code...
    echo.
    call "%SCRIPT_DIR%\node\npm.cmd" install -g @anthropic-ai/claude-code
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ERROR: Installation failed.
        pause
        exit /b 1
    )
    echo.
    echo [OK] Claude Code installed
)

echo.
echo ============================================
echo  Setup complete! Run launch-claude.cmd
echo ============================================
pause
