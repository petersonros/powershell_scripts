# Get hostname
$nomeDoPC = $env:COMPUTERNAME

# Define file path
$caminhoArquivo = "..\machines\$nomeDoPC.txt"

# make sure the file is empty
if (Test-Path $caminhoArquivo) {
    Remove-Item $caminhoArquivo
}

# get disk info
$discosFisicos = Get-PhysicalDisk

foreach ($disco in $discosFisicos) {
    $tipoDisco = $disco.MediaType
    $idDisco = $disco.DeviceID
    "Disco ID: $idDisco - Tipo: $tipoDisco" | Out-File -FilePath $caminhoArquivo -Append

    # find disk partition
    $particoes = Get-Partition | Where-Object { $_.DiskNumber -eq $idDisco }

    foreach ($particao in $particoes) {
        # use id partition to find disk
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

