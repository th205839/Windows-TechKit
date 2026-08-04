function Write-TechLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "[$timestamp] $Message"
    Write-Host $line

    $logDirectory = Join-Path $PSScriptRoot '../logs'
    if (-not (Test-Path $logDirectory)) {
        New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
    }

    $logFile = Join-Path $logDirectory 'techkit.log'
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}
