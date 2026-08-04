function Backup-Drivers {
    param([string]$Destination = '.\DriverBackup')
    Export-WindowsDriver -Online -Destination $Destination
}
