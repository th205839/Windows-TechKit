function New-UpdateReport {
    [CmdletBinding()]
    param([string]$Summary = 'Update workflow completed')

    return [pscustomobject]@{
        Module = 'Updates'
        Summary = $Summary
        Generated = (Get-Date).ToString('o')
    }
}
