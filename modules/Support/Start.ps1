[CmdletBinding()]
param()

Write-Host 'Support module initialized.' -ForegroundColor Yellow

try {
    $ticket = New-SupportTicket -ClientName 'System' -Issue 'Support module initialized'
    Write-Host ('Support workflow ready: {0}' -f $ticket.TicketId) -ForegroundColor Green
    return $ticket
}
catch {
    Write-Warning ('Support workflow failed to initialize: {0}' -f $_.Exception.Message)
    throw
}
