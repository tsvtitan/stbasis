program MappingColumns;

uses
  Forms,
  fMappingColumns in 'fMappingColumns.pas' {frmMappingColumns},
  dmMainBase in '..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainLayers in '..\..\fMainLayers.pas' {frmMainLayers},
  uDatSUtils in '..\..\uDatSUtils.pas',
  daADDAptManager;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainBase, dmlMainBase);
  Application.CreateForm(TfrmMappingColumns, frmMappingColumns);
  Application.Run;
end.
