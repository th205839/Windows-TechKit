[CmdletBinding()]
param(
    [switch]$Quiet,
    [switch]$Backup,
    [string]$BackupPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-TechKitDriverSnapshot {
    [CmdletBinding()]
    param()

    $devices = @()
    if (Get-Command Get-PnpDevice -ErrorAction SilentlyContinue) {
        $devices = @(Get-PnpDevice | ForEach-Object {
            $driver = $null
            if (Get-Command Get-PnpDeviceProperty -ErrorAction SilentlyContinue) {
                $driver = Get-PnpDeviceProperty -InstanceId $_.InstanceId -KeyName 'DEVPKEY_Device_DriverVersion' -ErrorAction SilentlyContinue
            }

            [pscustomobject]@{
                Class = $_.Class
                FriendlyName = $_.FriendlyName
                Status = $_.Status
                ProblemCode = $_.ProblemCode
                InstanceId = $_.InstanceId
                DriverVersion = if ($driver) { $driver.Data } else { $null }
            }
        })
    }

    [pscustomobject]@{
        Timestamp = (Get-Date).ToString('o')
        ComputerName = $env:COMPUTERNAME
        DeviceCount = $devices.Count
        ProblemDeviceCount = @($devices | Where-Object { $_.Status -ne 'OK' }).Count
        Devices = $devices
    }
}

function Backup-TechKitDrivers {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination
    )

    if (-not (Get-Command Export-WindowsDriver -ErrorAction SilentlyContinue)) {
        throw 'Export-WindowsDriver não está disponível neste ambiente.'
    }

    if (-not (Test-Path -LiteralPath $Destination)) {
        $null = New-Item -ItemType Directory -Path $Destination -Force
    }

    if ($PSCmdlet.ShouldProcess($Destination, 'Exportar drivers instalados do Windows')) {
        Export-WindowsDriver -Online -Destination $Destination
    }
}

$snapshot = Get-TechKitDriverSnapshot

if (-not $Quiet) {
    Write-Host "`n=== Windows-TechKit | Drivers ===" -ForegroundColor Cyan
    Write-Host ("Dispositivos encontrados: {0}" -f $snapshot.DeviceCount)
    Write-Host ("Dispositivos com possível problema: {0}" -f $snapshot.ProblemDeviceCount)
    $snapshot.Devices |
        Where-Object { $_.Status -ne 'OK' } |
        Select-Object Class, FriendlyName, Status, ProblemCode, DriverVersion |
        Format-Table -AutoSize

    if ($snapshot.ProblemDeviceCount -eq 0) {
        Write-Host 'Nenhum dispositivo com status diferente de OK foi identificado.' -ForegroundColor Green
    }
}

if ($Backup) {
    if ([string]::IsNullOrWhiteSpace($BackupPath)) {
        throw 'Informe -BackupPath para executar o backup dos drivers.'
    }
    Backup-TechKitDrivers -Destination $BackupPath -Confirm
}

return $snapshot
