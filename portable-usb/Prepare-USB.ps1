[CmdletBinding()]
param(
    [Parameter()]
    [string]$DriveLetter = 'E:'
)

$drive = $DriveLetter.TrimEnd('\\')
if (-not (Test-Path $drive)) {
    throw "Drive $drive not found."
}

$layout = Join-Path $drive 'Windows-TechKit'
New-Item -ItemType Directory -Path $layout -Force | Out-Null

$items = @(
    'Start-TechKit.ps1',
    'config',
    'core',
    'modules',
    'docs',
    'logs',
    'portable-usb'
)

foreach ($item in $items) {
    $source = Join-Path (Split-Path -Parent $PSScriptRoot) $item
    if (Test-Path $source) {
        Copy-Item $source -Destination (Join-Path $layout (Split-Path -Leaf $source)) -Recurse -Force
    }
}

Write-Host "Prepared USB layout at $layout" -ForegroundColor Green
Write-Host "Place Windows 10/11 ISO files in $layout\\portable-usb\\isos if needed." -ForegroundColor Yellow
