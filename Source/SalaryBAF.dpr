library SalaryBAF;

uses
  Windows,
  SysUtils,
  Classes,
  USalBafFuncProc in 'SalaryBAF\USalBafFuncProc.pas',
  UMainUnited in 'United\UMainUnited.pas',
  USalBafConst in 'SalaryBAF\USalBafConst.pas',
  URptMemOrder5 in 'SalaryBAF\URptMemOrder5.pas' {fmRptMemOrder5},
  URptMain in 'United\URptMain.pas' {fmRptMain},
  URptThread in 'United\URptThread.pas',
  tsvDbGrid in 'United\tsvDbGrid.pas',
  dbtree in 'United\Dbtree.pas';

{$R *.RES}
procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
      InitAll;
    end;
    DLL_PROCESS_DETACH: begin
      FreeCreatures;
    end;
  end;
end;

exports
  GetInfoLibrary_ name ConstGetInfoLibrary,
  GetListEntryRoot_ name ConstGetListEntryRoot,
  ViewEntry_ name ConstViewEntry,
  RefreshEntryes_ name ConstRefreshEntryes,
  SetAppAndScreen_ name ConstSetAppAndScreen,
  SetConnection_ name ConstSetConnection;
//  BeforeSetOptions_ name ConstBeforeSetOptions,
//  AfterSetOptions_ name ConstAfterSetOptions,
//  GetListOptionsRoot_ name ConstGetListOptionsRoot;

begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
