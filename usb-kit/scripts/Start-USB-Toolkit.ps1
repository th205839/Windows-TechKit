[CmdletBinding()]
param()

$root = Split-Path -Parent $PSScriptRoot
$toolkit = Join-Path $root 'tools\Start-TechKit.ps1'

Write-Host 'Windows-TechKit USB Kit' -ForegroundColor Cyan
Write-Host 'Preparing environment...' -ForegroundColor DarkCyan

if (Test-Path $toolkit) {
    & $toolkit
}
else {
    Write-Host 'Toolkit launcher not found in tools/.' -ForegroundColor Yellow
}
