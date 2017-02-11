program ParseURI;

uses
  Forms,
  main in 'main.pas' {frmDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDemo, frmDemo);
  Application.Run;
end.
