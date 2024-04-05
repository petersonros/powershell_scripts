# Define o nome do arquivo e o caminho no servidor remoto
# $caminhoRemoto = "\\Servidor\Compartilhamento\info_hardware_$env:COMPUTERNAME.txt"
$caminhoRemoto = "..\scripts_info\info_hardware_$env:COMPUTERNAME.txt"

# Coleta as informações de hardware
$cpu = Get-WmiObject -Class Win32_Processor | Select-Object -Property Name, NumberOfCores, NumberOfLogicalProcessors
$ram = Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
$disks = Get-WmiObject -Class Win32_DiskDrive | Select-Object -Property Model, MediaType, Size
$video = Get-WmiObject -Class Win32_VideoController | Select-Object -Property Name, VideoProcessor

# Converte a capacidade de RAM de bytes para GB
$ramTotalGB = [Math]::Round($ram.Sum / 1GB, 2)

# Prepara o texto para ser salvo
$texto = @"
Informações de Hardware do PC: $env:COMPUTERNAME
`nProcessador: $($cpu.Name)
Núcleos: $($cpu.NumberOfCores)
Processadores Lógicos: $($cpu.NumberOfLogicalProcessors)
`nRAM Total: ${ramTotalGB}GB
`nDisco(s):
$($disks | ForEach-Object { "$($_.Model) - $($_.MediaType) - $([Math]::Round($_.Size / 1GB, 2))GB`n" })
`nPlaca(s) de Vídeo:
$($video | ForEach-Object { "$($_.Name) - $($_.VideoProcessor)`n" })
"@

# Salva as informações no arquivo no servidor remoto
 try {
  $texto | Out-File -FilePath $caminhoRemoto -Encoding UTF8
    Write-Host "Informações de hardware foram salvas com sucesso em '$caminhoRemoto'"
} catch {
    Write-Error "Não foi possível salvar as informações no caminho especificado: $_"
}
