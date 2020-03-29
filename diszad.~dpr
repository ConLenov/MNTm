program diszad;

uses
  Forms,
  Taskman in 'Taskman.pas' {Form1},
  Taskman2 in 'Taskman2.pas' {Form2},
  Cmd in 'Cmd.pas' {Form3},
  Unit4 in 'Unit4.pas' {cpuform},
  Unit5 in 'Unit5.pas' {memform};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(Tcpuform, cpuform);
  Application.CreateForm(Tmemform, memform);
  Application.Run;
end.
