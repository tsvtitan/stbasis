program HTTPClient;

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  {$ENDIF}
  Main in 'Main.pas' {Form1},
  frmLogin in 'frmLogin.pas' {LoginForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TLoginForm, LoginForm);
  Application.Run;
end.
