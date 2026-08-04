function Save-TechReport {
    param(
        [string]$ReportName,
        [string]$Content
    )

    $path = Join-Path $PSScriptRoot "../../logs/$ReportName.txt"
    $Content | Out-File -FilePath $path -Encoding UTF8
}
