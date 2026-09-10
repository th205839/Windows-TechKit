$repoRoot = Split-Path -Parent $PSScriptRoot

Describe 'Windows-TechKit workflow modules' {
    BeforeAll {
        . (Join-Path $repoRoot 'modules/Recovery/Actions.ps1')
        . (Join-Path $repoRoot 'modules/Security/Actions.ps1')
        . (Join-Path $repoRoot 'modules/Updates/Actions.ps1')
        . (Join-Path $repoRoot 'modules/Tweaks/Performance.ps1')
        . (Join-Path $repoRoot 'modules/Tweaks/Privacy.ps1')
        . (Join-Path $repoRoot 'modules/Tweaks/Services.ps1')
        . (Join-Path $repoRoot 'modules/Tweaks/TweaksReport.ps1')
        . (Join-Path $repoRoot 'modules/Support/Actions.ps1')
    }

    It 'prepares recovery actions' {
        $result = Invoke-RecoveryActions
        if (-not $result.Actions -or $result.Actions.Count -eq 0) {
            throw 'Recovery actions were not prepared'
        }
    }

    It 'prepares security actions' {
        $result = Invoke-SecurityActions
        if (-not $result.Actions -or $result.Actions.Count -eq 0) {
            throw 'Security actions were not prepared'
        }
    }

    It 'prepares update workflow' {
        $result = Invoke-UpdateWorkflow
        if (-not $result.Actions -or $result.Actions.Count -eq 0) {
            throw 'Update actions were not prepared'
        }
    }

    It 'prepares tweak actions' {
        $performance = Optimize-TechKitPerformance
        $privacy = Set-TechKitPrivacy
        $services = Optimize-TechKitServices

        if ($performance.Status -notin @('Prepared', 'Applied')) {
            throw 'Performance status was not valid'
        }

        if ($privacy.Status -notin @('Prepared', 'Applied')) {
            throw 'Privacy status was not valid'
        }

        if ($services.Status -notin @('Prepared', 'Applied')) {
            throw 'Services status was not valid'
        }
    }

    It 'creates a tweaks report' {
        $result = New-TechKitTweaksReport -Summary 'review complete'
        if ($result.Module -ne 'Tweaks') {
            throw 'Tweaks report module name was incorrect'
        }
    }

    It 'creates a support ticket' {
        $ticket = New-SupportTicket -ClientName 'Client' -Issue 'Needs assistance'
        if ($ticket.TicketId -notmatch '^TKT-') {
            throw 'Support ticket id was invalid'
        }
    }
}
