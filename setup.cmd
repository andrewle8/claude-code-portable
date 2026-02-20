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

REM Check if Node is already set up
if exist "%SCRIPT_DIR%node\node.exe" (
    echo [OK] Node.js already present
) else (
    echo Downloading Node.js v22.22.0 portable...
    echo.
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/latest-v22.x/node-v22.22.0-win-x64.zip' -OutFile '%SCRIPT_DIR%node-portable.zip'"
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to download Node.js
        pause
        exit /b 1
    )
    echo Extracting...
    powershell -Command "Expand-Archive -Path '%SCRIPT_DIR%node-portable.zip' -DestinationPath '%SCRIPT_DIR%' -Force"
    xcopy /E /Y /Q "%SCRIPT_DIR%node-v22.22.0-win-x64\*" "%SCRIPT_DIR%node\"
    rmdir /S /Q "%SCRIPT_DIR%node-v22.22.0-win-x64"
    del "%SCRIPT_DIR%node-portable.zip"
    echo [OK] Node.js installed
)

echo.

REM Create folders if needed
if not exist "%SCRIPT_DIR%npm-global" mkdir "%SCRIPT_DIR%npm-global"
if not exist "%SCRIPT_DIR%config" mkdir "%SCRIPT_DIR%config"

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

REM Check if Claude Code is already installed
if exist "%SCRIPT_DIR%npm-global\claude.cmd" (
    echo [OK] Claude Code already installed
    echo.
    echo Run update-claude.cmd to update to the latest version.
) else (
    echo Installing Claude Code...
    echo.
    "%SCRIPT_DIR%node\npm.cmd" install -g @anthropic-ai/claude-code
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
