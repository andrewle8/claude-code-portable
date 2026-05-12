@echo off
setlocal EnableExtensions

REM ===========================================================
REM  Claude Code Portable - Windows Setup (one-time, needs net)
REM ===========================================================
REM  Downloads portable Node.js, installs Claude Code into the
REM  drive. Nothing is written to the host machine.
REM ===========================================================

title Claude Code Portable - Setup

REM Resolve the drive root (parent of /win/)
set "WIN_DIR=%~dp0"
if "%WIN_DIR:~-1%"=="\" set "WIN_DIR=%WIN_DIR:~0,-1%"
for %%I in ("%WIN_DIR%\..") do set "DRIVE_ROOT=%%~fI"

echo ============================================
echo  Claude Code Portable - Setup
echo ============================================
echo Drive root: %DRIVE_ROOT%
echo.

REM Required directories on the drive
if not exist "%DRIVE_ROOT%\config\AppData\Roaming" mkdir "%DRIVE_ROOT%\config\AppData\Roaming"
if not exist "%DRIVE_ROOT%\config\AppData\Local"   mkdir "%DRIVE_ROOT%\config\AppData\Local"
if not exist "%DRIVE_ROOT%\temp"                   mkdir "%DRIVE_ROOT%\temp"
if not exist "%DRIVE_ROOT%\npm-cache"              mkdir "%DRIVE_ROOT%\npm-cache"
if not exist "%DRIVE_ROOT%\npm-global"             mkdir "%DRIVE_ROOT%\npm-global"
if not exist "%DRIVE_ROOT%\node"                   mkdir "%DRIVE_ROOT%\node"

REM Download portable Node.js if not already present
if exist "%DRIVE_ROOT%\node\node.exe" (
    echo [OK] Node.js already present
) else (
    echo Downloading Node.js v22.22.0 portable...
    powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://nodejs.org/dist/latest-v22.x/node-v22.22.0-win-x64.zip' -OutFile '%DRIVE_ROOT%\node-portable.zip'"
    if errorlevel 1 (
        echo ERROR: Failed to download Node.js. Check your internet connection.
        pause
        exit /b 1
    )
    echo Extracting...
    powershell -NoProfile -Command "Expand-Archive -Path '%DRIVE_ROOT%\node-portable.zip' -DestinationPath '%DRIVE_ROOT%' -Force"
    xcopy /E /Y /Q "%DRIVE_ROOT%\node-v22.22.0-win-x64\*" "%DRIVE_ROOT%\node\" >nul
    rmdir /S /Q "%DRIVE_ROOT%\node-v22.22.0-win-x64"
    del "%DRIVE_ROOT%\node-portable.zip"
    echo [OK] Node.js installed
)

REM Apply portable environment for the install step
call "%~dp0_env.cmd" "%DRIVE_ROOT%"

REM Install Claude Code if not already installed
if exist "%DRIVE_ROOT%\npm-global\claude.cmd" (
    echo [OK] Claude Code already installed
    echo     Run update.cmd to update to the latest version.
) else (
    echo Installing Claude Code from npm...
    call "%DRIVE_ROOT%\node\npm.cmd" install -g @anthropic-ai/claude-code
    if errorlevel 1 (
        echo ERROR: Installation failed.
        pause
        exit /b 1
    )
    echo [OK] Claude Code installed
)

echo.
echo ============================================
echo  Setup complete. Run launch.cmd to start.
echo ============================================
pause
endlocal
