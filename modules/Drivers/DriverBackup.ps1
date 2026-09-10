function Backup-Drivers {
    [CmdletBinding()]
    param(
        [string]$Destination = '.\DriverBackup',
        [switch]$Apply
    )

    $toolAvailable = [bool](Get-Command Export-WindowsDriver -ErrorAction SilentlyContinue)
    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        Destination = $Destination
        ToolAvailable = $toolAvailable
        AdminRequired = $true
    }

    if (-not $toolAvailable) {
        $result.Status = 'Unavailable'
        $result.Reason = 'Export-WindowsDriver is not available on this system.'
        return [pscustomobject]$result
    }

    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    if ($Apply) {
        try {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object Security.Principal.WindowsPrincipal($identity)
            if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                throw 'Administrator privileges are required to export drivers.'
            }

            Export-WindowsDriver -Online -Destination $Destination
            $result.Status = 'Executed'
        }
        catch {
            $result.Status = 'Failed'
            $result.Error = $_.Exception.Message
            throw
        }
    }

    return [pscustomobject]$result
}
