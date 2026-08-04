param()

$Root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

Write-Host "Starting Windows-TechKit..."

$config = Join-Path $Root "config/Settings.psd1"
if (Test-Path $config) {
    Import-PowerShellDataFile $config | Out-Null
}

$menu = Join-Path $Root "menu/MainMenu.ps1"

if (Test-Path $menu) {
    . $menu
    if (Get-Command Start-MainMenu -ErrorAction SilentlyContinue) {
        Start-MainMenu
    }
} else {
    Write-Host "Menu system not found."
}
