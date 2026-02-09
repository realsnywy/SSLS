using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.IO.Compression;
using System.Reflection;
using System.Security.Principal;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Collections.Generic;

namespace SSLSSetup
{
    public class SetupForm : Form
    {
        // Controls
        private Button btnInstall;
        private Button btnRunTemp;
        private Button btnUninstall;
        private Label lblTitle;
        private Label lblSubtitle;
        private Label lblStatus;
        private ComboBox cmbLanguage;
        private Panel pnlHeader;

        // Configuration
        private string InstallFolder;
        private string ShortcutName = "SSLS.lnk";

        // Colors (Dark Theme)
        private Color ColorBG = ColorTranslator.FromHtml("#2d2d2d");
        private Color ColorPanel = ColorTranslator.FromHtml("#383838");
        private Color ColorButton = ColorTranslator.FromHtml("#454545");
        private Color ColorText = ColorTranslator.FromHtml("#e5e5e5");
        private Color ColorAccent = ColorTranslator.FromHtml("#84fec5");
        private Color ColorGreen = ColorTranslator.FromHtml("#34a853");
        private Color ColorRed = ColorTranslator.FromHtml("#ea4335");

        // Localization
        private Dictionary<string, Dictionary<string, string>> Locales;
        private string CurrentLang = "pt-BR";

        [DllImport("dwmapi.dll", PreserveSig = true)]
        public static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int attrValue, int attrSize);

        public SetupForm()
        {
            // Init Data
            InitLocales();

            // Setup Form
            this.Text = "SSLS Setup";
            this.Size = new Size(620, 360);
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Icon = Icon.ExtractAssociatedIcon(Application.ExecutablePath);
            this.BackColor = ColorBG;
            this.ForeColor = ColorText;

            // Header/Title bar dark mode support
            int useDarkMode = 1;
            try {
                // Try catch for older Windows versions compatibility
                DwmSetWindowAttribute(this.Handle, 20, ref useDarkMode, sizeof(int));
            } catch {}

            InstallFolder = @"C:\SSLS";

            InitializeComponents();
            UpdateLanguage();
        }

        private void InitLocales()
        {
            Locales = new Dictionary<string, Dictionary<string, string>>();

            var pt = new Dictionary<string, string>();
            pt["Title"] = "SSLS - Snywy's Silly Little Script";
            pt["Subtitle"] = "Selecione o idioma e uma ação:";
            pt["Install"] = "Instalar";
            pt["Run"] = "Executar";
            pt["Uninstall"] = "Desinstalar";
            pt["StatusReady"] = "Pronto.";
            pt["StatusInstalling"] = "Instalando...";
            pt["StatusDone"] = "Instalação concluída!";
            pt["StatusRunning"] = "Executando script...";
            pt["StatusUninstalling"] = "Desinstalando...";
            pt["StatusUninstalled"] = "Desinstalado.";
            pt["ErrorAdminInstall"] = "A instalação em C:\\SSLS requer privilégios de administrador. Deseja reiniciar como Administrador?";
            pt["ErrorAdminUninstall"] = "A desinstalação requer privilégios de administrador.";
            pt["SuccessInstall"] = "Instalado com sucesso em ";
            pt["AlreadyInstalled"] = "SSLS já parece estar instalado. Deseja reinstalar?";
            Locales["pt-BR"] = pt;

            var en = new Dictionary<string, string>();
            en["Title"] = "SSLS - Snywy's Silly Little Script";
            en["Subtitle"] = "Select language and action:";
            en["Install"] = "Install";
            en["Run"] = "Run";
            en["Uninstall"] = "Uninstall";
            en["StatusReady"] = "Ready.";
            en["StatusInstalling"] = "Installing...";
            en["StatusDone"] = "Installation complete!";
            en["StatusRunning"] = "Running script...";
            en["StatusUninstalling"] = "Uninstalling...";
            en["StatusUninstalled"] = "Uninstalled.";
            en["ErrorAdminInstall"] = "Installation to C:\\SSLS requires administrator privileges. Restart as Administrator?";
            en["ErrorAdminUninstall"] = "Uninstallation requires administrator privileges.";
            en["SuccessInstall"] = "Successfully installed at ";
            en["AlreadyInstalled"] = "SSLS seems to be installed already. Reinstall?";
            Locales["en-US"] = en;
        }

        private string T(string key)
        {
            if (Locales.ContainsKey(CurrentLang) && Locales[CurrentLang].ContainsKey(key))
                return Locales[CurrentLang][key];
            return key;
        }

        private void UpdateLanguage()
        {
            lblTitle.Text = T("Title");
            lblSubtitle.Text = T("Subtitle");
            btnInstall.Text = T("Install");
            btnRunTemp.Text = T("Run");
            btnUninstall.Text = T("Uninstall");
            lblStatus.Text = T("StatusReady");
        }

