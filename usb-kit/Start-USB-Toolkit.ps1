[CmdletBinding()]
param(
    [ValidateSet('interactive','noninteractive')]
    [string]$Mode = 'interactive'
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$launcher = Join-Path $root 'tools/Start-TechKit.ps1'

if (Test-Path $launcher) {
    & $launcher -Mode $Mode
}
else {
    Write-Host 'Launcher not found. Expected: ' $launcher -ForegroundColor Red
    Write-Host 'Copy the full usb-kit folder to the pendrive and try again.' -ForegroundColor Yellow
}
