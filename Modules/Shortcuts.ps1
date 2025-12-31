$Global:ShortcutsList = @(
    [PSCustomObject]@{ Nome = "Aplicativos Padrão";             Comando = "start ms-settings:defaultapps" },
    [PSCustomObject]@{ Nome = "Ativação";                       Comando = "start ms-settings:activation" },
    [PSCustomObject]@{ Nome = "Barra de Tarefas";               Comando = "start ms-settings:taskbar" },
    [PSCustomObject]@{ Nome = "Configurações de Gráficos (HAGS)"; Comando = "start ms-settings:display-advancedgraphics" },
    [PSCustomObject]@{ Nome = "Cores";                          Comando = "start ms-settings:colors" },
    [PSCustomObject]@{ Nome = "Data e Hora";                    Comando = "start ms-settings:dateandtime" },
    [PSCustomObject]@{ Nome = "Idioma";                         Comando = "start ms-settings:regionlanguage" },
    [PSCustomObject]@{ Nome = "Privacidade";                    Comando = "start ms-settings:privacy" },
    [PSCustomObject]@{ Nome = "Região";                         Comando = "start ms-settings:region" }

)