        private void InitializeComponents()
        {
            // Panel Header
            pnlHeader = new Panel();
            pnlHeader.Size = new Size(620, 80);
            pnlHeader.Location = new Point(0, 0);
            pnlHeader.BackColor = ColorPanel;
            this.Controls.Add(pnlHeader);

            // Title
            lblTitle = new Label();
            lblTitle.Font = new Font("Segoe UI", 16, FontStyle.Bold);
            lblTitle.ForeColor = ColorAccent;
            lblTitle.Location = new Point(20, 20);
            lblTitle.AutoSize = true;
            lblTitle.BackColor = Color.Transparent; // Panel handles bg
            pnlHeader.Controls.Add(lblTitle);

            // Language Selector
            cmbLanguage = new ComboBox();
            cmbLanguage.Items.Add("Português (Brasil)");
            cmbLanguage.Items.Add("English (US)");
            cmbLanguage.SelectedIndex = 0; // Default PT
            cmbLanguage.Location = new Point(440, 25);
            cmbLanguage.Size = new Size(140, 30);
            cmbLanguage.DropDownStyle = ComboBoxStyle.DropDownList;
            cmbLanguage.Font = new Font("Segoe UI", 9);
            cmbLanguage.BackColor = ColorButton;
            cmbLanguage.ForeColor = ColorText;
            cmbLanguage.FlatStyle = FlatStyle.Flat;
            cmbLanguage.SelectedIndexChanged += new EventHandler((s, e) => {
                CurrentLang = cmbLanguage.SelectedIndex == 0 ? "pt-BR" : "en-US";
                UpdateLanguage();
            });
            pnlHeader.Controls.Add(cmbLanguage);

            // Subtitle
            lblSubtitle = new Label();
            lblSubtitle.Font = new Font("Segoe UI", 10);
            lblSubtitle.Location = new Point(35, 110);
            lblSubtitle.AutoSize = true;
            this.Controls.Add(lblSubtitle);

            // Buttons - Centered for 620 width
            // Total width needed for 3 buttons (160px) + spacing (30px) = 480 + 60 = 540
            // Start X = (620 - 540) / 2 = 40

            int btnY = 160;
            int btnW = 160;
            int btnH = 55;
            int gap = 30;
            int startX = 35; // Custom alignment

            btnInstall = CreateFlatButton(T("Install"), startX, btnY, btnW, btnH, ColorAccent, Color.Black);
            btnInstall.Click += BtnInstall_Click;
            this.Controls.Add(btnInstall);

            btnRunTemp = CreateFlatButton(T("Run"), startX + btnW + gap, btnY, btnW, btnH, ColorButton, ColorText);
            btnRunTemp.Click += BtnRunTemp_Click;
            this.Controls.Add(btnRunTemp);

            btnUninstall = CreateFlatButton(T("Uninstall"), startX + (btnW + gap) * 2, btnY, btnW, btnH, ColorRed, ColorText);
            btnUninstall.Click += deleteInstallation;
            this.Controls.Add(btnUninstall);

            // Status
            lblStatus = new Label();
            lblStatus.Text = "";
            lblStatus.Font = new Font("Segoe UI", 9, FontStyle.Italic);
            lblStatus.ForeColor = Color.DarkGray;
            lblStatus.Location = new Point(35, 270);
            lblStatus.AutoSize = true;
            this.Controls.Add(lblStatus);
        }

        private Button CreateFlatButton(string text, int x, int y, int w, int h, Color bg, Color fg)
        {
            Button btn = new Button();
            btn.Text = text;
            btn.Location = new Point(x, y);
            btn.Size = new Size(w, h);
            btn.FlatStyle = FlatStyle.Flat;
            btn.FlatAppearance.BorderSize = 0;
            btn.BackColor = bg;
            btn.ForeColor = fg;
            btn.Font = new Font("Segoe UI", 11, FontStyle.Bold);
            btn.Cursor = Cursors.Hand;
            return btn;
        }

        private bool IsRunAsAdmin()
        {
            WindowsIdentity id = WindowsIdentity.GetCurrent();
            WindowsPrincipal principal = new WindowsPrincipal(id);
            return principal.IsInRole(WindowsBuiltInRole.Administrator);
        }

