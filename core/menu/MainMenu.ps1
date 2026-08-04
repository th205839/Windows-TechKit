function Show-MainMenu {
    [CmdletBinding()]
    param()

    Clear-Host
    Show-TechKitBanner
    Write-Host 'Professional technician menu' -ForegroundColor DarkCyan
    Write-Host ''
    Write-Host '1 - Diagnostics' -ForegroundColor Green
    Write-Host '2 - Maintenance' -ForegroundColor Green
    Write-Host '3 - Export Report' -ForegroundColor Green
    Write-Host '4 - Repair' -ForegroundColor Green
    Write-Host '5 - Network' -ForegroundColor Green
    Write-Host '6 - Inventory' -ForegroundColor Green
    Write-Host '7 - Support' -ForegroundColor Green
    Write-Host '8 - Exit' -ForegroundColor Red
    Write-Host ''
    $selection = Read-Host 'Select an option'

    switch ($selection) {
        '1' {
            Write-TechLog -Message 'Diagnostics workflow selected'
            $diagnostics = Invoke-TechKitDiagnostics
            $null = Export-TechKitReport -Data ([pscustomobject]$diagnostics) -FileName 'diagnostics'
        }
        '2' {
            Write-TechLog -Message 'Maintenance workflow selected'
            $clientName = Read-Host 'Client name'
            $maintenance = Invoke-TechKitMaintenance -ClientName $clientName
            $null = Export-TechKitReport -Data ([pscustomobject]$maintenance) -FileName 'maintenance'
        }
        '3' {
            Write-TechLog -Message 'Export report workflow selected'
            $report = New-TechKitReport -Title 'Manual export'
            $null = Export-TechKitReport -Data ([pscustomobject]$report) -FileName 'manual-export'
        }
        '4' {
            Write-TechLog -Message 'Repair workflow selected'
            & (Join-Path $PSScriptRoot '../launcher/StartupPipeline.ps1')
        }
        '5' {
            Write-TechLog -Message 'Network workflow selected'
        }
        '6' {
            Write-TechLog -Message 'Inventory workflow selected'
        }
        '7' {
            Write-TechLog -Message 'Support workflow selected'
        }
        '8' {
            Write-Host 'Exiting Windows-TechKit.' -ForegroundColor Yellow
            return
        }
        default {
            Write-Host 'Please select a valid option.' -ForegroundColor Yellow
        }
    }
}
