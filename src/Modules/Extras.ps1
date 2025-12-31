function Initialize-ExtrasTab {
    param($ParentPanel, $ColorPanel, $ColorText, $ColorButton, $ColorAccent)
    $ParentPanel.Controls.Clear()

    # --- GroupBox: Ferramentas do Sistema ---
    $GrpTools = New-Object System.Windows.Forms.GroupBox
    $GrpTools.Text = (Get-Text "ExtraSystemTools")
    $GrpTools.Location = New-Object System.Drawing.Point(20, 20)
    $GrpTools.Size = New-Object System.Drawing.Size(920, 100)
    $GrpTools.ForeColor = $ColorAccent
    $GrpTools.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

    # --- Botão MAS ---
    $BtnMAS = New-Object System.Windows.Forms.Button
    $BtnMAS.Text = (Get-Text "ExtraMAS")
    $BtnMAS.Size = New-Object System.Drawing.Size(200, 45)
    $BtnMAS.Location = New-Object System.Drawing.Point(20, 35)
    $BtnMAS.BackColor = $ColorButton
    $BtnMAS.ForeColor = $ColorAccent
    $BtnMAS.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $BtnMAS.FlatStyle = "Flat"
    $BtnMAS.FlatAppearance.BorderColor = $ColorAccent
    $BtnMAS.FlatAppearance.BorderSize = 1
    $BtnMAS.Cursor = [System.Windows.Forms.Cursors]::Hand

    $BtnMAS.Add_Click({
        try {
            Start-Process powershell -ArgumentList "-NoProfile -Command `"irm https://get.activated.win | iex`""
        } catch {
            [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraError") + ": $_", (Get-Text "ExtraError"))
        }
    })

    # --- Botão Restore Point ---
    $BtnRestore = New-Object System.Windows.Forms.Button
    $BtnRestore.Text = (Get-Text "ExtraRestorePoint")
    $BtnRestore.Size = New-Object System.Drawing.Size(220, 45)
    $BtnRestore.Location = New-Object System.Drawing.Point(240, 35)
    $BtnRestore.BackColor = $ColorButton
    $BtnRestore.ForeColor = $ColorText
    $BtnRestore.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $BtnRestore.FlatStyle = "Flat"
    $BtnRestore.FlatAppearance.BorderColor = $ColorAccent
    $BtnRestore.FlatAppearance.BorderSize = 1
    $BtnRestore.Cursor = [System.Windows.Forms.Cursors]::Hand

    $BtnRestore.Add_Click({
        try {
            Checkpoint-Computer -Description "SSLS Manual Restore Point" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
            [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraRestoreSuccess"), (Get-Text "ExtraSuccess"))
        } catch {
            [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraRestoreErrorMsg") + ": $_`n" + (Get-Text "ExtraCheckSysProt"), (Get-Text "ExtraError"))
        }
    })

    $GrpTools.Controls.Add($BtnMAS)
    $GrpTools.Controls.Add($BtnRestore)

    # --- GroupBox: Execução Manual ---
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

    $TxtManual = New-Object System.Windows.Forms.TextBox
    $TxtManual.Multiline = $true
    $TxtManual.Size = New-Object System.Drawing.Size(880, 150)
    $TxtManual.Location = New-Object System.Drawing.Point(20, 60)
    $TxtManual.BackColor = $ColorPanel
    $TxtManual.ForeColor = $ColorText
    $TxtManual.BorderStyle = "FixedSingle"
    $TxtManual.Font = New-Object System.Drawing.Font("Consolas", 10)

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
            try { Invoke-Expression $TxtManual.Text; [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraCommandSent"), (Get-Text "ExtraSuccess")) }
            catch { [System.Windows.Forms.MessageBox]::Show((Get-Text "ExtraError") + ": $_", (Get-Text "ExtraError")) }
        }
    })

    $GrpManual.Controls.Add($LblManual)
    $GrpManual.Controls.Add($TxtManual)
    $GrpManual.Controls.Add($BtnRunManual)

    $ParentPanel.Controls.Add($GrpTools)
    $ParentPanel.Controls.Add($GrpManual)
}
