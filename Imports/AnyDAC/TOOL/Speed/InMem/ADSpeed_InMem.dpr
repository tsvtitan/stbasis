{$I ..\ADSpeed.inc}

program ADSpeed_InMem;

uses
  Forms,
  daADGUIxFormsWait,
  daADGUIxFormsfOptsBase in '..\..\..\SOURCE\daADGUIxFormsfOptsBase.pas' {frmADGUIxFormsOptsBase},
  fADSpeedUI in '..\fADSpeedUI.pas' {ADSpeedUIFrm},
  ADSpeedBase in '..\ADSpeedBase.pas',
  ADSpeedRegInMem in 'ADSpeedRegInMem.pas',
  ADSpeedADCDS in 'ADSpeedADCDS.pas',
  ADSpeedKBM in 'ADSpeedKBM.pas',
  ADSpeedCDS in 'ADSpeedCDS.pas',
  ADSpeedDXM in 'ADSpeedDXM.pas',
  ADSpeedInMemTests in 'ADSpeedInMemTests.pas',
  fADSpeedUIInMem in 'fADSpeedUIInMem.pas' {ADSpeedUIInMemFrm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'AnyDAC Benchmark Suite';
  Application.CreateForm(TADSpeedUIInMemFrm, ADSpeedUIInMemFrm);
  Application.Run;
end.
