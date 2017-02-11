program MailDemo;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  Main in 'Main.pas' {frmMain},
  Setup in 'Setup.pas' {fmSetup},
  MsgEdtAdv in 'MsgEdtAdv.pas' {frmAdvancedOptions},
  MsgEditor in 'MsgEditor.pas' {frmMessageEditor0},
  smtpauth in 'smtpauth.pas' {frmSMTPAuthentication};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAdvancedOptions, frmAdvancedOptions);
  Application.CreateForm(TfrmMessageEditor, frmMessageEditor);
  Application.CreateForm(TfrmSMTPAuthentication, frmSMTPAuthentication);
  Application.Run;
end.
