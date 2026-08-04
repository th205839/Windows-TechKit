# Windows-TechKit Professional Launcher
# Entry point for the technician toolkit

[CmdletBinding()]
param(
    [ValidateSet('interactive', 'noninteractive')]
    [string]$Mode = 'interactive'
)

Write-Host 'Windows-TechKit Professional' -ForegroundColor Cyan
Write-Host 'Initializing environment...' -ForegroundColor DarkCyan

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$config = Join-Path $root 'config/version.json'
if (Test-Path $config) {
    Write-Host 'Configuration loaded.' -ForegroundColor Green
}

$launcherScript = Join-Path $root 'core/launcher/Start-TechKit.ps1'
if (Test-Path $launcherScript) {
    & $launcherScript -Mode $Mode
}
else {
    Write-Host 'Launcher script not found.' -ForegroundColor Yellow
}
