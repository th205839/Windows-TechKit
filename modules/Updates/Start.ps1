[CmdletBinding()]
param()

Write-Host 'Updates module initialized.' -ForegroundColor Yellow

try {
    $result = Invoke-UpdateWorkflow
    Write-Host ('Update workflow ready: {0}' -f $result.Status) -ForegroundColor Green
    return $result
}
catch {
    Write-Warning ('Update workflow failed to initialize: {0}' -f $_.Exception.Message)
    throw
}
