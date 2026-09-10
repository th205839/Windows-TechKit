$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Backup and drivers modules' {
    BeforeAll {
        Import-Module (Join-Path $repoRoot 'modules/Backup/Backup.psm1') -Force
        Import-Module (Join-Path $repoRoot 'modules/Drivers/Drivers.psm1') -Force
        . (Join-Path $repoRoot 'modules/Drivers/DriverBackup.ps1')
        . (Join-Path $repoRoot 'modules/Drivers/DriverInventory.ps1')
        . (Join-Path $repoRoot 'modules/Drivers/DriverRestore.ps1')
        . (Join-Path $repoRoot 'modules/Backup/SystemBackup.ps1')
        . (Join-Path $repoRoot 'modules/Backup/Restore.ps1')
    }

    It 'creates a backup folder' {
        $source = Join-Path $TestDrive 'source'
        $destination = Join-Path $TestDrive 'backup-root'
        New-Item -ItemType Directory -Path $source -Force | Out-Null
        Set-Content -Path (Join-Path $source 'sample.txt') -Value 'hello'

        $result = New-TechKitBackup -SourcePath $source -DestinationPath $destination
        if ([string]::IsNullOrWhiteSpace($result.BackupName)) {
            throw 'BackupName should not be empty'
        }
    }

    It 'prepares a system backup without executing it' {
        $result = Start-SystemBackup -Destination (Join-Path $TestDrive 'system-backup')
        if ($result.Status -ne 'Prepared') {
            throw 'System backup status was not prepared'
        }
    }

    It 'prepares a backup restore plan' {
        $path = Join-Path $TestDrive 'restore-source'
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        $result = Restore-Backup -BackupPath $path
        if ($result.Status -ne 'Prepared') {
            throw 'Restore status was not prepared'
        }
    }

    It 'returns a driver inventory object' {
        $result = Get-TechKitDriverInventory
        if ($null -eq $result -or $result.DriverCount -lt 0) {
            throw 'Driver inventory did not return a valid object'
        }
    }

    It 'prepares a driver export plan without execution' {
        $result = Backup-Drivers -Destination (Join-Path $TestDrive 'driver-backup')
        if ($result.Status -ne 'Prepared' -and $result.Status -ne 'Unavailable') {
            throw 'Driver backup status was not valid'
        }
    }

    It 'prepares a driver restore plan without execution' {
        $result = Restore-Drivers -Source (Join-Path $TestDrive 'driver-backup')
        if ($result.Status -ne 'Prepared' -and $result.Status -ne 'MissingSource' -and $result.Status -ne 'Unavailable') {
            throw 'Driver restore status was not valid'
        }
    }
}
