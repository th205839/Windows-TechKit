# Module executor: provides a standardized safe API to prepare or apply module workflows

function Invoke-TechKitModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [switch]$Apply,
        [switch]$Force,
        [string]$ApplyToken
    )

    $root = Get-TechKitRepositoryRoot
    if (-not $root) {
        throw 'Repository root could not be resolved.'
    }

    $modulePath = Join-Path $root 'modules' | Join-Path -ChildPath $Name
    if (-not (Test-Path $modulePath)) {
        throw "Module path not found: $modulePath"
    }

    # Import any module files (.psm1) inside the module folder so Export-ModuleMember runs in module context.
    Get-ChildItem -Path $modulePath -Filter *.psm1 -File -ErrorAction SilentlyContinue | ForEach-Object {
        try { Import-Module -Name $_.FullName -Force -Scope Global -ErrorAction SilentlyContinue } catch {}
    }

    # Dot-source non-start script files (*.ps1) in the module so they can define functions used by Start.ps1 (Actions, Report, etc.)
    Get-ChildItem -Path $modulePath -Filter *.ps1 -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'Start.ps1' } | ForEach-Object {
        try { . $_.FullName } catch {}
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

    $result = [ordered]@{
        Module = $Name
        Timestamp = (Get-Date).ToString('o')
        Status = 'Prepared'
    }

    # If an apply was requested, validate token or force flag before executing destructive actions.
    if ($Apply) {
        $envToken = $env:TECHKIT_APPLY_TOKEN
        if (-not $Force) {
            if (-not $ApplyToken -and -not $envToken) {
                throw "Apply requested but no ApplyToken provided and TECHKIT_APPLY_TOKEN is not set. Provide a token or use -Force to override."
            }
            if ($ApplyToken -and $envToken -and ($ApplyToken -ne $envToken)) {
                throw "Apply token mismatch."
            }
        }
        Write-TechLog -Message ("Apply requested for module {0}. Force={1}" -f $Name, $Force)
    }

    try {
        switch ($Name.ToLower()) {
            'repair' {
                if (Get-Command Invoke-FullWindowsRepair -ErrorAction SilentlyContinue) {
                    $plan = Invoke-FullWindowsRepair -DriveLetter 'C:'
                    $result.Plan = $plan
                    if ($Apply) {
                        try {
                            Write-TechLog -Message 'Executing full repair (Apply)'
                            $exec = Invoke-FullWindowsRepair -DriveLetter 'C:' -Apply:$Apply -ErrorAction Stop
                            $result.Status = 'Executed'
                            $result.Execution = $exec
                        }
                        catch {
                            $result.Status = 'Failed'
                            $result.ExecutionError = $_.Exception.Message
                        }
                    }
                }
            }
            'network' {
                if (Get-Command Test-NetworkStatus -ErrorAction SilentlyContinue) {
                    $status = Test-NetworkStatus
                    $result.StatusDetail = $status
                    if ($Apply) {
                        # Network module has no destructive default apply; if a function exists, call it.
                        if (Get-Command Invoke-NetworkRepair -ErrorAction SilentlyContinue) {
                            try {
                                Write-TechLog -Message 'Executing network repair (Apply)'
                                $exec = Invoke-NetworkRepair -ErrorAction Stop
                                $result.Status = 'Executed'
                                $result.Execution = $exec
                            }
                            catch {
                                $result.Status = 'Failed'
                                $result.ExecutionError = $_.Exception.Message
                            }
                        }
                    }
                }
            }
            'backup' {
                if (Get-Command Start-SystemBackup -ErrorAction SilentlyContinue) {
                    $sb = Start-SystemBackup -Destination '.\\Backup' 
                    $result.StatusDetail = $sb
                    if ($Apply) {
                        try {
                            Write-TechLog -Message 'Executing system backup (Apply)'
                            $exec = Start-SystemBackup -Destination '.\\Backup' -Apply:$Apply -ErrorAction Stop
                            $result.Status = 'Executed'
                            $result.Execution = $exec
                        }
                        catch {
                            $result.Status = 'Failed'
                            $result.ExecutionError = $_.Exception.Message
                        }
                    }
                }
            }
            'drivers' {
                if (Get-Command Get-TechKitDriverInventory -ErrorAction SilentlyContinue) {
                    $drv = Get-TechKitDriverInventory
                    $result.StatusDetail = $drv
                    if ($Apply) {
                        if (Get-Command Invoke-TechKitDriverExport -ErrorAction SilentlyContinue) {
                            try {
                                Write-TechLog -Message 'Executing driver export (Apply)'
                                $exec = Invoke-TechKitDriverExport -ErrorAction Stop
                                $result.Status = 'Executed'
                                $result.Execution = $exec
                            }
                            catch {
                                $result.Status = 'Failed'
                                $result.ExecutionError = $_.Exception.Message
                            }
                        }
                    }
                }
            }
            'security' {
                if (Get-Command Invoke-SecurityActions -ErrorAction SilentlyContinue) {
                    $sec = Invoke-SecurityActions
                    $result.StatusDetail = $sec
                    if ($Apply) {
                        try {
                            Write-TechLog -Message 'Executing security actions (Apply)'
                            $exec = Invoke-SecurityActions -Apply:$Apply -ErrorAction Stop
                            $result.Status = 'Executed'
                            $result.Execution = $exec
                        }
                        catch {
                            $result.Status = 'Failed'
                            $result.ExecutionError = $_.Exception.Message
                        }
                    }
                }
            }
            'updates' {
                if (Get-Command Invoke-UpdateWorkflow -ErrorAction SilentlyContinue) {
                    $up = Invoke-UpdateWorkflow
                    $result.StatusDetail = $up
                    if ($Apply) {
                        try {
                            Write-TechLog -Message 'Executing updates (Apply)'
                            $exec = Invoke-UpdateWorkflow -Apply:$Apply -ErrorAction Stop
                            $result.Status = 'Executed'
                            $result.Execution = $exec
                        }
                        catch {
                            $result.Status = 'Failed'
                            $result.ExecutionError = $_.Exception.Message
                        }
                    }
                }
            }
            'tweaks' {
                if (Get-Command Invoke-TechKitTweaks -ErrorAction SilentlyContinue) {
                    $t = Invoke-TechKitTweaks
                    $result.StatusDetail = $t
                    if ($Apply) {
                        if (Get-Command Invoke-TechKitTweaksApply -ErrorAction SilentlyContinue) {
                            try {
                                Write-TechLog -Message 'Executing tweaks (Apply)'
                                $exec = Invoke-TechKitTweaksApply -ErrorAction Stop
                                $result.Status = 'Executed'
                                $result.Execution = $exec
                            }
                            catch {
                                $result.Status = 'Failed'
                                $result.ExecutionError = $_.Exception.Message
                            }
                        }
                    }
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

