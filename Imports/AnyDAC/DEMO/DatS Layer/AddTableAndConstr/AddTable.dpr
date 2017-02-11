program AddTable;

uses
  Forms,
  fAddTables in 'fAddTables.pas' {frmAddTables},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAddTables, frmAddTables);
  Application.Run;
end.
