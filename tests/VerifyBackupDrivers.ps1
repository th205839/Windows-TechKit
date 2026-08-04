Import-Module (Join-Path $PSScriptRoot '../modules/Backup/Backup.psm1') -Force
Import-Module (Join-Path $PSScriptRoot '../modules/Drivers/Drivers.psm1') -Force

$tempRoot = Join-Path $env:TEMP 'techkit-backup-test'
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
$source = Join-Path $tempRoot 'source'
$destination = Join-Path $tempRoot 'dest'
New-Item -ItemType Directory -Path $source -Force | Out-Null
Set-Content -Path (Join-Path $source 'sample.txt') -Value 'hello'

$backup = New-TechKitBackup -SourcePath $source -DestinationPath $destination
$inventory = Get-TechKitDriverInventory

Write-Host ('backup=' + $backup.BackupName)
Write-Host ('drivers=' + $inventory.DriverCount)
