$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'ModuleExecutor apply flow' {
    BeforeAll {
        # Enable testing mode so ModuleExecutor does not import real module implementations
        $env:TECHKIT_TESTING = '1'
        . (Join-Path $repoRoot 'core/module-manager/ModuleManager.ps1')
        . (Join-Path $repoRoot 'core/module-manager/ModuleExecutor.ps1')
        . (Join-Path $repoRoot 'core/logger/Logger.ps1')

        # Provide a fake Invoke-FullWindowsRepair that supports prepare and apply
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
    }

    It 'throws when Apply is requested without token or force' {
        Remove-Item Env:TECHKIT_APPLY_TOKEN -ErrorAction SilentlyContinue
        $threw = $false
        try { Invoke-TechKitModule -Name 'Repair' -Apply } catch { $threw = $true }
        if (-not $threw) { throw 'Expected invocation to throw when Apply without token or force' }
    }

    It 'executes when ApplyToken matches environment token' {
        $env:TECHKIT_APPLY_TOKEN = 'test-token'
        $res = Invoke-TechKitModule -Name 'Repair' -Apply -ApplyToken 'test-token'
        if ($res.Status -ne 'Executed') { throw 'Expected Status Executed' }
        if (-not $res.Execution) { throw 'Expected Execution data' }
    }

    It 'executes when called with -Force' {
        Remove-Item Env:TECHKIT_APPLY_TOKEN -ErrorAction SilentlyContinue
        $res = Invoke-TechKitModule -Name 'Repair' -Apply -Force
        if ($res.Status -ne 'Executed') { throw 'Expected Status Executed with -Force' }
        if (-not $res.Execution) { throw 'Expected Execution data with -Force' }
    }
}
