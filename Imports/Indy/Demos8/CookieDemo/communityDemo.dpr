program communityDemo;

uses
  Forms,
  mainf in 'mainf.pas' {Form1},
  loginF in 'loginF.pas' {frmLogin};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
