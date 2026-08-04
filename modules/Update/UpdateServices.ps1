# Windows-TechKit - Update Services Module

function Restart-WindowsUpdateServices {
    Write-Host "Restarting Windows Update services..."

    $services = @('wuauserv','bits','cryptsvc')

    foreach ($service in $services) {
        Restart-Service -Name $service -Force -ErrorAction SilentlyContinue
    }
}

Export-ModuleMember -Function Restart-WindowsUpdateServices
