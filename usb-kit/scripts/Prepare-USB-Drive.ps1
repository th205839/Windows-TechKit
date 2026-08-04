[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$DriveLetter
)

$drive = $DriveLetter.TrimEnd('\\')
$target = Join-Path $drive 'Windows-TechKit-USB'

New-Item -ItemType Directory -Path $target -Force | Out-Null
Copy-Item (Join-Path $PSScriptRoot '..\*') -Destination $target -Recurse -Force

Write-Host "USB layout prepared at $target" -ForegroundColor Green
