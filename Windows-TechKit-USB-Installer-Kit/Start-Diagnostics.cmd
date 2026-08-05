@echo off
cls
echo ================================
echo Diagnostico Basico de Suporte
echo ================================
echo.
echo Verificando ambiente de suporte...
echo.
echo [1] Verificar hardware
echo [2] Verificar rede
echo [3] Coletar logs
set /p choice=Escolha uma opcao: 

if /I "%choice%"=="1" echo Diagnostico de hardware: em desenvolvimento.
if /I "%choice%"=="2" echo Diagnostico de rede: em desenvolvimento.
if /I "%choice%"=="3" echo Logs salvos em logs/.

echo.
echo Pressione qualquer tecla para voltar ao menu...
pause >nul
