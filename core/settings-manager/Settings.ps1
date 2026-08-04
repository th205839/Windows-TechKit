# Windows-TechKit Settings Manager

$script:TechKitSettings = @{}

function Set-TechKitSetting {
    param($Name,$Value)
    $script:TechKitSettings[$Name] = $Value
}
