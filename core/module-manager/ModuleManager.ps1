# Windows-TechKit Module Manager
# Loads and manages toolkit modules

function Get-TechKitModules {
    param([string]$Path)
    if (Test-Path $Path) {
        Get-ChildItem $Path -Directory
    }
}
