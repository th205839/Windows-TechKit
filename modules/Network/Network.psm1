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
            if ($config.IPv4DefaultGateway) { $summary.Gateway = $config.IPv4DefaultGateway[0].NextHop }
            if ($config.DnsServer) { $summary.DNS = $config.DnsServer[0].ServerAddresses -join ', ' }
        }
    }

    Write-Host ('Network status: {0}' -f $summary.Status) -ForegroundColor Green
    return [pscustomobject]$summary
}

function Invoke-TechKitNetworkDiagnostics {
    [CmdletBinding()]
    param([string[]]$Targets = @('1.1.1.1', '8.8.8.8'))

    foreach ($target in $Targets) {
        try {
            $reply = Test-Connection -ComputerName $target -Count 2 -ErrorAction Stop
            [pscustomobject]@{
                Target = $target
                Status = 'Online'
                AverageMs = [math]::Round((($reply | Measure-Object ResponseTime -Average).Average), 0)
            }
        } catch {
            [pscustomobject]@{ Target = $target; Status = 'Offline'; AverageMs = $null }
        }
    }
}

Export-ModuleMember -Function Test-NetworkStatus, Invoke-TechKitNetworkDiagnostics
