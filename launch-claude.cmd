@echo off
title Claude Code Portable
echo ============================================
echo  Claude Code Portable
echo ============================================
echo.

set "SCRIPT_DIR=%~dp0"
set "PATH=%SCRIPT_DIR%node;%SCRIPT_DIR%npm-global;%PATH%"
set "NPM_CONFIG_PREFIX=%SCRIPT_DIR%npm-global"
set "CLAUDE_CONFIG_DIR=%SCRIPT_DIR%config"
set "NODE_PATH=%SCRIPT_DIR%npm-global\node_modules"

echo Starting Claude Code...
echo.

"%SCRIPT_DIR%npm-global\claude.cmd" %*

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo If Claude failed to start, run install-claude.cmd first.
    pause
)
