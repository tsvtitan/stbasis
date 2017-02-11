program Qry_CachedUpdates;

uses
  Forms,
  dmMainBase in '..\..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  dmMainComp in '..\..\..\dmMainComp.pas' {dmlMainComp: TdmlMainComp},
  fMainBase in '..\..\..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainCompBase in '..\..\..\fMainCompBase.pas' {frmMainCompBase},
  fMainQueryBase in '..\..\fMainQueryBase.pas' {frmMainQueryBase},
  fCachedUpdates in 'fCachedUpdates.pas' {frmCachedUpdates};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainComp, dmlMainComp);
  Application.CreateForm(TfrmCachedUpdates, frmCachedUpdates);
  Application.Run;
end.
