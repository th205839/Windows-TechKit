# Windows-TechKit Technician Dashboard

function Show-TechKitDashboard {
    [CmdletBinding()]
    param()

    Show-TechKitBanner
    Write-Host 'Dashboard' -ForegroundColor Cyan
    Write-Host '1 - Diagnostics' -ForegroundColor Green
    Write-Host '2 - Maintenance' -ForegroundColor Green
    Write-Host '3 - Reports' -ForegroundColor Green
    Write-Host '4 - Client history' -ForegroundColor Green
    Write-Host '5 - Inventory' -ForegroundColor Green
}
