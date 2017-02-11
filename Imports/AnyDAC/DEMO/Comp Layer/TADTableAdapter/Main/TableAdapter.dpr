program TableAdapter;

uses
  Forms,
  fTableAdapter in 'fTableAdapter.pas' {frmTableAdapter},
  dmMainBase in '..\..\..\dmMainBase.pas' {dmlMainBase: TDataModule},
  dmMainComp in '..\..\dmMainComp.pas' {dmlMainComp: TDataModule},
  fMainBase in '..\..\..\fMainBase.pas' {frmMainBase},
  fMainConnectionDefBase in '..\..\..\fMainConnectionDefBase.pas' {frmMainConnectionDefBase},
  fMainCompBase in '..\..\fMainCompBase.pas' {frmMainCompBase};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmlMainComp, dmlMainComp);
  Application.CreateForm(TfrmTableAdapter, frmTableAdapter);
  Application.Run;
end.
