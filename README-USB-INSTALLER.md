# Windows-TechKit USB Installer

Este pacote agora inclui um script para preparar um pendrive com a ISO do Windows 10/11 e o kit técnico do Windows-TechKit.

## Como usar

1. Tenha a ISO do Windows 10 ou 11 em mãos.
2. No PowerShell, execute:

```powershell
./Prepare-USB-Installer.ps1 -DriveLetter E: -IsoPath C:\caminho\para\Windows.iso
```

3. O script tentará:
   - formatar o pendrive
   - copiar os arquivos da ISO para o pendrive
   - copiar o kit técnico para o pendrive
   - aplicar o boot sector

## Observações
- O processo depende de ferramentas Windows e do arquivo bootsect.exe.
- Se o seu computador não aceitar a inicialização pelo pendrive, use o Rufus com a ISO do Windows e depois copie a pasta do kit técnico.
- Para uso real, o pendrive precisa estar em modo UEFI.
