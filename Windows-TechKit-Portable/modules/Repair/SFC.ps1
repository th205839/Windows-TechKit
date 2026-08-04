function Invoke-SFCScan {
    Write-Host "Running System File Checker..."
    sfc /scannow
}
