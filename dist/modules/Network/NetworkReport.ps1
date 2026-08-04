function New-NetworkReport {
    $path = "NetworkReport.txt"

    "Windows-TechKit Network Report" | Out-File $path
    Get-Date | Out-File $path -Append
    ipconfig | Out-File $path -Append

    Write-Host "Report generated: $path"
}
