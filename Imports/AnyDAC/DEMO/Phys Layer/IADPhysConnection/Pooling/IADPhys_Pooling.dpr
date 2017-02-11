program IADPhys_Pooling;

uses
  Forms,
  fPooling in 'fPooling.pas' {frmPooling},
  dmMainBase in '..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainLayers in '..\..\..\fMainLayers.pas' {frmMainLayers};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainBase, dmlMainBase);
  Application.CreateForm(TfrmPooling, frmPooling);
  Application.Run;
end.
