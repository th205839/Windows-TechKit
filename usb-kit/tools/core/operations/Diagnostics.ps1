function Invoke-TechKitDiagnostics {
    [CmdletBinding()]
    param()

    $report = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        ComputerName = $env:COMPUTERNAME
        UserName = $env:USERNAME
        OS = $env:OS
        Admin = $false
    }

    if (Get-Command Test-AdminRights -ErrorAction SilentlyContinue) {
        $report.Admin = Test-AdminRights
    }

    $network = $false
    if (Get-Command Test-Connection -ErrorAction SilentlyContinue) {
        $network = Test-Connection -ComputerName '8.8.8.8' -Count 1 -Quiet
    }

    $report.Network = $network

    $summary = [pscustomobject]$report
    Write-Host ('Diagnostics completed for {0}' -f $summary.ComputerName) -ForegroundColor Green
    return $summary
}
