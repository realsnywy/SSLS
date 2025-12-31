# Modules/Language.ps1

# Variável global para armazenar o idioma atual
if (-not $Global:CurrentLanguage) {
    $Global:CurrentLanguage = "pt-BR"
}

# Carregar dados de idioma
$LanguageFilePath = Join-Path $PSScriptRoot "..\Data\Languages.json"
if (Test-Path $LanguageFilePath) {
    $Global:LanguageData = Get-Content -Path $LanguageFilePath -Raw | ConvertFrom-Json
} else {
    Write-Host "Erro: Arquivo de idiomas não encontrado em $LanguageFilePath" -ForegroundColor Red
    $Global:LanguageData = @{}
}

function Get-Text {
    param(
        [string]$Key
    )

    if ($Global:LanguageData.$($Global:CurrentLanguage).$Key) {
        return $Global:LanguageData.$($Global:CurrentLanguage).$Key
    }

    # Fallback para pt-BR se não encontrar
    if ($Global:LanguageData."pt-BR".$Key) {
        return $Global:LanguageData."pt-BR".$Key
    }

    return "[$Key]"
}

function Set-Language {
    param(
        [string]$LangCode
    )
    $Global:CurrentLanguage = $LangCode
}

function Get-AvailableLanguages {
    if ($Global:LanguageData) {
        return $Global:LanguageData.PSObject.Properties.Name
    }
    return @("pt-BR")
}
