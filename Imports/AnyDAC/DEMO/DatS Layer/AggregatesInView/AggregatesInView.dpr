program AggregatesInView;

uses
  Forms,
  fAggregates in 'fAggregates.pas' {frmAggregates},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAggregates, frmAggregates);
  Application.Run;
end.
