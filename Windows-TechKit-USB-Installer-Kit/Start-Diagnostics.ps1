[CmdletBinding()]
param()

Clear-Host
Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Windows-TechKit - Diagnostico Basico' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

Write-Host '1) Sistema operacional' -ForegroundColor Yellow
try {
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Host "   Nome: $($os.Caption) $($os.OSArchitecture)"
    Write-Host "   Versao: $($os.Version)"
    Write-Host "   Build: $($os.BuildNumber)"
}
catch {
    Write-Host '   Falha ao ler informacoes do sistema.' -ForegroundColor Red
}
Write-Host ''

Write-Host '2) Hardware principal' -ForegroundColor Yellow
try {
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $memory = Get-CimInstance Win32_ComputerSystem
    Write-Host "   Processador: $($cpu.Name)"
    Write-Host "   Cores: $($cpu.NumberOfCores) Threads: $($cpu.NumberOfLogicalProcessors)"
    Write-Host "   RAM total: $([math]::Round($memory.TotalPhysicalMemory / 1GB, 2)) GB"
}
catch {
    Write-Host '   Falha ao ler informacoes de hardware.' -ForegroundColor Red
}
Write-Host ''

Write-Host '3) Armazenamento' -ForegroundColor Yellow
try {
    Get-CimInstance Win32_Volume | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
        Write-Host "   $_.DriveLetter : $_.Label - $([math]::Round($_.Capacity / 1GB, 1)) GB total, $([math]::Round($_.FreeSpace / 1GB, 1)) GB livre"
    }
}
catch {
    Write-Host '   Falha ao ler informacoes de disco.' -ForegroundColor Red
}
Write-Host ''

Write-Host '4) Rede' -ForegroundColor Yellow
try {
    $interface = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1
    if ($interface) {
        Write-Host "   Adaptador: $($interface.Name)"
        Write-Host "   Status: $($interface.Status)"
        Write-Host "   Ligado: $($interface.LinkSpeed)"
    }
    else {
        Write-Host '   Nenhum adaptador de rede ativo encontrado.' -ForegroundColor Yellow
    }
    $ping = Test-NetConnection -ComputerName 8.8.8.8 -WarningAction SilentlyContinue
    if ($ping.TcpTestSucceeded -or $ping.PingSucceeded) {
        Write-Host '   Conectividade: OK' -ForegroundColor Green
    }
    else {
        Write-Host '   Conectividade: Falha' -ForegroundColor Red
    }
}
catch {
    Write-Host '   Falha ao verificar rede.' -ForegroundColor Red
}
Write-Host ''

Write-Host '5) Servicos basicos' -ForegroundColor Yellow
try {
    $services = Get-Service -Name wuauserv, bits, Winmgmt -ErrorAction SilentlyContinue
    foreach ($svc in $services) {
        Write-Host "   $($svc.DisplayName) ($($svc.Name)) : $($svc.Status)"
    }
}
catch {
    Write-Host '   Falha ao verificar servicos do Windows.' -ForegroundColor Red
}
Write-Host ''

Write-Host 'Resultado: diagnostico basico concluido.' -ForegroundColor Green
Write-Host ''
Write-Host 'Detalhes gravados em logs/diagnostics.txt se disponivel.' -ForegroundColor Cyan

try {
    $logPath = Join-Path (Split-Path -Parent $PSScriptRoot) '..\logs\diagnostics.txt'
    $logPath = Resolve-Path $logPath -ErrorAction SilentlyContinue
    if (-not $logPath) {
        New-Item -ItemType File -Path (Join-Path (Split-Path -Parent $PSScriptRoot) '..\logs\diagnostics.txt') -Force | Out-Null
        $logPath = Join-Path (Split-Path -Parent $PSScriptRoot) '..\logs\diagnostics.txt'
    }
    $report = @(
        'Windows-TechKit Diagnostics Report',
        '=================================',
        "Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
        '',
        "OS: $($os.Caption) $($os.OSArchitecture) $($os.Version)",
        "CPU: $($cpu.Name)",
        "RAM: $([math]::Round($memory.TotalPhysicalMemory / 1GB, 2)) GB",
        '',
        'Discos:'
    )
    $volumes = Get-CimInstance Win32_Volume | Where-Object { $_.DriveType -eq 3 }
    foreach ($vol in $volumes) {
        $report += "  $($vol.DriveLetter) $($vol.Label) $([math]::Round($vol.Capacity / 1GB, 1))GB total $([math]::Round($vol.FreeSpace / 1GB, 1))GB livre"
    }
    $report += @('', 'Rede:', "  Adaptador: $($interface.Name)", "  Status: $($interface.Status)", "  Conectividade: $($if ($ping.TcpTestSucceeded -or $ping.PingSucceeded) { 'OK' } else { 'Falha' })")
    $report | Set-Content -Path $logPath -Force
}
catch {
    Write-Host 'Nao foi possivel gravar o log de diagnostico.' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Pressione qualquer tecla para voltar ao menu...' -ForegroundColor Yellow
Read-Host | Out-Null
