program timedemo;

uses
  Forms,
  Main in 'Main.pas' {frmTimeDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTimeDemo, frmTimeDemo);
  Application.Run;
end.
