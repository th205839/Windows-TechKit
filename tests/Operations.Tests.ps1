$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Windows-TechKit operations' {
    BeforeAll {
        . (Join-Path $repoRoot 'core/operations/Diagnostics.ps1')
        . (Join-Path $repoRoot 'core/operations/Maintenance.ps1')
        . (Join-Path $repoRoot 'core/operations/Reporting.ps1')
    }

    It 'runs diagnostics' {
        $result = Invoke-TechKitDiagnostics
        if ([string]::IsNullOrWhiteSpace($result.ComputerName)) {
            throw 'ComputerName should not be empty'
        }
    }

    It 'runs maintenance workflow' {
        $result = Invoke-TechKitMaintenance -ClientName 'Client'
        if ($result.ClientName -ne 'Client') {
            throw 'Maintenance client name did not match expectation'
        }
    }

    It 'exports a report' {
        $result = Export-TechKitReport -Data ([pscustomobject]@{ Status = 'ok' }) -FileName 'test-export'
        if ($result -notmatch 'test-export.json') {
            throw 'Report export path did not match expectation'
        }
    }
}
