<#
    Snywy's Silly Little Script (SSLS)
    Arquivo Principal: SSLS.ps1
    Descrição: Gerenciador de pós-instalação do Windows.
#>

# Configura a codificação do console para UTF-8 corrigindo a exibição de caracteres especiais na interface
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ==========================================
# 1. PERMISSÕES E DEPENDÊNCIAS
# ==========================================

# O script precisa rodar como Administrador para instalar programas e modificar o sistema.
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs -WindowStyle Hidden -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

# Verifica se o Winget (gerenciador de pacotes) está instalado. Se não, instalamos ele.
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "Winget não encontrado. Iniciando instalação automática..." -ForegroundColor Cyan
    try {
        $WingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        $WingetPath = "$env:TEMP\winget.msixbundle"
        Invoke-WebRequest -Uri $WingetUrl -OutFile $WingetPath -UseBasicParsing
        Add-AppxPackage -Path $WingetPath
        Remove-Item -Path $WingetPath -Force -ErrorAction SilentlyContinue
        Write-Host "Winget instalado com sucesso!" -ForegroundColor Green
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Não foi possível instalar o Winget. Verifique sua conexão.", "Erro Crítico")
        Exit
    }
}

# Carrega as bibliotecas visuais do Windows (Forms e Drawing)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Código C# utilitário para:
# 1. Esconder a janela preta do console;
# 2. Deixar a barra de título escura;
# 3. Corrigir desfoque em telas de alta resolução (DPI).
if (-not ([System.Management.Automation.PSTypeName]'WindowUtils').Type) {
    $WindowUtilsCode = @"
using System;
using System.Runtime.InteropServices;
public class WindowUtils {
    [DllImport("dwmapi.dll", PreserveSig = true)]
    public static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int attrValue, int attrSize);

    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();

    public static void SetDarkTitleBar(IntPtr hwnd) {
        int useDarkMode = 1;
        DwmSetWindowAttribute(hwnd, 20, ref useDarkMode, sizeof(int));
    }

    public static void HideConsole() {
        IntPtr hwnd = GetConsoleWindow();
        if (hwnd != IntPtr.Zero) { ShowWindow(hwnd, 0); }
    }
}
"@
    Add-Type -TypeDefinition $WindowUtilsCode -Language CSharp
}

# Aplica as configurações do sistema
[WindowUtils]::HideConsole()
try { [WindowUtils]::SetProcessDPIAware() } catch {}

# ==========================================
# 2. CARREGAMENTO DE MÓDULOS E IDIOMAS
# ==========================================

$ModulesPath = Join-Path $PSScriptRoot "Modules"
$Global:LanguageJSONPath = Join-Path $PSScriptRoot "Data\Languages.json"

# Carrega o sistema de idiomas primeiro
$LanguageFile = Join-Path $ModulesPath "Language.ps1"
if (Test-Path $LanguageFile) {
    . $LanguageFile
} else {
    [System.Windows.Forms.MessageBox]::Show("Arquivo essencial 'Language.ps1' não encontrado.", "Erro Fatal")
    Exit
}

# Carrega os outros módulos (GUI das abas, lógica de software, etc)
Get-ChildItem -Path $ModulesPath -Filter "*.ps1" | Where-Object { $_.Name -ne "Language.ps1" } | ForEach-Object {
    try { . $_.FullName } catch { [System.Windows.Forms.MessageBox]::Show("Falha ao carregar módulo: $($_.Name)", "Aviso") }
}

# ==========================================
# 3. ESTILO VISUAL (CORES E FONTES)
# ==========================================

# Paleta de Cores (Tema Escuro)
$ColorBG       = [System.Drawing.ColorTranslator]::FromHtml("#2d2d2d") # Fundo Principal
$ColorPanel    = [System.Drawing.ColorTranslator]::FromHtml("#383838") # Painéis
$ColorButton   = [System.Drawing.ColorTranslator]::FromHtml("#454545") # Botões normais
$ColorText     = [System.Drawing.ColorTranslator]::FromHtml("#e5e5e5") # Texto
$ColorAccent   = [System.Drawing.ColorTranslator]::FromHtml("#84fec5") # Destaque (Verde menta)
$ColorGreen    = [System.Drawing.ColorTranslator]::FromHtml("#34a853") # Botão Iniciar
$ColorRed      = [System.Drawing.ColorTranslator]::FromHtml("#ea4335") # Botão Desfazer

# Fontes Padrão
$FontMain      = New-Object System.Drawing.Font("Segoe UI", 9)
$FontBold      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$FontButton    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

