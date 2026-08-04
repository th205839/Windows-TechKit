Write-Host "Repairing Windows Update components..."

Stop-Service wuauserv -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue
