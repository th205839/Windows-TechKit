function Start-SystemBackup {
    [CmdletBinding()]
    param(
        [string]$Destination = '.\Backup',
        [switch]$Apply
    )

    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Destination = $Destination
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        AdminRequired = $true
    }

    if ($Apply) {
        try {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object Security.Principal.WindowsPrincipal($identity)
            if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                throw 'Administrator privileges are required to create a system backup.'
            }

            $result.Status = 'Executed'
        }
        catch {
            $result.Status = 'Failed'
            $result.Error = $_.Exception.Message
            throw
        }
    }

    Write-Output ('System backup preparation: {0}' -f $Destination)
    return [pscustomobject]$result
}
