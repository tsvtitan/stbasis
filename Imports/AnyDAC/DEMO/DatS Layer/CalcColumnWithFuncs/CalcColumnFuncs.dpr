program CalcColumnFuncs;

uses
  Forms,
  fCalculatedColumnsFuncs in 'fCalculatedColumnsFuncs.pas' {frmCalculatedColumnsFuncs},
  fMainBase in '..\..\fMainBase.pas' {frmMainBase},
  fDatSLayerBase in '..\fDatSLayerBase.pas' {frmDatSLayerBase};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCalculatedColumnsFuncs, frmCalculatedColumnsFuncs);
  Application.Run;
end.
