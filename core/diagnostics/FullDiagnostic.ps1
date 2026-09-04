[CmdletBinding()]
param(
    [switch]$Quiet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$reportScript = Join-Path $root 'core\reporting\Report.ps1'
if (Test-Path -LiteralPath $reportScript) { . $reportScript }

$modules = @{
    System  = Join-Path $root 'modules\System\Start.ps1'
    Disk    = Join-Path $root 'modules\Disk\Start.ps1'
    Network = Join-Path $root 'modules\Network\Network.ps1'
    Drivers = Join-Path $root 'modules\Drivers\Start.ps1'
}

function Invoke-TechKitModuleQuiet {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        return [pscustomobject]@{ Error = "Module not found: $Path" }
    }
    try { return (& $Path -Quiet) }
    catch { return [pscustomobject]@{ Error = $_.Exception.Message } }
}

$sections = @{}
foreach ($name in 'System','Disk','Drivers') {
    $sections[$name] = Invoke-TechKitModuleQuiet -Path $modules[$name]
}

try { $sections['Network'] = @(& $modules.Network -Targets @('1.1.1.1','8.8.8.8')) }
catch { $sections['Network'] = [pscustomobject]@{ Error = $_.Exception.Message } }

$report = New-TechKitReport -Title 'Windows-TechKit - Diagnóstico Completo' -Sections $sections

if (-not $Quiet) {
    Write-Host ''
    Write-Host '=== Windows-TechKit | Diagnóstico Completo ===' -ForegroundColor Cyan
    Write-Host ("Computador: {0}" -f $report.ComputerName)
    foreach ($entry in $sections.GetEnumerator()) {
        Write-Host ("[{0}] coletado" -f $entry.Key) -ForegroundColor Green
    }
}

return $report
