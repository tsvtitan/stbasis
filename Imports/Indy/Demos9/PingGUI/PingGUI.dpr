program PingGUI;

uses
  Forms,
  Main in 'Main.pas' {frmPing},
  IdRawClient in '..\..\IdRawClient.pas',
  IdRawBase in '..\..\IdRawBase.pas',
  IdSocketHandle in '..\..\IdSocketHandle.pas',
  IdComponent in '..\..\IdComponent.pas',
  IdThread in '..\..\IdThread.pas',
  IdResourceStrings in '..\..\IdResourceStrings.pas',
  IdGlobal in '..\..\IdGlobal.pas',
  IdStack in '..\..\IdStack.pas',
  IdStackConsts in '..\..\IdStackConsts.pas',
  IdIcmpClient in '..\..\IdIcmpClient.pas',
  IdRawHeaders in '..\..\IdRawHeaders.pas',
  IdRawFunctions in '..\..\IdRawFunctions.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPing, frmPing);
  Application.Run;
end.
