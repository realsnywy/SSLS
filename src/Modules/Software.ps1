function Get-SoftwareList {
    return @(
        # --- Internet ---
        [PSCustomObject]@{ Nome = "Brave Browser";      Id = "Brave.Brave";             Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescBrave") },
        [PSCustomObject]@{ Nome = "Discord";            Id = "Discord.Discord";         Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescDiscord") },
        [PSCustomObject]@{ Nome = "Mozilla Firefox";    Id = "Mozilla.Firefox";         Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescFirefox") },
        [PSCustomObject]@{ Nome = "PicoTorrent";        Id = "PicoTorrent.PicoTorrent"; Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescPicoTorrent") },
        [PSCustomObject]@{ Nome = "Thunderbird";        Id = "Mozilla.Thunderbird";     Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescThunderbird") },
        [PSCustomObject]@{ Nome = "Unigram";            Id = "Unigram.Unigram";         Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescUnigram") },
        [PSCustomObject]@{ Nome = "Vencord";            Id = "Vendicated.Vencord";      Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescVencord") },
        [PSCustomObject]@{ Nome = "WhatsApp";           Id = "WhatsApp.WhatsApp";       Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescWhatsApp") },
        [PSCustomObject]@{ Nome = "Zen Browser";        Id = "Zen-Team.Zen-Browser";    Categoria = (Get-Text "CatInternet"); Descricao = (Get-Text "DescZen") },

        # --- Multimídia ---
        [PSCustomObject]@{ Nome = "AIMP";               Id = "AIMP.AIMP";               Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescAIMP") },
        [PSCustomObject]@{ Nome = "Audacity";           Id = "Audacity.Audacity";       Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescAudacity") },
        [PSCustomObject]@{ Nome = "CapCut";             Id = "ByteDance.CapCut";        Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescCapCut") },
        [PSCustomObject]@{ Nome = "foobar2000";         Id = "PeterPawlowski.foobar2000"; Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescFoobar") },
        [PSCustomObject]@{ Nome = "HandBrake";          Id = "HandBrake.HandBrake";     Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescHandBrake") },
        [PSCustomObject]@{ Nome = "K-Lite Codec Pack";  Id = "CodecGuide.K-LiteCodecPack.Full"; Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescKLite") },
        [PSCustomObject]@{ Nome = "OBS Studio";         Id = "OBSProject.OBSStudio";    Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescOBS") },
        [PSCustomObject]@{ Nome = "Spotify";            Id = "Spotify.Spotify";         Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescSpotify") },
        [PSCustomObject]@{ Nome = "Stremio";            Id = "Stremio.Stremio";         Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescStremio") },
        [PSCustomObject]@{ Nome = "VLC";                Id = "VideoLAN.VLC";            Categoria = (Get-Text "CatMultimedia"); Descricao = (Get-Text "DescVLC") },

        # --- Gráficos ---
        [PSCustomObject]@{ Nome = "Affinity";           Id = "Canva.Affinity";          Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescAffinity") },
        [PSCustomObject]@{ Nome = "Blender";            Id = "BlenderFoundation.Blender"; Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescBlender") },
        [PSCustomObject]@{ Nome = "FastStone Viewer";   Id = "FastStone.Viewer";        Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescFastStone") },
        [PSCustomObject]@{ Nome = "GIMP";               Id = "GIMP.GIMP";               Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescGIMP") },
        [PSCustomObject]@{ Nome = "Greenshot";          Id = "Greenshot.Greenshot";     Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescGreenshot") },
        [PSCustomObject]@{ Nome = "Inkscape";           Id = "Inkscape.Inkscape";       Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescInkscape") },
        [PSCustomObject]@{ Nome = "IrfanView";          Id = "IrfanSkiljan.IrfanView";  Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescIrfanView") },
        [PSCustomObject]@{ Nome = "Krita";              Id = "KDE.Krita";               Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescKrita") },
        [PSCustomObject]@{ Nome = "MediBang Paint";     Id = "MediBang.MediBangPaintPro"; Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescMediBang") },
        [PSCustomObject]@{ Nome = "Paint.NET";          Id = "dotPDN.PaintDotNet";      Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescPaintDotNet") },
        [PSCustomObject]@{ Nome = "ShareX";             Id = "ShareX.ShareX";           Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescShareX") },
        [PSCustomObject]@{ Nome = "XnView MP";          Id = "XnSoft.XnViewMP";         Categoria = (Get-Text "CatGraphics"); Descricao = (Get-Text "DescXnView") },

        # --- Jogos ---
        [PSCustomObject]@{ Nome = "Amazon Games";       Id = "Amazon.Games";            Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescAmazonGames") },
        [PSCustomObject]@{ Nome = "EA App";             Id = "ElectronicArts.EADesktop"; Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescEAApp") },
        [PSCustomObject]@{ Nome = "Epic Games";         Id = "EpicGames.EpicGamesLauncher"; Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescEpicGames") },
        [PSCustomObject]@{ Nome = "Fishstrap";          Id = "Fishstrap.Fishstrap";     Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescFishstrap") },
        [PSCustomObject]@{ Nome = "GOG Galaxy";         Id = "GOG.Galaxy";              Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescGOG") },
        [PSCustomObject]@{ Nome = "osu!lazer";          Id = "ppy.osu";                 Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescOsu") },
        [PSCustomObject]@{ Nome = "Prism Launcher";     Id = "PrismLauncher.PrismLauncher"; Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescPrism") },
        [PSCustomObject]@{ Nome = "Sonic Robo Blast 2"; Id = "SonicTeamJr.SonicRoboBlast2"; Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescSRB2") },
        [PSCustomObject]@{ Nome = "Steam";              Id = "Valve.Steam";             Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescSteam") },
        [PSCustomObject]@{ Nome = "Ubisoft Connect";    Id = "Ubisoft.Connect";         Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescUbisoft") },
        [PSCustomObject]@{ Nome = "YARG";               Id = "YARC.YARCLauncher";       Categoria = (Get-Text "CatGames"); Descricao = (Get-Text "DescYARG") },

        # --- Desenvolvimento ---
        [PSCustomObject]@{ Nome = ".NET 6";             Id = "Microsoft.DotNet.DesktopRuntime.6"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescDotNet6") },
        [PSCustomObject]@{ Nome = ".NET 8";             Id = "Microsoft.DotNet.DesktopRuntime.8"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescDotNet8") },
        [PSCustomObject]@{ Nome = "FileZilla";          Id = "FileZilla.FileZilla";     Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescFileZilla") },
        [PSCustomObject]@{ Nome = "Git";                Id = "Git.Git";                 Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescGit") },
        [PSCustomObject]@{ Nome = "Java 17";            Id = "EclipseAdoptium.Temurin.17.JDK"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescJava17") },
        [PSCustomObject]@{ Nome = "Java 21";            Id = "EclipseAdoptium.Temurin.21.JDK"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescJava21") },
        [PSCustomObject]@{ Nome = "Notepad++";          Id = "Notepad++.Notepad++";     Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescNotepadPlus") },
        [PSCustomObject]@{ Nome = "PuTTY";              Id = "PuTTY.PuTTY";             Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescPuTTY") },
        [PSCustomObject]@{ Nome = "Python 3";           Id = "Python.Python.3";         Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescPython3") },
        [PSCustomObject]@{ Nome = "Visual C++";         Id = "TechPowerUp.VCRedist";    Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescVCRedist") },
        [PSCustomObject]@{ Nome = "Visual Studio Code"; Id = "Microsoft.VisualStudioCode"; Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescVSCode") },
        [PSCustomObject]@{ Nome = "WinMerge";           Id = "WinMerge.WinMerge";       Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescWinMerge") },
        [PSCustomObject]@{ Nome = "WinSCP";             Id = "WinSCP.WinSCP";           Categoria = (Get-Text "CatDevelopment"); Descricao = (Get-Text "DescWinSCP") },

        # --- Sistema ---
        [PSCustomObject]@{ Nome = "CPU-Z";              Id = "CPUID.CPU-Z";             Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescCPUZ") },
        [PSCustomObject]@{ Nome = "CrystalDiskInfo";    Id = "CrystalDewWorld.CrystalDiskInfo"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescCrystalDiskInfo") },
        [PSCustomObject]@{ Nome = "Everything";         Id = "voidtools.Everything";    Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescEverything") },
        [PSCustomObject]@{ Nome = "GPU-Z";              Id = "TechPowerUp.GPU-Z";       Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescGPUZ") },
        [PSCustomObject]@{ Nome = "KeePassXC";          Id = "KeePassXCTeam.KeePassXC"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescKeePassXC") },
        [PSCustomObject]@{ Nome = "LibreOffice";        Id = "TheDocumentFoundation.LibreOffice"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescLibreOffice") },
        [PSCustomObject]@{ Nome = "Malwarebytes";       Id = "Malwarebytes.Malwarebytes"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescMalwarebytes") },
        [PSCustomObject]@{ Nome = "NanaZip";            Id = "M2Team.NanaZip";          Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescNanaZip") },
        [PSCustomObject]@{ Nome = "Notion";             Id = "Notion.Notion";           Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescNotion") },
        [PSCustomObject]@{ Nome = "Open-Shell";         Id = "Open-Shell.Open-Shell-Menu"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescOpenShell") },
        [PSCustomObject]@{ Nome = "PowerToys";          Id = "Microsoft.PowerToys";     Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescPowerToys") },
        [PSCustomObject]@{ Nome = "Radmin VPN";         Id = "Famatech.RadminVPN";      Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescRadmin") },
        [PSCustomObject]@{ Nome = "Revo Uninstaller";   Id = "RevoUninstaller.RevoUninstaller"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescRevo") },
        [PSCustomObject]@{ Nome = "SumatraPDF";         Id = "SumatraPDF.SumatraPDF";   Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescSumatraPDF") },
        [PSCustomObject]@{ Nome = "TeraCopy";           Id = "CodeSector.TeraCopy";     Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescTeraCopy") },
        [PSCustomObject]@{ Nome = "Virtual Desktop";    Id = "VirtualDesktop.Streamer"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescVirtualDesktop") },
        [PSCustomObject]@{ Nome = "VRCX";               Id = "VRCX.VRCX";               Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescVRCX") },
        [PSCustomObject]@{ Nome = "WizTree";            Id = "AntibodySoftware.WizTree"; Categoria = (Get-Text "CatSystem"); Descricao = (Get-Text "DescWizTree") }
    )
}

$Global:SoftwareList = Get-SoftwareList

function Initialize-SoftwareTab {
    param($ParentPanel, $ColorBG, $ColorAccent, $ColorText)
    $ParentPanel.Controls.Clear()

    $FlowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $FlowPanel.Dock = "Fill"
    $FlowPanel.AutoScroll = $true
    $FlowPanel.FlowDirection = "TopDown"
    $FlowPanel.WrapContents = $true
    $FlowPanel.BackColor = $ColorBG

    $ToolTip = New-Object System.Windows.Forms.ToolTip
    $ToolTip.AutoPopDelay = 10000
    $ToolTip.InitialDelay = 500
    $ToolTip.ReshowDelay = 500
    $ToolTip.ShowAlways = $true

    $Categories = $Global:SoftwareList | Select-Object -ExpandProperty Categoria -Unique | Sort-Object
    $Global:SoftCheckBoxes = @()

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

            if ($item.Descricao) {
                $ToolTip.SetToolTip($cb, $item.Descricao)
            }

            $Global:SoftCheckBoxes += $cb
            $GroupPanel.Controls.Add($cb)
        }
        $GroupBox.Controls.Add($GroupPanel)
        $FlowPanel.Controls.Add($GroupBox)
    }
    $ParentPanel.Controls.Add($FlowPanel)
}
