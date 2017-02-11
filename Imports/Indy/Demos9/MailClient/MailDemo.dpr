program MailDemo;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  Setup in 'Setup.pas' {fmSetup},
  msgEdtAdv in 'msgEdtAdv.pas' {frmAdvancedOptions},
  MsgEditor in 'MsgEditor.pas' {frmMessageEditor0},
  smtpauth in 'smtpauth.pas' {frmSMTPAuthentication},
  Global in 'Global.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAdvancedOptions, frmAdvancedOptions);
  Application.CreateForm(TfrmMessageEditor, frmMessageEditor);
  Application.CreateForm(TfrmSMTPAuthentication, frmSMTPAuthentication);
  Application.Run;
end.
