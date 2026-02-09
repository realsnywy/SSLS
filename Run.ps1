<#
    SSLS - Installer & Launcher (Instalação Limpa)
    Instala em C:\SSLS, configura atalho na Desktop e executa.
    Uso: irm https://raw.githubusercontent.com/realsnywy/SSLS/main/Run.ps1 | iex
#>

$ErrorActionPreference = "Stop"

# --- 0. Verificação de Admin ---
# Necessário para escrever em C:\ e gerenciar atalhos globais/sistema se precisar
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] O instalador precisa de privilégios de Administrador para instalar em C:\SSLS." -ForegroundColor Yellow
    Write-Host "     Reiniciando processo como Administrador..." -ForegroundColor Yellow

    # Baixa o script novamente para um local temporário para executar via 'RunAs'
    # Usando o link do GitHub Raw para garantir acesso ao script mesmo via pipe
    $TempInstaller = "$env:TEMP\SSLS_WebInstall.ps1"
    $SelfURL = "https://raw.githubusercontent.com/realsnywy/SSLS/main/Run.ps1"

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $SelfURL -OutFile $TempInstaller -UseBasicParsing
        Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempInstaller`""
        Exit
    } catch {
        Write-Error "Falha ao reiniciar como admin. Por favor, abra o PowerShell como Administrador e tente novamente."
        Exit
    }
}

# Configurações de Caminho
$InstallDir = "C:\SSLS"
$TempDir = Join-Path $env:TEMP "SSLS_Installer_$(Get-Random)"

Write-Host "`n=== Instalação do SSLS ===`n" -ForegroundColor Cyan

# --- 1. Preparação (Limpeza) ---
Write-Host " [1/5] Preparando diretório C:\SSLS..." -ForegroundColor White
if (Test-Path $InstallDir) {
    try {
        Remove-Item $InstallDir -Recurse -Force -ErrorAction Stop
    } catch {
        Write-Warning "Não foi possível remover arquivos antigos. Tente fechar programas que estejam usando a pasta C:\SSLS."
        Exit
    }
}
New-Item -Path $InstallDir -ItemType Directory -Force | Out-Null
New-Item -Path $TempDir -ItemType Directory -Force | Out-Null

# --- 2. Download ---
Write-Host " [2/5] Baixando repositório..." -ForegroundColor White
$RepoZipUrl = "https://github.com/realsnywy/SSLS/archive/refs/heads/main.zip"
$ZipPath = Join-Path $TempDir "SSLS.zip"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Invoke-WebRequest -Uri $RepoZipUrl -OutFile $ZipPath -UseBasicParsing
} catch {
    Write-Error "Erro no download. Verifique sua conexão."
    Exit
}

# --- 3. Extração e Instalação ---
Write-Host " [3/5] Extraindo arquivos..." -ForegroundColor White
Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force

# Move apenas o conteúdo da pasta 'src' para 'C:\SSLS'
$ExtractedSrc = Join-Path $TempDir "SSLS-main\src"

if (Test-Path $ExtractedSrc) {
    Get-ChildItem -Path $ExtractedSrc | Move-Item -Destination $InstallDir -Force
} else {
    Write-Error "Estrutura do repositório inválida: pasta 'src' não encontrada dentro do ZIP."
    Exit
}

# --- 4. Configuração do Atalho ---
Write-Host " [4/5] Configurando atalho..." -ForegroundColor White
$ShortcutSource = Join-Path $InstallDir "SSLS.lnk"
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutDest = Join-Path $DesktopPath "SSLS.lnk"

# Remove atalho antigo da desktop se existir
if (Test-Path $ShortcutDest) { Remove-Item $ShortcutDest -Force }

if (Test-Path $ShortcutSource) {
    # Move o arquivo .lnk existente
    Move-Item -Path $ShortcutSource -Destination $ShortcutDest -Force

    # Tenta corrigir o caminho do atalho para o novo local (C:\SSLS\SSLS.ps1)
    try {
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($ShortcutDest)
        $Shortcut.TargetPath = "powershell.exe"
        # Configura para rodar invisível/bypass se necessário, ou direto pro arquivo via args
        $Shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"C:\SSLS\SSLS.ps1`""
        $Shortcut.WorkingDirectory = "C:\SSLS"
        $Shortcut.IconLocation = "C:\SSLS\icon.ico"
        $Shortcut.Save()
    } catch {
        Write-Warning "Falha ao atualizar as propriedades do atalho. Ele pode não funcionar corretamente."
    }
} else {
    # Se não houver atalho no repo, cria um novo
    Write-Warning "Atalho 'SSLS.lnk' não encontrado no pacote. Criando um novo..."
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutDest)
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"C:\SSLS\SSLS.ps1`""
    $Shortcut.WorkingDirectory = "C:\SSLS"
    $Shortcut.Save()
}

# --- 5. Limpeza Final e Execução ---
Write-Host " [5/5] Iniciando..." -ForegroundColor Green
Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue

$MainScript = Join-Path $InstallDir "SSLS.ps1"
if (Test-Path $MainScript) {
    & $MainScript
} else {
    Write-Error "Erro crítico: $MainScript não encontrado após instalação."
}
