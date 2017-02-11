program Client;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  ClientThread in 'ClientThread.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
