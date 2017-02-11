program UDPClient;

uses
  Forms,
  UDPClientMain in 'UDPClientMain.pas' {UDPMainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TUDPMainForm, UDPMainForm);
  Application.Run;
end.
