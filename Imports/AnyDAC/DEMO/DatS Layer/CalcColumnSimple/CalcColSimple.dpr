program CalcColSimple;

uses
  Forms,
  fCalculatedColumns in 'fCalculatedColumns.pas' {frmCalculatedColumns},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCalculatedColumns, frmCalculatedColumns);
  Application.Run;
end.
