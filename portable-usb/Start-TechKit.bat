@echo off
REM Start-TechKit.bat - One-click launcher for Windows-TechKit (portable USB)
REM Place this file in the root of the USB folder containing the Windows-TechKit files.
SET SCRIPT_DIR=%~dp0
start "Windows-TechKit" powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%SCRIPT_DIR%Windows-TechKit\core\launcher\Start-TechKit.ps1' -Mode interactive"
exit /b
