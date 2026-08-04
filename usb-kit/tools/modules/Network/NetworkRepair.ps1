function Repair-NetworkStack {
    Write-Host "Repairing network stack..."

    ipconfig /flushdns
    ipconfig /release
    ipconfig /renew

    netsh winsock reset
    netsh int ip reset

    Write-Host "Network repair completed."
}
