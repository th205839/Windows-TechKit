[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$DriveLetter
)

$target = $DriveLetter.TrimEnd('\\') + '\Windows-TechKit'
New-Item -ItemType Directory -Path $target -Force | Out-Null
Copy-Item (Join-Path $PSScriptRoot '*') -Destination $target -Recurse -Force
Write-Host ('Prepared portable toolkit at {0}' -f $target) -ForegroundColor Green