# ==========================================
# 4. CONSTRUÇÃO DA INTERFACE (GUI)
# ==========================================

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "SSLS - Snywy's Silly Little Script"
$Form.Size = New-Object System.Drawing.Size(1150, 750)
$Form.MinimumSize = New-Object System.Drawing.Size(950, 600)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $ColorBG
$Form.ForeColor = $ColorText
$Form.Font = $FontMain

# Ícone do App
$IconPath = "$PSScriptRoot\icon.ico"
if (Test-Path $IconPath) { try { $Form.Icon = New-Object System.Drawing.Icon($IconPath) } catch {} }

# --- Estrutura de Painéis ---
$TopPanel = New-Object System.Windows.Forms.Panel
$TopPanel.Dock = "Top"
$TopPanel.Height = 35
$TopPanel.BackColor = $ColorBG

$ContentPanel = New-Object System.Windows.Forms.Panel
$ContentPanel.Dock = "Fill"
$ContentPanel.BackColor = $ColorBG

$BottomPanel = New-Object System.Windows.Forms.Panel
$BottomPanel.Dock = "Bottom"
$BottomPanel.Height = 80
$BottomPanel.BackColor = $ColorPanel

# --- Navegação (Botões das Abas) ---
function New-TabButton {
    param($Text, $X)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $Text
    $btn.Size = New-Object System.Drawing.Size(180, 35)
    $btn.Location = New-Object System.Drawing.Point($X, 0)
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = $ColorBG
    $btn.ForeColor = [System.Drawing.Color]::Gray
    $btn.Font = $FontMain
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $btn
}

$BtnTabWelcome = New-TabButton -Text (Get-Text "TabWelcome") -X 0
$BtnTab1       = New-TabButton -Text (Get-Text "TabPrograms") -X 180
$BtnTab2       = New-TabButton -Text (Get-Text "TabTweaks")   -X 360
$BtnTab4       = New-TabButton -Text (Get-Text "TabShortcuts") -X 540
$BtnTab3       = New-TabButton -Text (Get-Text "TabExtras")    -X 720

$TopPanel.Controls.AddRange(@($BtnTabWelcome, $BtnTab1, $BtnTab2, $BtnTab3, $BtnTab4))

# --- Seletor de Idioma ---
$CmbLanguage = New-Object System.Windows.Forms.ComboBox
$CmbLanguage.DropDownStyle = "DropDownList"
$CmbLanguage.Size = New-Object System.Drawing.Size(80, 25)
$CmbLanguage.Location = New-Object System.Drawing.Point(1000, 5)
$CmbLanguage.FlatStyle = "Flat"
$CmbLanguage.BackColor = $ColorButton
$CmbLanguage.ForeColor = $ColorText
$CmbLanguage.Font = $FontMain

$AvailableLanguages = Get-AvailableLanguages
foreach ($lang in $AvailableLanguages) { $CmbLanguage.Items.Add($lang) | Out-Null }
$CmbLanguage.SelectedItem = $Global:CurrentLanguage

# Evento: Quando o idioma muda, precisamos redesenhar tudo
$CmbLanguage.Add_SelectedIndexChanged({
    $NewLang = $CmbLanguage.SelectedItem
    if ($NewLang -ne $Global:CurrentLanguage) {
        Set-Language $NewLang

        # Atualiza títulos
        $BtnTabWelcome.Text = Get-Text "TabWelcome"
        $BtnTab1.Text = Get-Text "TabPrograms"
        $BtnTab2.Text = Get-Text "TabTweaks"
        $BtnTab4.Text = Get-Text "TabShortcuts"
        $BtnTab3.Text = Get-Text "TabExtras"

        # Reseta as listas e limpa a memória visual
        $Global:SoftwareList = Get-SoftwareList
        $Global:TweaksList = Get-TweaksList
        $Global:ShortcutsList = Get-ShortcutsList
        $Global:SoftCheckBoxes = @()
        $Global:TweakGrid = $null

        $TabWelcome.Controls.Clear()
        $TabSoft.Controls.Clear()
        $TabTweak.Controls.Clear()
        $TabShortcuts.Controls.Clear()
        $TabExtra.Controls.Clear()

        # Recria o conteúdo de cada aba
        Initialize-WelcomeTab -ParentPanel $TabWelcome -ColorText $ColorText -ColorAccent $ColorAccent
        Initialize-SoftwareTab -ParentPanel $TabSoft -ColorBG $ColorBG -ColorAccent $ColorAccent -ColorText $ColorText
        Initialize-TweaksTab -ParentPanel $TabTweak -ColorPanel $ColorPanel -ColorText $ColorText -ColorBG $ColorBG -ColorAccent $ColorAccent -ColorButton $ColorButton
        Initialize-ShortcutsTab -ParentPanel $TabShortcuts -ColorBG $ColorBG -ColorButton $ColorButton -ColorText $ColorText -ColorAccent $ColorAccent
        Initialize-ExtrasTab -ParentPanel $TabExtra -ColorPanel $ColorPanel -ColorText $ColorText -ColorButton $ColorButton -ColorAccent $ColorAccent

        # Atualiza botões do rodapé
        if ($BtnApply) { $BtnApply.Text = Get-Text "BtnStart" }
        if ($BtnRevert) { $BtnRevert.Text = Get-Text "BtnUndo" }
        if ($ChkRestore) { $ChkRestore.Text = Get-Text "ChkRestorePoint" }
        if ($StatusLabel) { $StatusLabel.Text = Get-Text "StatusWaiting" }
    }
})
$TopPanel.Controls.Add($CmbLanguage)

