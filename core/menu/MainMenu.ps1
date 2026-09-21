function Confirm-And-Apply {
    param(
        [Parameter(Mandatory)][string]$ModuleName
    )

    Write-Host "WARNING: You are about to APPLY changes for module '$ModuleName'. This may perform destructive operations." -ForegroundColor Red
    Write-Host "If you understand the risk, type YES to proceed, or type FORCE to proceed without token. Press Enter to cancel." -ForegroundColor Yellow
    $choice = Read-Host 'Confirm (YES/FORCE/Cancel)'

    if ($choice -eq 'YES') {
        if ($env:TECHKIT_APPLY_TOKEN) {
            Write-TechLog -Message ("User confirmed apply for {0} with token" -f $ModuleName)
            $res = Invoke-TechKitModule -Name $ModuleName -Apply -ApplyToken $env:TECHKIT_APPLY_TOKEN
            $null = Export-TechKitReport -Data ([pscustomobject]$res) -FileName ("apply-{0}-{1}" -f $ModuleName, (Get-Date -Format 'yyyyMMddHHmmss'))
            Write-Host ("Apply result: {0}" -f $res.Status)
            return $res
        }
        else {
            Write-Host 'No TECHKIT_APPLY_TOKEN set in environment. Use FORCE to override or set a token. Aborting.' -ForegroundColor Yellow
            return $null
        }
    }
    elseif ($choice -eq 'FORCE') {
        Write-TechLog -Message ("User forced apply for {0}" -f $ModuleName)
        $res = Invoke-TechKitModule -Name $ModuleName -Apply -Force
        $null = Export-TechKitReport -Data ([pscustomobject]$res) -FileName ("apply-{0}-{1}" -f $ModuleName, (Get-Date -Format 'yyyyMMddHHmmss'))
        Write-Host ("Apply result: {0}" -f $res.Status)
        return $res
    }
    else {
        Write-Host 'Apply canceled.' -ForegroundColor Yellow
        return $null
    }
}

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
                Write-Host ''
                Write-Host 'Do you want to apply the repair plan now? (interactive)' -ForegroundColor Yellow
                $applyRes = Confirm-And-Apply -ModuleName 'Repair'
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
                Write-Host ''
                Write-Host 'Do you want to run network repairs now? (interactive)' -ForegroundColor Yellow
                $applyRes = Confirm-And-Apply -ModuleName 'Network'
            }
        }
        '6' {
            Write-TechLog -Message 'Inventory workflow selected'
            if (Get-Command Invoke-TechKitModule -ErrorAction SilentlyContinue) {
                $res = Invoke-TechKitModule -Name 'Inventory'
                $null = Export-TechKitReport -Data ([pscustomobject]$res) -FileName 'inventory-snapshot'
                Write-Host ''
                Write-Host 'Apply inventory changes? (interactive) — typically none' -ForegroundColor Yellow
                $applyRes = Confirm-And-Apply -ModuleName 'Inventory'
            }
        }
        '7' {
            Write-TechLog -Message 'Support workflow selected'
            if (Get-Command Invoke-TechKitModule -ErrorAction SilentlyContinue) {
                $res = Invoke-TechKitModule -Name 'Support'
                $null = Export-TechKitReport -Data ([pscustomobject]$res) -FileName 'support-init'
                Write-Host ''
                Write-Host 'Create support ticket and notify? (interactive)' -ForegroundColor Yellow
                $applyRes = Confirm-And-Apply -ModuleName 'Support'
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
