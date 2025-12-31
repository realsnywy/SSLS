$Global:TweaksList = @(
    # --- Visual & Interface ---
    [PSCustomObject]@{
        Nome = "Restaurar menu de contexto clássico (Win 11)";
        Descricao = "Remove o 'Mostrar mais opções' do clique direito";
        Acao = { New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Value "" -Force | Out-Null };
        Desfazer = { Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Force -ErrorAction SilentlyContinue }
    },
    [PSCustomObject]@{
        Nome = "Mostrar segundos no relógio";
        Descricao = "Exibe os segundos na barra de tarefas (Win 11)";
        Acao = { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Value 1 -Force };
        Desfazer = { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Value 0 -Force }
    },
    [PSCustomObject]@{
        Nome = "Ativar modo escuro completo";
        Descricao = "Sistema e apps em modo escuro";
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
        Nome = "Mostrar extensões e arquivos ocultos";
        Descricao = "Essencial para segurança e navegação";
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
        Nome = "Desativar efeitos de transparência";
        Descricao = "Melhora a resposta da interface e economiza recursos";
        Acao = { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord -Force };
        Desfazer = { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 1 -Type DWord -Force }
    },

    # --- Desempenho & Gaming ---
    [PSCustomObject]@{
        Nome = "Plano de energia: Desempenho máximo";
        Descricao = "Libera o plano 'Ultimate Performance' e ativa";
        Acao = {
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
            powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
        };
        Desfazer = {
            # Reverte para o plano "Equilibrado" (Balanced) padrão do Windows
            powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
        }
    },
    [PSCustomObject]@{
        Nome = "Desativar otimização de tela cheia";
        Descricao = "Reduz input lag em jogos (GameDVR)";
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
        Nome = "Acelerar menus (Mouse)";
        Descricao = "Reduz o delay ao passar o mouse em menus (400ms -> 100ms)";
        Acao = { Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "100" };
        Desfazer = { Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "400" }
    },
    [PSCustomObject]@{
        Nome = "Mouse: Desativar aceleração";
        Descricao = "Desativa 'Aprimorar precisão do ponteiro' (Input 1:1)";
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
             Set-ItemProperty -Path $key -Name "MouseThreshold2" -Value "10"
        }
    },
    [PSCustomObject]@{
        Nome = "Gerenciamento de RAM/Cache";
        Descricao = "Auto-encerrar tarefas travadas e cache largo";
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
        Nome = "Desativar limitação de energia (Power Throttling)";
        Descricao = "Impede que o Windows limite energia de apps em segundo plano";
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
        Nome = "Ativar agendamento de GPU (HAGS)";
        Descricao = "Reduz latência e melhora performance (Requer GPU compatível)";
        Acao = { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -Force };
        Desfazer = { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 1 -Type DWord -Force }
    },

    # --- Rede & Sistema ---
    [PSCustomObject]@{
        Nome = "Otimizar rede (Desativar limitação)";
        Descricao = "Remove o limite de processamento de tráfego de rede";
        Acao = { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force };
        Desfazer = { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -Force }
    },
    [PSCustomObject]@{
        Nome = "Desativar hibernação";
        Descricao = "Libera espaço em disco (Tamanho da RAM) e desativa Fast Startup";
        Acao = { powercfg -h off };
        Desfazer = { powercfg -h on }
    },
    [PSCustomObject]@{
        Nome = "Desativar timestamp de último acesso (NTFS)";
        Descricao = "Reduz escritas desnecessárias no disco";
        Acao = { fsutil behavior set disablelastaccess 1 };
        Desfazer = { fsutil behavior set disablelastaccess 0 }
    },
    [PSCustomObject]@{
        Nome = "Desativar SysMain (Superfetch)";
        Descricao = "Reduz uso de disco/CPU em SSDs (Opcional)";
        Acao = {
            Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
            Set-Service -Name "SysMain" -StartupType Disabled
        };
        Desfazer = {
            Set-Service -Name "SysMain" -StartupType Automatic
            Start-Service -Name "SysMain" -ErrorAction SilentlyContinue
        }
    },

    # --- Privacidade & Debloat ---
    [PSCustomObject]@{
        Nome = "Desativar telemetria (Básico)";
        Descricao = "Limita o envio de dados para a Microsoft";
        Acao = {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
        };
        Desfazer = {
             Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
        }
    },
    [PSCustomObject]@{
        Nome = "Desativar serviço de telemetria (DiagTrack)";
        Descricao = "Desativa o serviço principal de coleta de dados";
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
        Nome = "Remover Bing e pesquisa na web";
        Descricao = "Busca do Windows procura apenas arquivos locais";
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
        Nome = "Desativar sugestões de apps";
        Descricao = "Remove 'Dicas' e propagandas do Menu Iniciar";
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
        Nome = "Desativar relatório de erros";
        Descricao = "Para de perguntar se quer enviar relatório ao travar";
        Acao = {
            $path = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
            Set-ItemProperty -Path $path -Name "Disabled" -Value 1 -Force
        };
        Desfazer = {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 0 -Force
        }
    }
)
