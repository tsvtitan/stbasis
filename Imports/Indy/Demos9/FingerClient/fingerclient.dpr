program FingerClient;

uses
  Forms,
  main in 'main.pas' {frmFingerDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFingerDemo, frmFingerDemo);
  Application.Run;
end.
