library systems;

{$I stbasis.inc}     



{$R 'United\WindowsXP.res' 'United\WindowsXP.rc'}

uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  UJRMainGrid in 'United\UJRMainGrid.pas' {fmJRMainGrid},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  tsvAdjust in 'United\tsvAdjust.pas' {fmAdjust},
  tsvHint in 'United\tsvHint.pas',
  UEditJRSqlOperation in 'SysTsv\UEditJRSqlOperation.pas' {fmEditJRSqlOperation},
  UJRError in 'SysTsv\UJRError.pas' {fmJRError},
  UJRSqlOperation in 'SysTsv\UJRSqlOperation.pas' {fmJRSqlOperation},
  URBApp in 'SysTsv\URBApp.pas',
  URBUserApp in 'SysTsv\URBUserApp.pas' {fmRBUserApp},
  URBUsers in 'SysTsv\URBUsers.pas' {fmRBUsers},
  UEditRBUsers in 'SysTsv\UEditRBUsers.pas' {fmEditRBUser},
  UEditRBApp in 'SysTsv\UEditRBApp.pas' {fmEditRBApp},
  UEditRBUserApp in 'SysTsv\UEditRBUserApp.pas' {fmEditRBUserApp},
  tsvDbGrid in 'United\tsvDbGrid.pas',
  dbtree in 'United\DBTREE.PAS',
  URBUsersEmp in 'SysTsv\URBUsersEmp.pas' {fmRBUsersEmp},
  UEditRBUsersEmp in 'SysTsv\UEditRBUsersEmp.pas' {fmEditRBUsersEmp},
  UEditJRError in 'SysTsv\UEditJRError.pas' {fmEditJRError},
  URBAppPermColumn in 'SysTsv\URBAppPermColumn.pas' {fmRBAppPermColumn},
  UEditRBAppPermColumn in 'SysTsv\UEditRBAppPermColumn.pas' {fmEditRBAppPermColumn},
  tsvTVNavigatorEx in 'United\tsvTVNavigatorEx.pas',
  USysTsvForToolBars in 'SysTsv\USysTsvForToolBars.pas' {fmForToolBars},
  tsvPicture in 'United\tsvPicture.pas',
  tsvComCtrls in 'United\tsvComCtrls.pas',
  USrvMain in 'United\USrvMain.pas' {fmSrvMain},
  tsvInterbase in 'United\tsvInterbase.pas',
  USrvPermission in 'SysTsv\USrvPermission.pas' {fmSrvPermission},
  USysTsvOptions in 'SysTsv\USysTsvOptions.pas' {fmOptions},
  USysTsvData in 'SysTsv\USysTsvData.pas',
  USysTsvDM in 'SysTsv\USysTsvDM.pas' {dm: TDataModule},
  USysTsvCode in 'SysTsv\USysTsvCode.pas',
  XPMan in 'United\XPMan.pas';

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
//      InitAll;
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

