$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Windows-TechKit feature modules' {
    BeforeAll {
        . (Join-Path $repoRoot 'core/branding/Branding.ps1')
        . (Join-Path $repoRoot 'core/client/ClientRegistry.ps1')
        . (Join-Path $repoRoot 'core/usb/UsbLayout.ps1')
        . (Join-Path $repoRoot 'modules/Inventory/Actions.ps1')
        . (Join-Path $repoRoot 'modules/Support/Actions.ps1')
    }

    It 'builds branding information' {
        $branding = Get-TechKitBranding
        if ($branding.Name -ne 'Windows-TechKit') {
            throw 'Branding name did not match expectation'
        }
    }

    It 'creates a client record' {
        $client = New-TechKitClient -Name 'Tech Support'
        if ($client.Name -ne 'Tech Support') {
            throw 'Client name did not match expectation'
        }
    }

    It 'creates a usb layout' {
        $path = Join-Path $TestDrive 'usb-root'
        $layout = New-TechKitUsbLayout -RootPath $path
        if ($layout.Directories -notcontains 'reports') {
            throw 'USB layout did not include reports directory'
        }
    }

    It 'collects inventory snapshot' {
        $snapshot = Get-InventorySnapshot
        if ([string]::IsNullOrWhiteSpace($snapshot.ComputerName)) {
            throw 'ComputerName should not be empty'
        }
    }

    It 'creates a support ticket' {
        $ticket = New-SupportTicket -ClientName 'Client' -Issue 'Needs assistance'
        if ($ticket.Issue -ne 'Needs assistance') {
            throw 'Support ticket issue did not match expectation'
        }
    }
}
