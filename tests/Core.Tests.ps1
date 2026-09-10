$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Windows-TechKit core functions' {
    BeforeAll {
        . (Join-Path $repoRoot 'core/runtime/Environment.ps1')
        . (Join-Path $repoRoot 'core/runtime/Runtime.ps1')
        . (Join-Path $repoRoot 'core/health/HealthCheck.ps1')
        . (Join-Path $repoRoot 'core/settings-manager/Settings.ps1')
        . (Join-Path $repoRoot 'core/logger/Logger.ps1')
        . (Join-Path $repoRoot 'core/reporting/ReportManager.ps1')
    }

    It 'initializes runtime context' {
        $result = Initialize-TechKitRuntime
        if ($result.Status -ne 'ready') {
            throw 'Runtime status was not ready'
        }
    }

    It 'reports health status' {
        $result = Invoke-TechKitHealthCheck
        if ($result.Status -ne 'Ready') {
            throw 'Health status was not Ready'
        }
    }

    It 'manages settings' {
        Set-TechKitSetting -Name 'Mode' -Value 'Maintenance'
        $setting = Get-TechKitSetting -Name 'Mode'
        if ($setting -ne 'Maintenance') {
            throw 'Settings did not persist the expected value'
        }
    }

    It 'creates reports' {
        $report = New-TechKitReport -Title 'Test'
        if ($report.Title -ne 'Test') {
            throw 'Report title did not match expectation'
        }
    }
}
