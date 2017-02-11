program FTPDemo;

uses
  Forms,
  mainf in 'mainf.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
