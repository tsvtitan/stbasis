program Meta_Indices;

uses
  Forms,
  fMetaIndices in 'fMetaIndices.pas' {frmMain},
  dmMainBase in '..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainLayers in '..\..\..\fMainLayers.pas' {frmMainLayers},
  uDatSUtils in '..\..\..\uDatSUtils.pas';

{R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainBase, dmlMainBase);
  Application.CreateForm(TfrmMetaIndices, frmMetaIndices);
  Application.Run;
end.
