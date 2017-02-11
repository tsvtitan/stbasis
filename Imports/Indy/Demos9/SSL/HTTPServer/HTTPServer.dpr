program HTTPServer;

uses
  Forms,
  ServerMain in 'ServerMain.pas' {fmHTTPServerMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmHTTPServerMain, fmHTTPServerMain);
  Application.Run;
end.
