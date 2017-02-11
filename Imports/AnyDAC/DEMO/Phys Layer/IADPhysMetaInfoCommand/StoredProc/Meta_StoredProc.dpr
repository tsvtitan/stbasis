program Meta_StoredProc;

uses
  Forms,
  fMetaStoredProc in 'fMetaStoredProc.pas' {frmMetaStoredProc},
  dmMainBase in '..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainLayers in '..\..\..\fMainLayers.pas' {frmMainLayers},
  uDatSUtils in '..\..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMetaStoredProc, frmMetaStoredProc);
  Application.Run;
end.
