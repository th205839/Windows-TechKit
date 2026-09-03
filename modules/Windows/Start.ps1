[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-TechKitWindowsMaintenance {
    [CmdletBinding()]
    param(
        [switch]$RunSfc,
        [switch]$RunDism
    )

    $results = [ordered]@{}

    if ($RunSfc) {
        Write-Host 'Executando SFC /scannow...' -ForegroundColor Yellow
        $sfc = Start-Process -FilePath 'sfc.exe' -ArgumentList '/scannow' -Wait -PassThru -NoNewWindow
        $results.SfcExitCode = $sfc.ExitCode
    }

    if ($RunDism) {
        Write-Host 'Executando DISM /Online /Cleanup-Image /RestoreHealth...' -ForegroundColor Yellow
        $dism = Start-Process -FilePath 'DISM.exe' -ArgumentList '/Online','/Cleanup-Image','/RestoreHealth' -Wait -PassThru -NoNewWindow
        $results.DismExitCode = $dism.ExitCode
    }

    [pscustomobject]$results
}

Write-Host "`n=== Windows-TechKit | Manutenção do Windows ===" -ForegroundColor Cyan
Write-Host 'Use Invoke-TechKitWindowsMaintenance -RunSfc e/ou -RunDism para executar reparos.'
