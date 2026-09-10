# Module executor: provides a standardized safe API to prepare or apply module workflows

function Invoke-TechKitModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [switch]$Apply
    )

    $root = Get-TechKitRepositoryRoot
    if (-not $root) {
        throw 'Repository root could not be resolved.'
    }

    $modulePath = Join-Path $root 'modules' | Join-Path -ChildPath $Name
    if (-not (Test-Path $modulePath)) {
        throw "Module path not found: $modulePath"
    }

    # Prefer an explicit Start.ps1 that returns a safe object.
    $startScript = Join-Path $modulePath 'Start.ps1'
    if (Test-Path $startScript) {
        try {
            # dot-source Start.ps1 so it can return objects or write-host; capture return
            . $startScript
            # If module script wrote to output, try to return last object available in the session
            if (Get-Variable -Name 'result' -Scope 1 -ErrorAction SilentlyContinue) {
                return Get-Variable -Name 'result' -Scope 1 -ValueOnly
            }
            # Start.ps1 did not produce a result object; fall through to known fallback contracts below.
        }
        catch {
            throw "Module '$Name' failed to initialize: $($_.Exception.Message)"
        }
    }

    # Fallback: call known function contracts without applying destructive actions
    # Import any module files (.psm1) inside the module folder so Export-ModuleMember runs in module context.
    Get-ChildItem -Path $modulePath -Filter *.psm1 -File -ErrorAction SilentlyContinue | ForEach-Object {
        try { Import-Module -Name $_.FullName -Force -Scope Global -ErrorAction SilentlyContinue } catch {}
    }

    $result = [ordered]@{
        Module = $Name
        Timestamp = (Get-Date).ToString('o')
        Status = 'Prepared'
    }

    try {
        switch ($Name.ToLower()) {
            'repair' {
                if (Get-Command Invoke-FullWindowsRepair -ErrorAction SilentlyContinue) {
                    $plan = Invoke-FullWindowsRepair -DriveLetter 'C:'
                    $result.Plan = $plan
                }
            }
            'network' {
                if (Get-Command Test-NetworkStatus -ErrorAction SilentlyContinue) {
                    $status = Test-NetworkStatus
                    $result.StatusDetail = $status
                }
            }
            'backup' {
                if (Get-Command Start-SystemBackup -ErrorAction SilentlyContinue) {
                    $sb = Start-SystemBackup -Destination '.\Backup' 
                    $result.StatusDetail = $sb
                }
            }
            'drivers' {
                if (Get-Command Get-TechKitDriverInventory -ErrorAction SilentlyContinue) {
                    $drv = Get-TechKitDriverInventory
                    $result.StatusDetail = $drv
                }
            }
            'security' {
                if (Get-Command Invoke-SecurityActions -ErrorAction SilentlyContinue) {
                    $sec = Invoke-SecurityActions
                    $result.StatusDetail = $sec
                }
            }
            'updates' {
                if (Get-Command Invoke-UpdateWorkflow -ErrorAction SilentlyContinue) {
                    $up = Invoke-UpdateWorkflow
                    $result.StatusDetail = $up
                }
            }
            'tweaks' {
                if (Get-Command Invoke-TechKitTweaks -ErrorAction SilentlyContinue) {
                    $t = Invoke-TechKitTweaks
                    $result.StatusDetail = $t
                }
            }
            'inventory' {
                if (Get-Command Get-InventorySnapshot -ErrorAction SilentlyContinue) {
                    $inv = Get-InventorySnapshot
                    $result.StatusDetail = $inv
                }
            }
            'support' {
                if (Get-Command New-SupportTicket -ErrorAction SilentlyContinue) {
                    $ticket = New-SupportTicket -ClientName 'System' -Issue 'Module prepare'
                    $result.StatusDetail = $ticket
                }
            }
            Default {
                $result.Note = 'No known fallback contract for this module.'
            }
        }
    }
    catch {
        $result.Status = 'Failed'
        $result.Error = $_.Exception.Message
    }

    return [pscustomobject]$result
}

