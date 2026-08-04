# Windows-TechKit - Update Cache Cleanup

function Clear-WindowsUpdateCache {
    Write-Host "Cleaning Windows Update cache..."

    Stop-Service wuauserv -ErrorAction SilentlyContinue
    Stop-Service bits -ErrorAction SilentlyContinue

    $path = "$env:SystemRoot\SoftwareDistribution\Download"

    if (Test-Path $path) {
        Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    Start-Service wuauserv -ErrorAction SilentlyContinue
    Start-Service bits -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function Clear-WindowsUpdateCache
