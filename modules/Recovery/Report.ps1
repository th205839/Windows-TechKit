function New-RecoveryReport {
    [CmdletBinding()]
    param([string]$Summary = 'Recovery workflow completed')

    return [pscustomobject]@{
        Module = 'Recovery'
        Summary = $Summary
        Generated = (Get-Date).ToString('o')
    }
}
