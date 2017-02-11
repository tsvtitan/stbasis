program RowFilter;

uses
  Forms,
  fRowFilter in 'fRowFilter.pas' {frmRowFilter},
  dmMainBase in '..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainLayers in '..\..\fMainLayers.pas' {frmMainLayers},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainBase, dmlMainBase);
  Application.CreateForm(TfrmRowFilter, frmRowFilter);
  Application.Run;
end.
