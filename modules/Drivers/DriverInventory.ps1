function Get-DriverInventory {
    [CmdletBinding()]
    param()

    $drivers = @()
    if (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
        try {
            $drivers = Get-CimInstance Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion
        }
        catch {
            $drivers = @()
        }
    }

    return [pscustomobject]@{
        Timestamp = (Get-Date).ToString('o')
        DriverCount = @($drivers).Count
        Drivers = @($drivers)
        Status = 'Ready'
    }
}
