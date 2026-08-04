$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Repair and network modules' {
    BeforeAll {
        Import-Module (Join-Path $repoRoot 'modules/Repair/Repair.psm1') -Force
        Import-Module (Join-Path $repoRoot 'modules/Network/Network.psm1') -Force
    }

    It 'returns a repair plan' {
        $result = Invoke-WindowsRepair
        $result.Status | Should -Be 'Completed'
    }

    It 'returns network status' {
        $result = Test-NetworkStatus
        $result.Status | Should -Match 'Available|Unavailable'
    }
}
