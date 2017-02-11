library SalaryVAV;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Windows,
  USalaryVAVCode in 'SalaryVAV\USalaryVAVCode.pas',
  USalaryVAVData in 'SalaryVAV\USalaryVAVData.pas',
  USalaryVAVDM in 'SalaryVAV\USalaryVAVDM.pas' {dm: TDataModule},
  USalaryVAVOptions in 'SalaryVAV\USalaryVAVOptions.pas' {fmOptions},
  UMainUnited in 'United\UMainUnited.pas',
  StCalendarUtil in 'United\StCalendarUtil.pas',
  USalPeriod in 'SalaryVAV\USalPeriod.pas' {fmSalPeriod},
  URptThread in 'United\URptThread.pas',
  ComObj in 'United\COMOBJ.PAS',
  Controls in 'United\Controls.pas',
  DBCtrls in 'United\DBCTRLS.PAS',
  dbtree in 'United\DBTREE.PAS',
  dbtree_l in 'United\DBTREE_L.PAS',
  Excel97 in 'United\Excel97.pas',
  Graphics in 'United\Graphics.pas',
  UAdjust in 'United\UAdjust.pas' {fmAdjust},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  tsvDbGrid in 'United\tsvDbGrid.pas',
  tsvHint in 'United\tsvHint.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  URptMain in 'United\URptMain.pas' {fmRptMain},
  ComCtrls in 'United\ComCtrls.pas',
  UTreeBuilding in 'SalaryVAV\UTreeBuilding.pas' {fmBuildingTree},
  UOTSalary in 'SalaryVAV\UOTSalary.pas' {fmOTSalary},
  URBCalcPeriod in 'SalaryVAV\URBCalcPeriod.pas' {fmRBCalcPeriod},
  UEditRBCalcPeriod in 'SalaryVAV\UEditRBCalcPeriod.pas' {fmEditRBCalcPeriod},
  UEditRBAddCharge in 'SalaryVAV\UEditRBAddCharge.pas' {fmEditRBAddCharge},
  UEditRBAddConstCharge in 'SalaryVAV\UEditRBAddConstCharge.pas' {fmEditRBAddConstCharge},
  UEditRBPrivilege in 'SalaryVAV\UEditRBPrivilege.pas' {fmEditRBPrivelege},
  URBPrivilege in 'SalaryVAV\URBPrivilege.pas' {fmRBPrivelege},
  StVAVKit in 'United\StVAVKit.pas';

{$R *.RES}
procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
 //     InitAll;
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

