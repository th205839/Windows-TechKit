# Tweaks report generator

function New-TechKitTweaksReport {
    [CmdletBinding()]
    param(
        [string]$Summary = 'Tweaks workflow completed'
    )

    $report = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Module = 'Tweaks'
        Summary = $Summary
        Status = 'Prepared'
    }

    Write-Host 'Tweaks report generated.' -ForegroundColor Cyan
    return [pscustomobject]$report
}
