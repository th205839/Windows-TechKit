function New-TechKitUsbLayout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RootPath
    )

    $requiredDirectories = @(
        'tools',
        'reports',
        'logs',
        'drivers',
        'backups',
        'scripts'
    )

    foreach ($directory in $requiredDirectories) {
        $targetPath = Join-Path $RootPath $directory
        if (-not (Test-Path $targetPath)) {
            New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
        }
    }

    return [pscustomobject]@{
        RootPath = $RootPath
        Directories = $requiredDirectories
        Created = (Get-Date).ToString('o')
    }
}
