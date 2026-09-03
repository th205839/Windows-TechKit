param()

Import-Module "$PSScriptRoot/Network.psm1" -Force

$result = Invoke-TechKitNetworkDiagnostics
$result | Format-Table Target, Status, AverageMs -AutoSize
