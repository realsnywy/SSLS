<#
    SSLS - Uninstaller
    Remove a pasta C:\SSLS e o atalho da Área de Trabalho.
    Uso: irm https://raw.githubusercontent.com/realsnywy/SSLS/main/Uninstall.ps1 | iex
#>

$ErrorActionPreference = "Stop"

# --- Verificação de Admin ---
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host " [!] O desinstalador precisa de privilégios de Administrador." -ForegroundColor Yellow
    Write-Host "     Reiniciando processo como Administrador..." -ForegroundColor Yellow

    $TempUninstaller = "$env:TEMP\SSLS_WebUninstall.ps1"
    $SelfURL = "https://raw.githubusercontent.com/realsnywy/SSLS/main/Uninstall.ps1"

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $SelfURL -OutFile $TempUninstaller -UseBasicParsing
        Start-Process PowerShell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempUninstaller`""
        Exit
    } catch {
        Write-Error "Falha ao reiniciar como admin."
        Exit
    }
}

Write-Host "`n=== Desinstalação do SSLS ===`n" -ForegroundColor Red

# 1. Remover pasta de instalação
if (Test-Path "C:\SSLS") {
    Write-Host " Removendo arquivos (C:\SSLS)..." -ForegroundColor White
    try {
        Remove-Item "C:\SSLS" -Recurse -Force -ErrorAction Stop
        Write-Host " Pasta removida." -ForegroundColor Green
    } catch {
        Write-Error "Falha ao remover C:\SSLS. Verifique se o programa está aberto."
    }
} else {
    Write-Host " Pasta C:\SSLS não encontrada." -ForegroundColor Gray
}

# 2. Remover atalho da Desktop
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutDest = Join-Path $DesktopPath "SSLS.lnk"

if (Test-Path $ShortcutDest) {
    Write-Host " Removendo atalho da Área de Trabalho..." -ForegroundColor White
    Remove-Item $ShortcutDest -Force
    Write-Host " Atalho removido." -ForegroundColor Green
} else {
    Write-Host " Atalho não encontrado." -ForegroundColor Gray
}

Write-Host "`n Desinstalação concluída com sucesso!" -ForegroundColor Green
Start-Sleep -Seconds 3
