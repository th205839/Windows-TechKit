Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$diagnostic = Join-Path $repoRoot 'core\diagnostics\FullDiagnostic.ps1'
$report = Join-Path $repoRoot 'core\reporting\Report.ps1'

function Assert-TechKit {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw "TEST FAILED: $Message" }
}

Assert-TechKit (Test-Path $diagnostic) 'FullDiagnostic.ps1 exists'
Assert-TechKit (Test-Path $report) 'Report.ps1 exists'

. $report
$data = New-TechKitReport -Title 'Test' -Sections @{ System = @{ Status = 'OK' } }
Assert-TechKit ($data.Title -eq 'Test') 'report title'
Assert-TechKit ($data.Sections.System.Status -eq 'OK') 'report section'

$html = ConvertTo-TechKitHtml -Data $data
Assert-TechKit ($html -match '<!doctype html>') 'HTML document generated'
Assert-TechKit ($html -match 'System') 'section rendered'

Write-Host 'Windows-TechKit tests: PASS' -ForegroundColor Green
