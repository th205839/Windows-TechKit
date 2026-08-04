# Windows-TechKit Module Manager
# Responsible for module discovery and execution lifecycle.

function Get-TechKitModules {
    param([string]$ModulesPath = "modules")

    if (Test-Path $ModulesPath) {
        return Get-ChildItem $ModulesPath -Directory
    }

    return @()
}

function Start-TechKitModule {
    param([string]$ModulePath)

    $launcher = Join-Path $ModulePath "Start.ps1"
    if (Test-Path $launcher) {
        & $launcher
    }
}
