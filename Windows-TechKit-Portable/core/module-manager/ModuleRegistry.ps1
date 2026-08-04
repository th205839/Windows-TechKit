# Windows-TechKit Module Registry

$TechKitModules = @(
    "Repair",
    "Network",
    "Update",
    "Drivers",
    "Backup",
    "Tweaks"
)

function Get-TechKitModules {
    return $TechKitModules
}

Export-ModuleMember -Function Get-TechKitModules
