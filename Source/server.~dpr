library server;

{$I stbasis.inc}     

{%File 'stbasis.inc'}

uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  tsvDbGrid in 'United\tsvDbGrid.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  StrUtils in 'United\StrUtils.pas',
  tsvInterbase in 'United\tsvInterbase.pas',
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  tsvTVNavigator in 'United\tsvTVNavigator.pas',
  tsvStdCtrls in 'United\tsvStdCtrls.pas',
  USyncServerCode in 'SyncServer\USyncServerCode.pas',
  USyncServerData in 'SyncServer\USyncServerData.pas',
  USyncServerDM in 'SyncServer\USyncServerDM.pas' {dm: TDataModule},
  URBSync_Office in 'SyncServer\URBSync_Office.pas' {fmRBSync_Office},
  UEditRBSync_Office in 'SyncServer\UEditRBSync_Office.pas' {fmEditRBSync_Office},
  URBSync_Package in 'SyncServer\URBSync_Package.pas' {fmRBSync_Package},
  UEditRBSync_Package in 'SyncServer\UEditRBSync_Package.pas' {fmEditRBSync_Package},
  URBSync_Object in 'SyncServer\URBSync_Object.pas' {fmRBSync_Object},
  UEditRBSync_Object in 'SyncServer\UEditRBSync_Object.pas' {fmEditRBSync_Object},
  URBSync_OfficePackage in 'SyncServer\URBSync_OfficePackage.pas' {fmRBSync_OfficePackage},
  UEditRBSync_OfficePackage in 'SyncServer\UEditRBSync_OfficePackage.pas' {fmEditRBSync_OfficePackage};

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

