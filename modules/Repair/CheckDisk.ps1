function Invoke-DiskCheck {
    [CmdletBinding()]
    param(
        [string]$DriveLetter = 'C:',
        [switch]$Apply
    )

    $toolAvailable = [bool](Get-Command chkdsk -ErrorAction SilentlyContinue)
    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Tool = 'chkdsk'
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        DriveLetter = $DriveLetter
        Command = 'chkdsk {0} /scan' -f $DriveLetter
        ToolAvailable = $toolAvailable
        AdminRequired = $true
    }

    if (-not $toolAvailable) {
        $result.Status = 'Unavailable'
        Write-Warning 'chkdsk is not available on this system.'
        return [pscustomobject]$result
    }

    if ($Apply) {
        try {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object Security.Principal.WindowsPrincipal($identity)
            if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                throw 'Administrator privileges are required to run chkdsk.'
            }

            & chkdsk $DriveLetter /scan
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
