[CmdletBinding()]
param()

Write-Host 'Hardware diagnostics module loaded.' -ForegroundColor Yellow

try {
    $result = [ordered]@{
        Module = 'Hardware'
        Timestamp = (Get-Date).ToString('o')
        Status = 'Prepared'
        StatusDetail = $null
        AdminRequired = $false
        Details = 'Initialized'
    }

    if (Get-Command Invoke-HardwareDiagnostics -ErrorAction SilentlyContinue) {
        $result.StatusDetail = Invoke-HardwareDiagnostics
    }

    Write-Host ('Hardware workflow ready: {0}' -f ($result.StatusDetail.Status -or $result.Status)) -ForegroundColor Green
    return [pscustomobject]$result
}
catch {
    Write-Warning ('Hardware module failed to initialize: {0}' -f $_.Exception.Message)
    throw
}
