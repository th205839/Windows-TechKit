function Invoke-FullWindowsRepair {
    [CmdletBinding()]
    param(
        [string]$DriveLetter = 'C:',
        [switch]$Apply
    )

    $plan = @(
        (Invoke-SFCScan -Apply:$Apply),
        (Invoke-DISMRepair -Apply:$Apply),
        (Invoke-DiskCheck -DriveLetter $DriveLetter -Apply:$Apply)
    )

    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        DriveLetter = $DriveLetter
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        Steps = $plan
        AdminRequired = $true
    }

    if ($Apply) {
        Write-Host 'Repair sequence completed.' -ForegroundColor Green
    }
    else {
        Write-Host 'Repair sequence prepared.' -ForegroundColor Yellow
    }

    return [pscustomobject]$result
}
