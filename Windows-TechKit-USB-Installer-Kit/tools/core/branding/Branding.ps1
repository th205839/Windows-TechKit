function Get-TechKitBranding {
    return [ordered]@{
        Name = 'Windows-TechKit'
        Edition = 'Professional Technician Suite'
        Version = '1.0.0-beta'
        Tagline = 'Bootable maintenance and support toolkit for Windows technicians'
    }
}

function Show-TechKitBanner {
    $branding = Get-TechKitBranding
    Write-Host ''
    Write-Host ('=' * 70) -ForegroundColor Cyan
    Write-Host $branding.Name -ForegroundColor Cyan
    Write-Host $branding.Edition -ForegroundColor DarkCyan
    Write-Host $branding.Tagline -ForegroundColor Gray
    Write-Host ('=' * 70) -ForegroundColor Cyan
    Write-Host ''
}
