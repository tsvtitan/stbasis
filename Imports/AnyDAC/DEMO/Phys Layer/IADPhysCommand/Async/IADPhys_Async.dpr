program IADPhys_Async;

uses
  Forms,
  fAsync in 'fAsync.pas' {frmAsync},
  dmMainBase in '..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainLayers in '..\..\..\fMainLayers.pas' {frmMainLayers};

{R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainBase, dmlMainBase);
  Application.CreateForm(TfrmAsync, frmAsync);
  Application.Run;
end.
