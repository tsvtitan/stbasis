library client;

{$I stbasis.inc}     

{%File 'stbasis.inc'}

uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  tsvDbGrid in 'United\tsvDbGrid.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  tsvRTFStream in 'Ancement\tsvRTFStream.pas',
  StrUtils in 'United\StrUtils.pas',
  tsvInterbase in 'United\tsvInterbase.pas',
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  tsvTVNavigator in 'United\tsvTVNavigator.pas',
  tsvStdCtrls in 'United\tsvStdCtrls.pas',
  USyncClientCode in 'SyncClient\USyncClientCode.pas',
  USyncClientData in 'SyncClient\USyncClientData.pas',
  USyncClientDM in 'SyncClient\USyncClientDM.pas' {dm: TDataModule},
  URBSync_Connection in 'SyncClient\URBSync_Connection.pas' {fmRBSync_Connection},
  UEditRBSync_Connection in 'SyncClient\UEditRBSync_Connection.pas' {fmEditRBSync_Connection},
  USvcSync in 'SyncClient\USvcSync.pas' {fmSvcSync},
  USrvMain in 'United\USrvMain.pas' {fmSrvMain},
  tsvSyncClient in 'SyncClient\tsvSyncClient.pas',
  StbasisSGlobal in 'StbasisS\StbasisSGlobal.pas',
  tsvCrypter in 'United\tsvCrypter.pas',
  StbasisSClientDataSet in 'StbasisS\StbasisSClientDataSet.pas',
  StbasisSCrypter in 'StbasisS\StbasisSCrypter.pas';

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
    //  InitAll;
    end;
    DLL_PROCESS_DETACH: begin
      DeInitAll;
    end;
  end;
end;

exports
  GetInfoLibrary_ name ConstGetInfoLibrary,
  RefreshLibrary_ name ConstRefreshLibrary,
  SetConnection_ name ConstSetConnection,
  InitAll_ name ConstInitAll;

{$R *.RES}

begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

