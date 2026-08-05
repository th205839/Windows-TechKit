function Invoke-FullWindowsRepair {
    Write-Host "Starting Windows repair sequence..."

    sfc /scannow
    DISM /Online /Cleanup-Image /RestoreHealth
    chkdsk C: /scan

    Write-Host "Repair sequence completed."
}
