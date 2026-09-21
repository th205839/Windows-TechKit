@echo off
REM Start-TechKit.bat - One-click launcher for Windows-TechKit
REM Place this file in the root of the USB folder containing the Windows-TechKit files.
:: Resolve script directory (location of this .bat)
SET SCRIPT_DIR=%~dp0
:: Launch PowerShell with the toolkit launcher
start "Windows-TechKit" powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%SCRIPT_DIR%core\launcher\Start-TechKit.ps1' -Mode 'interactive'"
exit /b
