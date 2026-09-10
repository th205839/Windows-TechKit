function Invoke-DISMRepair {
    [CmdletBinding()]
    param(
        [switch]$Apply,
        [string]$Mode = '/Online /Cleanup-Image /RestoreHealth'
    )

    $toolAvailable = [bool](Get-Command DISM -ErrorAction SilentlyContinue)
    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Tool = 'DISM'
        Status = if ($Apply) { 'Executed' } else { 'Prepared' }
        Command = 'DISM {0}' -f $Mode
        ToolAvailable = $toolAvailable
        AdminRequired = $true
    }

    if (-not $toolAvailable) {
        $result.Status = 'Unavailable'
        Write-Warning 'DISM is not available on this system.'
        return [pscustomobject]$result
    }

    if ($Apply) {
        try {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object Security.Principal.WindowsPrincipal($identity)
            if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                throw 'Administrator privileges are required to run DISM.'
            }

            & DISM $Mode.Split(' ')
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
