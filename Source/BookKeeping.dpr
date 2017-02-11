library BookKeeping;

{$I stbasis.inc}

uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  UBookKeepingCode in 'BookKeeping\UBookKeepingCode.pas',
  tsvHint in 'United\tsvHint.pas',
  UBookKeepingData in 'BookKeeping\UBookKeepingData.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  UBookKeepingDM in 'BookKeeping\UBookKeepingDM.pas' {dm: TDataModule},
  tsvDbGrid in 'United\tsvDbGrid.pas',
  UEditRBKindSubkonto in 'BookKeeping\UEditRBKindSubkonto.pas' {fmEditRBKindSubkonto},
  UEditRBPlanAccounts in 'BookKeeping\UEditRBPlanAccounts.pas' {fmEditRBPlanAccounts},
  UFrameSubkonto in 'BookKeeping\UFrameSubkonto.pas' {FrameSubkonto: TFrame},
  URBKindSubkonto in 'BookKeeping\URBKindSubkonto.pas' {fmRBKindSubkonto},
  URBPlanAccounts in 'BookKeeping\URBPlanAccounts.pas' {fmRBPlanAccounts},
  URBSubkontoSubkonto in 'BookKeeping\URBSubkontoSubkonto.pas' {fmRBSubkontoSubkonto},
  UEditRBSubkontoSubkonto in 'BookKeeping\UEditRBSubkontoSubkonto.pas' {fmEditRBSubkontoSubkonto},
  UJRMainGrid in 'United\UJRMainGrid.pas' {fmJRMainGrid},
  UJRMagazinePostings in 'BookKeeping\UJRMagazinePostings.pas' {fmJRMagazinePostings},
  UEditJRMagazinePostings in 'BookKeeping\UEditJRMagazinePostings.pas' {fmEditJRMagazinePostings};

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

begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

