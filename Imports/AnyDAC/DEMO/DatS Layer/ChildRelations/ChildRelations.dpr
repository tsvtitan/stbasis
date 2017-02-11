program ChildRelations;

uses
  Forms,
  fChildRelations in 'fChildRelations.pas' {Form1},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmChildRelations, frmChildRelations);
  Application.Run;
end.
