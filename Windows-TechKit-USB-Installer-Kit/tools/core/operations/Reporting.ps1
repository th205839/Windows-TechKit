function Export-TechKitReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Data,
        [string]$FileName = 'techkit-report'
    )

    $reportDirectory = Join-Path $PSScriptRoot '../logs/reports'
    if (-not (Test-Path $reportDirectory)) {
        New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null
    }

    $targetPath = Join-Path $reportDirectory ($FileName + '.json')
    $Data | ConvertTo-Json -Depth 8 | Set-Content -Path $targetPath -Encoding UTF8

    Write-Host ('Report exported to {0}' -f $targetPath) -ForegroundColor Cyan
    return $targetPath
}
