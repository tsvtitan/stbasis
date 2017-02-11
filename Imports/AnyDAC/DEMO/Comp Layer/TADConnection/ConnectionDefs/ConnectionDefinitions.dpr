program ConnectionDefinitions;

uses
  Forms,
  dmMainBase in '..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  dmMainComp in '..\..\dmMainComp.pas' {dmlMainComp: TDataModule},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase},
  fConnectionDefinitions in 'fConnectionDefinitions.pas' {frmConnectionDefinitions},
  fConnProperties in 'fConnProperties.pas' {frmProperties: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainComp, dmlMainComp);
  Application.CreateForm(TfrmConnectionDefinitions, frmConnectionDefinitions);
  Application.Run;
end.
