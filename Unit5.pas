unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellAPI, Gauges;

type
  Tmemform = class(TForm)
    memname: TLabel;
    physmemall: TLabel;
    physmemloadc: TLabel;
    physmemload: TLabel;
    physmemavac: TLabel;
    physmemava: TLabel;
    Timer1: TTimer;
    memstruct: TGauge;
    Timepercent: TTimer;
    virtmemc: TLabel;
    virtmemload: TLabel;
    virtmemall: TLabel;
    procedure FormDblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimepercentTimer(Sender: TObject);
  private
    { Private declarations }
    function UpRound(Value: Double): Integer;
    function DownRound(Value: Double): Integer;
  public
    { Public declarations }
    procedure CurrentInfo;
procedure MemInfo;
  end;

var
  memform: Tmemform;

implementation

uses Taskman;

{$R *.dfm}

procedure Tmemform.FormDblClick(Sender: TObject);
begin
Form1.Show;
 memform.Hide;
end;

 function Tmemform.DownRound(Value: Double): Integer;
begin
  Result := Trunc(Value);
end;

procedure Tmemform.Timer1Timer(Sender: TObject);
begin
CurrentInfo;
end;

procedure Tmemform.MemInfo;
var memstat:tmemorystatus;
begin
MemStat.dwLength := SizeOf(MemStat);
GlobalMemoryStatus(MemStat);
with MemStat do begin
  physmemload.Caption :=Format('%0.3f ',[(dwTotalPhys-dwAvailPhys) div 1024 /1024])+'��';
  physmemall.Caption := Format('%0.3f ',[dwTotalPhys div 1024 / 1024])+'��';
  physmemava.Caption := Format('%0.3f ',[dwAvailPhys div 1024 / 1024])+'��';
  virtmemload.Caption:= Format('%0.3f ',[(dwTotalPageFile-dwAvailPageFile) div 1024 /1024])+'/';
  virtmemall.Caption := Format('%0.3f ',[dwTotalPageFile div 1024 / 1024])+'��';
end;
end;

procedure Tmemform.CurrentInfo;
begin
meminfo;
end;

procedure Tmemform.TimepercentTimer(Sender: TObject);
const
  cBytesPorMb = 1024 * 1024;
var
  MemStatus: TMemoryStatus;
begin
MemStatus.dwLength := SizeOf(MemStatus);
  GlobalMemoryStatus(MemStatus);
with memstruct do
  begin
    MaxValue := DownRound(MemStatus.dwTotalPhys / cBytesPorMb);
    Progress := UpRound((MemStatus.dwTotalPhys - MemStatus.dwAvailPhys) / cBytesPorMb);
  end;
end;

function Tmemform.UpRound(Value: Double): Integer;
begin
  Result := Trunc(Value);
  if Frac(Value) <> 0 then
    Result := Trunc(Value + 1);
end;

end.
