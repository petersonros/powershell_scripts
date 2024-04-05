# Define o caminho do arquivo onde as informações serão salvas
$caminhoArquivo = "d:\info_discos.txt"

# Certifica-se de que o arquivo está vazio antes de começar a escrever
if (Test-Path $caminhoArquivo) {
    Remove-Item $caminhoArquivo
}

# Captura as informações de cada disco físico
$discosFisicos = Get-PhysicalDisk

foreach ($disco in $discosFisicos) {
    $tipoDisco = $disco.MediaType
    $idDisco = $disco.DeviceID
    "Disco ID: $idDisco - Tipo: $tipoDisco" | Out-File -FilePath $caminhoArquivo -Append

    # Encontra as partições para cada disco físico baseando-se no número do disco
    $particoes = Get-Partition | Where-Object { $_.DiskNumber -eq $idDisco }

    foreach ($particao in $particoes) {
        # Usa o identificador da partição para encontrar o volume correspondente
        $volume = Get-Volume | Where-Object { $_.UniqueId -like "*$($particao.GUID)*" }

        if ($volume) {
            $espacoTotalGB = [math]::Round($volume.Size / 1GB, 2)
            $espacoLivreGB = [math]::Round($volume.SizeRemaining / 1GB, 2)
            $espacoUsadoGB = $espacoTotalGB - $espacoLivreGB
            $textoVolume = @"
    Volume $($volume.DriveLetter):
        Espaço Total: $espacoTotalGB GB
        Espaço Usado: $espacoUsadoGB GB
        Espaço Livre: $espacoLivreGB GB
"@
            $textoVolume | Out-File -FilePath $caminhoArquivo -Append
        }
    }
}
