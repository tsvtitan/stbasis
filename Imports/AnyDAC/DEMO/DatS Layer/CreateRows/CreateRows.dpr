program CreateRows;

uses
  Forms,
  fCreateRows in 'fCreateRows.pas' {frmCreateRows},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCreateRows, frmCreateRows);
  Application.Run;
end.
