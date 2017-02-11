program testclient;

uses
  Forms,
  mainformU in 'mainformU.pas' {mainform};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tmainform, mainform);
  Application.Run;
end.
