program pPopFix;

uses
  Forms, Windows, SysUtils, Registry, Classes, Dialogs;

{$R *.RES}
{$R FILES.RES}

const
  TITLE = 'PopTB Fix';
  POP_NOT_FOUND = 'Put this file in your "Populous: The Beginning" directory';
  POP_FIXED = 'FIXED!, Now Populous should work';
  ABOUT = #13#10#13#10 + 'made by ALACN, http://www.alacn.cjb.net';
var
  reg: TRegistry;
  path, drive, dir: string;
  sysdir: array[0..255] of char;
  rs: TResourceStream;
begin
  Application.Initialize;
  Application.Title := 'PopFix';
  Application.Run;

  if not FileExists('HW_SW_Select.exe') then
  begin
    MessageBox(Application.Handle, POP_NOT_FOUND + ABOUT, TITLE, MB_ICONEXCLAMATION);
    Exit;
  end;

  path := ExtractFileDir(Application.ExeName);

  reg := TRegistry.Create;
  with reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('SOFTWARE\Bullfrog Productions Ltd\Populous: The Beginning', True) then
    begin
      WriteString('InstallPath', path);

      drive := ExtractFileDrive(path);
      WriteString('InstallDrive', drive);

      dir := copy(path, Length(drive) + 2, Length(path));
      WriteString('InstallDirectory', dir);

      WriteString('Version', '1.01');
      WriteInteger('Language', $09);
      WriteString('Matchmaker URL', 'http://www.populous.net/gamelobbyfinal.html');

      OpenKey('1.01', True);

      CloseKey;
    end;

    if OpenKey('SOFTWARE\Bullfrog Productions Ltd\Populous: The Beginning\HWSWSelect', True) then
    begin
      WriteString('Title', 'Populous: The Beginning');
      WriteString('Prompt', 'Please select the version you want to run:');
      WriteString('Prompt1', 'Software Rendered - No 3D Acceleration');
      WriteString('Prompt2', 'Direct3D Rendered - 3D Accelerated');
      WriteString('OK', 'OK');
      WriteString('Cancel', 'Cancel');
      WriteString('Next', '&Next >');
      WriteString('Back', '< &Back');
      WriteString('Exe1', 'popTB.exe');
      WriteString('Exe2', 'D3DpopTB.exe');
      WriteString('CurrentExe', '');
      CloseKey;
    end;

    if OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\POP3.EXE', True) then
    begin
      WriteString('', Path + '\HW_SW_Select.exe');
      WriteString('Path', Path);
      CloseKey;
    end;

    if OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\HW_SW_Select.exe', True) then
    begin
      WriteString('', Path + '\HW_SW_Select.exe');
      WriteString('Path', Path);
      CloseKey;
    end;
  finally
    reg.Free;
  end;

  GetSystemDirectory(sysdir, SizeOf(sysdir));

  rs := TResourceStream.Create(hInstance, 'EAEXEC', RT_RCDATA);
  try
    rs.SaveToFile(sysdir + '\EAEXEC.EXE');
  finally
    rs.Free;
  end;

  rs := TResourceStream.Create(hInstance, 'EALTEST', RT_RCDATA);
  try
    rs.SaveToFile(sysdir + '\EALTEST.EXE');
  finally
    rs.Free;
  end;

  MessageBox(Application.Handle, POP_FIXED + ABOUT, TITLE, MB_ICONASTERISK);
end.

