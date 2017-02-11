program WSZipCodeServer;

uses
  Forms,
  ServerMain in 'ServerMain.pas' {formMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
