function New-SecurityReport {
    [CmdletBinding()]
    param([string]$Summary = 'Security workflow completed')

    return [pscustomobject]@{
        Module = 'Security'
        Summary = $Summary
        Generated = (Get-Date).ToString('o')
    }
}
