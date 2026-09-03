[CmdletBinding()]
param(
    [switch]$Quiet,
    [string]$Destination,
    [string]$UserProfile = $env:USERPROFILE
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Backup-TechKitUserProfile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Source,
        [Parameter(Mandatory)]
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Container)) {
        throw "Perfil de usuário não encontrado: $Source"
    }

    if (-not (Get-Command robocopy.exe -ErrorAction SilentlyContinue)) {
        throw 'Robocopy não está disponível neste Windows.'
    }

    if (-not (Test-Path -LiteralPath $Destination)) {
        $null = New-Item -ItemType Directory -Path $Destination -Force
    }

    $folders = @('Desktop', 'Documents', 'Downloads', 'Pictures', 'Videos', 'Music')
    $results = @()

    foreach ($folder in $folders) {
        $sourcePath = Join-Path $Source $folder
        $targetPath = Join-Path $Destination $folder
        if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) {
            continue
        }

        if ($PSCmdlet.ShouldProcess($sourcePath, "Copiar para $targetPath")) {
            & robocopy.exe $sourcePath $targetPath /E /COPY:DAT /DCOPY:DAT /R:1 /W:2 /XJ /NFL /NDL
            $exitCode = $LASTEXITCODE
            $results += [pscustomobject]@{
                Folder = $folder
                Source = $sourcePath
                Destination = $targetPath
                ExitCode = $exitCode
                Status = if ($exitCode -lt 8) { 'Success' } else { 'Failed' }
            }
        }
    }

    return $results
}

if ([string]::IsNullOrWhiteSpace($Destination)) {
    if (-not $Quiet) {
        Write-Host "`n=== Windows-TechKit | Backup do Perfil ===" -ForegroundColor Cyan
        Write-Host 'Informe -Destination para iniciar o backup.' -ForegroundColor Yellow
        Write-Host 'Exemplo: -Destination D:\TechKitBackup\Cliente'
    }
    return
}

$results = Backup-TechKitUserProfile -Source $UserProfile -Destination $Destination -Confirm

if (-not $Quiet) {
    $results | Format-Table Folder, Status, ExitCode, Destination -AutoSize
}

return [pscustomobject]@{
    Timestamp = (Get-Date).ToString('o')
    Source = $UserProfile
    Destination = $Destination
    Results = @($results)
}
