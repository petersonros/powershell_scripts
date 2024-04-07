# Obtem informações do sistema
$computerInfo = Get-WmiObject -Class Win32_ComputerSystem

# Exibe o fabricante e o modelo do computador
Write-Host "Fabricante: $($computerInfo.Manufacturer)"
Write-Host "Modelo: $($computerInfo.Model)"
Write-Host "Nome do PC (host name): $($computerInfo.Name)"

# Coleta informações do processador
$processorInfo = Get-WmiObject -Class Win32_Processor

# Exibe o nome e a descrição do processador
Write-Host "Processador: $($processorInfo.Name)"
Write-Host "Frequencia do Processador: $($processorInfo.MaxClockSpeed) GHz"

Write-Host "Descrição: $($processorInfo.Description)"

# Coleta informações da placa-mãe
$motherboardInfo = Get-WmiObject -Class Win32_BaseBoard

# Exibe o fabricante e o produto da placa-mãe
Write-Host "Placa-mãe Fabricante: $($motherboardInfo.Manufacturer)"
Write-Host "Placa-mãe Produto: $($motherboardInfo.Product)"
