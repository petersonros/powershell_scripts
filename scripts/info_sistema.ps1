# Nome do arquivo: info_sistema.ps1

# Captura informações do processador
$processador = Get-WmiObject -Class Win32_Processor
Write-Host "Processador: $($processador.Name)"

# Captura a quantidade total de memória física (RAM)
$memoriaRAM = Get-WmiObject -Class Win32_ComputerSystem
Write-Host "Memória RAM Total: $(($memoriaRAM.TotalPhysicalMemory / 1GB) -as [int]) GB"

# Captura informações da(s) placa(s) de vídeo
$placasVideo = Get-WmiObject -Class Win32_VideoController
foreach ($placa in $placasVideo) {
    Write-Host "Placa de Vídeo: $($placa.Name)"
    if ($placa.VideoProcessor -match "integrated" -or $placa.VideoProcessor -match "Intel") {
        Write-Host "Detalhe: GPU Integrada"
    } else {
        Write-Host "Detalhe: GPU Dedicada"
    }
}

# Adicionais: Versão do Windows e Arquitetura do Sistema
$soInfo = Get-WmiObject -Class Win32_OperatingSystem
Write-Host "Sistema Operacional: $($soInfo.Caption), Versão: $($soInfo.Version)"
Write-Host "Arquitetura: $($soInfo.OSArchitecture)"

# Captura as informações de cada disco físico
$discosFisicos = Get-PhysicalDisk

foreach ($disco in $discosFisicos) {
    $tipoDisco = $disco.MediaType
    $idDisco = $disco.DeviceID
    Write-Host "Disco ID: $idDisco - Tipo: $tipoDisco"

    # Encontra as partições para cada disco físico baseando-se no número do disco
    $particoes = Get-Partition | Where-Object { $_.DiskNumber -eq $idDisco }

    foreach ($particao in $particoes) {
        # Usa o identificador da partição para encontrar o volume correspondente
        $volume = Get-Volume | Where-Object { $_.UniqueId -like "*$($particao.GUID)*" }

        if ($volume) {
            $espacoTotalGB = [math]::Round($volume.Size / 1GB, 2)
            $espacoLivreGB = [math]::Round($volume.SizeRemaining / 1GB, 2)
            $espacoUsadoGB = $espacoTotalGB - $espacoLivreGB
            Write-Host "    Volume $($volume.DriveLetter):"
            Write-Host "        Espaço Total: $espacoTotalGB GB"
            Write-Host "        Espaço Usado: $espacoUsadoGB GB"
            Write-Host "        Espaço Livre: $espacoLivreGB GB"
        }
    }
}


# Salva as informações em um arquivo
$infoPath = "D:\info_sistema.txt"
Out-File -FilePath $infoPath -InputObject $info -Append