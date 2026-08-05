[CmdletBinding()]
param(
    [ValidateSet('interactive','noninteractive')]
    [string]$Mode = 'interactive'
)

$root = Split-Path -Parent $PSScriptRoot
$launcher = Join-Path $root 'tools/Start-TechKit.ps1'

if (Test-Path $launcher) {
    & $launcher -Mode $Mode
}
else {
    Write-Host 'Launcher nao encontrado.' -ForegroundColor Red
    Write-Host 'Certifique-se de copiar a pasta completa do kit para o pendrive.' -ForegroundColor Yellow
}
