function New-TechKitClient {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [string]$Email = '',
        [string]$Phone = ''
    )

    return [pscustomobject]@{
        Id = [guid]::NewGuid().ToString('N').Substring(0, 8)
        Name = $Name
        Email = $Email
        Phone = $Phone
        Created = (Get-Date).ToString('o')
    }
}

function Add-TechKitMaintenanceHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ClientId,
        [Parameter(Mandatory)]
        [string]$Action
    )

    $entry = [pscustomobject]@{
        ClientId = $ClientId
        Action = $Action
        Timestamp = (Get-Date).ToString('o')
    }

    $historyPath = Join-Path $PSScriptRoot '../logs/maintenance-history.json'
    $history = @()
    if (Test-Path $historyPath) {
        $history = Get-Content -Path $historyPath -Raw | ConvertFrom-Json
        if ($null -eq $history) {
            $history = @()
        }
    }

    $history += $entry
    $history | ConvertTo-Json -Depth 5 | Set-Content -Path $historyPath -Encoding UTF8
    return $entry
}
