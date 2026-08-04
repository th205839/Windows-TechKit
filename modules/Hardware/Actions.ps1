# Hardware Module Actions

function Invoke-HardwareDiagnostics {
    [CmdletBinding()]
    param()

    $summary = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        ComputerName = $env:COMPUTERNAME
        Status = 'Completed'
    }

    if (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
        $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
        $summary.Manufacturer = $computerSystem.Manufacturer
        $summary.Model = $computerSystem.Model
    }

    Write-Host 'Hardware diagnostics completed.' -ForegroundColor Green
    return [pscustomobject]$summary
}
