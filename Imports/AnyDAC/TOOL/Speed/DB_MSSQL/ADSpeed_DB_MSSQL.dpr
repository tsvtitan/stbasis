{$I ..\ADSpeed.inc}

program ADSpeed_DB_MSSQL;

uses
  Forms,
  daADGUIxFormsWait,
  {$I ..\..\TOOLDBs.inc}
  daADGUIxFormsfOptsBase in '..\..\..\SOURCE\daADGUIxFormsfOptsBase.pas' {frmADGUIxFormsOptsBase},
  fADSpeedUI in '..\fADSpeedUI.pas' {ADSpeedUIFrm},
  fADSpeedUIDB in '..\DB\fADSpeedUIDB.pas' {ADSpeedUIDBFrm},
  fADSpeedGenData in '..\DB\fADSpeedGenData.pas' {ADSpeedGenDataFrm},
  ADSpeedBase in '..\ADSpeedBase.pas',
  ADSpeedBaseDB in '..\DB\ADSpeedBaseDB.pas',
  ADSpeedDBTests in '..\DB\ADSpeedDBTests.pas',
  ADSpeedSQLDirect in '..\DB\ADSpeedSQLDirect.pas',
  ADSpeedAD in '..\DB\ADSpeedAD.pas',
  ADSpeedDbExpr in '..\DB\ADSpeedDbExpr.pas',
  DBLocalS in 'C:\Program Files\Borland\Delphi7\Demos\Db\SQLClientDataset\DBLocalS.pas',
  ADSpeedADO in '..\DB\ADSpeedADO.pas',
  ADSpeedODBC in '..\DB\ADSpeedODBC.pas',
  ADSpeedBDE in '..\DB\ADSpeedBDE.pas',
  ADSpeedRegMSSQL in 'ADSpeedRegMSSQL.pas',
  ADSpeedSDAC in 'ADSpeedSDAC.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'AnyDAC Benchmark Suite';
  Application.CreateForm(TADSpeedUIDBFrm, ADSpeedUIDBFrm);
  Application.Run;
end.
