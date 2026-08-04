function Get-NetworkDiagnostics {
    Write-Host "Starting network diagnostics..."

    Write-Host "`nIP Configuration"
    ipconfig

    Write-Host "`nDNS Cache"
    Get-DnsClientCache | Select-Object -First 20

    Write-Host "`nActive Adapters"
    Get-NetAdapter | Where-Object Status -eq 'Up'
}
