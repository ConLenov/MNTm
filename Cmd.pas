unit Cmd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Taskman;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
Form1.Show;
 Form3.Hide;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
winexec(pchar(ComboBox1.text),1);
Form3.Hide;
end;

end.
