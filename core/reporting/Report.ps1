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
    param([Parameter(Mandatory)][psobject]$Data)

    $cards = foreach ($section in $Data.Sections.GetEnumerator()) {
        $json = $section.Value | ConvertTo-Json -Depth 12
        $escaped = [System.Net.WebUtility]::HtmlEncode($json)
        @"
<section class="card">
<h2>$([System.Net.WebUtility]::HtmlEncode([string]$section.Key))</h2>
<pre>$escaped</pre>
</section>
"@
    }

    @"
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>$([System.Net.WebUtility]::HtmlEncode([string]$Data.Title))</title>
<style>
body{font-family:Segoe UI,Arial,sans-serif;margin:0;background:#f4f6f8;color:#202124}
main{max-width:1100px;margin:0 auto;padding:32px}
header{background:#fff;padding:24px;border-radius:12px;margin-bottom:20px}
h1{margin:0 0 8px}.meta{color:#666}.card{background:#fff;border-radius:12px;padding:20px;margin:16px 0;box-shadow:0 1px 4px rgba(0,0,0,.08)}
h2{margin-top:0}pre{white-space:pre-wrap;overflow:auto;background:#f7f7f7;padding:14px;border-radius:8px}
footer{color:#777;font-size:12px;margin-top:24px}
</style>
</head>
<body>
<main>
<header>
<h1>$([System.Net.WebUtility]::HtmlEncode([string]$Data.Title))</h1>
<div class="meta">Computador: $([System.Net.WebUtility]::HtmlEncode([string]$Data.ComputerName))<br>Gerado em: $([System.Net.WebUtility]::HtmlEncode([string]$Data.GeneratedAt))</div>
</header>
$($cards -join [Environment]::NewLine)
<footer>Gerado automaticamente pelo Windows-TechKit.</footer>
</main>
</body>
</html>
"@
}

function Export-TechKitReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][psobject]$Data,
        [string]$OutputDirectory = (Join-Path (Get-TechKitRoot) 'Logs'),
        [string]$FileName = 'techkit-report'
    )

    if (-not (Test-Path -LiteralPath $OutputDirectory)) {
        $null = New-Item -ItemType Directory -Path $OutputDirectory -Force
    }

    $safeName = ($FileName -replace '[^a-zA-Z0-9._-]', '_')
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $base = Join-Path $OutputDirectory "$safeName-$stamp"
    $Data | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath "$base.json" -Encoding UTF8
    ConvertTo-TechKitHtml -Data $Data | Set-Content -LiteralPath "$base.html" -Encoding UTF8

    if (Get-Command Write-TechLog -ErrorAction SilentlyContinue) {
        Write-TechLog -Message ("Report exported: {0}" -f $base)
    }

    [pscustomobject]@{ JsonPath = "$base.json"; HtmlPath = "$base.html" }
}
