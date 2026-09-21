@echo off
setlocal
chcp 65001 >nul

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_ROOT=%%~fI"
set "BUILD_SCRIPT=%SCRIPT_DIR%build_windows_demo.ps1"
set "OUTPUT_ROOT=%PROJECT_ROOT%\dist\windows-x64"

echo [LJQCApp] Building Windows desktop packages...
echo.

if not exist "%BUILD_SCRIPT%" (
    echo [ERROR] Build script not found:
    echo %BUILD_SCRIPT%
    echo.
    pause
    exit /b 1
)

where powershell.exe >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Windows PowerShell was not found.
    echo.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%BUILD_SCRIPT%" -OutputRoot "%OUTPUT_ROOT%"
set "BUILD_EXIT_CODE=%ERRORLEVEL%"

if not "%BUILD_EXIT_CODE%"=="0" (
    echo.
    echo [FAILED] Build did not complete. Please review the log above.
    echo.
    pause
    exit /b %BUILD_EXIT_CODE%
)

echo.
echo [OK] Build completed successfully.
echo Single-file EXE: dist\windows-x64\release\LJQCApp.exe
echo Folder version:  dist\windows-x64\dist\LJQCApp
echo.
pause
exit /b 0
