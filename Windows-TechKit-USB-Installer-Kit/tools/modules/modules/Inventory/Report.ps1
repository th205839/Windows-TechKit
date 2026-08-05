function New-InventoryReport {
    [CmdletBinding()]
    param([string]$Summary = 'Inventory snapshot collected')

    return [pscustomobject]@{
        Module = 'Inventory'
        Summary = $Summary
        Generated = (Get-Date).ToString('o')
    }
}
