# Habilitar .NET Framework (se necessário)
Install-WindowsFeature -name NET-Framework-45-Features

# Adicionar repositório NuGet (se necessário)
Register-PSRepository -Name "NuGetGallery" -SourceLocation "https://www.nuget.org/api/v2"

# Instalar o Windows Copilot (exemplo, ajuste conforme necessário)
Install-Package -Name WindowsCopilot -Source NuGetGallery

# Configuração pós-instalação (exemplo)
# Set-ItemProperty -Path "HKLM:\Software\WindowsCopilot" -Name "Config" -Value "..."

# Reiniciar o serviço Copilot (se aplicável)
Restart-Service -Name WindowsCopilot
