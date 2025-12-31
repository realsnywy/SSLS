function Initialize-WelcomeTab {
    param($ParentPanel, $ColorText, $ColorAccent)

    $LblTitle = New-Object System.Windows.Forms.Label
    $LblTitle.Text = "Bem-vindo ao SSLS"
    $LblTitle.AutoSize = $true
    $LblTitle.Location = New-Object System.Drawing.Point(30, 30)
    $LblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
    $LblTitle.ForeColor = $ColorAccent

    $LblDesc = New-Object System.Windows.Forms.Label
    $LblDesc.Text = "Snywy's Silly Little Script`n`nSelecione as abas acima para instalar programas, aplicar otimizações ou acessar ferramentas extras."
    $LblDesc.AutoSize = $true
    $LblDesc.Location = New-Object System.Drawing.Point(35, 90)
    $LblDesc.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $LblDesc.ForeColor = $ColorText

    $ParentPanel.Controls.Add($LblTitle)
    $ParentPanel.Controls.Add($LblDesc)
}
