<#
    Módulo: Welcome.ps1
    Descrição: Renderiza a aba de boas-vindas com o logo e título.
#>

function Initialize-WelcomeTab {
    param(
        $ParentPanel,  # Painel onde o conteúdo será desenhado
        $ColorText,    # Cor do texto principal
        $ColorAccent   # Cor de destaque (títulos)
    )

    # Limpa controles antigos para evitar duplicação em trocas de idioma
    $ParentPanel.Controls.Clear()

    # --- Ícone do App ---
    # Tenta carregar o ícone local para exibição
    $IconPath = Join-Path $PSScriptRoot "..\icon.ico"
    if (Test-Path $IconPath) {
        $PbIcon = New-Object System.Windows.Forms.PictureBox
        $PbIcon.Image = [System.Drawing.Image]::FromFile($IconPath)
        $PbIcon.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $PbIcon.Size = New-Object System.Drawing.Size(64, 64)
        $PbIcon.Location = New-Object System.Drawing.Point(30, 30)
        $ParentPanel.Controls.Add($PbIcon)
    }

    # --- Título Principal ---
    $LblTitle = New-Object System.Windows.Forms.Label
    $LblTitle.Text = Get-Text "WelcomeTitle"
    $LblTitle.AutoSize = $true
    $LblTitle.Location = New-Object System.Drawing.Point(30, 100)
    $LblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
    $LblTitle.ForeColor = $ColorAccent

    # --- Descrição ---
    $LblDesc = New-Object System.Windows.Forms.Label
    $LblDesc.Text = Get-Text "WelcomeDesc"
    $LblDesc.AutoSize = $true
    $LblDesc.Location = New-Object System.Drawing.Point(35, 160)
    $LblDesc.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $LblDesc.ForeColor = $ColorText

    # Adiciona os controles ao painel
    $ParentPanel.Controls.AddRange(@($LblTitle, $LblDesc))
}
