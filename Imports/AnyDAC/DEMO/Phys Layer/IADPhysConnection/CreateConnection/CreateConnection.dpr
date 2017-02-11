program CreateConnection;

uses
  Forms,
  fCreateConnection in 'fCreateConnection.pas' {frmCreateConnection},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCreateConnection, frmCreateConnection);
  Application.Run;
end.
