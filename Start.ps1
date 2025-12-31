<#
    Snywy's Silly Little Script (Custom Colors)
    Arquivo: Start.ps1
#>

# --- 1. Verificação de administrador ---
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs -WindowStyle Hidden -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

# --- 2. Verificação e instalação do Winget ---
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "Winget não detectado. Baixando e instalando..." -ForegroundColor Cyan
    try {
        $WingetUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        $WingetPath = "$env:TEMP\winget.msixbundle"
        Invoke-WebRequest -Uri $WingetUrl -OutFile $WingetPath -UseBasicParsing
        Add-AppxPackage -Path $WingetPath
        Remove-Item -Path $WingetPath -Force -ErrorAction SilentlyContinue
        Write-Host "Winget instalado com sucesso!" -ForegroundColor Green
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Erro crítico: Não foi possível instalar o Winget automaticamente.`nErro: $_", "Erro")
        Exit
    }
}

# --- 3. Carregar bibliotecas visuais ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Adicionando suporte a Dark Mode e ocultação do console
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

    public static void SetDarkTitleBar(IntPtr hwnd) {
        int useDarkMode = 1;
        DwmSetWindowAttribute(hwnd, 20, ref useDarkMode, sizeof(int));
    }

    public static void HideConsole() {
        IntPtr hwnd = GetConsoleWindow();
        if (hwnd != IntPtr.Zero) {
            ShowWindow(hwnd, 0); // 0 = SW_HIDE
        }
    }
}
"@
Add-Type -TypeDefinition $WindowUtilsCode -Language CSharp
[WindowUtils]::HideConsole()

# --- 4. Carregar módulos ---
$ScriptPath = $PSScriptRoot
$ExtrasFile   = Join-Path $ScriptPath "Modules\Extras.ps1"
$ShortcutsFile = Join-Path $ScriptPath "Modules\Shortcuts.ps1"
$SoftwareFile = Join-Path $ScriptPath "Modules\Software.ps1"
$TweaksFile   = Join-Path $ScriptPath "Modules\Tweaks.ps1"
$WelcomeFile  = Join-Path $ScriptPath "Modules\Welcome.ps1"


if (Test-Path $ExtrasFile)   { . $ExtrasFile }   else { [System.Windows.Forms.MessageBox]::Show("Erro: Extras.ps1 faltando!", "Erro"); Exit }
if (Test-Path $ShortcutsFile) { . $ShortcutsFile } else { [System.Windows.Forms.MessageBox]::Show("Erro: Shortcuts.ps1 faltando!", "Erro"); Exit }
if (Test-Path $SoftwareFile) { . $SoftwareFile } else { [System.Windows.Forms.MessageBox]::Show("Erro: Software.ps1 faltando!", "Erro"); Exit }
if (Test-Path $TweaksFile)   { . $TweaksFile }   else { [System.Windows.Forms.MessageBox]::Show("Erro: Tweaks.ps1 faltando!", "Erro"); Exit }
if (Test-Path $WelcomeFile)  { . $WelcomeFile }  else { [System.Windows.Forms.MessageBox]::Show("Erro: Welcome.ps1 faltando!", "Erro"); Exit }


# --- 5. Configuração de cores (Atualizado) ---
$ColorBG       = [System.Drawing.ColorTranslator]::FromHtml("#2d2d2d")
$ColorPanel    = [System.Drawing.ColorTranslator]::FromHtml("#383838")
$ColorButton   = [System.Drawing.ColorTranslator]::FromHtml("#454545")

# Novas cores solicitadas
$ColorText     = [System.Drawing.ColorTranslator]::FromHtml("#e5e5e5") # Texto claro
$ColorGreen    = [System.Drawing.ColorTranslator]::FromHtml("#34a853") # Botão iniciar
$ColorRed      = [System.Drawing.ColorTranslator]::FromHtml("#ea4335") # Botão desfazer

# Mantendo o Mint como destaque (ou mude se quiser)
$ColorAccent   = [System.Drawing.ColorTranslator]::FromHtml("#84fec5")

# --- 6. Interface gráfica ---

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "SSLS - Snywy's Silly Little Script"

# Ícone
$IconPath = "$PSScriptRoot\icon.ico"
if (Test-Path $IconPath) {
    try { $Form.Icon = New-Object System.Drawing.Icon($IconPath) } catch {}
}

$Form.Size = New-Object System.Drawing.Size(1150, 750)
$Form.MinimumSize = New-Object System.Drawing.Size(950, 600)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $ColorBG
$Form.ForeColor = $ColorText
$Form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# --- Sistema de abas (customizado) ---
$TopPanel = New-Object System.Windows.Forms.Panel
$TopPanel.Dock = "Top"
$TopPanel.Height = 35
$TopPanel.BackColor = $ColorBG

$ContentPanel = New-Object System.Windows.Forms.Panel
$ContentPanel.Dock = "Fill"
$ContentPanel.BackColor = $ColorBG

# Função para criar botões de aba
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
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $btn
}

$BtnTabWelcome = New-TabButton -Text "Início" -X 0
$BtnTab1 = New-TabButton -Text "Programas" -X 180
$BtnTab2 = New-TabButton -Text "Otimizações" -X 360
$BtnTab4 = New-TabButton -Text "Atalhos" -X 540
$BtnTab3 = New-TabButton -Text "Extras" -X 720

$TopPanel.Controls.AddRange(@($BtnTabWelcome, $BtnTab1, $BtnTab2, $BtnTab3, $BtnTab4))

# Páginas (Agora são painéis)
$TabWelcome = New-Object System.Windows.Forms.Panel
$TabWelcome.Dock = "Fill"
$TabWelcome.BackColor = $ColorBG
$TabWelcome.Visible = $true

$TabSoft = New-Object System.Windows.Forms.Panel
$TabSoft.Dock = "Fill"
$TabSoft.BackColor = $ColorBG
$TabSoft.Visible = $false

$TabTweak = New-Object System.Windows.Forms.Panel
$TabTweak.Dock = "Fill"
$TabTweak.BackColor = $ColorBG
$TabTweak.Visible = $false

$TabExtra = New-Object System.Windows.Forms.Panel
$TabExtra.Dock = "Fill"
$TabExtra.BackColor = $ColorBG
$TabExtra.Visible = $false

$TabShortcuts = New-Object System.Windows.Forms.Panel
$TabShortcuts.Dock = "Fill"
$TabShortcuts.BackColor = $ColorBG
$TabShortcuts.Visible = $false

$ContentPanel.Controls.AddRange(@($TabWelcome, $TabSoft, $TabTweak, $TabExtra, $TabShortcuts))

# Lógica de troca de abas
$SwitchTab = {
    param($ActiveBtn, $ActivePanel)

    # Resetar todos
    $BtnTabWelcome, $BtnTab1, $BtnTab2, $BtnTab3, $BtnTab4 | ForEach-Object {
        $_.BackColor = $ColorBG
        $_.ForeColor = [System.Drawing.Color]::Gray
        $_.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    }
    $TabWelcome.Visible = $false
    $TabSoft.Visible = $false
    $TabTweak.Visible = $false
    $TabExtra.Visible = $false
    $TabShortcuts.Visible = $false

    # Ativar selecionado
    $ActiveBtn.BackColor = $ColorPanel
    $ActiveBtn.ForeColor = [System.Drawing.Color]::White
    $ActiveBtn.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $ActivePanel.Visible = $true
}

$BtnTabWelcome.Add_Click({ & $SwitchTab $BtnTabWelcome $TabWelcome })
$BtnTab1.Add_Click({ & $SwitchTab $BtnTab1 $TabSoft })
$BtnTab2.Add_Click({ & $SwitchTab $BtnTab2 $TabTweak })
$BtnTab3.Add_Click({ & $SwitchTab $BtnTab3 $TabExtra })
$BtnTab4.Add_Click({ & $SwitchTab $BtnTab4 $TabShortcuts })

# Inicializar primeira aba
& $SwitchTab $BtnTabWelcome $TabWelcome

# --- Aba 0: Welcome ---
Initialize-WelcomeTab -ParentPanel $TabWelcome -ColorText $ColorText -ColorAccent $ColorAccent

# --- Aba 1: Software ---
$FlowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$FlowPanel.Dock = "Fill"
$FlowPanel.AutoScroll = $true
$FlowPanel.FlowDirection = "TopDown"
$FlowPanel.WrapContents = $true
$FlowPanel.BackColor = $ColorBG

$Categories = $Global:SoftwareList | Select-Object -ExpandProperty Categoria -Unique | Sort-Object
$SoftCheckBoxes = @()

foreach ($cat in $Categories) {
    $GroupBox = New-Object System.Windows.Forms.GroupBox
    $GroupBox.Text = " $cat "
    $GroupBox.AutoSize = $true
    $GroupBox.ForeColor = $ColorAccent
    $GroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $GroupBox.Margin = New-Object System.Windows.Forms.Padding(10, 10, 10, 20)
    $GroupBox.Padding = New-Object System.Windows.Forms.Padding(5)

    $GroupPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $GroupPanel.FlowDirection = "TopDown"
    $GroupPanel.AutoSize = $true
    $GroupPanel.Dock = "Fill"

    $Items = $Global:SoftwareList | Where-Object { $_.Categoria -eq $cat }
    foreach ($item in $Items) {
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Text = $item.Nome
        $cb.Tag = $item
        $cb.AutoSize = $true
        $cb.ForeColor = $ColorText
        $cb.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
        $SoftCheckBoxes += $cb
        $GroupPanel.Controls.Add($cb)
    }
    $GroupBox.Controls.Add($GroupPanel)
    $FlowPanel.Controls.Add($GroupBox)
}
$TabSoft.Controls.Add($FlowPanel)

# --- Aba 2: Tweaks ---
$TweakGrid = New-Object System.Windows.Forms.DataGridView
$TweakGrid.Dock = "Fill"
$TweakGrid.BackgroundColor = $ColorPanel
$TweakGrid.ForeColor = $ColorText
$TweakGrid.GridColor = [System.Drawing.ColorTranslator]::FromHtml("#505050")
$TweakGrid.BorderStyle = "None"
$TweakGrid.CellBorderStyle = "SingleHorizontal"
$TweakGrid.RowHeadersVisible = $false
$TweakGrid.AllowUserToAddRows = $false
$TweakGrid.AllowUserToDeleteRows = $false
$TweakGrid.AllowUserToResizeRows = $false
$TweakGrid.SelectionMode = "FullRowSelect"
$TweakGrid.MultiSelect = $false
$TweakGrid.ReadOnly = $false

# Estilos
$TweakGrid.DefaultCellStyle.BackColor = $ColorPanel
$TweakGrid.DefaultCellStyle.ForeColor = $ColorText
$TweakGrid.DefaultCellStyle.SelectionBackColor = $ColorButton
$TweakGrid.DefaultCellStyle.SelectionForeColor = $ColorText

$TweakGrid.EnableHeadersVisualStyles = $false
$TweakGrid.ColumnHeadersDefaultCellStyle.BackColor = $ColorBG
$TweakGrid.ColumnHeadersDefaultCellStyle.ForeColor = $ColorAccent
$TweakGrid.ColumnHeadersDefaultCellStyle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$TweakGrid.ColumnHeadersBorderStyle = "None"
$TweakGrid.ColumnHeadersHeight = 35
$TweakGrid.ColumnHeadersHeightSizeMode = "DisableResizing"

# Colunas
$ColCheck = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
$ColCheck.HeaderText = ""
$ColCheck.Width = 30
$ColCheck.Name = "Check"
[void]$TweakGrid.Columns.Add($ColCheck)

$ColName = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$ColName.HeaderText = "Nome"
$ColName.Width = 400
$ColName.Name = "Nome"
$ColName.ReadOnly = $true
[void]$TweakGrid.Columns.Add($ColName)

$ColDesc = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$ColDesc.HeaderText = "Descrição"
$ColDesc.AutoSizeMode = "Fill"
$ColDesc.Name = "Descricao"
$ColDesc.ReadOnly = $true
[void]$TweakGrid.Columns.Add($ColDesc)

foreach ($tweak in $Global:TweaksList) {
    $row = $TweakGrid.Rows.Add()
    $TweakGrid.Rows[$row].Cells["Nome"].Value = $tweak.Nome
    $TweakGrid.Rows[$row].Cells["Descricao"].Value = $tweak.Descricao
    $TweakGrid.Rows[$row].Tag = $tweak
}
$TabTweak.Controls.Add($TweakGrid)

# --- Aba 4: Atalhos ---
$ShortcutsFlow = New-Object System.Windows.Forms.FlowLayoutPanel
$ShortcutsFlow.Dock = "Fill"
$ShortcutsFlow.AutoScroll = $true
$ShortcutsFlow.Padding = New-Object System.Windows.Forms.Padding(20)
$ShortcutsFlow.BackColor = $ColorBG

foreach ($sc in $Global:ShortcutsList) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $sc.Nome
    $btn.Size = New-Object System.Drawing.Size(200, 60)
    $btn.Margin = New-Object System.Windows.Forms.Padding(10)
    $btn.BackColor = $ColorButton
    $btn.ForeColor = $ColorText
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderColor = $ColorAccent
    $btn.FlatAppearance.BorderSize = 1
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.Tag = $sc

    $btn.Add_Click({
        $s = $this.Tag
        try { Invoke-Expression $s.Comando }
        catch { [System.Windows.Forms.MessageBox]::Show("Erro ao abrir atalho: $_", "Erro") }
    })

    $ShortcutsFlow.Controls.Add($btn)
}
$TabShortcuts.Controls.Add($ShortcutsFlow)

# --- Aba 3: Extra ---
Initialize-ExtrasTab -ParentPanel $TabExtra -ColorPanel $ColorPanel -ColorText $ColorText -ColorButton $ColorButton -ColorAccent $ColorAccent

# --- Rodapé ---
$BottomPanel = New-Object System.Windows.Forms.Panel
$BottomPanel.Dock = "Bottom"
$BottomPanel.Height = 80
$BottomPanel.BackColor = $ColorPanel

$BtnApply = New-Object System.Windows.Forms.Button
$BtnApply.Text = "Iniciar processo"
$BtnApply.Size = New-Object System.Drawing.Size(220, 50)
$BtnApply.Location = New-Object System.Drawing.Point(20, 15)
$BtnApply.BackColor = $ColorGreen
$BtnApply.ForeColor = [System.Drawing.Color]::White
$BtnApply.FlatStyle = "Flat"
$BtnApply.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$BtnApply.Cursor = [System.Windows.Forms.Cursors]::Hand

$BtnRevert = New-Object System.Windows.Forms.Button
$BtnRevert.Text = "Desfazer otimizações"
$BtnRevert.Size = New-Object System.Drawing.Size(220, 50)
$BtnRevert.Location = New-Object System.Drawing.Point(260, 15)
$BtnRevert.BackColor = $ColorRed
$BtnRevert.ForeColor = [System.Drawing.Color]::White
$BtnRevert.FlatStyle = "Flat"
$BtnRevert.Cursor = [System.Windows.Forms.Cursors]::Hand

$ChkRestore = New-Object System.Windows.Forms.CheckBox
$ChkRestore.Text = "Criar Ponto de Restauração"
$ChkRestore.AutoSize = $true
$ChkRestore.Location = New-Object System.Drawing.Point(500, 15)
$ChkRestore.ForeColor = $ColorText
$ChkRestore.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$ChkRestore.Checked = $true

$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = "Aguardando seleção..."
$StatusLabel.AutoSize = $true
$StatusLabel.Location = New-Object System.Drawing.Point(500, 45)
$StatusLabel.ForeColor = [System.Drawing.Color]::Gray
$StatusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)

# --- Configuração do logo ---
$LogoMarginRight = 40
$LogoTop         = 14
$LogoUrl = "https://i.imgur.com/pzU4tB4.png"
$SiteUrl = "https://realsnywy.github.io/"

$LogoBox = New-Object System.Windows.Forms.PictureBox
$LogoBox.Size = New-Object System.Drawing.Size(178, 50)
$LogoBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$LogoBox.BackColor = [System.Drawing.Color]::Transparent
$LogoBox.Anchor = [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top
$LogoX = $BottomPanel.Width - $LogoBox.Width - $LogoMarginRight
$LogoBox.Location = New-Object System.Drawing.Point($LogoX, $LogoTop)
$LogoBox.Cursor = [System.Windows.Forms.Cursors]::Hand

$LogoBox.Add_Click({
    try { Start-Process $SiteUrl } catch { [System.Windows.Forms.MessageBox]::Show("Erro ao abrir link.", "Erro") }
})

try {
    $LogoBox.Load($LogoUrl)
} catch {
    # Texto de fallback
    $LogoBox.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics
        $subtleColor = [System.Drawing.Color]::FromArgb(50, 224, 224, 224)
        $brush = New-Object System.Drawing.SolidBrush($subtleColor)
        $font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
        $text = "snywy esteve aqui."
        $textSize = $g.MeasureString($text, $font)
        $x = $sender.Width - $textSize.Width - 5
        $y = ($sender.Height - $textSize.Height) / 2
        $g.DrawString($text, $font, $brush, $x, $y)
    })
    $LogoBox.Invalidate()
}

$BottomPanel.Controls.Add($BtnApply)
$BottomPanel.Controls.Add($BtnRevert)
$BottomPanel.Controls.Add($ChkRestore)
$BottomPanel.Controls.Add($StatusLabel)
$BottomPanel.Controls.Add($LogoBox)

$Form.Controls.Add($ContentPanel)
$Form.Controls.Add($TopPanel)
$Form.Controls.Add($BottomPanel)

# --- Lógica de ação ---
$BtnApply.Add_Click({
    $StatusLabel.Text = "Trabalhando..."
    $Form.Refresh()

    if ($ChkRestore.Checked) {
        $StatusLabel.Text = "Criando Ponto de Restauração..."
        $Form.Refresh()
        try {
            Checkpoint-Computer -Description "SSLS Auto Restore Point" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Aviso: Não foi possível criar o ponto de restauração.`nErro: $_", "Aviso")
        }
    }

    # Tenta atualizar fontes do Winget se necessário
    try { winget source update } catch {}

    $SelectedApps = $SoftCheckBoxes | Where-Object { $_.Checked }
    foreach ($chk in $SelectedApps) {
        $app = $chk.Tag
        $StatusLabel.Text = "Instalando: $($app.Nome)"
        $Form.Refresh()
        Start-Process winget -ArgumentList "install --id $($app.Id) -e --source winget --accept-package-agreements --accept-source-agreements" -NoNewWindow -PassThru -Wait
    }

    $SelectedTweaks = @()
    foreach ($row in $TweakGrid.Rows) {
        if ($row.Cells["Check"].Value -eq $true) {
            $SelectedTweaks += $row.Tag
        }
    }

    foreach ($tweak in $SelectedTweaks) {
        $StatusLabel.Text = "Aplicando: $($tweak.Nome)"
        $Form.Refresh()
        try { & $tweak.Acao } catch { [System.Windows.Forms.MessageBox]::Show("Erro: $_") }
    }

    if ($SelectedTweaks) {
        Stop-Process -Name explorer -Force
        Start-Sleep -Seconds 1
        if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer }
    }
    $StatusLabel.Text = "Concluído."
    [System.Windows.Forms.MessageBox]::Show("Processo finalizado!", "Sucesso", 0, 64)
})

$BtnRevert.Add_Click({
    $SelectedTweaks = @()
    foreach ($row in $TweakGrid.Rows) {
        if ($row.Cells["Check"].Value -eq $true) {
            $SelectedTweaks += $row.Tag
        }
    }

    if ($SelectedTweaks.Count -gt 0) {
        if ([System.Windows.Forms.MessageBox]::Show("Restaurar itens selecionados?", "Confirmar", 4) -eq "Yes") {
            foreach ($tweak in $SelectedTweaks) {
                $StatusLabel.Text = "Restaurando: $($tweak.Nome)"
                $Form.Refresh()
                try { & $tweak.Desfazer } catch {}
            }
            Stop-Process -Name explorer -Force
            Start-Sleep -Seconds 1
            if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer }
            $StatusLabel.Text = "Restauração Completa."
            [System.Windows.Forms.MessageBox]::Show("Itens restaurados.", "Sucesso", 0, 64)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Selecione na lista 'Otimizações' o que deseja desfazer.", "Aviso")
    }
})

$Form.Add_Shown({
    $Form.Activate()
    try { [WindowUtils]::SetDarkTitleBar($Form.Handle) } catch {}
})
[void]$Form.ShowDialog()
