<#
    Módulo: Shortcuts.ps1
    Descrição: Gerencia a aba de atalhos rápidos para configurações do Windows.
#>

# ==========================================
# Lista de Atalhos
# ==========================================
# Define comandos rápidos para abrir partes profundas do Painel de Configurações
function Get-ShortcutsList {
    return @(
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutDefaultApps"); Comando = "start ms-settings:defaultapps" },
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutActivation");  Comando = "start ms-settings:activation" },
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutTaskbar");     Comando = "start ms-settings:taskbar" },
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutGraphics");    Comando = "start ms-settings:display-advancedgraphics" },
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutColors");      Comando = "start ms-settings:colors" },
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutDateTime");    Comando = "start ms-settings:dateandtime" },
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutLanguage");    Comando = "start ms-settings:regionlanguage" },
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutPrivacy");     Comando = "start ms-settings:privacy" },
        [PSCustomObject]@{ Nome = (Get-Text "ShortcutRegion");      Comando = "start ms-settings:region" }
    )
}

# Inicializa a lista globalmente
$Global:ShortcutsList = Get-ShortcutsList

# ==========================================
# Interface Gráfica
# ==========================================

function Initialize-ShortcutsTab {
    param(
        $ParentPanel,
        $ColorBG,
        $ColorButton,
        $ColorText,
        $ColorAccent
    )

    # Limpa controles anteriores
    $ParentPanel.Controls.Clear()

    # Container de fluxo (FlowLayoutPanel) para organizar os botões automaticamente
    $ShortcutsFlow = New-Object System.Windows.Forms.FlowLayoutPanel
    $ShortcutsFlow.Dock = "Fill"
    $ShortcutsFlow.AutoScroll = $true
    $ShortcutsFlow.Padding = New-Object System.Windows.Forms.Padding(20)
    $ShortcutsFlow.BackColor = $ColorBG

    # Ordena alfabeticamente para facilitar a busca visual
    $SortedShortcuts = $Global:ShortcutsList | Sort-Object Nome

    foreach ($sc in $SortedShortcuts) {
        $btn = New-Object System.Windows.Forms.Button
        $btn.Text = $sc.Nome

        # Estilo do botão
        $btn.Size = New-Object System.Drawing.Size(200, 60)
        $btn.Margin = New-Object System.Windows.Forms.Padding(10)
        $btn.BackColor = $ColorButton
        $btn.ForeColor = $ColorText
        $btn.FlatStyle = "Flat"
        $btn.FlatAppearance.BorderColor = $ColorAccent
        $btn.FlatAppearance.BorderSize = 1
        $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $btn.Cursor = [System.Windows.Forms.Cursors]::Hand

        # Guarda o objeto do atalho na tag do botão para uso no clique
        $btn.Tag = $sc

        $btn.Add_Click({
            $s = $this.Tag
            try {
                # Executa o comando MS-Settings
                Invoke-Expression $s.Comando
            }
            catch {
                [System.Windows.Forms.MessageBox]::Show("Erro ao abrir atalho: $_", "Erro")
            }
        })

        $ShortcutsFlow.Controls.Add($btn)
    }

    $ParentPanel.Controls.Add($ShortcutsFlow)
}
