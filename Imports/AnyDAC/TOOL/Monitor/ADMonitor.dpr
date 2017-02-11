program ADMonitor;

uses
  Forms,
  fMainFrm in 'fMainFrm.pas' {ADMoniMainFrm},
  fOptionsFrm in 'fOptionsFrm.pas' {frmOptions},
  daADGUIxFormsfAbout in '..\..\Source\daADGUIxFormsfAbout.pas' {frmADGUIxFormsAbout},
  daADGUIxFormsfOptsBase in '..\..\Source\daADGUIxFormsfOptsBase.pas' {frmADGUIxFormsOptsBase},
  fObjFrm in 'fObjFrm.pas' {ADMoniObjectsFrm},
  fTraceFrm in 'fTraceFrm.pas' {ADMoniTraceFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TADMoniMainFrm, ADMoniMainFrm);
  Application.Run;
end.
