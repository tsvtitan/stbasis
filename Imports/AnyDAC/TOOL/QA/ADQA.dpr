program ADQA;

{$I daAD.inc}

uses
  Forms,
  {$I ..\TOOLDBs.inc}
  ADQAfMain in 'ADQAfMain.pas' {frmADQAMain},
  ADQAUtils in 'ADQAUtils.pas',
  ADQAConst in 'ADQAConst.pas',
  ADQAEvalFuncs in 'ADQAEvalFuncs.pas',
  ADQAVarField in 'ADQAVarField.pas',
  ADQAPack in 'ADQAPack.pas',
  ADQAStanLayer in 'ADQAStanLayer.pas',
  ADQADatSLayer in 'ADQADatSLayer.pas',
  ADQAGUIxLayer in 'ADQAGUIxLayer.pas',
  ADQAPhysLayerCNN in 'ADQAPhysLayerCNN.pas',
  ADQAPhysLayerCMD in 'ADQAPhysLayerCMD.pas',
  ADQAPhysLayerMTI in 'ADQAPhysLayerMTI.pas',
  ADQAPhysLayerSTP in 'ADQAPhysLayerSTP.pas',
  ADQADAptLayer in 'ADQADAptLayer.pas',
  ADQACompLayerCDS in 'ADQACompLayerCDS.pas',
  ADQACompLayerCNN in 'ADQACompLayerCNN.pas',
  ADQACompLayerMTI in 'ADQACompLayerMTI.pas',
  ADQACompLayerQRY in 'ADQACompLayerQRY.pas',
  ADQACompLayerSTP in 'ADQACompLayerSTP.pas',
  ADQACompLayerUPD in 'ADQACompLayerUPD.pas',
  ADQACompLayerDTM in 'ADQACompLayerDTM.pas',
  ADQAfConnOptions in 'ADQAfConnOptions.pas' {frmConnOptions},
  ADQAfSearch in 'ADQAfSearch.pas' {frmADQASearch};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AnyDAC QA Suite';
  Application.CreateForm(TfrmADQAMain, frmADQAMain);
  Application.CreateForm(TfrmConnOptions, frmConnOptions);
  Application.CreateForm(TfrmADQASearch, frmADQASearch);
  Application.Run;
end.
