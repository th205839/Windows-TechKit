# Windows-TechKit Runtime Environment

function Get-TechKitEnvironment {
    return @{
        ComputerName = $env:COMPUTERNAME
        User = $env:USERNAME
        OS = $env:OS
    }
}
