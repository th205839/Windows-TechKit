# Windows-TechKit Module Manager
# Responsible for module discovery and execution lifecycle.

function Get-TechKitRepositoryRoot {
    [CmdletBinding()]
    param()

    $candidates = @(
        (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),
        (Split-Path -Parent $PSScriptRoot),
        (Get-Location).Path
    )

    foreach ($candidate in $candidates) {
        if (-not $candidate) { continue }
        $modulesPath = Join-Path $candidate 'modules'
        if (Test-Path $modulesPath) {
            return $candidate
        }
    }

    return $null
}

function Get-TechKitModules {
    [CmdletBinding()]
    param(
        [string]$ModulesPath
    )

    $resolvedRoot = if ($PSBoundParameters.ContainsKey('ModulesPath') -and $ModulesPath) {
        $ModulesPath
    }
    else {
        $root = Get-TechKitRepositoryRoot
        if ($root) {
            Join-Path $root 'modules'
        }
        else {
            $null
        }
    }

    if ($resolvedRoot -and (Test-Path $resolvedRoot)) {
        return Get-ChildItem -Path $resolvedRoot -Directory | Sort-Object Name
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
        $moduleJsonPath = Join-Path $module.FullName 'module.json'
        $moduleMetadata = @{}
        if (Test-Path $moduleJsonPath) {
            try {
                $moduleMetadata = Get-Content -Path $moduleJsonPath -Raw | ConvertFrom-Json -AsHashtable
            }
            catch {
                $moduleMetadata = @{}
            }
        }

        [pscustomobject]@{
            Name = $module.Name
            Path = $module.FullName
            Enabled = [bool]($moduleMetadata.enabled)
            HasStartScript = Test-Path (Join-Path $module.FullName 'Start.ps1')
            HasActionsScript = Test-Path (Join-Path $module.FullName 'Actions.ps1')
            HasReportScript = Test-Path (Join-Path $module.FullName 'Report.ps1')
        }
    }

    return $inventory
}
