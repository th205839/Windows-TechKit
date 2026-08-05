[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory)]
    [string]$DriveLetter,

    [Parameter(Mandatory)]
    [string]$IsoPath,

    [string]$ToolkitSource = (Join-Path $PSScriptRoot 'usb-kit')
)

$drive = $DriveLetter.TrimEnd('\\')
if ($drive.Length -ne 2 -or $drive.Substring(1, 1) -ne ':') {
    throw 'DriveLetter must be in the format E:.'
}

$resolvedIso = (Resolve-Path $IsoPath -ErrorAction Stop).Path
$resolvedToolkit = (Resolve-Path $ToolkitSource -ErrorAction Stop).Path
$targetRoot = $drive + '\'

Write-Host ('Preparing USB drive {0} from {1}' -f $drive, $resolvedIso) -ForegroundColor Cyan

if (-not (Test-Path $targetRoot)) {
    throw ('Drive {0} not found.' -f $drive)
}

$bootsectPath = Join-Path $env:WINDIR 'System32\bootsect.exe'

try {
    $image = Mount-DiskImage -ImagePath $resolvedIso -PassThru
    $volume = $image | Get-DiskImage | Get-Volume
    $sourceRoot = ($volume.DriveLetter + ':\')

    if ($PSCmdlet.ShouldProcess($drive, 'Format USB drive')) {
        Format-Volume -DriveLetter $drive[0] -FileSystem NTFS -Confirm:$false -Force | Out-Null
    }

    New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null

    if ($PSCmdlet.ShouldProcess($targetRoot, 'Copy Windows installation files')) {
        & robocopy $sourceRoot $targetRoot /E /COPYALL /R:1 /W:1 /NFL /NDL /NP | Out-Null
        if ($LASTEXITCODE -ge 8) {
            throw 'Failed to copy Windows installation files to the USB drive.'
        }
    }

    if ($PSCmdlet.ShouldProcess($targetRoot, 'Copy toolkit files')) {
        Copy-Item (Join-Path $resolvedToolkit '*') -Destination $targetRoot -Recurse -Force
    }

    New-Item -ItemType Directory -Path (Join-Path $targetRoot 'isos') -Force | Out-Null
    Copy-Item $resolvedIso -Destination (Join-Path $targetRoot 'isos') -Force

    if (Test-Path $bootsectPath) {
        if ($PSCmdlet.ShouldProcess($drive, 'Apply boot sector')) {
            & $bootsectPath /nt60 $drive /force | Out-Null
        }
    }
    else {
        Write-Warning 'bootsect.exe was not found. If the USB does not boot, use Rufus or the Media Creation Tool with the same ISO.'
    }

    Write-Host ('USB prepared successfully at {0}' -f $drive) -ForegroundColor Green
    Write-Host 'Use the USB in UEFI mode and boot from the Windows installer entry.' -ForegroundColor Yellow
}
finally {
    Dismount-DiskImage -ImagePath $resolvedIso -ErrorAction SilentlyContinue | Out-Null
}
