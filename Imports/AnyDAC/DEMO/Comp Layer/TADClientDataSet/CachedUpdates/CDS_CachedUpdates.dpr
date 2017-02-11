program CDS_CachedUpdates;

uses
  Forms,
  dmMainBase in '..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  dmMainComp in '..\..\dmMainComp.pas' {dmlMainComp: TDataModule},
  fCachedUpdates in 'fCachedUpdates.pas' {frmCachedUpdates},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainCompBase in '..\..\fMainCompBase.pas' {frmMainCompBase};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainComp, dmlMainComp);
  Application.CreateForm(TfrmCachedUpdates, frmCachedUpdates);
  Application.Run;
end.
