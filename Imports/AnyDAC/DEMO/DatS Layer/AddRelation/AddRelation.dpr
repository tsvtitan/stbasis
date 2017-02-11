program AddRelation;

uses
  Forms,
  fAddRelation in 'fAddRelation.pas' {frmAddRelation},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAddRelation, frmAddRelation);
  Application.Run;
end.
