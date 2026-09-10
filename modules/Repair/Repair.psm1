# Windows-TechKit Repair Module

function Invoke-WindowsRepair {
    [CmdletBinding()]
    param(
        [switch]$Apply,
        [string]$DriveLetter = 'C:'
    )

    $actions = @()
    if (Get-Command sfc -ErrorAction SilentlyContinue) {
        $actions += 'sfc /scannow'
    }

    if (Get-Command DISM -ErrorAction SilentlyContinue) {
        $actions += 'DISM /Online /Cleanup-Image /RestoreHealth'
    }

    if (Get-Command chkdsk -ErrorAction SilentlyContinue) {
        $actions += ('chkdsk {0} /scan' -f $DriveLetter)
    }

    $report = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        Actions = $actions
        DriveLetter = $DriveLetter
        AdminRequired = $true
    }

    if ($Apply) {
        foreach ($command in $actions) {
            if ($command -like 'sfc*') {
                Invoke-SFCScan -Apply
            }
            elseif ($command -like 'DISM*') {
                Invoke-DISMRepair -Apply
            }
            elseif ($command -like 'chkdsk*') {
                Invoke-DiskCheck -DriveLetter $DriveLetter -Apply
            }
        }
    }

    Write-Host 'Windows repair diagnostics prepared.' -ForegroundColor Yellow
    return [pscustomobject]$report
}

Export-ModuleMember -Function Invoke-WindowsRepair
