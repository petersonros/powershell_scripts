# Configurar a política de execução temporariamente
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force

# Função para reiniciar e continuar o script
function Restart-AndContinue {
    param(
        [string]$taskName,
        [string]$scriptPath
    )
    
    # Criar tarefa agendada para continuar o script após reiniciar
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -AtStartup -Once
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Settings $settings -Principal $principal
    Restart-Computer
}

# Redefinir o hostname do Windows
$newHostname = "HB-W03"
Rename-Computer -NewName $newHostname -Force
Restart-AndContinue -taskName "ContinueSetupAfterReboot" -scriptPath "C:\Path\To\SetupAndUpdate.ps1"

# Esperar o computador reiniciar e continuar após o reinício
Start-Sleep -Seconds 60

# Atualizar o Windows
Import-Module PSWindowsUpdate
$windowsUpdates = Get-WindowsUpdate

if ($windowsUpdates) {
    Install-WindowsUpdate -AcceptAll -AutoReboot
    Restart-AndContinue -taskName "ContinueSetupAfterUpdate" -scriptPath "C:\Path\To\SetupAndUpdate.ps1"
}

# Instalar o OpenVPN
# winget install --id OpenVPNTechnologies.OpenVPN --accept-package-agreements --accept-source-agreements

# Caminho para os arquivos de configuração do OpenVPN
# $configSourcePath = "X:\caminho\para\configuracoes\OpenVPN"
# $configDestinationPath = "C:\Program Files\OpenVPN\config"
# Copy-Item -Path "$configSourcePath\*" -Destination $configDestinationPath -Recurse

# Lista de softwares a serem instalados via winget
$softwareList = @(
    "Google.Chrome",
    "Adobe.Acrobat.Reader.64-bit"
)

# Instalar softwares
foreach ($software in $softwareList) {
    winget install --id=$software --silent --accept-package-agreements --accept-source-agreements
}

# Atualizar todos os softwares instalados
winget upgrade --all --accept-package-agreements --accept-source-agreements

# Adicionar o computador ao domínio
# $domainName = "seu.dominio.local"
# $domainCredential = Get-Credential
# Add-Computer -DomainName $domainName -Credential $domainCredential -Restart
