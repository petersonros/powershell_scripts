# get hostname
$nomeDoPC = $env:COMPUTERNAME

# Define o caminho onde o arquivo será salvo
$caminhoDoArquivo = "..\machines\$nomeDoPC.txt"

$informacoesDoPC = @()
$informacoesDoPC += "Nome da máquina: $nomeDoPC"
$informacoesDoPC += "Processador: " + (Get-WmiObject Win32_Processor).Name
$informacoesDoPC += "Memória RAM: " + "{0:N2} GB" -f ((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$informacoesDoPC += "Armazenamento: " + (Get-Partition | Where-Object { $_.DriveLetter -eq 'C' }).Size / 1GB -as [int] + " GB"

$informacoesDoPC | Out-File -FilePath $caminhoDoArquivo

Write-Host "As informações foram salvas em '$caminhoDoArquivo'"
