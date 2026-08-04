function Initialize-BackupModule {
    [CmdletBinding()]
    param()

    return 'Backup module loaded'
}

function New-TechKitBackup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,
        [Parameter(Mandatory)]
        [string]$DestinationPath
    )

    if (-not (Test-Path $SourcePath)) {
        throw "Source path not found: $SourcePath"
    }

    if (-not (Test-Path $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    }

    $backupName = 'backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
    $targetPath = Join-Path $DestinationPath $backupName
    New-Item -ItemType Directory -Path $targetPath -Force | Out-Null

    Copy-Item -Path $SourcePath -Destination $targetPath -Recurse -Force

    return [pscustomobject]@{
        BackupName = $backupName
        SourcePath = $SourcePath
        DestinationPath = $targetPath
        Timestamp = (Get-Date).ToString('o')
    }
}

Export-ModuleMember -Function Initialize-BackupModule
Export-ModuleMember -Function New-TechKitBackup
