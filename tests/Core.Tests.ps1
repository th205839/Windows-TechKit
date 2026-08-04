$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Windows-TechKit core functions' {
    BeforeAll {
        . (Join-Path $repoRoot 'core/runtime/Runtime.ps1')
        . (Join-Path $repoRoot 'core/health/HealthCheck.ps1')
        . (Join-Path $repoRoot 'core/settings-manager/Settings.ps1')
        . (Join-Path $repoRoot 'core/logger/Logger.ps1')
        . (Join-Path $repoRoot 'core/reporting/ReportManager.ps1')
    }

    It 'initializes runtime context' {
        $result = Initialize-TechKitRuntime
        $result.Status | Should -Be 'ready'
    }

    It 'reports health status' {
        $result = Invoke-TechKitHealthCheck
        $result.Status | Should -Be 'Ready'
    }

    It 'manages settings' {
        Set-TechKitSetting -Name 'Mode' -Value 'Maintenance'
        (Get-TechKitSetting -Name 'Mode') | Should -Be 'Maintenance'
    }

    It 'creates reports' {
        $report = New-TechKitReport -Title 'Test'
        $report.Title | Should -Be 'Test'
    }
}
