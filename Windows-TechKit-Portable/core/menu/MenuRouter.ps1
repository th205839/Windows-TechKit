function Invoke-MenuSelection {
    param(
        [int]$Option
    )

    switch ($Option) {
        1 { Write-Host "Iniciando modulo Repair..." }
        2 { Write-Host "Modulo Network em desenvolvimento..." }
        3 { Write-Host "Modulo Update em desenvolvimento..." }
        4 { Write-Host "Modulo Drivers em desenvolvimento..." }
        5 { Write-Host "Modulo Backup em desenvolvimento..." }
        6 { exit }
        default { Write-Host "Opcao invalida" }
    }
}
