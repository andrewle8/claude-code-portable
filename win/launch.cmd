@echo off
setlocal EnableExtensions

REM ===========================================================
REM  Claude Code Portable - Windows Launcher
REM ===========================================================

title Claude Code Portable

set "WIN_DIR=%~dp0"
if "%WIN_DIR:~-1%"=="\" set "WIN_DIR=%WIN_DIR:~0,-1%"
for %%I in ("%WIN_DIR%\..") do set "DRIVE_ROOT=%%~fI"

REM Ensure required dirs exist (drive may be freshly mounted on a different machine)
if not exist "%DRIVE_ROOT%\config\AppData\Roaming" mkdir "%DRIVE_ROOT%\config\AppData\Roaming"
if not exist "%DRIVE_ROOT%\config\AppData\Local"   mkdir "%DRIVE_ROOT%\config\AppData\Local"
if not exist "%DRIVE_ROOT%\temp"                   mkdir "%DRIVE_ROOT%\temp"
if not exist "%DRIVE_ROOT%\npm-cache"              mkdir "%DRIVE_ROOT%\npm-cache"

REM Apply portable environment
call "%~dp0_env.cmd" "%DRIVE_ROOT%"

if not exist "%DRIVE_ROOT%\npm-global\claude.cmd" (
    echo Claude Code is not installed on this drive.
    echo Run win\setup.cmd first ^(needs internet^).
    pause
    exit /b 1
)

echo ============================================
echo  Claude Code Portable
echo ============================================
echo  Drive: %DRIVE_ROOT%
echo  First run on a new machine: type /login
echo ============================================
echo.

call "%DRIVE_ROOT%\npm-global\claude.cmd" %*

endlocal
