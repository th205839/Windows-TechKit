[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-TechKitSystemSnapshot {
    [CmdletBinding()]
    param()

    $os = Get-CimInstance Win32_OperatingSystem
    $cs = Get-CimInstance Win32_ComputerSystem
    $bios = Get-CimInstance Win32_BIOS
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $gpu = Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, AdapterRAM
    $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
        Select-Object DeviceID, VolumeName, FileSystem,
            @{Name='SizeGB';Expression={ if ($_.Size) { [math]::Round($_.Size / 1GB, 2) } else { $null } }},
            @{Name='FreeGB';Expression={ if ($_.FreeSpace) { [math]::Round($_.FreeSpace / 1GB, 2) } else { $null } }}

    $memoryModules = Get-CimInstance Win32_PhysicalMemory |
        Select-Object Manufacturer, PartNumber,
            @{Name='CapacityGB';Expression={ [math]::Round($_.Capacity / 1GB, 2) }},
            Speed, ConfiguredClockSpeed

    [pscustomobject]@{
        Timestamp = (Get-Date).ToString('o')
        ComputerName = $env:COMPUTERNAME
        Manufacturer = $cs.Manufacturer
        Model = $cs.Model
        Windows = $os.Caption
        Version = $os.Version
        Build = $os.BuildNumber
        Architecture = $os.OSArchitecture
        InstallDate = $os.InstallDate
        LastBoot = $os.LastBootUpTime
        TotalMemoryGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
        MemoryModules = @($memoryModules)
        CpuName = $cpu.Name
        CpuCores = $cpu.NumberOfCores
        CpuLogicalProcessors = $cpu.NumberOfLogicalProcessors
        CpuMaxClockMHz = $cpu.MaxClockSpeed
        BiosManufacturer = $bios.Manufacturer
        BiosVersion = ($bios.SMBIOSBIOSVersion -join ', ')
        BiosReleaseDate = $bios.ReleaseDate
        Gpu = @($gpu | ForEach-Object {
            [pscustomobject]@{
                Name = $_.Name
                DriverVersion = $_.DriverVersion
                AdapterMemoryGB = if ($_.AdapterRAM) { [math]::Round($_.AdapterRAM / 1GB, 2) } else { $null }
            }
        })
        LogicalDisks = @($disks)
    }
}

Write-Host "`n=== Windows-TechKit | Inventário do Sistema ===" -ForegroundColor Cyan
$snapshot = Get-TechKitSystemSnapshot
$snapshot | Select-Object ComputerName, Manufacturer, Model, Windows, Version, Build, Architecture, TotalMemoryGB, CpuName, CpuCores, CpuLogicalProcessors, BiosVersion, LastBoot | Format-List
Write-Host 'Discos:' -ForegroundColor DarkCyan
$snapshot.LogicalDisks | Format-Table DeviceID, VolumeName, FileSystem, SizeGB, FreeGB -AutoSize
Write-Host 'Memória:' -ForegroundColor DarkCyan
$snapshot.MemoryModules | Format-Table Manufacturer, PartNumber, CapacityGB, Speed, ConfiguredClockSpeed -AutoSize
Write-Host 'GPU:' -ForegroundColor DarkCyan
$snapshot.Gpu | Format-Table Name, DriverVersion, AdapterMemoryGB -AutoSize
