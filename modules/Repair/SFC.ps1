function Invoke-SFCScan {
    [CmdletBinding()]
    param(
        [switch]$Apply,
        [string]$ScanType = '/scannow'
    )

    $toolAvailable = [bool](Get-Command sfc -ErrorAction SilentlyContinue)
    $adminRequired = $true
    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Tool = 'sfc'
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        Command = 'sfc {0}' -f $ScanType
        ToolAvailable = $toolAvailable
        AdminRequired = $adminRequired
    }

    if (-not $toolAvailable) {
        $result.Status = 'Unavailable'
        Write-Warning 'sfc is not available on this system.'
        return [pscustomobject]$result
    }

    if ($Apply) {
        try {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object Security.Principal.WindowsPrincipal($identity)
            if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                throw 'Administrator privileges are required to run sfc.'
            }

            & sfc $ScanType
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
