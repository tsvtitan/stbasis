program testclient;

uses
  QForms,
  mainformU in 'mainformU.pas' {mainform};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tmainform, mainform);
  Application.Run;
end.