# --- Criação dos Painéis de Conteúdo (Páginas) ---
$TabWelcome = New-Object System.Windows.Forms.Panel; $TabWelcome.Dock="Fill"; $TabWelcome.BackColor=$ColorBG; $TabWelcome.Visible=$true
$TabSoft    = New-Object System.Windows.Forms.Panel; $TabSoft.Dock="Fill";    $TabSoft.BackColor=$ColorBG;    $TabSoft.Visible=$false
$TabTweak   = New-Object System.Windows.Forms.Panel; $TabTweak.Dock="Fill";   $TabTweak.BackColor=$ColorBG;   $TabTweak.Visible=$false
$TabExtra   = New-Object System.Windows.Forms.Panel; $TabExtra.Dock="Fill";   $TabExtra.BackColor=$ColorBG;   $TabExtra.Visible=$false
$TabShortcuts = New-Object System.Windows.Forms.Panel; $TabShortcuts.Dock="Fill"; $TabShortcuts.BackColor=$ColorBG; $TabShortcuts.Visible=$false

$ContentPanel.Controls.AddRange(@($TabWelcome, $TabSoft, $TabTweak, $TabExtra, $TabShortcuts))

# Lógica de troca de abas
$SwitchTab = {
    param($ActiveBtn, $ActivePanel)
    # Reseta o estilo de todos os botões
    $BtnTabWelcome, $BtnTab1, $BtnTab2, $BtnTab3, $BtnTab4 | ForEach-Object {
        $_.BackColor = $ColorBG
        $_.ForeColor = [System.Drawing.Color]::Gray
        $_.Font = $FontMain
    }
    # Esconde todos os painéis
    $TabWelcome.Visible = $false; $TabSoft.Visible = $false; $TabTweak.Visible = $false; $TabExtra.Visible = $false; $TabShortcuts.Visible = $false

    # Ativa o escolhido
    $ActiveBtn.BackColor = $ColorPanel
    $ActiveBtn.ForeColor = [System.Drawing.Color]::White
    $ActiveBtn.Font = $FontBold
    $ActivePanel.Visible = $true
}

# Conecta os cliques
$BtnTabWelcome.Add_Click({ & $SwitchTab $BtnTabWelcome $TabWelcome })
$BtnTab1.Add_Click({ & $SwitchTab $BtnTab1 $TabSoft })
$BtnTab2.Add_Click({ & $SwitchTab $BtnTab2 $TabTweak })
$BtnTab3.Add_Click({ & $SwitchTab $BtnTab3 $TabExtra })
$BtnTab4.Add_Click({ & $SwitchTab $BtnTab4 $TabShortcuts })

# --- Inicialização do Conteúdo ---
# Carregamos todas as abas no início para que estejam prontas
Initialize-WelcomeTab -ParentPanel $TabWelcome -ColorText $ColorText -ColorAccent $ColorAccent
Initialize-SoftwareTab -ParentPanel $TabSoft -ColorBG $ColorBG -ColorAccent $ColorAccent -ColorText $ColorText
Initialize-TweaksTab -ParentPanel $TabTweak -ColorPanel $ColorPanel -ColorText $ColorText -ColorBG $ColorBG -ColorAccent $ColorAccent -ColorButton $ColorButton
Initialize-ShortcutsTab -ParentPanel $TabShortcuts -ColorBG $ColorBG -ColorButton $ColorButton -ColorText $ColorText -ColorAccent $ColorAccent
Initialize-ExtrasTab -ParentPanel $TabExtra -ColorPanel $ColorPanel -ColorText $ColorText -ColorButton $ColorButton -ColorAccent $ColorAccent

