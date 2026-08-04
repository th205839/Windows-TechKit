# Hardware Module Report

function New-HardwareReport {
    [CmdletBinding()]
    param([string]$Summary = 'Hardware report generated')

    return [pscustomobject]@{
        Module = 'Hardware'
        Summary = $Summary
        Generated = (Get-Date).ToString('o')
    }
}
