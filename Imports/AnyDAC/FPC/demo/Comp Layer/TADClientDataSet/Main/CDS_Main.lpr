program CDS_Main;

uses
  Interfaces,
  Forms, fProperties;

begin
  Application.Initialize;
  Application.CreateForm(TfrmProperties, frmProperties);
  Application.Run;
end.
