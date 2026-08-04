[CmdletBinding()]
param()

Write-Host '====================================' -ForegroundColor Cyan
Write-Host 'Windows-TechKit USB Toolkit' -ForegroundColor Cyan
Write-Host '====================================' -ForegroundColor Cyan
Write-Host ''
Write-Host '1. Iniciar toolkit' -ForegroundColor Yellow
Write-Host '2. Guia de instalação Windows' -ForegroundColor Yellow
Write-Host '3. Sair' -ForegroundColor Yellow
Write-Host ''
$choice = Read-Host 'Escolha uma opção'

switch ($choice) {
    '1' { & (Join-Path $PSScriptRoot 'Start-USB-Toolkit.ps1') }
    '2' { & (Join-Path $PSScriptRoot 'Install-Windows-Guide.ps1') }
    '3' { Write-Host 'Encerrando...' -ForegroundColor Green }
    default { Write-Host 'Opção inválida.' -ForegroundColor Red }
}
