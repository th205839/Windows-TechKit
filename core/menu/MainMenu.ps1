function Invoke-TechKitMenuModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [string]$Label
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        Write-Host ("Módulo não encontrado: {0}" -f $Path) -ForegroundColor Yellow
        return $null
    }

    Write-TechLog -Message ("Module selected: {0}" -f $Label)
    try {
        return @(& $Path)
    }
    catch {
        Write-TechLog -Message ("Module failed: {0} - {1}" -f $Label, $_.Exception.Message)
        Write-Host ("Erro no módulo {0}: {1}" -f $Label, $_.Exception.Message) -ForegroundColor Red
        return $null
    }
}

function Show-MainMenu {
    [CmdletBinding()]
    param()

    $moduleRoot = Join-Path (Split-Path -Parent $PSScriptRoot) '..\modules'
    $moduleRoot = [System.IO.Path]::GetFullPath($moduleRoot)

    do {
        Clear-Host
        Show-TechKitBanner
        Write-Host 'Menu profissional do técnico' -ForegroundColor DarkCyan
        Write-Host ''
        Write-Host '1 - Diagnóstico geral' -ForegroundColor Green
        Write-Host '2 - Manutenção do Windows' -ForegroundColor Green
        Write-Host '3 - Diagnóstico de rede' -ForegroundColor Green
        Write-Host '4 - Inventário do sistema' -ForegroundColor Green
        Write-Host '5 - Diagnóstico de discos' -ForegroundColor Green
        Write-Host '6 - Exportar relatório' -ForegroundColor Green
        Write-Host '7 - Reparação assistida' -ForegroundColor Green
        Write-Host '8 - Suporte' -ForegroundColor Green
        Write-Host '9 - Sair' -ForegroundColor Red
        Write-Host ''

        $selection = Read-Host 'Selecione uma opção'
        Write-Host ''

        switch ($selection) {
            '1' {
                $diagnostics = Invoke-TechKitDiagnostics
                if ($null -ne $diagnostics) {
                    $null = Export-TechKitReport -Data ([pscustomobject]$diagnostics) -FileName 'diagnostics'
                }
            }
            '2' {
                Write-Host 'A manutenção SFC/DISM exige confirmação e privilégios administrativos.' -ForegroundColor Yellow
                $clientName = Read-Host 'Nome do cliente (opcional)'
                $maintenancePath = Join-Path $moduleRoot 'Windows\Start.ps1'
                $maintenance = Invoke-TechKitMenuModule -Path $maintenancePath -Label 'Windows Maintenance'
                if ($clientName) {
                    Write-TechLog -Message ("Client: {0}" -f $clientName)
                }
                if ($maintenance) {
                    $null = Export-TechKitReport -Data ([pscustomobject]$maintenance) -FileName 'maintenance'
                }
            }
            '3' {
                $networkPath = Join-Path $moduleRoot 'Network\Network.ps1'
                $network = Invoke-TechKitMenuModule -Path $networkPath -Label 'Network Diagnostics'
                if ($network) {
                    $null = Export-TechKitReport -Data ([pscustomobject]@{ Network = $network }) -FileName 'network'
                }
            }
            '4' {
                $inventoryPath = Join-Path $moduleRoot 'System\Start.ps1'
                $inventory = Invoke-TechKitMenuModule -Path $inventoryPath -Label 'System Inventory'
                if ($inventory) {
                    $null = Export-TechKitReport -Data ([pscustomobject]@{ Inventory = $inventory }) -FileName 'inventory'
                }
            }
            '5' {
                $diskPath = Join-Path $moduleRoot 'Disk\Start.ps1'
                $disk = Invoke-TechKitMenuModule -Path $diskPath -Label 'Disk Diagnostics'
                if ($disk) {
                    $null = Export-TechKitReport -Data ([pscustomobject]@{ Disk = $disk }) -FileName 'disk'
                }
            }
            '6' {
                $report = New-TechKitReport -Title 'Exportação manual'
                $null = Export-TechKitReport -Data ([pscustomobject]$report) -FileName 'manual-export'
                Write-Host 'Relatório exportado.' -ForegroundColor Green
            }
            '7' {
                Write-TechLog -Message 'Repair workflow selected'
                $pipeline = Join-Path $PSScriptRoot '../launcher/StartupPipeline.ps1'
                if (Test-Path -LiteralPath $pipeline) {
                    & $pipeline
                }
                else {
                    Write-Host 'Pipeline de reparação não encontrado.' -ForegroundColor Yellow
                }
            }
            '8' {
                Write-TechLog -Message 'Support workflow selected'
                Write-Host 'Consulte os logs e relatórios gerados pelo Windows-TechKit para atendimento técnico.' -ForegroundColor Cyan
                Write-Host 'Os caminhos de saída são controlados pelo módulo de configuração/relatórios.'
            }
            '9' {
                Write-Host 'Encerrando o Windows-TechKit.' -ForegroundColor Yellow
            }
            default {
                Write-Host 'Opção inválida. Escolha um número do menu.' -ForegroundColor Yellow
            }
        }

        if ($selection -ne '9') {
            Write-Host ''
            [void](Read-Host 'Pressione ENTER para continuar')
        }
    } while ($selection -ne '9')
}
