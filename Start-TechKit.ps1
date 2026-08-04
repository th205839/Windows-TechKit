# Windows-TechKit Professional Launcher
# Entry point for the technician toolkit

Write-Host "Windows-TechKit Professional" -ForegroundColor Cyan
Write-Host "Initializing environment..."

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$config = Join-Path $root "config\version.json"
if (Test-Path $config) {
    Write-Host "Configuration loaded."
}

Write-Host "Launcher ready."
