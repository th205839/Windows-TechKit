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
            Write-Host 'Preparing repair plan...' -ForegroundColor Cyan
            if (Get-Command Invoke-TechKitModule -ErrorAction SilentlyContinue) {
                $res = Invoke-TechKitModule -Name 'Repair'
                $null = Export-TechKitReport -Data ([pscustomobject]$res) -FileName 'repair-plan'
            }
            else {
                Write-Warning 'Module executor not available.'
            }
        }
        '5' {
            Write-TechLog -Message 'Network workflow selected'
            if (Get-Command Invoke-TechKitModule -ErrorAction SilentlyContinue) {
                $res = Invoke-TechKitModule -Name 'Network'
                $null = Export-TechKitReport -Data ([pscustomobject]$res) -FileName 'network-status'
            }
        }
        '6' {
            Write-TechLog -Message 'Inventory workflow selected'
            if (Get-Command Invoke-TechKitModule -ErrorAction SilentlyContinue) {
                $res = Invoke-TechKitModule -Name 'Inventory'
                $null = Export-TechKitReport -Data ([pscustomobject]$res) -FileName 'inventory-snapshot'
            }
        }
        '7' {
            Write-TechLog -Message 'Support workflow selected'
            if (Get-Command Invoke-TechKitModule -ErrorAction SilentlyContinue) {
                $res = Invoke-TechKitModule -Name 'Support'
                $null = Export-TechKitReport -Data ([pscustomobject]$res) -FileName 'support-init'
            }
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
