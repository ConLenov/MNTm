program MNTm;

uses
  Forms,
  Main in 'Main.pas' {MinForm},
  Max in 'Max.pas' {MaxInfoForm},
  Cmd in 'Cmd.pas' {newtask},
  CpuInfo in 'CpuInfo.pas' {cpuform},
  MemInfo in 'MemInfo.pas' {memform},
  uSMBIOS in 'uSMBIOS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMinForm, MinForm);
  Application.CreateForm(TMaxInfoForm, MaxInfoForm);
  Application.CreateForm(Tnewtask, newtask);
  Application.CreateForm(Tcpuform, cpuform);
  Application.CreateForm(Tmemform, memform);
  Application.Run;
end.
