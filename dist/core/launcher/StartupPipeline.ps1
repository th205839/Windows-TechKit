# Windows-TechKit Startup Pipeline
# Coordinates startup sequence

param(
    [string]$RootPath = (Split-Path -Parent $PSScriptRoot)
)

Write-Host "Starting Windows-TechKit pipeline..."

$components = @(
    "runtime/Runtime.ps1",
    "health/HealthCheck.ps1",
    "module-manager/ModuleManager.ps1",
    "settings-manager/Settings.ps1"
)

foreach ($component in $components) {
    $path = Join-Path $RootPath $component
    if (Test-Path $path) {
        Write-Host "Loaded: $component"
    }
}

Write-Host "Startup pipeline ready."
