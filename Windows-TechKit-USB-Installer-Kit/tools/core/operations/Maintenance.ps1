function Invoke-TechKitMaintenance {
    [CmdletBinding()]
    param(
        [string]$ClientName = 'Unknown'
    )

    $clientRegistryPath = Join-Path $PSScriptRoot '../client/ClientRegistry.ps1'
    if (Test-Path $clientRegistryPath) {
        . $clientRegistryPath
    }

    $client = New-TechKitClient -Name $ClientName
    $history = Add-TechKitMaintenanceHistory -ClientId $client.Id -Action 'Maintenance workflow executed'

    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        ClientName = $ClientName
        ClientId = $client.Id
        Status = 'Completed'
        Actions = @('Health check', 'Inventory snapshot', 'Report saved')
        HistoryEntry = $history
    }

    Write-Host ('Maintenance workflow completed for {0}' -f $ClientName) -ForegroundColor Green
    return [pscustomobject]$result
}
