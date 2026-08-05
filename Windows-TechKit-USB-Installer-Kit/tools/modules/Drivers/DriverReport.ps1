function New-DriverReport {
    param([string]$Path = '.\DriverReport.txt')
    Get-CimInstance Win32_PnPSignedDriver | Out-File $Path
}
