program MailClientWindows;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  fSetup in 'fSetup.pas' {frmSetup};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
