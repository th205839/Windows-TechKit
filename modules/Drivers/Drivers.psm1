# Windows-TechKit Drivers Module

function Get-TechKitDriversModule {
    [CmdletBinding()]
    param()

    return 'Drivers module loaded'
}

function Get-TechKitDriverInventory {
    [CmdletBinding()]
    param()

    $drivers = @()
    $elevationRequired = $false
    $status = 'Prepared'

    if (Get-Command Get-WindowsDriver -ErrorAction SilentlyContinue) {
        try {
            $drivers = Get-WindowsDriver -Online | Select-Object -First 10
            $status = 'Ready'
        }
        catch {
            $elevationRequired = $true
            $status = 'ElevationRequired'
            $drivers = @()
        }
    }
    elseif (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
        try {
            $drivers = Get-CimInstance Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion -First 10
            $status = 'Ready'
        }
        catch {
            $elevationRequired = $true
            $status = 'ElevationRequired'
            $drivers = @()
        }
    }

    return [pscustomobject]@{
        Timestamp = (Get-Date).ToString('o')
        DriverCount = @($drivers).Count
        Drivers = @($drivers)
        ElevationRequired = $elevationRequired
        Status = $status
    }
}

Export-ModuleMember -Function Get-TechKitDriversModule
Export-ModuleMember -Function Get-TechKitDriverInventory
