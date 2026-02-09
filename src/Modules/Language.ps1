<#
    Módulo: Language.ps1
    Descrição: Gerencia a localização (tradução) do SSLS.
    Funções: Carregar JSON, Obter textos (Get-Text), Trocar idioma.
#>

# Inicializa o idioma padrão se ainda não definido
if (-not $Global:CurrentLanguage) {
    $Global:CurrentLanguage = "pt-BR"
}

# ==========================================
# Carregamento do Arquivo de Dados
# ==========================================

# Define o caminho do arquivo JSON se ainda não estiver definido
if (-not $Global:LanguageJSONPath) {
    # Caminho relativo seguro (baseado na localização deste script)
    $Global:LanguageJSONPath = Join-Path $PSScriptRoot "..\Data\Languages.json"
}

# Tenta carregar o conteúdo do JSON
if (Test-Path $Global:LanguageJSONPath) {
    try {
        $Global:LanguageData = Get-Content -Path $Global:LanguageJSONPath -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        Write-Host "Erro Crítico: Falha ao ler o arquivo JSON de idiomas." -ForegroundColor Red
        $Global:LanguageData = @{}
    }
} else {
    Write-Host "Erro Crítico: Arquivo de idiomas não encontrado em $Global:LanguageJSONPath" -ForegroundColor Red
    $Global:LanguageData = @{}
}

# ==========================================
# Funções Públicas
# ==========================================

<#
    .SYNOPSIS
    Retorna o texto traduzido para a chave especificada.
#>
function Get-Text {
    param([string]$Key)

    # Tenta obter a tradução no idioma atual
    if ($Global:LanguageData.$($Global:CurrentLanguage).$Key) {
        return $Global:LanguageData.$($Global:CurrentLanguage).$Key
    }

    # Fallback: Tenta obter em pt-BR se falhar
    if ($Global:LanguageData."pt-BR".$Key) {
        return $Global:LanguageData."pt-BR".$Key
    }

    # Último recurso: Retorna a chave entre colchetes para indicar erro
    return "[$Key]"
}

<#
    .SYNOPSIS
    Define o idioma atual da sessão.
#>
function Set-Language {
    param([string]$LangCode)
    $Global:CurrentLanguage = $LangCode
}

<#
    .SYNOPSIS
    Lista os códigos de idiomas disponíveis no JSON.
#>
function Get-AvailableLanguages {
    if ($Global:LanguageData) {
        return $Global:LanguageData.PSObject.Properties.Name
    }
    return @("pt-BR")
}
