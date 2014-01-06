; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "MiniZinc IDE"
#define MyAppVersion "0.9"
#define MyAppPublisher "NICTA and Monash University"
#define MyAppURL "http://www.minizinc.org"
#define MyAppExeName "MiniZincIDE.exe"

#define MyAppDirectory "C:\cygwin\home\Guido\MiniZincIDE\build-MiniZincIDE-Desktop_Qt_5_2_0_MSVC2010_32bit-Release\release"
#define MyAppQt "C:\Users\Guido\Desktop\MiniZinc IDE\ide"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{35677F29-029E-416E-AF07-7975F1B9C16F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputBaseFilename=MiniZinc IDE setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#MyAppDirectory}\MiniZincIDE.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\icudt51.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\icuin51.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\icuuc51.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\libEGL.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\libGLESv2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Core.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Gui.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Multimedia.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5MultimediaWidgets.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Network.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5OpenGL.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Positioning.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5PrintSupport.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Qml.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Quick.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Sensors.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Sql.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5WebKit.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5WebKitWidgets.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\Qt5Widgets.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppQt}\accessible\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\bearer\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\designer\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\iconengines\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\imageformats\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\mediaservice\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\platforms\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\playlistformats\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\position\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\printsupport\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\qml1tooling\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\qmltooling\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\sensorgestures\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\sensors\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppQt}\sqldrivers\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

