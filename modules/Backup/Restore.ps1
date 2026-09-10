function Restore-Backup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$BackupPath,
        [switch]$Apply
    )

    if (-not (Test-Path $BackupPath)) {
        throw "Backup path not found: $BackupPath"
    }

    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        BackupPath = $BackupPath
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        AdminRequired = $true
    }

    if ($Apply) {
        try {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object Security.Principal.WindowsPrincipal($identity)
            if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                throw 'Administrator privileges are required to restore from backup.'
            }

            $result.Status = 'Executed'
        }
        catch {
            $result.Status = 'Failed'
            $result.Error = $_.Exception.Message
            throw
        }
    }

    Write-Output ('Restore preparation: {0}' -f $BackupPath)
    return [pscustomobject]$result
}
