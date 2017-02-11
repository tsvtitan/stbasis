program telnet;

uses
  Forms,
  mainform in 'mainform.pas' {frmTelnetDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTelnetDemo, frmTelnetDemo);
  Application.Run;
end.
