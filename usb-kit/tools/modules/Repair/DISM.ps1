function Invoke-DISMRepair {
    Write-Host "Running DISM health restore..."
    DISM /Online /Cleanup-Image /RestoreHealth
}
