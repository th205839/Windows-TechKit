@echo off
cls
for /f "delims=" %%A in (banner.txt) do echo %%A

echo.
echo [1] Instalar Windows
echo [2] Abrir Toolkit de Suporte
echo [3] Diagnostico Basico
echo [4] Sair
echo.
set /p choice=Escolha uma opcao: 

if /I "%choice%"=="1" call "%~dp0Start-Install-Windows.cmd"
if /I "%choice%"=="2" call "%~dp0Start-USB-Toolkit.cmd"
if /I "%choice%"=="3" call "%~dp0Start-Diagnostics.cmd"
if /I "%choice%"=="4" exit /b 0

exit /b 0
