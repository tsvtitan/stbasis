program WSZipCodeClient;

uses
  Forms,
  ClientMain in 'ClientMain.pas' {formMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
