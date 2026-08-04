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

    if (Get-Command Get-WindowsDriver -ErrorAction SilentlyContinue) {
        try {
            $drivers = Get-WindowsDriver -Online | Select-Object -First 10
        }
        catch {
            $elevationRequired = $true
            $drivers = @()
        }
    }

    return [pscustomobject]@{
        Timestamp = (Get-Date).ToString('o')
        DriverCount = $drivers.Count
        Drivers = $drivers
        ElevationRequired = $elevationRequired
    }
}

Export-ModuleMember -Function Get-TechKitDriversModule
Export-ModuleMember -Function Get-TechKitDriverInventory
