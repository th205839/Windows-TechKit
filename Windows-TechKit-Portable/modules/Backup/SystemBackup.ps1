function Start-SystemBackup {
    param([string]$Destination = '.\Backup')

    if (!(Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination | Out-Null
    }

    Write-Output "System backup preparation: $Destination"
}
