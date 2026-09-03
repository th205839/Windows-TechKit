[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-TechKitDiskSnapshot {
    [CmdletBinding()]
    param()

    $logical = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        [pscustomobject]@{
            Drive = $_.DeviceID
            VolumeName = $_.VolumeName
            FileSystem = $_.FileSystem
            SizeGB = if ($_.Size) { [math]::Round($_.Size / 1GB, 2) } else { $null }
            FreeGB = if ($_.FreeSpace) { [math]::Round($_.FreeSpace / 1GB, 2) } else { $null }
            FreePercent = if ($_.Size) { [math]::Round(($_.FreeSpace / $_.Size) * 100, 1) } else { $null }
        }
    })

    $physical = @()
    if (Get-Command Get-PhysicalDisk -ErrorAction SilentlyContinue) {
        $physical = @(Get-PhysicalDisk | Select-Object FriendlyName, MediaType, BusType, HealthStatus, OperationalStatus, Size)
    }

    [pscustomobject]@{
        Timestamp = (Get-Date).ToString('o')
        LogicalDisks = $logical
        PhysicalDisks = $physical
    }
}

Write-Host "`n=== Windows-TechKit | Discos ===" -ForegroundColor Cyan
$snapshot = Get-TechKitDiskSnapshot
$snapshot.LogicalDisks | Format-Table Drive, VolumeName, FileSystem, SizeGB, FreeGB, FreePercent -AutoSize
if ($snapshot.PhysicalDisks.Count -gt 0) {
    Write-Host 'Saúde dos discos físicos:' -ForegroundColor DarkCyan
    $snapshot.PhysicalDisks | Select-Object FriendlyName, MediaType, BusType, HealthStatus, OperationalStatus, @{Name='SizeGB';Expression={ if ($_.Size) { [math]::Round($_.Size / 1GB, 2) } else { $null } }} | Format-Table -AutoSize
}
