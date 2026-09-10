[CmdletBinding()]
param()

Write-Host 'Security module initialized.' -ForegroundColor Yellow

try {
    $result = Invoke-SecurityActions
    Write-Host ('Security workflow ready: {0}' -f $result.Status) -ForegroundColor Green
    return $result
}
catch {
    Write-Warning ('Security workflow failed to initialize: {0}' -f $_.Exception.Message)
    throw
}
