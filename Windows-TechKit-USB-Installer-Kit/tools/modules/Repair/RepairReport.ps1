function New-RepairReport {
    param([string]$Action,[string]$Result)

    $entry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $Action | $Result"
    return $entry
}
