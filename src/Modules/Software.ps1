<#
    Módulo: Software.ps1
    Descrição: Lista de softwares suportados (Winget) e construção da aba de Programas.
#>

# ==========================================
# Definição dos Pacotes
# ==========================================
function Get-SoftwareList {
    return @(
        # --- Categoria: Internet ---
        [PSCustomObject]@{ Nome = "Brave Browser";      Id = "Brave.Brave";             Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescBrave") },
        [PSCustomObject]@{ Nome = "Discord";            Id = "Discord.Discord";         Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescDiscord") },
        [PSCustomObject]@{ Nome = "PicoTorrent";        Id = "PicoTorrent.PicoTorrent"; Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescPicoTorrent") },
        [PSCustomObject]@{ Nome = "Stremio";            Id = "Stremio.Stremio";         Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescStremio") },
        [PSCustomObject]@{ Nome = "Zen Browser";        Id = "Zen-Team.Zen-Browser";    Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescZen") },

        # --- Categoria: Multimídia ---
        [PSCustomObject]@{ Nome = "Audacity";           Id = "Audacity.Audacity";       Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescAudacity") },
        [PSCustomObject]@{ Nome = "foobar2000";         Id = "PeterPawlowski.foobar2000"; Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescFoobar") },
        [PSCustomObject]@{ Nome = "HandBrake";          Id = "HandBrake.HandBrake";     Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescHandBrake") },
        [PSCustomObject]@{ Nome = "K-Lite Codec Pack";  Id = "CodecGuide.K-LiteCodecPack.Full"; Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescKLite") },
        [PSCustomObject]@{ Nome = "OBS Studio";         Id = "OBSProject.OBSStudio";    Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescOBS") },
        [PSCustomObject]@{ Nome = "Spotify";            Id = "Spotify.Spotify";         Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescSpotify") },
        [PSCustomObject]@{ Nome = "Renoise";            Id = "Renoise.Renoise";         Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescRenoise") },

        # --- Categoria: Gráficos ---
        [PSCustomObject]@{ Nome = "Affinity Designer";  Id = "Canva.Affinity";          Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescAffinity") },
        [PSCustomObject]@{ Nome = "Drawpile";           Id = "Drawpile.Drawpile";       Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescDrawpile") },
        [PSCustomObject]@{ Nome = "MediBang Paint";     Id = "MediBang.MediBangPaintPro"; Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescMediBang") },

        # --- Categoria: Jogos ---
        [PSCustomObject]@{ Nome = "Hytale";             Id = "HypixelStudios.Hytale";   Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescHytale") },
        [PSCustomObject]@{ Nome = "Hydra Launcher";     Id = "HydraLauncher.Hydra";     Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescHydra") },
        [PSCustomObject]@{ Nome = "Parsec";             Id = "Parsec.Parsec";           Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescParsec") },
        [PSCustomObject]@{ Nome = "Parsec (VDD)";       Id = "Parsec.ParsecVDD";        Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescParsecVDD") },
        [PSCustomObject]@{ Nome = "Prism Launcher";     Id = "PrismLauncher.PrismLauncher"; Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescPrism") },
        [PSCustomObject]@{ Nome = "Steam";              Id = "Valve.Steam";             Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescSteam") },
        [PSCustomObject]@{ Nome = "Unity Hub";          Id = "Unity.UnityHub";          Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescUnityHub") },
        [PSCustomObject]@{ Nome = "Unity 2022";         Id = "Unity.Unity.2022";        Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescUnity2022") },

        # --- Categoria: Desenvolvimento ---
        [PSCustomObject]@{ Nome = ".NET 6 Runtime";     Id = "Microsoft.DotNet.DesktopRuntime.6"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescDotNet6") },
        [PSCustomObject]@{ Nome = ".NET 8 Runtime";     Id = "Microsoft.DotNet.DesktopRuntime.8"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescDotNet8") },
        [PSCustomObject]@{ Nome = ".NET 9 Runtime";     Id = "Microsoft.DotNet.DesktopRuntime.9"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescDotNet9") },
        [PSCustomObject]@{ Nome = ".NET 10 Runtime";    Id = "Microsoft.DotNet.DesktopRuntime.10"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescDotNet10") },
        [PSCustomObject]@{ Nome = "GitHub Desktop";     Id = "GitHub.GitHubDesktop";    Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescGitHubDesktop") },
        [PSCustomObject]@{ Nome = "Java 25 (JDK)";      Id = "EclipseAdoptium.Temurin.25.JDK"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescJava25") },
        [PSCustomObject]@{ Nome = "Notepad++";          Id = "Notepad++.Notepad++";     Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescNotepadPlus") },
        [PSCustomObject]@{ Nome = "Python 3.13";        Id = "Python.Python.3.13";      Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescPython313") },
        [PSCustomObject]@{ Nome = "VS Code";            Id = "Microsoft.VisualStudioCode"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescVSCode") },
        [PSCustomObject]@{ Nome = "Windows Terminal";   Id = "Microsoft.WindowsTerminal"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescWindowsTerminal") },

        # Additional development packages imported from winget export
        [PSCustomObject]@{ Nome = "Visual Studio 2022 Community"; Id = "Microsoft.VisualStudio.2022.Community"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescVS2022Community") },
        [PSCustomObject]@{ Nome = "Python Launcher";     Id = "Python.Launcher"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescPythonLauncher") },
        [PSCustomObject]@{ Nome = "Windows SDK 10.0.26100"; Id = "Microsoft.WindowsSDK.10.0.26100"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescWindowsSDK1026100") },
        [PSCustomObject]@{ Nome = "Rustup (Rust)";      Id = "Rustlang.Rustup"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescRustup") },

        # --- Categoria: Sistema ---
        [PSCustomObject]@{ Nome = "EarTrumpet";         Id = "File-New-Project.EarTrumpet"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescEarTrumpet") },
        [PSCustomObject]@{ Nome = "NanaZip";            Id = "M2Team.NanaZip";          Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescNanaZip") },
        [PSCustomObject]@{ Nome = "Nilesoft Shell";     Id = "Nilesoft.Shell";          Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescNilesoft") },
        [PSCustomObject]@{ Nome = "Notion";             Id = "Notion.Notion";           Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescNotion") },
        [PSCustomObject]@{ Nome = "Notion Calendar";    Id = "Notion.NotionCalendar";   Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescNotionCalendar") },
        [PSCustomObject]@{ Nome = "PowerToys";          Id = "Microsoft.PowerToys";     Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescPowerToys") },
        [PSCustomObject]@{ Nome = "Radmin VPN";         Id = "Famatech.RadminVPN";      Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescRadmin") },
        [PSCustomObject]@{ Nome = "StartAllBack";       Id = "StartIsBack.StartAllBack"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescStartAllBack") },
        [PSCustomObject]@{ Nome = "SumatraPDF";         Id = "SumatraPDF.SumatraPDF";   Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescSumatraPDF") },
        [PSCustomObject]@{ Nome = "Virtual Desktop";    Id = "VirtualDesktop.Streamer"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescVirtualDesktop") },
        [PSCustomObject]@{ Nome = "WizTree";            Id = "AntibodySoftware.WizTree"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescWizTree") },

        # Additional system / utility packages imported from winget export
        [PSCustomObject]@{ Nome = "Bitdefender";        Id = "Bitdefender.Bitdefender"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescBitdefender") },
        [PSCustomObject]@{ Nome = "Motorola Mobile Drivers"; Id = "Motorola.MobileDrivers"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescMotorolaDrivers") },
        [PSCustomObject]@{ Nome = "NVCleanstall";       Id = "TechPowerUp.NVCleanstall"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescNVCleanstall") },
        [PSCustomObject]@{ Nome = "Microsoft WSL";      Id = "Microsoft.WSL";          Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescWSL") },
        [PSCustomObject]@{ Nome = "ALCOM";              Id = "anatawa12.ALCOM";        Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescALCOM") },

        # --- Categoria: Bibliotecas ---
        [PSCustomObject]@{ Nome = "DirectX";            Id = "Microsoft.DirectX";       Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescDirectX") },
        [PSCustomObject]@{ Nome = "Dokany";             Id = "dokan-dev.Dokany";        Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescDokany") },
        [PSCustomObject]@{ Nome = "Game Input";         Id = "Microsoft.GameInput";     Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescGameInput") },
        [PSCustomObject]@{ Nome = "OpenAL";             Id = "CreativeTechnology.OpenAL"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescOpenAL") },
        [PSCustomObject]@{ Nome = "PhysX";              Id = "Nvidia.PhysX";            Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescPhysX") },
        [PSCustomObject]@{ Nome = "UI Xaml 2.8";        Id = "Microsoft.UI.Xaml.2.8";   Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescUIXaml") },
        [PSCustomObject]@{ Nome = "VC Libs 14";         Id = "Microsoft.VCLibs.14";     Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCLibs14") },
        [PSCustomObject]@{ Nome = "VC Libs Desktop 14"; Id = "Microsoft.VCLibs.Desktop.14"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCLibsDesktop") },
        [PSCustomObject]@{ Nome = "VC++ 2005";          Id = "Microsoft.VCRedist.2005.x64"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2005") },
        [PSCustomObject]@{ Nome = "VC++ 2008";          Id = "Microsoft.VCRedist.2008.x64"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2008") },
        [PSCustomObject]@{ Nome = "VC++ 2008 x86";      Id = "Microsoft.VCRedist.2008.x86"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2008x86") },
        [PSCustomObject]@{ Nome = "VC++ 2012";          Id = "Microsoft.VCRedist.2012.x64"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2012") },
        [PSCustomObject]@{ Nome = "VC++ 2012 x86";      Id = "Microsoft.VCRedist.2012.x86"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2012x86") },
        [PSCustomObject]@{ Nome = "VC++ 2013";          Id = "Microsoft.VCRedist.2013.x64"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2013") },
        [PSCustomObject]@{ Nome = "VC++ 2013 x86";      Id = "Microsoft.VCRedist.2013.x86"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2013x86") },
        [PSCustomObject]@{ Nome = "VC++ 2015+";         Id = "Microsoft.VCRedist.2015+.x64"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2015") },
        [PSCustomObject]@{ Nome = "VC++ 2015+ x86";     Id = "Microsoft.VCRedist.2015+.x86"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVCRedist2015x86") },
        [PSCustomObject]@{ Nome = "Windows App Runtime 1.6"; Id = "Microsoft.WindowsAppRuntime.1.6"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescWARv16") },
        [PSCustomObject]@{ Nome = "Windows App Runtime 1.7"; Id = "Microsoft.WindowsAppRuntime.1.7"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescWARv17") },
        [PSCustomObject]@{ Nome = "Windows App Runtime 1.8"; Id = "Microsoft.WindowsAppRuntime.1.8"; Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescWARv18") },
        [PSCustomObject]@{ Nome = "VSTO Runtime";       Id = "Microsoft.VSTOR";        Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescVSTOR") },
        [PSCustomObject]@{ Nome = "XNA Redist";         Id = "Microsoft.XNARedist";     Categoria = (Get-Text "CatLibraries"); Descricao = (Get-Text "DescXNARedist") }
    )
}

$Global:SoftwareList = Get-SoftwareList

# ==========================================
# Interface Gráfica
# ==========================================
function Initialize-SoftwareTab {
    param(
        $ParentPanel,
        $ColorBG,
        $ColorAccent,
        $ColorText
    )

    $ParentPanel.Controls.Clear()

    # Painel Principal com Rolagem
    $FlowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $FlowPanel.Dock = "Fill"
    $FlowPanel.AutoScroll = $true
    $FlowPanel.FlowDirection = "TopDown"
    $FlowPanel.WrapContents = $true
    $FlowPanel.BackColor = $ColorBG

    # Configuração de Tooltip (Balão de informação ao passar o mouse)
    $ToolTip = New-Object System.Windows.Forms.ToolTip
    $ToolTip.AutoPopDelay = 10000
    $ToolTip.InitialDelay = 500
    $ToolTip.ReshowDelay = 500
    $ToolTip.ShowAlways = $true

    # Agrupa por categorias
    $Categories = $Global:SoftwareList | Select-Object -ExpandProperty Categoria -Unique | Sort-Object
    $Global:SoftCheckBoxes = @()

    foreach ($cat in $Categories) {
        # Grupo Visual (Caixa em volta da categoria)
        $GroupBox = New-Object System.Windows.Forms.GroupBox
        $GroupBox.Text = " $cat "
        $GroupBox.AutoSize = $true
        $GroupBox.ForeColor = $ColorAccent
        $GroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $GroupBox.Margin = New-Object System.Windows.Forms.Padding(10, 10, 10, 20)
        $GroupBox.Padding = New-Object System.Windows.Forms.Padding(5)

        # Painel interno do grupo
        $GroupPanel = New-Object System.Windows.Forms.FlowLayoutPanel
        $GroupPanel.FlowDirection = "TopDown"
        $GroupPanel.AutoSize = $true
        $GroupPanel.Dock = "Fill"

        $Items = $Global:SoftwareList | Where-Object { $_.Categoria -eq $cat }
        foreach ($item in $Items) {
            $cb = New-Object System.Windows.Forms.CheckBox
            $cb.Text = $item.Nome
            $cb.Tag = $item # Guarda o objeto inteiro para o instalador usar depois
            $cb.AutoSize = $true
            $cb.ForeColor = $ColorText
            $cb.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)

            if ($item.Descricao) {
                $ToolTip.SetToolTip($cb, $item.Descricao)
            }

            # Adiciona à lista global de checkboxes para podermos ler depois
            $Global:SoftCheckBoxes += $cb
            $GroupPanel.Controls.Add($cb)
        }
        $GroupBox.Controls.Add($GroupPanel)
        $FlowPanel.Controls.Add($GroupBox)
    }

    $ParentPanel.Controls.Add($FlowPanel)
}
