function New-SupportReport {
    [CmdletBinding()]
    param([string]$Summary = 'Support workflow completed')

    return [pscustomobject]@{
        Module = 'Support'
        Summary = $Summary
        Generated = (Get-Date).ToString('o')
    }
}
