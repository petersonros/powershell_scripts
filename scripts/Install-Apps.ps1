
# Caminho para o arquivo com a lista de aplicativos
$appListFile = "apps.txt"

# Verifica se o arquivo existe
if (-not (Test-Path $appListFile)) {
  Write-Host "Arquivo 'apps.txt' não encontrado." -ForegroundColor Red
  exit
}

# Lê a lista de aplicativos do arquivo
$appList = Get-Content $appListFile

foreach ($app in $appList) {
  Write-Host "Instalando $app..." -ForegroundColor Green
  try {
      winget install --id $app --silent --accept-source-agreements --accept-package-agreements
      Write-Host "$app instalado com sucesso." -ForegroundColor Green
  } catch {
      Write-Host "Erro ao instalar $app." -ForegroundColor Red
  }
}
