unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ShellApi, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLType, Windows, process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  MysqlExeFile: TResourceStream;
  MysqlSavaToFileSteam, ConfigurationProcessStdErr: TFileStream;
  EXEINFO: _SHELLEXECUTEINFOA;
  ConfigEXEINFO: _SHELLEXECUTEINFOA;
  MySQLInstallProcess, ConfigurationProcess: TProcess;
begin
  Button1.Caption := '安装中...';
  Button1.Enabled := False;
  MysqlExeFile := TResourceStream.Create(HINSTANCE, 'MYSQL-5.5.60-WINX64', RT_RCDATA);
  MysqlSavaToFileSteam := TFileStream.Create(GetTempDir() + '.\MYSQL.msi', fmCreate);
  MysqlSavaToFileSteam.CopyFrom(MysqlExeFile, 0);
  MysqlSavaToFileSteam.Write(MysqlExeFile.Memory, MysqlExeFile.Size);
  MysqlSavaToFileSteam.Free;

  MySQLInstallProcess := TProcess.Create(nil);
  MySQLInstallProcess.Executable := 'msiexec.exe';
  MySQLInstallProcess.Parameters.Add('/a');
  MySQLInstallProcess.Parameters.Add('C:\Users\wuao\AppData\Local\Temp\MYSQL.msi');
  MySQLInstallProcess.Parameters.Add('INSTALLFOLDER="C:\MySQL\"');
  MySQLInstallProcess.Parameters.Add('/passive');
  MySQLInstallProcess.Options := MySQLInstallProcess.Options + [poWaitOnExit];
  MySQLInstallProcess.Execute;
  MySQLInstallProcess.Free;

  with ConfigEXEINFO do
  begin
    cbSize:=SizeOf(ConfigEXEINFO);
    fMask:=SEE_MASK_NOCLOSEPROCESS;
    wnd:=0;
    lpVerb:=nil;
    lpFile:='.\MySQLInstanceConfig.exe';
    lpParameters:='-i -q  "-lC:\mysql_install_log.txt" "-nMySQL Server 5.5"  "-pC:\Program Files\MySQL\MySQL Server 5.5" -v 5.5.60  ServerType=DEVELOPMENT DatabaseType=MIXED   ConnectionUsage=DSS Port=3306 ServiceName=MySQL55 RootPassword=root ConnectionCount=50 Charset=gbk';
    lpDirectory:='C:\MySQL\MySQL\MySQL Server 5.5\bin';
    nShow:=SW_HIDE;
    hInstApp:=0;
  end;

  ShellExecuteExA(@ConfigEXEINFO);
  WaitForSingleObject(ConfigEXEINFO.hProcess, 5000);
  CloseHandle(ConfigEXEINFO.hProcess);
  Button1.Enabled := True;
  Button1.Caption := '安装';
  ShowMessage('安装完成');
end;

end.

