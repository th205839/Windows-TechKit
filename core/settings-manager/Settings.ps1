# Windows-TechKit Settings Manager

$script:TechKitSettings = @{}

function Get-TechKitSetting {
    param($Name)
    return $script:TechKitSettings[$Name]
}

function Set-TechKitSetting {
    param($Name,$Value)
    $script:TechKitSettings[$Name] = $Value
}
