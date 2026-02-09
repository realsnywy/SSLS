<#
    Módulo: Tweaks.ps1
    Descrição: Lista de otimizações de registro e sistema, e construção da tabela de gestão.
#>

# ==========================================
# Lista de Otimizações
# ==========================================
function Get-TweaksList {
    return @(
        # --- Grupo: Visual & Interface ---
        [PSCustomObject]@{
            Nome = (Get-Text "TweakContextMenu");
            Descricao = (Get-Text "TweakContextMenuDesc");
            Acao = { New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Value "" -Force | Out-Null };
            Desfazer = { Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Force -ErrorAction SilentlyContinue }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakSeconds");
            Descricao = (Get-Text "TweakSecondsDesc");
            Acao = { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Value 1 -Force };
            Desfazer = { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Value 0 -Force }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakDarkMode");
            Descricao = (Get-Text "TweakDarkModeDesc");
            Acao = {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
            };
            Desfazer = {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakHiddenFiles");
            Descricao = (Get-Text "TweakHiddenFilesDesc");
            Acao = {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
            };
            Desfazer = {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 1
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 0
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakTransparency");
            Descricao = (Get-Text "TweakTransparencyDesc");
            Acao = { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord -Force };
            Desfazer = { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 1 -Type DWord -Force }
        },

        # --- Grupo: Desempenho & Gaming ---
        [PSCustomObject]@{
            Nome = (Get-Text "TweakPowerPlan");
            Descricao = (Get-Text "TweakPowerPlanDesc");
            Acao = {
                # Ativa o plano de Desempenho Máximo (Ultimate Performance)
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
                powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
            };
            Desfazer = {
                # Reverte para o plano Equilibrado
                powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakFSO");
            Descricao = (Get-Text "TweakFSODesc");
            Acao = {
                $path = "HKCU:\System\GameConfigStore"
                Set-ItemProperty -Path $path -Name "GameDVR_FSEBehaviorMode" -Value 2 -Force
                Set-ItemProperty -Path $path -Name "GameDVR_Enabled" -Value 0 -Force
            };
            Desfazer = {
                $path = "HKCU:\System\GameConfigStore"
                Remove-ItemProperty -Path $path -Name "GameDVR_FSEBehaviorMode" -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $path -Name "GameDVR_Enabled" -Value 1 -Force
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakMenuDelay");
            Descricao = (Get-Text "TweakMenuDelayDesc");
            Acao = { Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "100" };
            Desfazer = { Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "400" }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakMouseAccel");
            Descricao = (Get-Text "TweakMouseAccelDesc");
            Acao = {
                 $key = "HKCU:\Control Panel\Mouse"
                 Set-ItemProperty -Path $key -Name "MouseSpeed" -Value "0"
                 Set-ItemProperty -Path $key -Name "MouseThreshold1" -Value "0"
                 Set-ItemProperty -Path $key -Name "MouseThreshold2" -Value "0"
            };
            Desfazer = {
                 $key = "HKCU:\Control Panel\Mouse"
                 Set-ItemProperty -Path $key -Name "MouseSpeed" -Value "1"
                 Set-ItemProperty -Path $key -Name "MouseThreshold1" -Value "6"
                 Set-ItemProperty -Path $key -Name "MouseThreshold2" -Value "1"
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakRamCache");
            Descricao = (Get-Text "TweakRamCacheDesc");
            Acao = {
                Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value "1"
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1 -Force
            };
            Desfazer = {
                Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Value "0"
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 0 -Force
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakPowerThrottling");
            Descricao = (Get-Text "TweakPowerThrottlingDesc");
            Acao = {
                $path = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"
                if (!(Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
                Set-ItemProperty -Path $path -Name "PowerThrottlingOff" -Value 1 -Force
            };
            Desfazer = {
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 0 -Force
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakHAGS");
            Descricao = (Get-Text "TweakHAGSDesc");
            Acao = { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -Force };
            Desfazer = { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 1 -Type DWord -Force }
        },

        # --- Grupo: Rede & Sistema ---
        [PSCustomObject]@{
            Nome = (Get-Text "TweakNetwork");
            Descricao = (Get-Text "TweakNetworkDesc");
            Acao = { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force };
            Desfazer = { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -Force }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakHibernation");
            Descricao = (Get-Text "TweakHibernationDesc");
            Acao = { powercfg -h off };
            Desfazer = { powercfg -h on }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakLastAccess");
            Descricao = (Get-Text "TweakLastAccessDesc");
            Acao = { fsutil behavior set disablelastaccess 1 };
            Desfazer = { fsutil behavior set disablelastaccess 0 }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakSysMain");
            Descricao = (Get-Text "TweakSysMainDesc");
            Acao = {
                Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "SysMain" -StartupType Disabled
            };
            Desfazer = {
                Set-Service -Name "SysMain" -StartupType Automatic
                Start-Service -Name "SysMain" -ErrorAction SilentlyContinue
            }
        },

        # --- Grupo: Privacidade & Debloat ---
        [PSCustomObject]@{
            Nome = (Get-Text "TweakTelemetry");
            Descricao = (Get-Text "TweakTelemetryDesc");
            Acao = {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
            };
            Desfazer = {
                 Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakDiagTrack");
            Descricao = (Get-Text "TweakDiagTrackDesc");
            Acao = {
                Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
                Set-Service -Name "DiagTrack" -StartupType Disabled
            };
            Desfazer = {
                Set-Service -Name "DiagTrack" -StartupType Automatic
                Start-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakBing");
            Descricao = (Get-Text "TweakBingDesc");
            Acao = {
                New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1 -PropertyType DWORD -Force | Out-Null
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Force -ErrorAction SilentlyContinue
            };
            Desfazer = {
                Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -ErrorAction SilentlyContinue
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 1 -Force -ErrorAction SilentlyContinue
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakAppSuggestions");
            Descricao = (Get-Text "TweakAppSuggestionsDesc");
            Acao = {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Value 0
            };
            Desfazer = {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 1
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Value 1
            }
        },
        [PSCustomObject]@{
            Nome = (Get-Text "TweakErrorReporting");
            Descricao = (Get-Text "TweakErrorReportingDesc");
            Acao = {
                $path = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
                Set-ItemProperty -Path $path -Name "Disabled" -Value 1 -Force
            };
            Desfazer = {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 0 -Force
            }
        }
    )
}

$Global:TweaksList = Get-TweaksList

# ==========================================
# Interface Gráfica
# ==========================================
function Initialize-TweaksTab {
    param(
        $ParentPanel,
        $ColorPanel,
        $ColorText,
        $ColorBG,
        $ColorAccent,
        $ColorButton
    )

    $ParentPanel.Controls.Clear()

    # Cria a grade (tabela) de opções
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

    # Estilização das células
    $TweakGrid.DefaultCellStyle.BackColor = $ColorPanel
    $TweakGrid.DefaultCellStyle.ForeColor = $ColorText
    $TweakGrid.DefaultCellStyle.SelectionBackColor = $ColorButton
    $TweakGrid.DefaultCellStyle.SelectionForeColor = $ColorText

    # Cabeçalho
    $TweakGrid.EnableHeadersVisualStyles = $false
    $TweakGrid.ColumnHeadersDefaultCellStyle.BackColor = $ColorBG
    $TweakGrid.ColumnHeadersDefaultCellStyle.ForeColor = $ColorAccent
    $TweakGrid.ColumnHeadersDefaultCellStyle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $TweakGrid.ColumnHeadersBorderStyle = "None"
    $TweakGrid.ColumnHeadersHeight = 35
    $TweakGrid.ColumnHeadersHeightSizeMode = "DisableResizing"

    # Definição das Colunas
    # 1. Checkbox
    $ColCheck = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
    $ColCheck.HeaderText = ""
    $ColCheck.Width = 30
    $ColCheck.Name = "Check"
    [void]$TweakGrid.Columns.Add($ColCheck)

    # 2. Nome
    $ColName = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $ColName.HeaderText = "Nome"
    $ColName.Width = 400
    $ColName.Name = "Nome"
    $ColName.ReadOnly = $true
    [void]$TweakGrid.Columns.Add($ColName)

    # 3. Descrição
    $ColDesc = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $ColDesc.HeaderText = (Get-Text "HeaderDescription")
    $ColDesc.AutoSizeMode = "Fill"
    $ColDesc.Name = "Descricao"
    $ColDesc.ReadOnly = $true
    [void]$TweakGrid.Columns.Add($ColDesc)

    # Popula a grade com os dados ordenados
    $SortedTweaks = $Global:TweaksList | Sort-Object Nome

    foreach ($tweak in $SortedTweaks) {
        $row = $TweakGrid.Rows.Add()
        $TweakGrid.Rows[$row].Cells["Nome"].Value = $tweak.Nome
        $TweakGrid.Rows[$row].Cells["Descricao"].Value = $tweak.Descricao
        $TweakGrid.Rows[$row].Tag = $tweak # Guarda o objeto para execução
    }

    $Global:TweakGrid = $TweakGrid
    $ParentPanel.Controls.Add($TweakGrid)
}
