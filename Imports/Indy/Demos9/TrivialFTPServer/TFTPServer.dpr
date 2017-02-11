program TFTPServer;

uses
  Forms,
  Main in 'main.pas' {frmMain},
  transfer in 'transfer.pas' {frmTransfer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
