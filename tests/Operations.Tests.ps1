$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Windows-TechKit operations' {
    BeforeAll {
        . (Join-Path $repoRoot 'core/operations/Diagnostics.ps1')
        . (Join-Path $repoRoot 'core/operations/Maintenance.ps1')
        . (Join-Path $repoRoot 'core/operations/Reporting.ps1')
    }

    It 'runs diagnostics' {
        $result = Invoke-TechKitDiagnostics
        $result.ComputerName | Should -Not -BeNullOrEmpty
    }

    It 'runs maintenance workflow' {
        $result = Invoke-TechKitMaintenance -ClientName 'Client'
        $result.ClientName | Should -Be 'Client'
    }

    It 'exports a report' {
        $result = Export-TechKitReport -Data ([pscustomobject]@{ Status = 'ok' }) -FileName 'test-export'
        $result | Should -Match 'test-export.json'
    }
}