# Define aba inicial
& $SwitchTab $BtnTabWelcome $TabWelcome

# ==========================================
# 5. BARRA INFERIOR E EXECUÇÃO
# ==========================================

# Botão Iniciar (Aplicar)
$BtnApply = New-Object System.Windows.Forms.Button
$BtnApply.Text = (Get-Text "BtnStart")
$BtnApply.Size = New-Object System.Drawing.Size(220, 50)
$BtnApply.Location = New-Object System.Drawing.Point(20, 15)
$BtnApply.BackColor = $ColorGreen
$BtnApply.ForeColor = [System.Drawing.Color]::White
$BtnApply.FlatStyle = "Flat"
$BtnApply.Font = $FontButton
$BtnApply.Cursor = [System.Windows.Forms.Cursors]::Hand

# Botão Desfazer (Restaurar)
$BtnRevert = New-Object System.Windows.Forms.Button
$BtnRevert.Text = (Get-Text "BtnUndo")
$BtnRevert.Size = New-Object System.Drawing.Size(220, 50)
$BtnRevert.Location = New-Object System.Drawing.Point(260, 15)
$BtnRevert.BackColor = $ColorRed
$BtnRevert.ForeColor = [System.Drawing.Color]::White
$BtnRevert.FlatStyle = "Flat"
$BtnRevert.Cursor = [System.Windows.Forms.Cursors]::Hand

# Checkbox Ponto de Restauração
$ChkRestore = New-Object System.Windows.Forms.CheckBox
$ChkRestore.Text = (Get-Text "ChkRestorePoint")
$ChkRestore.AutoSize = $true
$ChkRestore.Location = New-Object System.Drawing.Point(500, 15)
$ChkRestore.ForeColor = $ColorText
$ChkRestore.Font = $FontMain
$ChkRestore.Checked = $true

# Label de Status
$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = (Get-Text "StatusWaiting")
$StatusLabel.AutoSize = $true
$StatusLabel.Location = New-Object System.Drawing.Point(500, 45)
$StatusLabel.ForeColor = [System.Drawing.Color]::Gray
$StatusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)

# Configuração do Logo e Créditos
$LogoUrl = "https://i.imgur.com/pzU4tB4.png"
$SiteUrl = "https://realsnywy.github.io/"
$LogoBox = New-Object System.Windows.Forms.PictureBox
$LogoBox.Size = New-Object System.Drawing.Size(178, 50)
$LogoBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$LogoBox.BackColor = [System.Drawing.Color]::Transparent
$LogoBox.Anchor = [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top
$LogoBox.Location = New-Object System.Drawing.Point(($BottomPanel.Width - 218), 14)
$LogoBox.Cursor = [System.Windows.Forms.Cursors]::Hand

$LogoBox.Add_Click({ try { Start-Process $SiteUrl } catch {} })

# Tenta carregar imagem da web sem travar o script
try { $LogoBox.WaitOnLoad = $false; $LogoBox.LoadAsync($LogoUrl) } catch {}

# Desenha um texto se a imagem falhar (Assinatura)
$LogoBox.Add_Paint({
    param($sender, $e)
    if ($sender.Image -eq $null) {
        $g = $e.Graphics
        $subtleColor = [System.Drawing.Color]::FromArgb(50, 224, 224, 224)
        $brush = New-Object System.Drawing.SolidBrush($subtleColor)
        $txtFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
        $txt = "snywy esteve aqui."
        $sz = $g.MeasureString($txt, $txtFont)
        $g.DrawString($txt, $txtFont, $brush, ($sender.Width - $sz.Width - 5), (($sender.Height - $sz.Height) / 2))
    }
})

$BottomPanel.Controls.AddRange(@($BtnApply, $BtnRevert, $ChkRestore, $StatusLabel, $LogoBox))
$Form.Controls.AddRange(@($ContentPanel, $TopPanel, $BottomPanel))

# ==========================================
# 6. LÓGICA DE EXECUÇÃO (BOTÕES)
# ==========================================

# Ação: Botão INICIAR
$BtnApply.Add_Click({
    $Form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $StatusLabel.Text = (Get-Text "StatusWorking")
    $Form.Refresh()

    # 1. Ponto de Restauração
    if ($ChkRestore.Checked) {
        try {
            Checkpoint-Computer -Description "SSLS Auto Restore Point" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        } catch {
            [System.Windows.Forms.MessageBox]::Show((Get-Text "MsgRestoreError"), "Aviso")
        }
    }

    # 2. Atualizar fontes do Winget (sem interação para não travar)
    try { Start-Process winget -ArgumentList "source update --disable-interactivity" -NoNewWindow -Wait } catch {}

    # 3. Instalar Programas
    $SelectedApps = $Global:SoftCheckBoxes | Where-Object { $_.Checked }
    $Errors = @() # Lista para guardar nomes de programas que falharam

    foreach ($chk in $SelectedApps) {
        $app = $chk.Tag
        $StatusLabel.Text = (Get-Text "StatusInstalling") + " $($app.Nome)"
        $Form.Refresh()

        # Captura o código de saída do Winget
        $Process = Start-Process winget -ArgumentList "install --id $($app.Id) -e --source winget --accept-package-agreements --accept-source-agreements --disable-interactivity" -NoNewWindow -PassThru -Wait

        # Se ExitCode não for 0, houve erro
        if ($Process.ExitCode -ne 0) {
            $Errors += $app.Nome
        }
    }

    # 4. Aplicar Tweaks
    $SelectedTweaks = @()
    if ($Global:TweakGrid) {
        foreach ($row in $Global:TweakGrid.Rows) {
            if ($row.Cells["Check"].Value -eq $true) { $SelectedTweaks += $row.Tag }
        }
    }

    foreach ($tweak in $SelectedTweaks) {
        $StatusLabel.Text = (Get-Text "StatusApplying") + "$($tweak.Nome)"
        $Form.Refresh()
        try { & $tweak.Acao } catch { [System.Windows.Forms.MessageBox]::Show("Erro no Tweak: $($tweak.Nome)") }
    }

    # 5. Reiniciar Explorer se necessário
    if ($SelectedTweaks) {
        Stop-Process -Name explorer -Force
        Start-Sleep -Seconds 1
        if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer }
    }

    $Form.Cursor = [System.Windows.Forms.Cursors]::Default

    if ($Errors.Count -eq 0) {
        $StatusLabel.Text = "Concluído."
        [System.Windows.Forms.MessageBox]::Show("Processo finalizado com sucesso!", "Sucesso", 0, 64)
    } else {
        $StatusLabel.Text = "Concluído com erros."
        $ErrorMsg = "Os seguintes itens falharam ao instalar:`n" + ($Errors -join "`n")
        [System.Windows.Forms.MessageBox]::Show($ErrorMsg, "Atenção", 0, 48) # Ícone de alerta
    }
})

