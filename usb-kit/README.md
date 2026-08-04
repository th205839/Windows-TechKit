# Windows-TechKit USB Kit

Este pacote foi preparado para ser copiado para um pendrive e utilizado como kit de recuperação, diagnóstico e instalação do Windows 10/11.

## Estrutura
- `tools/` - ferramentas do Windows-TechKit
- `isos/` - pastas para armazenar as ISOs do Windows 10/11
- `scripts/` - scripts auxiliares
- `logs/` - relatórios e registros

## Como usar
1. Copie esta pasta para o pendrive.
2. Coloque sua ISO do Windows 10 ou 11 na pasta `isos/`.
3. Abra o PowerShell na raiz do pendrive.
4. Execute:

```powershell
./scripts/Start-USB-Toolkit.ps1
```

## Objetivo
- instalar ou reparar o Windows 10/11
- diagnosticar hardware e rede
- executar backups e restaurações
- coletar logs e relatórios
