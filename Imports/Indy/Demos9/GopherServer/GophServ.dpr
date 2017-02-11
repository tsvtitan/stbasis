program GophServ;

uses
  Forms,
  main in 'main.pas' {Gopher};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TGopher, Gopher);
  Application.Run;
end.
