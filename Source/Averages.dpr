library Averages;

{$I stbasis.inc}

uses
  Windows,
  SysUtils,
  Classes,
  AveragesCode in 'Averages\AveragesCode.pas',
  AveragesData in 'Averages\AveragesData.pas' {dmAverages: TDataModule},
  StCalendarUtil in 'United\StCalendarUtil.pas',
  UMainUnited in 'United\UMainUnited.pas',
  UOTAveragesLeave in 'Averages\UOTAveragesLeave.pas' {fmOTAveragesLeave},
  UOTAveragesSick in 'Averages\UOTAveragesSick.pas' {fmOTAveragesSick},
  StSalaryKit in 'United\StSalaryKit.pas',
  AveragesOptions in 'Averages\AveragesOptions.pas' {frmAveragesOptions},
  USalaryVAVData in 'SalaryVAV\USalaryVAVData.pas';

{$R *.RES}

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

