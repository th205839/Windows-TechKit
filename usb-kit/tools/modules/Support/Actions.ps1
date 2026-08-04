function New-SupportTicket {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ClientName,
        [Parameter(Mandatory)]
        [string]$Issue
    )

    return [pscustomobject]@{
        TicketId = ('TKT-{0}' -f [guid]::NewGuid().ToString('N').Substring(0, 8))
        ClientName = $ClientName
        Issue = $Issue
        Created = (Get-Date).ToString('o')
    }
}
