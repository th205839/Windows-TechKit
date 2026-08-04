function Get-InventorySnapshot {
    [CmdletBinding()]
    param()

    $systemInfo = [ordered]@{
        ComputerName = $env:COMPUTERNAME
        UserName = $env:USERNAME
        OS = $env:OS
        Timestamp = (Get-Date).ToString('o')
    }

    if (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
        $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
        $bios = Get-CimInstance -ClassName Win32_BIOS
        $systemInfo.Manufacturer = $computerSystem.Manufacturer
        $systemInfo.Model = $computerSystem.Model
        $systemInfo.BIOSVersion = $bios.SMBIOSBIOSVersion
    }

    return [pscustomobject]$systemInfo
}
