function Restore-Drivers {
    param([string]$Source = '.\DriverBackup')
    pnputil /add-driver "$Source\*.inf" /subdirs /install
}
