program stbasiss;

{$R 'United\WindowsXP.res' 'United\WindowsXP.rc'}

uses
  Forms,
  StbasisSCode in 'StbasisS\StbasisSCode.pas',
  StbasisSCmdLine in 'StbasisS\StbasisSCmdLine.pas',
  StbasisSLog in 'StbasisS\StbasisSLog.pas',
  StbasisSConfig in 'StbasisS\StbasisSConfig.pas',
  StbasisSPrimaryDb in 'StbasisS\StbasisSPrimaryDb.pas',
  StbasisSUtils in 'StbasisS\StbasisSUtils.pas',
  StbasisSData in 'StbasisS\StbasisSData.pas',
  StbasisSService in 'StbasisS\StbasisSService.pas',
  StbasisSStand in 'StbasisS\StbasisSStand.pas' {StbasisSStandForm},
  StbasisSTCPServer in 'StbasisS\StbasisSTCPServer.pas',
  StbasisSGlobal in 'StbasisS\StbasisSGlobal.pas',
  StbasisSClientDataSet in 'StbasisS\StbasisSClientDataSet.pas',
  XPMan in 'United\XPMan.pas',
  StbasisSCrypter in 'StbasisS\StbasisSCrypter.pas';

{$R *.RES}

begin
//  Application.
  InitApplication;
  DoneApplication;
end.
