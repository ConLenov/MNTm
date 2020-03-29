unit Taskman2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, tlhelp32, jpeg, ExtCtrls, Grids;

type
  TForm2 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    applist: TStringGrid;
    killappbtn: TButton;
    Timer1: TTimer;
    procedure Image1Click(Sender: TObject);
    procedure killappbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function EnablePrivilege(const Value: Boolean; privilegename:string): Boolean;
    function killproc(id:THandle):boolean;
    function ThrCount(procinfogrid:TStringGrid):word;
    procedure CurrentInfo;
    procedure AppInfoToGrid(grid:TStringGrid);
    function killtaskfunc:boolean;
  end;

var
  Form2: TForm2;
    cd:TStringList;

implementation

uses Taskman;

{$R *.dfm}

procedure TForm2.Image1Click(Sender: TObject);
begin
 Form1.Show;
 Form2.Hide;
end;

function TForm2.EnablePrivilege(const Value: Boolean; privilegename:string): Boolean;
var
  hToken: THandle;
  tp: TOKEN_PRIVILEGES;
  d: DWORD;

begin
  Result := False;
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES, hToken) then
  begin
    tp.PrivilegeCount := 1;
    LookupPrivilegeValue(nil, pchar(privilegename), tp.Privileges[0].Luid);
    if Value then
      tp.Privileges[0].Attributes := $00000002
    else
      tp.Privileges[0].Attributes := $80000000;
    AdjustTokenPrivileges(hToken, False, tp, SizeOf(TOKEN_PRIVILEGES), nil, d);
    if GetLastError = ERROR_SUCCESS then
    begin
      Result := True;
    end;
    CloseHandle(hToken);
  end;
end;

function TForm2.killproc(id:THandle):boolean;
var hproc:THandle;
    ok:boolean;
begin
hproc:=OpenProcess(PROCESS_ALL_ACCESS,false,id);
ok:=TerminateProcess(hproc,0);
if ok=false then killproc:=false else killproc:=true;
CloseHandle(hproc);
end;

function TForm2.ThrCount(procinfogrid:TStringGrid):word;
var k:word;
    i:byte;
begin
k:=0;
for i:=1 to procinfogrid.RowCount-1 do
 k:=k+strtoint(procinfogrid.cells[2,i]);
thrcount:=k;
end;

procedure TForm2.CurrentInfo;
begin
application.ProcessMessages;
AppInfoToGrid(applist);
end;

function AddWinInfo(WinHandle: HWnd; list:TStringList): Boolean;
stdcall;
var  WinCaption: array[0..255] of Char;
begin
  Result:=True;
  if isWindowVisible(WinHandle) then
  if GetWindow(WinHandle,GW_OWNER)=0 then
  begin
  GetWindowText(WinHandle,WinCaption,SizeOf(WinCaption));
  if (WinCaption<>'')  then
  List.Add(inttostr(WinHandle));
  end;
end;

procedure TForm2.AppInfoToGrid(grid:TStringGrid);
var descript:TStringList;
    WinCaption:array[0..255] of char;
    i:word;

begin
descript:=TStringList.Create;
with descript do
  begin
    Clear;
    EnumWindows(@AddWinInfo,LParam(descript));
  end;
for i:=0 to descript.Count-1 do
 begin
  if i+1>grid.RowCount-1 then grid.RowCount:=grid.RowCount+1;
  GetWindowText(strtoint(descript.strings[i]),WinCaption,SizeOf(WinCaption));
  grid.Cells[0,i+1]:=WinCaption;
  grid.Cells[1,i+1]:=descript.strings[i];
 end;
if grid.RowCount>i+1 then grid.RowCount:=i+1;
descript.Destroy;
end;

function TForm2.killtaskfunc:boolean;
var hproc:THandle;
    id:Cardinal;
begin
GetWindowThreadProcessId(strtoint(applist.Cells[1,applist.row]),id);
hproc:=OpenProcess(PROCESS_ALL_ACCESS,false,id);
if TerminateProcess(hproc,0) then Result:=true else Result:=false;
applist.RowCount:=applist.RowCount-1;
closehandle(hproc);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
EnablePrivilege(true,'SeDebugPrivilege');
EnablePrivilege(true,'SeShutdownPrivilege');
CurrentInfo;
end;

procedure TForm2.killappbtnClick(Sender: TObject);
begin
if killtaskfunc=false then MessageBox(Form2.Handle,'Не возможно снять задачу!','Ошибка',0);
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
CurrentInfo;
end;

end.
