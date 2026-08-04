function Test-NetworkStatus {
    [CmdletBinding()]
    param()

    $result = $false
    if (Get-Command Test-Connection -ErrorAction SilentlyContinue) {
        $result = Test-Connection -ComputerName '8.8.8.8' -Count 2 -Quiet
    }

    $summary = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Status = if ($result) { 'Available' } else { 'Unavailable' }
        Gateway = $null
        DNS = $null
    }

    if (Get-Command Get-NetIPConfiguration -ErrorAction SilentlyContinue) {
        $config = Get-NetIPConfiguration -ErrorAction SilentlyContinue
        if ($config) {
            $summary.Gateway = $config.IPv4DefaultGateway[0].NextHop
            $summary.DNS = $config.DnsServer[0].Address
        }
    }

    Write-Host ('Network status: {0}' -f $summary.Status) -ForegroundColor Green
    return [pscustomobject]$summary
}

Export-ModuleMember -Function Test-NetworkStatus
