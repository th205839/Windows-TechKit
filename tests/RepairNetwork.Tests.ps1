$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Repair and network modules' {
    BeforeAll {
        Import-Module (Join-Path $repoRoot 'modules/Repair/Repair.psm1') -Force
        Import-Module (Join-Path $repoRoot 'modules/Network/Network.psm1') -Force
        . (Join-Path $repoRoot 'modules/Repair/SFC.ps1')
        . (Join-Path $repoRoot 'modules/Repair/DISM.ps1')
        . (Join-Path $repoRoot 'modules/Repair/CheckDisk.ps1')
        . (Join-Path $repoRoot 'modules/Repair/FullRepair.ps1')
    }

    It 'returns a repair plan' {
        $result = Invoke-WindowsRepair
        if ($result.Status -ne 'Prepared') {
            throw 'Repair status did not match expected value'
        }
    }

    It 'creates a full repair plan without executing' {
        $result = Invoke-FullWindowsRepair -DriveLetter 'C:'
        if ($result.Status -ne 'Prepared') {
            throw 'Full repair plan status was not prepared'
        }
    }

    It 'returns network status' {
        $result = Test-NetworkStatus
        if ($result.Status -notmatch 'Available|Unavailable') {
            throw 'Network status did not match expected values'
        }
    }
}
