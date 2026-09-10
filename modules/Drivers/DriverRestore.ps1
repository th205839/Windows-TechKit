function Restore-Drivers {
    [CmdletBinding()]
    param(
        [string]$Source = '.\DriverBackup',
        [switch]$Apply
    )

    $toolAvailable = [bool](Get-Command pnputil -ErrorAction SilentlyContinue)
    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        Source = $Source
        ToolAvailable = $toolAvailable
        AdminRequired = $true
    }

    if (-not $toolAvailable) {
        $result.Status = 'Unavailable'
        $result.Reason = 'pnputil is not available on this system.'
        return [pscustomobject]$result
    }

    if (-not (Test-Path $Source)) {
        $result.Status = 'MissingSource'
        $result.Reason = 'Driver backup source directory was not found.'
        return [pscustomobject]$result
    }

    if ($Apply) {
        try {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object Security.Principal.WindowsPrincipal($identity)
            if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                throw 'Administrator privileges are required to restore drivers.'
            }

            & pnputil /add-driver (Join-Path $Source '*.inf') /subdirs /install
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
