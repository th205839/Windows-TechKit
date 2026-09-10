function Invoke-SecurityActions {
    [CmdletBinding()]
    param()

    $defender = $null
    if (Get-Command Get-MpComputerStatus -ErrorAction SilentlyContinue) {
        $defender = Get-MpComputerStatus -ErrorAction SilentlyContinue
    }

    $winDefend = $null
    if (Get-Command Get-Service -ErrorAction SilentlyContinue) {
        $winDefend = Get-Service -Name WinDefend -ErrorAction SilentlyContinue
    }

    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Status = 'Prepared'
        DefenderAvailable = ($null -ne $defender)
        DefenderEnabled = if ($defender) { [bool]$defender.AntivirusEnabled } else { $false }
        WinDefendStatus = if ($winDefend) { $winDefend.Status.ToString() } else { 'NotFound' }
        Actions = @(
            'Verify Microsoft Defender state',
            'Confirm firewall and service state',
            'Review local admin and security policy settings'
        )
    }

    Write-Host 'Preparing security workflow...' -ForegroundColor Yellow
    return [pscustomobject]$result
}
