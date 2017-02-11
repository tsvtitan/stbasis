program Clients;

uses
  daADStanFactory,
  Forms,
  dmMainBase in '..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  fClients in 'fClients.pas' {frmClients},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainLayers in '..\..\fMainLayers.pas' {frmMainLayers};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainBase, dmlMainBase);
  Application.CreateForm(TfrmClients, frmClients);
  Application.Run;
end.
