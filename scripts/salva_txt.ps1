# Inicializa uma variável para armazenar todas as informações
$resultado = ""

# Coleta informações básicas do sistema
$computerInfo = Get-WmiObject -Class Win32_ComputerSystem
$resultado += "Fabricante: $($computerInfo.Manufacturer)`r`n"
$resultado += "Modelo: $($computerInfo.Model)`r`n"

# Get-CimInstance -ClassName Win32_Processor | Select-Object -ExcludeProperty "CIM*"

# $resultado += Get-CimInstance -ClassName Win32_BIOS

# $computerInfo = Get-CimInstance -ClassName Win32_ComputerSystem
# $resultado += "Instancia: $($computerInfo.InstanceProperties)"

# Coleta informações do processador
$processorInfo = Get-WmiObject -Class Win32_Processor
$resultado += "Processador: $($processorInfo.Name)`r`n"
$resultado += "Descrição: $($processorInfo.Description)`r`n"

# Coleta informações da placa-mãe
$motherboardInfo = Get-WmiObject -Class Win32_BaseBoard
$resultado += "Placa-mãe Fabricante: $($motherboardInfo.Manufacturer)`r`n"
$resultado += "Placa-mãe Produto: $($motherboardInfo.Product)`r`n"

# Salva todas as informações coletadas em um arquivo .txt
# $resultado | Out-File -FilePath d:\powershell\resultado.txt
$resultado | Out-File -FilePath \\arcanos\Bancada\resultado.txt

# Exibe uma mensagem confirmando que as informações foram salvas
Write-Host "As informações do hardware foram salvas em 'D:\powershell\resultado.txt'"
