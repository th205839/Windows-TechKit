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
        $branding.Name | Should -Be 'Windows-TechKit'
    }

    It 'creates a client record' {
        $client = New-TechKitClient -Name 'Tech Support'
        $client.Name | Should -Be 'Tech Support'
    }

    It 'creates a usb layout' {
        $path = Join-Path $TestDrive 'usb-root'
        $layout = New-TechKitUsbLayout -RootPath $path
        $layout.Directories | Should -Contain 'reports'
    }

    It 'collects inventory snapshot' {
        $snapshot = Get-InventorySnapshot
        $snapshot.ComputerName | Should -Not -BeNullOrEmpty
    }

    It 'creates a support ticket' {
        $ticket = New-SupportTicket -ClientName 'Client' -Issue 'Needs assistance'
        $ticket.Issue | Should -Be 'Needs assistance'
    }
}
