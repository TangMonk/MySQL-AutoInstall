unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ShellApi, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLType, windows;

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
  MysqlSavaToFileSteam: TFileStream;
  EXEINFO: _SHELLEXECUTEINFOA;
  ConfigEXEINFO: _SHELLEXECUTEINFOA;
begin
  Button1.Caption:='安装中...';
  Button1.Enabled:=false;
  MysqlExeFile:=TResourceStream.Create(HINSTANCE, 'MYSQL-5.5.60-WINX64', RT_RCDATA);
  MysqlSavaToFileSteam:=TFileStream.Create( GetTempDir() + '.\MYSQL.msi', fmCreate);
  MysqlSavaToFileSteam.CopyFrom(MysqlExeFile, 0);
  MysqlSavaToFileSteam.Write(MysqlExeFile.Memory, MysqlExeFile.Size);
  MysqlSavaToFileSteam.Free;
  with EXEINFO do
  begin
    cbSize:=SizeOf(EXEINFO);
    fMask:=SEE_MASK_NOCLOSEPROCESS;
    wnd:=0;
    lpVerb:=nil;
    lpFile:='msiexec.exe';
    lpParameters:='/i C:\Users\wuao\AppData\Local\Temp\mysql-5.5.60-winx64.msi /passive';
    lpDirectory:=nil;
    nShow:=SW_SHOW;
    hInstApp:=0;

  end;
  ShellExecuteExA(@EXEINFO);
  WaitForSingleObject(EXEINFO.hProcess, INFINITE);

  with ConfigEXEINFO do
  begin
    cbSize:=SizeOf(ConfigEXEINFO);
    fMask:=SEE_MASK_NOCLOSEPROCESS;
    wnd:=0;
    lpVerb:=nil;
    lpFile:='MySQLInstanceConfig.exe';
    lpParameters:='-i -q  "-lC:\mysql_install_log.txt" "-nMySQL Server 5.5"  "-pC:\Program Files\MySQL\MySQL Server 5.5" -v 5.5.60  ServerType=DEVELOPMENT DatabaseType=MIXED   ConnectionUsage=DSS Port=3306 ServiceName=MySQL5.5 RootPassword=root ConnectionCount=50';
    lpDirectory:='C:\Program Files\MySQL\MySQL Server 5.5\bin';
    nShow:=SW_HIDE;
    hInstApp:=0;
  end;

  ShellExecuteExA(@ConfigEXEINFO);
  Sleep(1000);
  WaitForSingleObject(ConfigEXEINFO.hProcess, INFINITE);
  CloseHandle(ConfigEXEINFO.hProcess);
  CloseHandle(EXEINFO.hProcess);
  Button1.Enabled:=true;
  Button1.Caption:='安装';
  ShowMessage('安装完成');
end;

end.

