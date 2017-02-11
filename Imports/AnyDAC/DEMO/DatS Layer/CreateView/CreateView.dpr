program CreateView;

uses
  Forms,
  fCreateView in 'fCreateView.pas' {frmCreateView},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase},
  uDatSUtils in '..\..\uDatSUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCreateView, frmCreateView);
  Application.Run;
end.
