$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Backup and drivers modules' {
    BeforeAll {
        Import-Module (Join-Path $repoRoot 'modules/Backup/Backup.psm1') -Force
        Import-Module (Join-Path $repoRoot 'modules/Drivers/Drivers.psm1') -Force
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

    It 'returns a driver inventory object' {
        $result = Get-TechKitDriverInventory
        if ($null -eq $result -or $result.DriverCount -lt 0) {
            throw 'Driver inventory did not return a valid object'
        }
    }
}
