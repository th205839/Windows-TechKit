# Windows-TechKit Tweaks Module

function Invoke-TechKitTweaks {
    [CmdletBinding()]
    param()

    $performance = Optimize-TechKitPerformance
    $privacy = Set-TechKitPrivacy
    $services = Optimize-TechKitServices

    $result = [ordered]@{
        Timestamp = (Get-Date).ToString('o')
        Status = 'Prepared'
        Performance = $performance
        Privacy = $privacy
        Services = $services
    }

    Write-Host 'Windows optimization module loaded.' -ForegroundColor Green
    return [pscustomobject]$result
}

Export-ModuleMember -Function Invoke-TechKitTweaks