# Ação: Botão DESFAZER
$BtnRevert.Add_Click({
    # Coleta o que está marcado nas abas
    $SelectedTweaks = @()
    if ($Global:TweakGrid) {
        foreach ($row in $Global:TweakGrid.Rows) {
            if ($row.Cells["Check"].Value -eq $true) { $SelectedTweaks += $row.Tag }
        }
    }
    $SelectedApps = @()
    if ($Global:SoftCheckBoxes) {
        $SelectedApps = $Global:SoftCheckBoxes | Where-Object { $_.Checked }
    }

    # Se houver algo selecionado, pedimos confirmação
    if ($SelectedTweaks.Count -gt 0 -or $SelectedApps.Count -gt 0) {
        if ([System.Windows.Forms.MessageBox]::Show((Get-Text "BtnUndo") + "?", "Confirmar Desfazer", 4) -eq "Yes") {

            # Desinstala softwares selecionados
            foreach ($chk in $SelectedApps) {
                $app = $chk.Tag
                $StatusLabel.Text = "Desinstalando: $($app.Nome)"
                $Form.Refresh()
                Start-Process winget -ArgumentList "uninstall --id $($app.Id) -e --source winget --accept-source-agreements --disable-interactivity" -NoNewWindow -PassThru -Wait
            }

            # Reverte tweaks selecionados
            foreach ($tweak in $SelectedTweaks) {
                $StatusLabel.Text = "Restaurando: $($tweak.Nome)"
                $Form.Refresh()
                try { & $tweak.Desfazer } catch {}
            }

            if ($SelectedTweaks.Count -gt 0) {
                Stop-Process -Name explorer -Force
                Start-Sleep -Seconds 1
                if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer }
            }

            $StatusLabel.Text = "Concluído."
            [System.Windows.Forms.MessageBox]::Show("Processo desfeito com sucesso!", "Sucesso", 0, 64)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Selecione os programas ou tweaks que deseja remover/desfazer.", "Nada Selecionado")
    }
})

# Inicia o formulário
$Form.Add_Shown({
    $Form.Activate()
    try { [WindowUtils]::SetDarkTitleBar($Form.Handle) } catch {}
})

# ==========================================
# 6. CHECAGEM DE ATALHO (PÓS-INIT)
[void]$Form.ShowDialog()
