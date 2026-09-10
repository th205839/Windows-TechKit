$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Repair and network modules' {
    BeforeAll {
        Import-Module (Join-Path $repoRoot 'modules/Repair/Repair.psm1') -Force
        Import-Module (Join-Path $repoRoot 'modules/Network/Network.psm1') -Force
    }

    It 'returns a repair plan' {
        $result = Invoke-WindowsRepair
        if ($result.Status -ne 'Completed') {
            throw 'Repair status did not match expected value'
        }
    }

    It 'returns network status' {
        $result = Test-NetworkStatus
        if ($result.Status -notmatch 'Available|Unavailable') {
            throw 'Network status did not match expected values'
        }
    }
}
