Import-Module (Join-Path $PSScriptRoot '../modules/Repair/Repair.psm1') -Force
Import-Module (Join-Path $PSScriptRoot '../modules/Network/Network.psm1') -Force

$repairResult = Invoke-WindowsRepair
$networkResult = Test-NetworkStatus

Write-Host ('repair=' + $repairResult.Status)
Write-Host ('network=' + $networkResult.Status)
