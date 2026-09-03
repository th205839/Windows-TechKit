[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-TechKitSystemSnapshot {
    $os = Get-CimInstance Win32_OperatingSystem
    $cs = Get-CimInstance Win32_ComputerSystem
    $bios = Get-CimInstance Win32_BIOS

    [pscustomobject]@{
        ComputerName = $env:COMPUTERNAME
        Manufacturer = $cs.Manufacturer
        Model = $cs.Model
        Windows = $os.Caption
        Version = $os.Version
        Build = $os.BuildNumber
        Architecture = $os.OSArchitecture
        TotalMemoryGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
        BiosVersion = ($bios.SMBIOSBIOSVersion -join ', ')
        LastBoot = $os.LastBootUpTime
    }
}

Write-Host "`n=== Windows-TechKit | Sistema ===" -ForegroundColor Cyan
Get-TechKitSystemSnapshot | Format-List
