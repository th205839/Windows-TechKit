function Invoke-TechKitReport {
    param(
        [string]$Module,
        [string]$Message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$timestamp][$Module] $Message"

    $reportPath = Join-Path $PSScriptRoot "../../logs/TechKit-Report.txt"
    Add-Content -Path $reportPath -Value $entry
}
