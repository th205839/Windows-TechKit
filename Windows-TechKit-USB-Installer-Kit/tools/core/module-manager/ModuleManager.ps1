# Windows-TechKit Module Manager
# Responsible for module discovery and execution lifecycle.

function Get-TechKitModules {
    [CmdletBinding()]
    param(
        [string]$ModulesPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'modules')
    )

    if (Test-Path $ModulesPath) {
        return Get-ChildItem -Path $ModulesPath -Directory | Sort-Object Name
    }

    return @()
}

function Start-TechKitModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulePath
    )

    $launcher = Join-Path $ModulePath 'Start.ps1'
    if (Test-Path $launcher) {
        & $launcher
        return $true
    }

    return $false
}

function Get-TechKitModuleInventory {
    [CmdletBinding()]
    param()

    $modules = Get-TechKitModules
    $inventory = foreach ($module in $modules) {
        [pscustomobject]@{
            Name = $module.Name
            Path = $module.FullName
            HasStartScript = Test-Path (Join-Path $module.FullName 'Start.ps1')
            HasActionsScript = Test-Path (Join-Path $module.FullName 'Actions.ps1')
            HasReportScript = Test-Path (Join-Path $module.FullName 'Report.ps1')
        }
    }

    return $inventory
}
