program UDPServer;

uses
  Forms,
  UDPServerMain in 'UDPServerMain.pas' {UDPMainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TUDPMainForm, UDPMainForm);
  Application.Run;
end.
