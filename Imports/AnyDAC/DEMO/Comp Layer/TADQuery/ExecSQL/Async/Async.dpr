program Async;

uses
  Forms,
  fAsync in 'fAsync.pas' {frmAsync},
  dmMainBase in '..\..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  dmMainComp in '..\..\..\dmMainComp.pas' {dmlMainComp: TDataModule},
  fMainBase in '..\..\..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainCompBase in '..\..\..\fMainCompBase.pas' {frmMainCompBase},
  fMainQueryBase in '..\..\fMainQueryBase.pas' {frmMainQueryBase};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainComp, dmlMainComp);
  Application.CreateForm(TfrmAsync, frmAsync);
  Application.Run;
end.
