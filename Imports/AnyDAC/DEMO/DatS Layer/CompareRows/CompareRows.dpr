program CompareRows;

uses
  Forms,
  fCompareRows in 'fCompareRows.pas' {frmCompareRows},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCompareRows, frmCompareRows);
  Application.Run;
end.
