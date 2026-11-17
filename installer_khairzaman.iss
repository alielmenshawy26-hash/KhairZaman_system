; برنامج تسطيب «مخبز خير زمان» (منفصل تمامًا عن زلط)
[Setup]
AppId={{878834C7-4E53-4BB9-B0A9-D1C3D8A41BA3}
AppName=Khair Zaman Bakery
AppVersion=1.0
AppPublisher=Khair Zaman Bakery
DefaultDirName={autopf}\KhairZaman
DefaultGroupName=Khair Zaman Bakery
DisableProgramGroupPage=yes
OutputDir=Output
OutputBaseFilename=KhairZaman-Setup
SetupIconFile=app.ico
UninstallDisplayIcon={app}\KhairZaman.exe
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=force
RestartApplications=no

[Tasks]
Name: "desktopicon"; Description: "Desktop shortcut"; GroupDescription: "Shortcuts:"
Name: "autostart"; Description: "Start Khair Zaman automatically with Windows (needed for the phone website)"; GroupDescription: "Website:"; Flags: unchecked
Name: "firewall"; Description: "Allow the website through Windows Firewall (port 8780)"; GroupDescription: "Website:"

[Files]
Source: "dist\KhairZaman.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "server_setup.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "server_setup.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "tools\SumatraPDF.exe"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

[Icons]
Name: "{group}\Khair Zaman Bakery"; Filename: "{app}\KhairZaman.exe"
Name: "{group}\Server setup (main PC only)"; Filename: "{app}\server_setup.bat"
Name: "{autodesktop}\Khair Zaman Bakery"; Filename: "{app}\KhairZaman.exe"; Tasks: desktopicon
Name: "{userstartup}\Khair Zaman Bakery"; Filename: "{app}\KhairZaman.exe"; Tasks: autostart

[Run]
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""KhairZaman Website"""; Flags: runhidden; Tasks: firewall
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""KhairZaman Website"" dir=in action=allow protocol=TCP localport=8780 profile=any"; Flags: runhidden; Tasks: firewall
Filename: "{app}\KhairZaman.exe"; Description: "Run Khair Zaman"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""KhairZaman Website"""; Flags: runhidden; RunOnceId: "KhairZamanFw"

[Code]
// قبل التسطيب: يقفل أي نسخة شغالة من البرنامج علشان الملف يتبدل
function PrepareToInstall(var NeedsRestart: Boolean): String;
var Code: Integer;
begin
  Exec(ExpandConstant('{sys}\taskkill.exe'), '/F /T /IM KhairZaman.exe', '', SW_HIDE, ewWaitUntilTerminated, Code);
  Sleep(1500);
  Result := '';
end;
