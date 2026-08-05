[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$DriveLetter
)

$drive = $DriveLetter.TrimEnd('\\')
$root = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path $drive)) {
    throw "Drive not found: $drive"
}

$target = Join-Path $drive 'Windows-TechKit'
New-Item -ItemType Directory -Path $target -Force | Out-Null
Copy-Item (Join-Path $root '*') -Destination $target -Recurse -Force

Write-Host "Prepared bootable-style USB layout at $target" -ForegroundColor Green
Write-Host 'Place your Windows 10/11 ISO files in the isos folder if needed.' -ForegroundColor Yellow
