program EchoClient;

uses
  Forms,
  main in 'main.pas' {formEchoTest};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TformEchoTest, formEchoTest);
  Application.Run;
end.
