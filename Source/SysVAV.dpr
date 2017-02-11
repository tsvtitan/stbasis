library StoreVAV;

{$I stbasis.inc}     



uses
  SysUtils,
  Classes,
  Windows,
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  tsvInterbase in 'United\tsvInterbase.pas',
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  StVAVKit in 'United\StVAVKit.pas',
  UMainUnited in 'United\UMainUnited.pas',
  USysVAVCode in 'SysVAV\USysVAVCode.pas',
  USysVAVData in 'SysVAV\USysVAVData.pas',
  USysVAVDM in 'SysVAV\USysVAVDM.pas' {dm: TDataModule},
  USysVAVOptions in 'SysVAV\USysVAVOptions.pas' {fmOptions},
  UEditRBLinkTypeDocNumerator in 'SysVAV\UEditRBLinkTypeDocNumerator.pas' {fmEditRBLinkTypeDocNumerator},
  UEditRBTypeNumerator in 'SysVAV\UEditRBTypeNumerator.pas' {fmEditRBTypeNumerator},
  URBTypeNumerator in 'SysVAV\URBTypeNumerator.pas' {fmRBTypeNumerator},
  UEditRBNumerators in 'SysVAV\UEditRBNumerators.pas' {fmEditRBNumerators},
  URBUsersGroup in 'SysVAV\URBUsersGroup.pas' {fmRBUsersGroup},
  UEditRBUsersGroup in 'SysVAV\UEditRBUsersGroup.pas' {fmEditRBUsersGroup},
  UEditRBUsersInGroup in 'SysVAV\UEditRBUsersInGroup.pas' {fmEditRBUsersInGroup};

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
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
  
begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

