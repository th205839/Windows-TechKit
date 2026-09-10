[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('interactive', 'noninteractive')]
    [string]$Mode = 'interactive'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

. (Join-Path $Root 'core/branding/Branding.ps1')
. (Join-Path $Root 'core/runtime/Environment.ps1')
. (Join-Path $Root 'core/runtime/Runtime.ps1')
. (Join-Path $Root 'core/security/AdminCheck.ps1')
. (Join-Path $Root 'core/health/HealthCheck.ps1')
. (Join-Path $Root 'core/logger/Logger.ps1')
. (Join-Path $Root 'core/settings-manager/Settings.ps1')
. (Join-Path $Root 'core/reporting/ReportManager.ps1')
. (Join-Path $Root 'core/module-manager/ModuleManager.ps1')
. (Join-Path $Root 'core/operations/Diagnostics.ps1')
. (Join-Path $Root 'core/operations/Maintenance.ps1')
. (Join-Path $Root 'core/operations/Reporting.ps1')
. (Join-Path $Root 'core/menu/MainMenu.ps1')

Show-TechKitBanner
Write-TechLog -Message 'Starting Windows-TechKit...'

$config = Join-Path $Root 'config/Settings.psd1'
if (Test-Path $config) {
    $settingsData = Import-PowerShellDataFile $config
    foreach ($entry in $settingsData.GetEnumerator()) {
        Set-TechKitSetting -Name $entry.Key -Value $entry.Value
    }
    Write-TechLog -Message 'Configuration loaded.'
}

$runtime = Initialize-TechKitRuntime
$health = Invoke-TechKitHealthCheck
$modules = Get-TechKitModules

Set-TechKitSetting -Name 'Mode' -Value $Mode
Set-TechKitSetting -Name 'RootPath' -Value $Root
Set-TechKitSetting -Name 'Runtime' -Value $runtime
Set-TechKitSetting -Name 'Health' -Value $health
Set-TechKitSetting -Name 'Modules' -Value $modules

Write-TechLog -Message ('Runtime ready: {0}' -f $runtime.Status)
Write-TechLog -Message ('Health status: {0}' -f $health.Status)
Write-TechLog -Message ('Modules discovered: {0}' -f (($modules | ForEach-Object { $_.Name }) -join ', '))

if ($Mode -eq 'noninteractive') {
    Write-Host 'Non-interactive mode enabled. Completed startup checks.'
    return [pscustomobject]@{
        Runtime = $runtime
        Health = $health
    }
}

if (Get-Command Show-MainMenu -ErrorAction SilentlyContinue) {
    Show-MainMenu
}

