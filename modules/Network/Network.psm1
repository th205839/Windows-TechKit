function Test-NetworkStatus {
    Write-Host "Checking network connectivity..."

    $result = Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet

    if ($result) {
        Write-Host "Network available."
    }
    else {
        Write-Host "Network unavailable."
    }
}

Export-ModuleMember -Function Test-NetworkStatus