        private void Elevate()
        {
            var exeName = Process.GetCurrentProcess().MainModule.FileName;
            ProcessStartInfo startInfo = new ProcessStartInfo(exeName);
            startInfo.Verb = "runas";
            try
            {
                Process.Start(startInfo);
                Application.Exit();
            }
            catch
            {
                MessageBox.Show(T("ErrorAdminUninstall"), "SSLS", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnInstall_Click(object sender, EventArgs e)
        {
            if (!IsRunAsAdmin())
            {
                var result = MessageBox.Show(T("ErrorAdminInstall"), "Admin", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
                if (result == DialogResult.Yes) Elevate();
                return;
            }

            if (Directory.Exists(InstallFolder))
            {
                var result = MessageBox.Show(T("AlreadyInstalled"), "SSLS", MessageBoxButtons.YesNo);
                if (result == DialogResult.No) return;
            }

            try
            {
                lblStatus.Text = T("StatusInstalling");
                Application.DoEvents(); // Force UI update

                if (!Directory.Exists(InstallFolder)) Directory.CreateDirectory(InstallFolder);

                string zipPath = Path.Combine(InstallFolder, "payload.zip");
                ExtractResource("payload.zip", zipPath);

                ExtractZip(zipPath, InstallFolder);
                File.Delete(zipPath);

                string sourceShortcut = Path.Combine(InstallFolder, "SSLS.lnk");
                string destShortcut = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonDesktopDirectory), "SSLS.lnk");

                if (File.Exists(sourceShortcut))
                {
                    File.Copy(sourceShortcut, destShortcut, true);
                }
                else
                {
                    CreateShortcut("SSLS", Path.Combine(InstallFolder, "SSLS.ps1"));
                }

                lblStatus.Text = T("StatusDone");
                MessageBox.Show(T("SuccessInstall") + InstallFolder, "SSLS");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
                lblStatus.Text = "Error.";
            }
        }

        private void BtnRunTemp_Click(object sender, EventArgs e)
        {
            try
            {
                lblStatus.Text = T("StatusInstalling"); // Actually extracting
                Application.DoEvents();

                string tempFolder = Path.Combine(Path.GetTempPath(), "SSLS_" + Guid.NewGuid().ToString().Substring(0, 8));
                Directory.CreateDirectory(tempFolder);

                string zipPath = Path.Combine(tempFolder, "payload.zip");
                ExtractResource("payload.zip", zipPath);
                ExtractZip(zipPath, tempFolder);

                string psFile = Path.Combine(tempFolder, "SSLS.ps1");

                lblStatus.Text = T("StatusRunning");
                Application.DoEvents();
                RunPowerShell(psFile);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void deleteInstallation(object sender, EventArgs e) {
             try {
                if (!IsRunAsAdmin())
                {
                    MessageBox.Show(T("ErrorAdminUninstall"), "SSLS", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                if (Directory.Exists(InstallFolder)) {
                    lblStatus.Text = T("StatusUninstalling");
                    Application.DoEvents();
                    Directory.Delete(InstallFolder, true);
                }
                string desktop = Environment.GetFolderPath(Environment.SpecialFolder.CommonDesktopDirectory);
                string shortcut = Path.Combine(desktop, ShortcutName);
                if (File.Exists(shortcut)) File.Delete(shortcut);

                lblStatus.Text = T("StatusUninstalled");
                MessageBox.Show(T("StatusUninstalled"), "SSLS");
             } catch (Exception ex) {
                 MessageBox.Show("Error: " + ex.Message);
             }
        }

        private void ExtractResource(string resourceName, string outputPath)
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            string fullResourceName = null;
            foreach(string name in assembly.GetManifestResourceNames()) {
                if(name.EndsWith(resourceName)) {
                    fullResourceName = name;
                    break;
                }
            }

            if (fullResourceName == null) throw new Exception("Resource not found: " + resourceName);

            using (Stream stream = assembly.GetManifestResourceStream(fullResourceName))
            using (FileStream fileStream = new FileStream(outputPath, FileMode.Create))
            {
                stream.CopyTo(fileStream);
            }
        }

        private void ExtractZip(string zipPath, string extractPath)
        {
             ZipFile.ExtractToDirectory(zipPath, extractPath);
        }

        private void CreateShortcut(string name, string targetHtml)
        {
            string desktop = Environment.GetFolderPath(Environment.SpecialFolder.CommonDesktopDirectory);
            string shortcutPath = Path.Combine(desktop, name + ".lnk");

            Type t = Type.GetTypeFromProgID("WScript.Shell");
            dynamic shell = Activator.CreateInstance(t);
            var lnk = shell.CreateShortcut(shortcutPath);

            lnk.TargetPath = "powershell.exe";
            lnk.Arguments = "-ExecutionPolicy Bypass -File \"" + targetHtml + "\"";

            string iconPath = Path.Combine(Path.GetDirectoryName(targetHtml), "icon.ico");
            if (File.Exists(iconPath))
            {
                lnk.IconLocation = iconPath;
            }
            else
            {
                lnk.IconLocation = "powershell.exe,0";
            }

            lnk.Description = "Snywy's Silly Little Script";
            lnk.Save();
        }

        private void RunPowerShell(string scriptPath)
        {
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.FileName = "powershell.exe";
            startInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File \"" + scriptPath + "\"";
            startInfo.UseShellExecute = true;
            startInfo.Verb = "runas";
            Process.Start(startInfo);
        }

        private static bool IsRunningAsAdministrator()
        {
            WindowsIdentity id = WindowsIdentity.GetCurrent();
            WindowsPrincipal principal = new WindowsPrincipal(id);
            return principal.IsInRole(WindowsBuiltInRole.Administrator);
        }

        [STAThread]
        static void Main()
        {
            if (!IsRunningAsAdministrator())
            {
                var exeName = Process.GetCurrentProcess().MainModule.FileName;
                ProcessStartInfo startInfo = new ProcessStartInfo(exeName);
                startInfo.UseShellExecute = true;
                startInfo.Verb = "runas";
                try
                {
                    Process.Start(startInfo);
                }
                catch
                {
                    MessageBox.Show("Este software precisa de permissões de Administrador para ser executado.", "SSLS Setup", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                return;
            }

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new SetupForm());
        }
    }
}
