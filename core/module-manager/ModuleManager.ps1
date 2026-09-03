# Windows-TechKit Module Manager
# Responsible for module discovery and execution lifecycle.

Set-StrictMode -Version Latest

function Get-TechKitRoot {
    [CmdletBinding()]
    param()

    return Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
}

function Get-TechKitModules {
    [CmdletBinding()]
    param(
        [string]$ModulesPath = (Join-Path (Get-TechKitRoot) 'modules')
    )

    if (Test-Path -LiteralPath $ModulesPath -PathType Container) {
        return @(Get-ChildItem -LiteralPath $ModulesPath -Directory | Sort-Object Name)
    }

    return @()
}

function Start-TechKitModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulePath
    )

    if (-not (Test-Path -LiteralPath $ModulePath -PathType Container)) {
        throw "Module path not found: $ModulePath"
    }

    $launcher = Join-Path $ModulePath 'Start.ps1'
    if (Test-Path -LiteralPath $launcher -PathType Leaf) {
        & $launcher
        return $true
    }

    return $false
}

function Get-TechKitModuleInventory {
    [CmdletBinding()]
    param()

    $modules = Get-TechKitModules
    return @(
        foreach ($module in $modules) {
            [pscustomobject]@{
                Name            = $module.Name
                Path            = $module.FullName
                HasStartScript  = Test-Path (Join-Path $module.FullName 'Start.ps1')
                HasActionsScript = Test-Path (Join-Path $module.FullName 'Actions.ps1')
                HasReportScript  = Test-Path (Join-Path $module.FullName 'Report.ps1')
            }
        }
    )
}
