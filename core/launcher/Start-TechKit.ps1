param()

$Root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$logger = Join-Path $Root "logger/Logger.ps1"
if (Test-Path $logger) {
    . $logger
}

Write-TechLog "Starting Windows-TechKit..."

$config = Join-Path $Root "config/Settings.psd1"
if (Test-Path $config) {
    Import-PowerShellDataFile $config | Out-Null
    Write-TechLog "Configuration loaded."
}

$loader = Join-Path $Root "core/module-manager/ModuleLoader.ps1"
if (Test-Path $loader) {
    . $loader
    if (Get-Command Load-TechKitModules -ErrorAction SilentlyContinue) {
        Load-TechKitModules
        Write-TechLog "Modules loaded."
    }
}

$menu = Join-Path $Root "core/menu/MainMenu.ps1"

if (Test-Path $menu) {
    . $menu
    if (Get-Command Start-MainMenu -ErrorAction SilentlyContinue) {
        Start-MainMenu
    }
} else {
    Write-TechLog "Menu system not found."
}
