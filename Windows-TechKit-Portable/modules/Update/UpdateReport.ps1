# Windows-TechKit - Update Report

function Get-WindowsUpdateReport {
    $report = [PSCustomObject]@{
        ComputerName = $env:COMPUTERNAME
        Date = Get-Date
        UpdateService = (Get-Service wuauserv -ErrorAction SilentlyContinue).Status
    }

    return $report
}

Export-ModuleMember -Function Get-WindowsUpdateReport
