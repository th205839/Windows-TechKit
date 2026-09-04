Set-StrictMode -Version Latest

function New-TechKitReport {
    [CmdletBinding()]
    param(
        [string]$Title = 'Windows-TechKit - Relatório Técnico',
        [hashtable]$Sections = @{}
    )

    [pscustomobject]@{
        Title = $Title
        GeneratedAt = (Get-Date).ToString('o')
        ComputerName = $env:COMPUTERNAME
        Sections = $Sections
    }
}

function ConvertTo-TechKitHtml {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Data
    )

    $json = $Data | ConvertTo-Json -Depth 12
    $escaped = [System.Net.WebUtility]::HtmlEncode($json)

    @"
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>$([System.Net.WebUtility]::HtmlEncode($Data.Title))</title>
<style>
body{font-family:Segoe UI,Arial,sans-serif;margin:32px;line-height:1.5}
h1{margin-bottom:4px}
.meta{color:#666;margin-bottom:24px}
pre{white-space:pre-wrap;background:#f5f5f5;padding:16px;border-radius:8px}
</style>
</head>
<body>
<h1>$([System.Net.WebUtility]::HtmlEncode($Data.Title))</h1>
<div class="meta">Computador: $([System.Net.WebUtility]::HtmlEncode([string]$Data.ComputerName)) | Gerado em: $([System.Net.WebUtility]::HtmlEncode([string]$Data.GeneratedAt))</div>
<pre>$escaped</pre>
</body>
</html>
"@
}

function Export-TechKitReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Data,
        [string]$OutputDirectory = (Join-Path (Get-TechKitRoot) 'Logs'),
        [string]$FileName = 'techkit-report'
    )

    if (-not (Test-Path -LiteralPath $OutputDirectory)) {
        $null = New-Item -ItemType Directory -Path $OutputDirectory -Force
    }

    $safeName = ($FileName -replace '[^a-zA-Z0-9._-]', '_')
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $base = Join-Path $OutputDirectory "$safeName-$stamp"

    $jsonPath = "$base.json"
    $htmlPath = "$base.html"

    $Data | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $jsonPath -Encoding UTF8
    ConvertTo-TechKitHtml -Data $Data | Set-Content -LiteralPath $htmlPath -Encoding UTF8

    if (Get-Command Write-TechLog -ErrorAction SilentlyContinue) {
        Write-TechLog -Message ("Report exported: {0}" -f $base)
    }

    [pscustomobject]@{
        JsonPath = $jsonPath
        HtmlPath = $htmlPath
    }
}
