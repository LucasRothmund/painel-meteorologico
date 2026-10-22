$ErrorActionPreference = 'Stop'

$projectUrl = Read-Host 'URL do projeto Supabase'
$publishableKey = Read-Host 'Chave publishable do Supabase'

if (-not $projectUrl.StartsWith('https://')) {
  throw 'Informe uma URL Supabase começando com https://.'
}
if (-not $publishableKey -or $publishableKey -match '(?i)service_role|secret|^sb_secret_') {
  throw 'Use somente a chave publishable ou anon do Supabase, nunca uma chave secreta.'
}

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$previewRoot = Join-Path $env:TEMP 'painel-meteorologico-preview'
New-Item -ItemType Directory -Path $previewRoot -Force | Out-Null

$html = [System.IO.File]::ReadAllText((Join-Path $projectRoot 'index.html'), [System.Text.Encoding]::UTF8)
$html = $html.Replace('__SUPABASE_URL__', (ConvertTo-Json -InputObject $projectUrl -Compress))
$html = $html.Replace('__SUPABASE_PUBLISHABLE_KEY__', (ConvertTo-Json -InputObject $publishableKey -Compress))
if ($html.Contains('__SUPABASE_')) {
  throw 'Não foi possível preencher a configuração do Supabase.'
}

[System.IO.File]::WriteAllText((Join-Path $previewRoot 'index.html'), $html, [System.Text.UTF8Encoding]::new($false))
Copy-Item -LiteralPath (Join-Path $projectRoot 'site_admin.js') -Destination (Join-Path $previewRoot 'site_admin.js') -Force

$launcher = Get-Command py -ErrorAction SilentlyContinue
if ($launcher) {
  $pythonArgs = @('-3', '-m', 'http.server', '8765', '--directory', $previewRoot)
} else {
  $launcher = Get-Command python -ErrorAction SilentlyContinue
  if (-not $launcher) {
    throw 'Python não foi encontrado. Instale Python ou inicie um servidor HTTP para a pasta temporária.'
  }
  $pythonArgs = @('-m', 'http.server', '8765', '--directory', $previewRoot)
}

$url = 'http://127.0.0.1:8765/'
Write-Host "Abrindo $url. Mantenha esta janela aberta; pressione Ctrl+C para encerrar."
Start-Process $url
& $launcher.Source @pythonArgs
