# Windows-TechKit Module Loader

function Get-TechKitModules {
    $modulesPath = Join-Path $PSScriptRoot "../../modules"

    if (Test-Path $modulesPath) {
        return Get-ChildItem -Path $modulesPath -Directory
    }

    return @()
}

function Load-TechKitModules {
    $modules = Get-TechKitModules

    foreach ($module in $modules) {
        Write-Host "Module detected: $($module.Name)"
    }
}
