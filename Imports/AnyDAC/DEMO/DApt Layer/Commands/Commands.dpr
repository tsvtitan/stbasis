program Commands;

uses
  Forms,
  dmMainBase in '..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  fCommands in 'fCommands.pas' {frmCommands},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainLayers in '..\..\fMainLayers.pas' {frmMainLayers},
  uDatSUtils in '..\..\uDatSUtils.pas',
  daADDAptManager;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainBase, dmlMainBase);
  Application.CreateForm(TfrmCommands, frmCommands);
  Application.Run;
end.
