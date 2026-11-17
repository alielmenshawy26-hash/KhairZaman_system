; برنامج تسطيب «زلط» — السيستم الجديد (منفصل عن Warehouse Online، وبيستخدم نفس الداتا)
[Setup]
AppId={{CFAE1A38-4163-4AF6-AB8F-41A787133FA9}
AppName=Zalat
AppVersion=1.0
AppPublisher=Zalat
DefaultDirName={autopf}\Zalat
DefaultGroupName=Zalat
DisableProgramGroupPage=yes
OutputDir=Output
OutputBaseFilename=Zalat-Setup
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=force
RestartApplications=no

[Tasks]
Name: "desktopicon"; Description: "Desktop shortcut"; GroupDescription: "Shortcuts:"
Name: "autostart"; Description: "Start Zalat automatically with Windows (for the warehouse PC that runs the website)"; GroupDescription: "Website:"; Flags: unchecked
Name: "firewall"; Description: "Allow the website through Windows Firewall (port 8780)"; GroupDescription: "Website:"

[Files]
Source: "dist\Zalat.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "server_setup.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "server_setup.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "tools\SumatraPDF.exe"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

[Icons]
Name: "{group}\Zalat"; Filename: "{app}\Zalat.exe"
Name: "{group}\Server setup (main PC only)"; Filename: "{app}\server_setup.bat"
Name: "{autodesktop}\Zalat"; Filename: "{app}\Zalat.exe"; Tasks: desktopicon
Name: "{userstartup}\Zalat"; Filename: "{app}\Zalat.exe"; Tasks: autostart

[Run]
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Zalat Website"""; Flags: runhidden; Tasks: firewall
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Zalat Website"" dir=in action=allow protocol=TCP localport=8780 profile=any"; Flags: runhidden; Tasks: firewall
Filename: "{app}\Zalat.exe"; Description: "Run Zalat"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Zalat Website"""; Flags: runhidden; RunOnceId: "ZalatFw"

[Code]
// قبل التسطيب: يقفل أي نسخة شغالة من البرنامج علشان الملف يتبدل
function PrepareToInstall(var NeedsRestart: Boolean): String;
var Code: Integer;
begin
  Exec(ExpandConstant('{sys}\taskkill.exe'), '/F /T /IM Zalat.exe', '', SW_HIDE, ewWaitUntilTerminated, Code);
  Sleep(1500);
  Result := '';
end;
