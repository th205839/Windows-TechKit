@echo off
cls
echo =====================================
echo Carregando ferramentas do kit tecnico
echo =====================================
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\Start-USB-Toolkit.ps1"
echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
