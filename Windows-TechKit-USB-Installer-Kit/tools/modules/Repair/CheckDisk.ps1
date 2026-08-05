function Invoke-DiskCheck {
    Write-Host "Starting disk check..."
    chkdsk C: /scan
}
