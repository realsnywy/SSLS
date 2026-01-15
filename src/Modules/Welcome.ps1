function Initialize-WelcomeTab {
    param($ParentPanel, $ColorText, $ColorAccent)
    $ParentPanel.Controls.Clear()

    $IconPath = Join-Path $PSScriptRoot "..\icon.ico"
    if (Test-Path $IconPath) {
        $PbIcon = New-Object System.Windows.Forms.PictureBox
        $PbIcon.Image = [System.Drawing.Image]::FromFile($IconPath)
        $PbIcon.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
        $PbIcon.Size = New-Object System.Drawing.Size(64, 64)
        $PbIcon.Location = New-Object System.Drawing.Point(30, 30)
        $ParentPanel.Controls.Add($PbIcon)
    }

    $LblTitle = New-Object System.Windows.Forms.Label
    $LblTitle.Text = Get-Text "WelcomeTitle"
    $LblTitle.AutoSize = $true
    $LblTitle.Location = New-Object System.Drawing.Point(30, 100)
    $LblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
    $LblTitle.ForeColor = $ColorAccent

    $LblDesc = New-Object System.Windows.Forms.Label
    $LblDesc.Text = Get-Text "WelcomeDesc"
    $LblDesc.AutoSize = $true
    $LblDesc.Location = New-Object System.Drawing.Point(35, 160)
    $LblDesc.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $LblDesc.ForeColor = $ColorText

    $ParentPanel.Controls.Add($LblTitle)
    $ParentPanel.Controls.Add($LblDesc)
}
