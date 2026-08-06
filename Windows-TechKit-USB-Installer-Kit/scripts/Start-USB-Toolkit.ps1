[CmdletBinding()]
param()

function Show-ToolkitMenu {
    Clear-Host
    Write-Host '=============================================' -ForegroundColor Cyan
    Write-Host ' Windows-TechKit - Menu de Ferramentas' -ForegroundColor Cyan
    Write-Host '=============================================' -ForegroundColor Cyan
    Write-Host ''

    $root = Split-Path -Parent $PSScriptRoot
    $modulesPath = Join-Path $root '..\tools\modules'
    $modules = Get-ChildItem -Path $modulesPath -Directory | Sort-Object Name

    $descriptions = @{
        Backup = 'Backup e restauracao de arquivos e sistema'
        Drivers = 'Inventario de drivers e restauracao'
        Hardware = 'Informacoes e diagnostico de hardware'
        Inventory = 'Inventario de sistema e relatorios'
        Network = 'Diagnostico e reparo de rede'
        Recovery = 'Acoes de recuperacao do Windows'
        Repair = 'Reparos com SFC, DISM e automacao'
        Security = 'Verificacoes de seguranca basicas'
        Support = 'Ferramentas de suporte e assistencia'
        Tweaks = 'Ajustes de desempenho e privacidade'
        Update = 'Manutencao e limpeza de atualizacoes'
        Updates = 'Acoes de atualizacao adicionais'
    }

    for ($i = 0; $i -lt $modules.Count; $i++) {
        $module = $modules[$i]
        $name = $module.Name
        $desc = $descriptions[$name]
        if (-not $desc) { $desc = 'Ferramenta de suporte generica' }
        Write-Host "[$($i+1)] $name - $desc" -ForegroundColor Green
    }
    Write-Host ''
    Write-Host '[0] Voltar ao menu principal' -ForegroundColor Yellow
    Write-Host ''

    $selection = Read-Host 'Escolha uma ferramenta para ver detalhes'
    if ($selection -eq '0') {
        return
    }

    if ([int]::TryParse($selection, [ref]$index) -and $index -ge 1 -and $index -le $modules.Count) {
        $module = $modules[$index - 1]
        $moduleName = $module.Name
        $moduleDesc = $descriptions[$moduleName]
        Write-Host ''
        Write-Host "Abrindo ferramenta: $moduleName" -ForegroundColor Cyan
        Write-Host "Descricao: $moduleDesc" -ForegroundColor Yellow

        $moduleFiles = Get-ChildItem -Path $module.FullName -File | Select-Object -ExpandProperty Name
        Write-Host ''
        Write-Host 'Arquivos disponiveis:' -ForegroundColor Green
        $moduleFiles | ForEach-Object { Write-Host " - $_" }

        $startScript = Join-Path $module.FullName 'Start.ps1'
        if (Test-Path $startScript) {
            Write-Host ''
            Write-Host 'Executando a ferramenta principal...' -ForegroundColor Cyan
            try {
                & $startScript
            }
            catch {
                Write-Host 'A execucao encontrou um erro.' -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red
            }
        }
        else {
            Write-Host ''
            Write-Host 'Nao existe Start.ps1 nesta ferramenta.' -ForegroundColor Yellow
            Write-Host 'Voce pode executar um dos arquivos listados manualmente.' -ForegroundColor Yellow
        }

        Write-Host ''
        Write-Host 'Pressione Enter para voltar ao menu de ferramentas...' -ForegroundColor Cyan
        Read-Host | Out-Null
        Show-ToolkitMenu
    }
    else {
        Write-Host 'Selecao invalida. Tente novamente.' -ForegroundColor Red
        Start-Sleep -Seconds 1
        Show-ToolkitMenu
    }
}

Show-ToolkitMenu
