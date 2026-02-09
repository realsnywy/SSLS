<#
    Módulo: Extras.ps1
    Descrição: Ferramentas adicionais (Ponto de Restauração Manual, Executor de Comandos).
#>

function Initialize-ExtrasTab {
    param(
        $ParentPanel,
        $ColorPanel,
        $ColorText,
        $ColorButton,
        $ColorAccent
    )

    # Limpeza preventiva
    $ParentPanel.Controls.Clear()

    # ==========================================
    # Seção 1: Ferramentas do Sistema
    # ==========================================
    $GrpTools = New-Object System.Windows.Forms.GroupBox
    $GrpTools.Text = (Get-Text "ExtraSystemTools")
    $GrpTools.Location = New-Object System.Drawing.Point(20, 20)
    $GrpTools.Size = New-Object System.Drawing.Size(920, 100)
    $GrpTools.ForeColor = $ColorAccent
    $GrpTools.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

    # Botão: Criar Ponto de Restauração Agora
    $BtnRestore = New-Object System.Windows.Forms.Button
    $BtnRestore.Text = (Get-Text "ExtraRestorePoint")
    $BtnRestore.Size = New-Object System.Drawing.Size(220, 45)
    $BtnRestore.Location = New-Object System.Drawing.Point(20, 35)
    $BtnRestore.BackColor = $ColorButton
    $BtnRestore.ForeColor = $ColorText
    $BtnRestore.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $BtnRestore.FlatStyle = "Flat"
    $BtnRestore.FlatAppearance.BorderColor = $ColorAccent
    $BtnRestore.FlatAppearance.BorderSize = 1
    $BtnRestore.Cursor = [System.Windows.Forms.Cursors]::Hand

    $BtnRestore.Add_Click({
        # Usa cursor de espera pois criar ponto de restauração demora
        $ParentPanel.FindForm().Cursor = [System.Windows.Forms.Cursors]::WaitCursor
        try {
            Checkpoint-Computer -Description "SSLS Manual Restore Point" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
            [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraRestoreSuccess"), (Get-Text "ExtraSuccess"))
        } catch {
            [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraRestoreErrorMsg") + ": $_`n" + (Get-Text "ExtraCheckSysProt"), (Get-Text "ExtraError"))
        }
        $ParentPanel.FindForm().Cursor = [System.Windows.Forms.Cursors]::Default
    })

    $GrpTools.Controls.Add($BtnRestore)

    # ==========================================
    # Seção 2: Execução Manual (PowerShell)
    # ==========================================
    $GrpManual = New-Object System.Windows.Forms.GroupBox
    $GrpManual.Text = (Get-Text "ExtraManualExec")
    $GrpManual.Location = New-Object System.Drawing.Point(20, 140)
    $GrpManual.Size = New-Object System.Drawing.Size(920, 300)
    $GrpManual.ForeColor = $ColorAccent
    $GrpManual.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

    $LblManual = New-Object System.Windows.Forms.Label
    $LblManual.Text = (Get-Text "ExtraManualLabel")
    $LblManual.AutoSize = $true
    $LblManual.Location = New-Object System.Drawing.Point(20, 30)
    $LblManual.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $LblManual.ForeColor = $ColorText

    # Caixa de texto para comandos
    $TxtManual = New-Object System.Windows.Forms.TextBox
    $TxtManual.Multiline = $true
    $TxtManual.Size = New-Object System.Drawing.Size(880, 150)
    $TxtManual.Location = New-Object System.Drawing.Point(20, 60)
    $TxtManual.BackColor = $ColorPanel
    $TxtManual.ForeColor = $ColorText
    $TxtManual.BorderStyle = "FixedSingle"
    $TxtManual.Font = New-Object System.Drawing.Font("Consolas", 10) # Fonte monoespaçada para código

    # Botão Executar
    $BtnRunManual = New-Object System.Windows.Forms.Button
    $BtnRunManual.Text = (Get-Text "ExtraRunCommand")
    $BtnRunManual.Size = New-Object System.Drawing.Size(200, 45)
    $BtnRunManual.Location = New-Object System.Drawing.Point(20, 230)
    $BtnRunManual.BackColor = $ColorButton
    $BtnRunManual.ForeColor = $ColorText
    $BtnRunManual.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $BtnRunManual.FlatStyle = "Flat"
    $BtnRunManual.FlatAppearance.BorderColor = $ColorAccent
    $BtnRunManual.FlatAppearance.BorderSize = 1
    $BtnRunManual.Cursor = [System.Windows.Forms.Cursors]::Hand

    $BtnRunManual.Add_Click({
        if ($TxtManual.Text -ne "") {
            try {
                # Executa o comando arbitrário na sessão atual
                Invoke-Expression $TxtManual.Text
                [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraCommandSent"), (Get-Text "ExtraSuccess"))
            }
            catch {
                [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraError") + ": $_", (Get-Text "ExtraError"))
            }
        }
    })

    $GrpManual.Controls.AddRange(@($LblManual, $TxtManual, $BtnRunManual))

    # Adiciona grupos ao painel principal
    $ParentPanel.Controls.Add($GrpTools)
    $ParentPanel.Controls.Add($GrpManual)
}
