[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-TechKitNetworkDiagnostic {
    $targets = @('1.1.1.1', '8.8.8.8')
    $results = foreach ($target in $targets) {
        $reachable = Test-Connection -ComputerName $target -Count 2 -Quiet -ErrorAction SilentlyContinue
        [pscustomobject]@{
            Target = $target
            Reachable = [bool]$reachable
        }
    }

    $dns = Resolve-DnsName -Name 'www.microsoft.com' -ErrorAction SilentlyContinue
    $gateways = Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "IPEnabled = True" -ErrorAction SilentlyContinue |
        ForEach-Object { $_.DefaultIPGateway } |
        Where-Object { $_ }

    [pscustomobject]@{
        ComputerName = $env:COMPUTERNAME
        Connectivity = $results
        DnsResolution = [bool]$dns
        DefaultGateway = ($gateways -join ', ')
    }
}

Write-Host "`n=== Windows-TechKit | Rede ===" -ForegroundColor Cyan
Invoke-TechKitNetworkDiagnostic | Format-List
