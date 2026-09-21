# Debug-ApplyTest.ps1
function Invoke-FullWindowsRepair {
    param(
        [string]$DriveLetter = 'C:',
        [switch]$Apply
    )

    if ($Apply) {
        return @{ Timestamp = (Get-Date).ToString('o'); DriveLetter = $DriveLetter; Status = 'Executed'; Result = 'MockedApply' }
    }

    return @{ Timestamp = (Get-Date).ToString('o'); DriveLetter = $DriveLetter; Status = 'Prepared'; Steps = @('sfc','dism') }
}

$env:TECHKIT_TESTING = '1'
. .\core\module-manager\ModuleManager.ps1
. .\core\logger\Logger.ps1
. .\core\module-manager\ModuleExecutor.ps1
$env:TECHKIT_APPLY_TOKEN = 'test-token'
$res = Invoke-TechKitModule -Name 'Repair' -Apply -ApplyToken 'test-token'
$res | Format-List * -Force
