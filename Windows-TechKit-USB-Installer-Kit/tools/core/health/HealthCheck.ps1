# Windows-TechKit Health Check Engine
# Base system validation module

function Invoke-TechKitHealthCheck {
    [CmdletBinding()]
    param()

    $status = [ordered]@{
        Status = 'Ready'
        Timestamp = (Get-Date).ToString('o')
        Admin = $false
        Environment = Get-TechKitEnvironment
    }

    if (Get-Command Test-AdminRights -ErrorAction SilentlyContinue) {
        $status.Admin = Test-AdminRights
    }

    return [pscustomobject]$status
}
