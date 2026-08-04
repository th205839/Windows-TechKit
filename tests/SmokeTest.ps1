$repoRoot = Split-Path -Parent $PSScriptRoot

. (Join-Path $repoRoot 'core/launcher/Start-TechKit.ps1') -Mode noninteractive | Out-Null
. (Join-Path $repoRoot 'core/operations/Diagnostics.ps1')
. (Join-Path $repoRoot 'core/operations/Maintenance.ps1')
. (Join-Path $repoRoot 'core/operations/Reporting.ps1')
. (Join-Path $repoRoot 'modules/Inventory/Actions.ps1')
. (Join-Path $repoRoot 'modules/Hardware/Actions.ps1')

$diag = Invoke-TechKitDiagnostics
$maint = Invoke-TechKitMaintenance -ClientName 'Demo'
$inventory = Get-InventorySnapshot
$hardware = Invoke-HardwareDiagnostics
$path = Export-TechKitReport -Data ([pscustomobject]@{ Status = 'ok'; Inventory = $inventory; Hardware = $hardware }) -FileName 'smoke-test'

Write-Host ('diag=' + $diag.ComputerName)
Write-Host ('maint=' + $maint.ClientName)
Write-Host ('inventory=' + $inventory.ComputerName)
Write-Host ('path=' + $path)
