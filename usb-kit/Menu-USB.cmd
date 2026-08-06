@echo off
cls
echo =====================================
echo Windows-TechKit USB Installer Kit
echo =====================================
echo.
echo 1. Instalar Windows
echo 2. Abrir ferramentas do kit
echo 3. Sair
echo.
set /p choice=Escolha uma opcao: 

if /I "%choice%"=="1" call "%~dp0Start-Install-Windows.cmd"
if /I "%choice%"=="2" call "%~dp0Start-USB-Toolkit.cmd"
if /I "%choice%"=="3" exit /b 0

exit /b 0
