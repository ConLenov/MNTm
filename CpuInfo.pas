unit CpuInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  adCpuUsage, Dialogs, ExtCtrls, TeEngine, Series, TeeProcs, Chart, jpeg,
  StdCtrls, Menus, LDSfunc, tlhelp32, Grids, registry, uSMBIOS;

type
  Tcpuform = class(TForm)
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Series5: TLineSeries;
    Series6: TLineSeries;
    Series7: TLineSeries;
    Series8: TLineSeries;
    Timer1: TTimer;
    Label1: TLabel;
    speed: TLabel;
    speedlabel: TLabel;
    cpuspeed: TLabel;
    cpuspeedc: TLabel;
    Timer2: TTimer;
    maxspeed: TLabel;
    cpu_freq: TLabel;
    cpu_name: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure Chart1DblClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CurrentInfo;
    procedure GetProcessorInfo;
  end;

var
  cpuform: Tcpuform;

implementation

uses Max;

{$R *.dfm}
  //  $00 DA E4 7E
procedure Tcpuform.Timer1Timer(Sender: TObject);
var
 i: integer;
begin
 CollectCPUData;
 for i:=0 to GetCPUCount-1 do
  begin
   if Chart1.Series[i].Count>20
   then Chart1.Series[i].Delete(0);
   Chart1.Series[i].AddXY(Time, GetCPUUsage(i)*100,
                Format('%5.2f%%',[GetCPUUsage(i)*100]));
   speedlabel.Caption:=FloatToStr(Round(GetCPUUsage(i)*100))+'%';
  end;
end;

procedure Tcpuform.FormDblClick(Sender: TObject);
begin
 MaxInfoForm.Show;
 cpuform.Hide;
end;

procedure Tcpuform.Chart1DblClick(Sender: TObject);
begin
  MaxInfoForm.Show;
 cpuform.Hide;
end;

procedure Tcpuform.CurrentInfo;
begin

end;

procedure Tcpuform.Timer2Timer(Sender: TObject);
begin
CurrentInfo;
GetProcessorInfo
end;

procedure Tcpuform.GetProcessorInfo;
  Var
    SMBios : TSMBios;
    LProcessorInfo : TProcessorInformation;
    LSRAMTypes : TCacheSRAMTypes;
    I : Integer;
  begin
    SMBios := TSMBios.Create;
    try
      if SMBios.HasProcessorInfo
      then
        for I := Low(SMBios.ProcessorInfo) to High(SMBios.ProcessorInfo) do
        begin
          LProcessorInfo := SMBios.ProcessorInfo[I];
          cpuspeedc.Caption:= Format('%d  Mhz', [LProcessorInfo.RAWProcessorInformation^.CurrentSpeed]);
          cpu_name.Caption :=LProcessorInfo.ProcessorVersionStr;
           end
    finally
      SMBios.Free;
    end;
  end;

procedure Tcpuform.FormShow(Sender: TObject);
begin
with LDSf do begin
    cpu_freq.Caption := GetProcessorInfo(CP_SPEED,0,'0')+' Mhz';
  end;
end;

end.
